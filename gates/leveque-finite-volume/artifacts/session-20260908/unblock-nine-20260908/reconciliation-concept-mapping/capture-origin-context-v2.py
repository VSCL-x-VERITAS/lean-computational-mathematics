"""Read committed origin contracts for an explicit hash-pinned lane inventory.

POSIX Git object reads only. No live audit or operational gate is inspected.
"""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import posixpath
import sys

HERE = Path(__file__).resolve().parent
HELPERS = HERE.parent/'reconciliation-helpers'
assert hashlib.sha256((HELPERS/'common.py').read_bytes()).hexdigest() == 'acbf38816a1f0c1436b2191a6afa89c30a23eb2a9f4137da8e895d2119111e9b'
sys.path.insert(0, str(HELPERS))
from common import GitObjects, canonical, digest, load, decode_json, write_new, require, checked_lanes


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--inventory', type=Path, required=True)
    p.add_argument('--inventory-sha256', required=True)
    p.add_argument('--topology', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    inventory, ih = load(args.inventory)
    require(ih == args.inventory_sha256, 'wrong inventory bytes')
    topology, th = load(args.topology)
    require(th == inventory['topology_sha256'], 'wrong topology')
    _, lanes = checked_lanes(topology)
    lane = lanes[inventory['lane_id']]
    require(lane['head'] == inventory['head'], 'wrong origin head')
    git = GitObjects(lane['repository'])
    def read_ref(item):
        return decode_json(git.evidence(inventory['head'], item))
    gate_asset = next(a for a in inventory['assets'] if a['kind'] == 'gate')
    gate_ref = {'path': gate_asset['path'], 'sha256': gate_asset['blob_sha256']}
    gate = read_ref(gate_ref)
    rows = []
    for row in gate['rows']:
        record = {'row': row['id'], 'origin_status': row['status'], 'row_sha256': digest(canonical(row))}
        if row['status'] in ('PROVED', 'REUSED'):
            path = posixpath.normpath(str(PurePosixPath(gate_ref['path']).parent/row['source_contract_artifact']))
            require(not path.startswith('../') and not PurePosixPath(path).is_absolute(), 'bad origin contract path')
            cref = {'path': path, 'sha256': row['source_contract_sha256']}
            artifact = read_ref(cref)
            contract = artifact['payload']['contract']
            require(digest(json.dumps(contract, sort_keys=True, separators=(',', ':'), ensure_ascii=False).encode('utf-8')) == row['contract_hash'], 'origin source contract mismatch')
            task_path = row['faithfulness_task']
            task_bytes = git.run('show', inventory['head'] + ':' + task_path)
            task = decode_json(task_bytes)
            record.update(declarations=row['lean_declarations'], contract=contract, contract_ref=cref,
                          source=task['source'], target=task['target'],
                          task_ref={'path': task_path, 'sha256': digest(task_bytes)},
                          classification=row['classification'],
                          policy_domain_scope='Exact origin-selected contract and target; not candidate acceptance.')
        rows.append(record)
    result = {'schema': 1, 'artifact_kind': 'origin-source-context', 'inventory_sha256': ih,
              'lane_id': inventory['lane_id'], 'origin_head': inventory['head'],
              'origin_gate': gate_ref, 'source_sha256': inventory['source_sha256'],
              'rows': rows, 'source_acceptance': False,
              'limits': 'Only origin-selected source contracts are decoded. Other audits remain the inventoried historical bytes; no prior verdict is reused for a current candidate.'}
    checked_lanes(topology)
    require(load(args.inventory)[1] == ih and load(args.topology)[1] == th, 'input drift')
    write_new(args.output, result)
    print(json.dumps({'origin_head': inventory['head'], 'rows': len(rows),
                      'origin_selected_contracts': sum('contract' in r for r in rows),
                      'output_sha256': digest(args.output.read_bytes()), 'source_acceptance': False}))


if __name__ == '__main__':
    main()
