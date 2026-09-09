"""Pure rejection tests and read-only checks against already frozen native evidence.

Does not construct a binding request, run a validator/audit, or invoke Git.
"""
import ast
import copy
import json
from pathlib import Path

import qualified_row_support as q


def main():
    tests = []
    def passed(name):
        tests.append(name)
    def rejected(name, action):
        try:
            action()
        except (ValueError, KeyError):
            passed(name)
        else:
            raise AssertionError('expected rejection: ' + name)
    for name in ('qualified_row_support.py', 'bind-qualified-row.py', 'validate-closed-row-audits-v4.py', 'selftest.py'):
        ast.parse((q.HERE/name).read_text())
        passed('syntax ' + name)
    q.base()
    passed('pinned original stronger utilities load without main')
    selection, mapping = q.choices()
    assert len(mapping) == 9
    passed('exact nine rows/eight coordinator choices')
    gate = q.read(q.ROOT/'gates/leveque-finite-volume/chapter-01.json')
    baseline = q.validate_preserved_rows(gate)
    passed('actual unchanged 32 accepted semantic bindings and 16 skipped objects')
    altered = copy.deepcopy(gate)
    row = next(r for r in altered['rows'] if r['id'] == baseline['closed_rows'][0]['id'])
    row['classification'] = 'not-faithful-weaker'
    rejected('historical acceptance cannot change', lambda: q.validate_preserved_rows(altered))
    altered = copy.deepcopy(gate)
    row = next(r for r in altered['rows'] if r['id'] == baseline['skipped_rows'][0]['id'])
    row['reason'] += ' changed'
    rejected('historical skip cannot change', lambda: q.validate_preserved_rows(altered))
    altered = copy.deepcopy(gate)
    row = next(r for r in altered['rows'] if r['id'] == baseline['closed_rows'][0]['id'])
    row['blind_sha256'] = '0' * 64
    q.validate_preserved_rows(altered)
    passed('semantic baseline permits separate artifact refresh (artifact validity remains released checker responsibility)')
    for classification, pair in q.PAIRS.items():
        synthetic = {'accepted': True, 'classification': classification,
                     'implications': dict(zip(q.DIRECTIONS, [{'verdict': p} for p in pair]))}
        assert q.accepted_pair(synthetic) == (classification, pair)
        passed('synthetic classification pairing ' + classification)
        synthetic['accepted'] = False
        rejected('unaccepted ' + classification, lambda: q.accepted_pair(synthetic))
    rejected('stronger cannot silently become equivalent', lambda: q.accepted_pair({
        'accepted': True, 'classification': 'faithful-stronger',
        'implications': {d: {'verdict': 'yes'} for d in q.DIRECTIONS}}))
    for classification in ('undetermined', 'not-faithful-weaker', 'not-faithful-different'):
        rejected('forbidden ' + classification, lambda c=classification: q.accepted_pair({'accepted': True, 'classification': c}))
    for path in ('../outside', 'C:/elsewhere', '/tmp/elsewhere'):
        rejected('path escape ' + path, lambda p=path: q.repo_path(p))
    name = 'Synthetic.fixture'
    assert q.declaration_axioms(name + ' : True\n\'' + name + "' does not depend on any axioms", name) == []
    passed('empty axiom report')
    assert q.declaration_axioms(name + '.{u_1} : True\n\'' + name + ".{u_1}' depends on axioms: [propext]", name) == ['propext']
    passed('universe-displayed declaration/axioms')
    rejected('sorry axiom', lambda: q.declaration_axioms(name + ' : True\n\'' + name + "' depends on axioms: [sorryAx]", name))
    rejected('duplicate axiom report', lambda: q.declaration_axioms(name + ' : True\n' + ("'" + name + "' depends on axioms: []\n") * 2, name))
    directory = q.SESSION/'unblock-nine-20260908/material-review'
    proof = q.read(directory/'production-manifest.json')
    for target in proof['files']:
        native = {'receipt_kind': 'snapshots', 'check': q.reference(directory/'Checks.lean'),
                  'output': q.reference(directory/'checks-final/output.txt'),
                  'receipt': q.reference(directory/'checks-final/receipt.json'),
                  'proof_manifest': q.reference(directory/'production-manifest.json'),
                  'declarations': target['declarations']}
        result = q.validate_native(native, {'target': {'path': target['path'], 'declaration': target['declarations'][0]}})
        assert set(result[target['declarations'][0]]) <= q.ALLOWED_AXIOMS
        passed('actual native snapshot evidence ' + target['declarations'][0])
    print(json.dumps({'status': 'PASS', 'tests': tests, 'count': len(tests),
                      'audit_commands': 0, 'git_commands': 0, 'gate_writes': 0,
                      'synthetic_objects_are_not_audit_evidence': True}, indent=2))


if __name__ == '__main__':
    main()
