"""Candidate-local replay; never creates a gate, epoch, or semantic judgment.

The supplied input manifest must be committed before candidate construction.
The candidate tree is an external command argument, avoiding a commit/hash cycle.
Only successful deterministic summaries reach stdout; native failures retain diagnostics.
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys

sys.dont_write_bytecode = True
CHECKS = ('source_coverage', 'import_graph', 'signature_graph', 'body_graph',
          'declaration_resolution', 'focused_build', 'full_build', 'pristine_replay')
SESSION = 'gates/leveque-finite-volume/artifacts/session-20260908'
HERE = SESSION + '/unblock-nine-20260908/final-candidate-epoch-preparation'
TOOLS = {
    'coverage': SESSION + '/verify-reviewed-source-coverage.py',
    'architecture': SESSION + '/validate-candidate-architecture.py',
    'layout': 'tools/architecture/check_layout.py',
    'tiers': 'tools/architecture/check_tiers.py',
    'compatibility': 'tools/architecture/check_compatibility.py',
    'hygiene': 'tools/architecture/check_placeholders.py',
}
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}
QUALIFICATIONS = ('coordinator_selected_interpretation', 'interpretation_refinement_ref',
    'strengthening_evidence', 'qualified_binding_request', 'native_evidence',
    'source_context_extension', 'inherited_source_interpretation_packet', 'source_context_lineage')


def need(ok, message):
    if not ok:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def relative(value):
    need(isinstance(value, str) and value and '\\' not in value and ':' not in value,
         'Expected portable repository-relative path')
    p = Path(value)
    need(not p.is_absolute() and '..' not in p.parts and '.' not in p.parts,
         'Path escapes repository')
    return p


def git(root, *args):
    return subprocess.check_output(['git', '-c', 'core.longpaths=true', *args], cwd=root)


def bound(root, ref, committed=False):
    need(isinstance(ref, dict) and set(ref) == {'path', 'sha256'}, 'Invalid file reference')
    need(re.fullmatch('[0-9a-f]{64}', ref['sha256']) is not None, 'Invalid file SHA256')
    path = root / relative(ref['path'])
    need(path.resolve().is_relative_to(root.resolve()) and not path.is_symlink(), 'Unsafe input path')
    data = path.read_bytes()
    need(digest(data) == ref['sha256'], 'Changed input: ' + ref['path'])
    if committed:
        need(git(root, 'show', 'HEAD:' + ref['path']) == data, 'Input is not exact committed content')
    return data


def decoded(root, ref, committed=False):
    return json.loads(bound(root, ref, committed))


def frozen_execution(root, item, committed=False):
    receipt = decoded(root, item['receipt'], committed)
    output = bound(root, item['output'], committed)
    need(type(receipt.get('exit_code')) is int and receipt['exit_code'] == 0, 'Missing actual zero exit')
    need(receipt.get('output_sha256') == digest(output), 'Raw output differs from receipt')
    need(isinstance(receipt.get('elapsed_ms'), int) and not isinstance(receipt['elapsed_ms'], bool)
         and receipt['elapsed_ms'] >= 0, 'Missing actual elapsed time')
    need(receipt.get('command') == item['command'], 'Execution command does not match exact input')
    need(re.fullmatch('[0-9a-f]{40}', receipt.get('input_commit', '')) is not None,
         'Missing actual original input commit')
    return receipt, output


def verify_audit_records(root, gate, raw, committed=False):
    data = json.loads(raw)
    need(data.get('mode') == 'released-complete-validation' and data.get('closed_rows') == 41,
         'Requires actual complete audit validation for 41 rows')
    rows = {r['id']: r for r in gate['rows'] if r['status'] in ('PROVED', 'REUSED')}
    records = data.get('records', [])
    need(len(rows) == len(records) == 41 and {r['row'] for r in records} == set(rows),
         'Audit receipt does not cover the exact selected rows')
    for record in records:
        row = rows[record['row']]
        task_path = row['faithfulness_task']
        task = json.loads((root / relative(task_path)).read_bytes())
        out = relative(task['audit_output'])
        manifest = decoded(root, {'path': (out / 'manifest.json').as_posix(),
                                 'sha256': record['manifest_sha256']}, committed)
        decision = decoded(root, {'path': (out / 'decision.json').as_posix(),
                                 'sha256': record['decision_sha256']}, committed)
        bound(root, {k: manifest['task_metadata'][k] for k in ('path', 'sha256')}, committed)
        bound(root, {k: manifest['target'][k] for k in ('path', 'sha256')}, committed)
        bound(root, record['config'], committed)
        need(manifest['task_metadata']['path'] == task_path, 'Task provenance differs')
        need(record['task'] == task['task_id'] == decision['task_id'] == manifest['task_id'], 'Task mismatch')
        need(row['lean_declarations'] == [record['declaration']] == [task['target']['declaration']],
             'Selected declaration differs')
        need(decision.get('accepted') is True and type(record.get('exit_code')) is int and record['exit_code'] == 0,
             'Not an accepted, actually validated sealed decision')
        need(record['classification'] == row['classification'] == decision['classification'],
             'Classification differs')
        pairs = {'faithful-equivalent': ('yes', 'yes'), 'faithful-stronger': ('yes', 'no')}
        need(record['classification'] in pairs and tuple(record[k] for k in
             ('lean_implies_source', 'source_implies_lean')) == pairs[record['classification']],
             'Classification/implication pair is invalid')
        for key in ('lean_implies_source', 'source_implies_lean'):
            need(record[key] == row[key] == decision['implications'][key]['verdict'], 'Implication differs')
        for key in QUALIFICATIONS:
            need(record.get(key) == row.get(key), 'Changed qualification: ' + key)


def load_inputs(root, ref, committed=False):
    spec = decoded(root, ref, committed)
    need(spec.get('schema_version') == 1 and spec.get('kind') == 'candidate-replay-inputs', 'Wrong manifest kind')
    pins = spec['immutable_inputs']
    need(pins and len({p['path'] for p in pins}) == len(pins), 'Need unique full evidence-closure pins')
    for pin in pins:
        bound(root, pin, committed)
    gate = decoded(root, spec['gate'], committed)
    need(gate['book_id'] == 'leveque-finite-volume' and gate['chapter'] == 1
         and gate['chapter_gate'] == 'PASS', 'Requires the real final Chapter1 PASS gate')
    need(len(gate['rows']) == 57 and len({r['id'] for r in gate['rows']}) == 57, 'Wrong inventory')
    need(sum(r['status'] in ('PROVED', 'REUSED') for r in gate['rows']) == 41
         and sum(r['status'] == 'SKIPPED' for r in gate['rows']) == 16, 'Not all rows closed')
    _, audit_raw = frozen_execution(root, spec['complete_audit_execution'], committed)
    command = spec['complete_audit_execution']['command']
    need(isinstance(command, list) and command[-2:] == ['--validate', '--require-all-closed'],
         'Wrong complete validator invocation')
    verify_audit_records(root, gate, audit_raw, committed)
    frozen_execution(root, spec['final_gate_execution'], committed)
    gate_command = spec['final_gate_execution']['command']
    need(isinstance(gate_command, list) and '--require-pass' in gate_command, 'Missing actual PASS check')
    dm = decoded(root, spec['declaration_manifest'], committed)
    names = sorted(d for row in gate['rows'] if row['status'] != 'SKIPPED' for d in row['lean_declarations'])
    need(len(names) == len(set(names)) == 41 and sorted(dm['declarations']) == names, 'Native check misses targets')
    for item in dm['files']:
        bound(root, {k: item[k] for k in ('path', 'sha256')}, committed)
    check = bound(root, {'path': dm['check_file'], 'sha256': dm['check_file_sha256']}, committed).decode('utf-8')
    expected = 'import ComputationalMathematics.Source.LeVeque.Chapter01\n\n' + '\n'.join(
        '#check ' + n + '\n#print axioms ' + n for n in names) + '\n'
    need(check.replace('\r\n', '\n') == expected, 'Native input differs from exact 41 checks/axioms')
    need(set(spec['tools']) == set(TOOLS), 'Missing replay tool')
    for name, path in TOOLS.items():
        need(spec['tools'][name]['path'] == path, 'Unexpected replay tool path')
        bound(root, spec['tools'][name], committed)
    name = spec['architecture_baseline_name']
    need(re.fullmatch('[A-Za-z0-9-]+', name) is not None, 'Unsafe baseline name')
    expected_graph = SESSION + '/architecture-graphs/' + name
    need(spec['graph_json']['path'] == expected_graph + '.json'
         and spec['graph_markdown']['path'] == expected_graph + '.md', 'Graph pair mismatch')
    bound(root, spec['graph_json'], committed); bound(root, spec['graph_markdown'], committed)
    # This reviewed measurement retains exact set-valued unit scope and ratchet evidence.
    # The pristine phase additionally executes current repository organization checkers.
    org = decoded(root, spec['organization_measurement'], committed)
    need(set(org['unit_scope']) == {'unexpected_changes', 'unclassified_modules', 'mixed_pending_split',
         'duplicate_wrappers', 'placeholder_findings', 'canonical_placement_pending'}, 'Incomplete scoped measurements')
    need(all(v == [] for v in org['unit_scope'].values()), 'Nonzero scoped organization finding')
    need(org['repository_ratchet'], 'Missing measured repository ratchet')
    review = decoded(root, spec['evidence_closure_review'], committed)
    need(review['status'] == 'reviewed-complete' and review['gate_sha256'] == spec['gate']['sha256']
         and review['immutable_inputs_sha256'] == digest(json.dumps(pins, sort_keys=True,
             separators=(',', ':'), ensure_ascii=True).encode()), 'Incomplete or mismatched evidence closure review')
    return spec, gate, dm


def run(root, command):
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1')
    result = subprocess.run(command, cwd=root, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if result.returncode:
        sys.stdout.buffer.write(result.stdout)
        raise ValueError('Actual command failed: ' + json.dumps(command) + '; exit=' + str(result.returncode))
    return result.stdout


def check(root, ref, phase, candidate_tree):
    need(re.fullmatch('[0-9a-f]{40}', candidate_tree) is not None, 'Actual candidate tree required')
    need(git(root, 'rev-parse', 'HEAD^{tree}').decode().strip() == candidate_tree, 'Wrong candidate tree')
    need(not git(root, 'status', '--porcelain', '--untracked-files=all').strip(), 'Candidate is dirty')
    spec, gate, dm = load_inputs(root, ref, committed=True)
    py = sys.executable
    if phase == 'source_coverage':
        run(root, [py, TOOLS['coverage']])
    elif phase in ('import_graph', 'signature_graph', 'body_graph'):
        # Existing wrapper checks all three graphs; cold imports are built before extraction.
        run(root, [py, TOOLS['architecture'], '--baseline-name', spec['architecture_baseline_name']])
    elif phase == 'declaration_resolution':
        raw = run(root, ['lake', 'env', 'lean', dm['check_file']]).decode('utf-8')
        reports = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", raw, re.S)
        need(len(reports) == 41 and {n for n, _ in reports} == set(dm['declarations']), 'Missing native axiom reports')
        for _, axioms in reports:
            need(set(x.strip() for x in axioms.split(',') if x.strip()) <= ALLOWED_AXIOMS, 'Unapproved native axiom')
    elif phase == 'focused_build':
        run(root, ['lake', '--quiet', '--log-level=error', 'build',
                   'ComputationalMathematics.Source.LeVeque.Chapter01', 'NumStability.Source.LeVeque.Chapter01'])
    elif phase == 'full_build':
        run(root, ['lake', '--quiet', '--log-level=error', 'build'])
    elif phase == 'pristine_replay':
        for name in ('layout', 'tiers', 'compatibility', 'hygiene'):
            run(root, [py, TOOLS[name]])
    else:
        raise ValueError('Unknown check')
    load_inputs(root, ref, committed=True)
    need(git(root, 'rev-parse', 'HEAD^{tree}').decode().strip() == candidate_tree, 'Candidate tree changed')
    need(not git(root, 'status', '--porcelain', '--untracked-files=all').strip(), 'Replay changed candidate')
    print(json.dumps({'check': phase, 'result': 'PASS', 'input_manifest_sha256': ref['sha256'],
        'gate_sha256': spec['gate']['sha256'], 'scope': 'Current exact inputs; frozen source judgments; actual local replay'},
        sort_keys=True, separators=(',', ':')))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--inputs', required=True); p.add_argument('--inputs-sha256', required=True)
    p.add_argument('--check', choices=CHECKS, required=True); p.add_argument('--candidate-tree', required=True)
    a = p.parse_args()
    root = Path(__file__).resolve().parents[6]
    own = HERE + '/candidate_checks.py'
    need(git(root, 'show', 'HEAD:' + own) == Path(__file__).read_bytes(), 'Replay helper is not exact committed bytes')
    check(root, {'path': a.inputs, 'sha256': a.inputs_sha256}, a.check, a.candidate_tree)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError, TypeError) as exc:
        raise SystemExit('REFUSED: ' + str(exc))
