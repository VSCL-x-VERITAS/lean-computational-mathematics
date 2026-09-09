"""Inventory one exact work/inspection lane from Git blobs; no candidate or verdict.

Run once per topology lane, supplying that lane's own committed fingerprints.
Inspection may have open rows: its gate-selected certificates describe its origin,
not current candidate acceptance. The converter retains inspection occurrences.
"""
from pathlib import Path
import argparse, re
from common import (GitObjects, BlobBatch, canonical, digest, decode_json, load,
                    require, checked_lanes, write_new, InputError)

GATE = 'gates/leveque-finite-volume/chapter-01.json'
CLOSED = {'PROVED', 'REUSED'}

def build(topology_path, lane_id, fingerprint_paths, require_closed=False,
          git_factory=GitObjects, batch_factory=BlobBatch):
    topology, topology_hash = load(topology_path)
    instances, lanes = checked_lanes(topology, git_factory)
    require(lane_id in lanes, 'not a work/inspection lane')
    lane = lanes[lane_id]; head = lane['head']; anchor = topology['shared_anchor']
    require(lane['anchor'] == anchor, 'lane anchor differs from shared anchor')
    git = git_factory(lane['repository'])
    git.run('merge-base', '--is-ancestor', anchor, head)
    tree = git.text('rev-parse', head + '^{tree}')
    entries, baseline = git.tree(head), git.tree(anchor)
    changed = {k for k, v in entries.items() if k not in baseline or v != baseline[k]}
    deleted = sorted(set(baseline) - set(entries))
    require(not deleted, 'deleted files need separately reviewed transport inventory')
    batch = batch_factory(git)
    try:
        def blob(path, data=False, old=False):
            mapping = baseline if old else entries
            require(path in mapping, 'missing origin blob: ' + path)
            return batch.get(mapping[path]['oid'], data)
        def read(path, old=False): return decode_json(blob(path, True, old))
        gate, oldgate = read(GATE), read(GATE, True)
        rows, oldrows = gate['rows'], {r['id']: r for r in oldgate['rows']}
        require(len(oldrows) == len(oldgate['rows']) and len({r['id'] for r in rows}) == len(rows), 'duplicate source row')
        openrows = [r['id'] for r in rows if r['status'] not in CLOSED | {'SKIPPED'}]
        require(not require_closed or not openrows, 'origin lane has open source rows')
        assets, coverage, modules_by_name = [], {}, {}
        def identifier(kind, key):
            return kind + '-' + digest(canonical([lane_id, head, kind, key]))[:32]
        def make(kind, key, payload, unique, disposition='selected', **metadata):
            if metadata.get('source_hash', False) is None: metadata.pop('source_hash')
            return dict(asset_id=identifier(kind, key), concept_id='unreviewed-' + digest(canonical([kind, key]))[:32],
                lane_id=lane_id, kind=kind, unique=unique, disposition=disposition,
                content_sha256=digest(canonical(payload)), uniqueness_basis='Conservative changed/new relative to anchor; no cross-lane uniqueness assertion', origin_commit=head, origin_ref=lane['ref'],
                origin_tree=tree, **metadata)
        def add(asset, paths=()):
            require(not any(a['asset_id'] == asset['asset_id'] for a in assets), 'duplicate asset ID')
            assets.append(asset)
            for p in paths:
                if p in changed:
                    require(p not in coverage, 'duplicate changed-file coverage: ' + p)
                    coverage[p] = asset['asset_id']
        sourcehash = gate['source_unit_sha256']
        add(make('gate', GATE, gate, GATE in changed, 'retained-unresolved' if openrows else 'selected',
                 path=GATE, blob_sha256=blob(GATE), source_hash=sourcehash, open_rows=openrows), [GATE])
        selected_tasks = {r['faithfulness_task'].rsplit('/', 1)[0]: r['id'] for r in rows if r['status'] in CLOSED}
        for row in rows:
            old = oldrows.get(row['id'])
            add(make('source-row', row['id'], row, old != row, 'retained-unresolved' if row['id'] in openrows else 'selected',
                row=row['id'], status=row['status'], source_hash=sourcehash,
                source_locator={k: row.get(k) for k in ['printed_page','pdf_page','source_label']},
                declarations=row.get('lean_declarations', []), faithfulness_task=row.get('faithfulness_task'),
                gate_blob_sha256=blob(GATE), baseline_row_sha256=digest(canonical(old)) if old else None))
        records, fingerprint_inputs, source_files, record_origins = {}, [], {}, {}
        require(fingerprint_paths and len(set(fingerprint_paths)) == len(fingerprint_paths), 'explicit distinct fingerprint paths required')
        for path in fingerprint_paths:
            f = read(path)
            fingerprint_inputs.append({'path': path, 'sha256': blob(path), 'normalization': f['normalization']})
            for src in f['files']:
                require(blob(src['path']) == src['sha256'], 'origin source/fingerprint mismatch: ' + src['path'])
                if src['path'] in source_files: require(source_files[src['path']] == src, 'conflicting fingerprint source pin')
                source_files[src['path']] = src
            for record in f['records']:
                name = record['name']
                if name in records: require(records[name] == record, 'overlapping unequal native declaration fingerprints')
                records[name] = record
                record_origins.setdefault(name, []).append(path)
        for row in rows:
            if row['status'] in CLOSED:
                for name in row['lean_declarations']:
                    require(name in records, 'missing exact selected declaration fingerprint: ' + name)
        modules = set(source_files) | {p for p in changed if p.endswith('.lean') and p.startswith(('ComputationalMathematics/', 'NumStability/'))}
        for path in sorted(modules):
            module = path[:-5].replace('/', '.')
            imports = re.findall(r'^import\s+(\S+)', blob(path, True).decode(), re.M)
            payload = {'module': module, 'path': path, 'source_sha256': blob(path), 'imports': imports}
            a = make('module', module, payload, path in changed, path=path, module=module, imports=imports,
                source_blob_sha256=blob(path), declaration_names=sorted(n for n, r in records.items() if r['module'] == module),
                baseline_blob_sha256=blob(path, old=True) if path in baseline else None, split_status='none')
            modules_by_name[module] = a['asset_id']; add(a, [path])
        for name, record in sorted(records.items()):
            module = record['module']; path = module.replace('.', '/') + '.lean'
            require(module in modules_by_name and path in entries, 'missing declaration owner')
            require(path not in baseline or path not in changed, 'changed existing declaration owner requires reviewed transport inventory')
            linked = [r['id'] for r in rows if name in r.get('lean_declarations', []) and r['status'] in CLOSED]
            add(make('declaration', name, record, path not in baseline, name=name, module=module,
                module_asset_id=modules_by_name[module], type_hash=record['type_sha256'], proof_hash=record['value_sha256'],
                recursor_values_sha256=record['recursor_values_sha256'], level_params_sha256=record['level_params_sha256'],
                selected_source_rows=linked, source_hash=sourcehash if linked else None,
                fingerprint_origin_paths=record_origins[name], identity_scope='Alpha-canonical structural expression, not full definitional normal form.'))
        historical_tasks = {r['faithfulness_task'].rsplit('/',1)[0] for r in oldgate['rows'] if r['status'] == 'PROVED'}
        audit_roots = sorted({p.rsplit('/',1)[0] for p in entries if p.endswith('/audit-task.json') and p.startswith('gates/leveque-finite-volume/artifacts/')})
        for directory in audit_roots:
            members = sorted(p for p in entries if p.startswith(directory + '/'))
            if not set(members) & changed and directory not in selected_tasks and directory not in historical_tasks: continue
            task = read(directory + '/audit-task.json'); decision_path = task['audit_output'] + '/decision.json'
            decision = read(decision_path) if decision_path in entries else None
            selected = directory in selected_tasks
            require(not selected or decision and decision.get('accepted') is True, 'origin selected audit lacks accepted decision')
            files = [{'path': p, 'sha256': blob(p)} for p in members]
            add(make('audit', task['task_id'], files, bool(set(members) & changed), 'selected' if selected else 'retained-unresolved',
                task_id=task['task_id'], selected_source_row=selected_tasks.get(directory), files=files,
                source_hash=task['source']['sha256'], target=task['target'],
                recorded_classification=decision.get('classification') if decision else None,
                recorded_accepted=decision.get('accepted') if decision else None,
                current_source_certificate=selected,
                purpose='Origin gate-selected audit only' if selected else 'Historical/unfinished origin evidence, not a current source acceptance'), members)
        misc = sorted(changed - set(coverage))
        if misc:
            files = [{'path': p, 'sha256': blob(p)} for p in misc]
            add(make('proof', 'retained-session-and-organization-evidence', files, True, files=files,
                purpose='Every remaining changed tracked file, including raw failures and historical evidence'), misc)
        require(set(coverage) == changed, 'incomplete changed-file coverage')
        changes = []
        for old in oldgate['rows']:
            if old['status'] != 'PROVED': continue
            current = next(r for r in rows if r['id'] == old['id'])
            ot = read(old['faithfulness_task'], True); nt = read(current['faithfulness_task'])
            if ot['target'] != nt['target']:
                on, nn = ot['target']['declaration'], nt['target']['declaration']
                require(on in records and nn in records, 'baseline transport requires old/new native fingerprints')
                changes.append({'row': old['id'], 'old_target': ot['target'], 'new_target': nt['target'],
                    'old_type_sha256': records[on]['type_sha256'], 'new_type_sha256': records[nn]['type_sha256'],
                    'old_proof_sha256': records[on]['value_sha256'], 'new_proof_sha256': records[nn]['value_sha256'],
                    'old_audit_task_sha256': blob(old['faithfulness_task'], old=True), 'new_audit_task_sha256': blob(current['faithfulness_task']),
                    'required_transport_class': 'producer', 'required_faithfulness': 'full-reaudit'})
        changed_blobs = [{'path': p, 'mode': entries[p]['mode'], 'oid': entries[p]['oid'], 'sha256': blob(p), 'asset_id': coverage[p]} for p in sorted(changed)]
        result = {'schema': 2, 'artifact_kind': 'lane-asset-inventory', 'lane_id': lane_id, 'role': lane['role'], 'ref': lane['ref'],
            'head': head, 'tree': tree, 'anchor': anchor, 'topology_sha256': topology_hash,
            'profile_sha256': gate['bindings']['module_profile_sha256'], 'source_sha256': sourcehash,
            'fingerprint_inputs': fingerprint_inputs, 'changed_file_count': len(changed), 'deleted_files': deleted,
            'file_coverage': coverage, 'changed_blobs': changed_blobs, 'assets': assets,
            'required_baseline_producer_transports': changes,
            'branch': {'instance_id': lane_id, 'ref': lane['ref'], 'unique_assets': [a['asset_id'] for a in assets if a['unique']], 'disposition': 'retain'},
            'open_source_rows': openrows, 'require_closed': require_closed,
            'selection_scope': 'Origin committed gate only. These dispositions/certificates are not a candidate selection or new semantic judgment.'}
    finally: batch.close()
    checked_lanes(topology, git_factory)
    require(load(topology_path)[1] == topology_hash, 'topology bytes changed during inventory')
    return result

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--topology', type=Path, required=True); p.add_argument('--lane', required=True)
    p.add_argument('--fingerprints', action='append', required=True); p.add_argument('--require-closed', action='store_true')
    p.add_argument('--output', type=Path, required=True); a = p.parse_args()
    require(not a.output.exists(), 'output already exists')
    result = build(a.topology, a.lane, a.fingerprints, a.require_closed)
    write_new(a.output, result)
    print('Inventoried exact lane ' + a.lane + ': ' + str(len(result['assets'])) + ' assets, ' + str(result['changed_file_count']) + ' changed blobs; no candidate verdict.')

if __name__ == '__main__':
    try: main()
    except (InputError, KeyError, TypeError, OSError, ValueError) as e: raise SystemExit('REFUSED: ' + str(e))
