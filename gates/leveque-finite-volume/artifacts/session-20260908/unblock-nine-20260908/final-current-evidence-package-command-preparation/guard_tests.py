"""POSIX-only pure guard fixtures plus read-only real suite/source pin checks.

Never invokes assembler.main, a gate checker, Git, an audit or a binder.
Synthetic records exist only in memory and are not evidence for actual rows.
"""
from pathlib import Path
import copy
import hashlib
import importlib.util
import json
import os

assert os.name != 'nt', 'Run through the POSIX launcher.'
D = Path(__file__).resolve().parents[1]
path = D / 'prepare-final-current-evidence-inputs-package-command-v1.py'
spec = importlib.util.spec_from_file_location('assembler_under_test', path)
a = importlib.util.module_from_spec(spec)
spec.loader.exec_module(a)
passed = []


def check(name, operation):
    operation()
    passed.append(name)


def rejects(operation):
    try:
        operation()
    except (ValueError, AssertionError, KeyError):
        return
    raise AssertionError('Expected rejection')


reader = a.Reader()
selected = a.suite(reader)
check('real adopted suite bytes and exact dependency links', lambda: reader.unchanged())
fingerprints = a.current_fingerprints(reader, selected)
check('one real effective fingerprint inventory and all 183 current owner source pins', lambda: reader.unchanged())
q = a.load_support(reader.bound(selected['helpers']['support']))

gate = {'rows': [{'id': f'fixture-{n:02}', 'status': 'PROVED' if n < 41 else 'SKIPPED'} for n in range(57)]}
closed = a.closed_rows(gate)
check('fixture exact 41 closed 16 skipped accepted by count guard', lambda: a.closed_rows(gate))
missing = copy.deepcopy(gate)
missing['rows'][0]['status'] = 'READY'
check('40 closed rejects', lambda: rejects(lambda: a.closed_rows(missing)))
duplicate = copy.deepcopy(gate)
duplicate['rows'][1]['id'] = duplicate['rows'][0]['id']
check('duplicate row identity rejects', lambda: rejects(lambda: a.closed_rows(duplicate)))

task = {'task_id': 'fixture-task', 'target': {'declaration': 'Fixture.theorem'}}
row = {'lean_declarations': ['Fixture.theorem'], 'classification': 'faithful-equivalent',
       'lean_implies_source': 'yes', 'source_implies_lean': 'yes'}
decision = {'task_id': 'fixture-task', 'accepted': True, 'classification': 'faithful-equivalent',
            'implications': {key: {'verdict': 'yes'} for key in ('lean_implies_source', 'source_implies_lean')}}
check('equivalent decision projection matches fixture', lambda: a.decision_matches(row, task, decision, q.accepted_pair))
strong_row, strong_decision = copy.deepcopy(row), copy.deepcopy(decision)
strong_row.update(classification='faithful-stronger', source_implies_lean='no')
strong_decision['classification'] = 'faithful-stronger'
strong_decision['implications']['source_implies_lean']['verdict'] = 'no'
check('accepted stronger yes/no preserved rather than coerced to equivalent',
      lambda: a.decision_matches(strong_row, task, strong_decision, q.accepted_pair))
unaccepted = dict(decision, accepted=False)
check('unaccepted decision rejects despite closed status', lambda: rejects(lambda: a.decision_matches(row, task, unaccepted, q.accepted_pair)))
check('mismatched implication projection rejects', lambda: rejects(lambda: a.decision_matches(row, task, strong_decision, q.accepted_pair)))
check('wrong task rejects', lambda: rejects(lambda: a.decision_matches(row, dict(task, task_id='other'), decision, q.accepted_pair)))
check('wrong selected declaration rejects', lambda: rejects(lambda: a.decision_matches(dict(row, lean_declarations=['Other']), task, decision, q.accepted_pair)))

head, output = '1' * 40, '2' * 64
receipt = {'exit_code': 0, 'input_commit': head, 'output_sha256': output, 'elapsed_ms': 1}
check('actual receipt fixture with current commit', lambda: a.evidence_receipt(receipt, output, head))
for key, value in [('exit_code', True), ('exit_code', 1), ('input_commit', 'old'), ('output_sha256', 'changed'), ('elapsed_ms', -1)]:
    check('receipt rejects ' + key + '=' + str(value),
          lambda key=key, value=value: rejects(lambda: a.evidence_receipt(dict(receipt, **{key: value}), output, head)))

audit = {'mode': 'released-complete-validation', 'closed_rows': 41,
         'records': [{'row': item['id'], 'exit_code': 0} for item in closed]}
command = ['/usr/bin/python3', '-B', selected['validator']['path'], '--validate', '--require-all-closed']
check('exact selected complete-validator command fixture', lambda: a.audit_receipt({'command': command}, audit, closed, selected))
absolute = ['/usr/bin/python3', str(a.R / selected['validator']['path']), '--validate', '--require-all-closed']
check('same exact validator via absolute path and optional B supported', lambda: a.audit_receipt({'command': absolute}, audit, closed, selected))
old = command.copy()
old[2] = selected['validator']['path'].replace('package-command-v1', 'dim-roots-v2')
check('mixed old validator rejects', lambda: rejects(lambda: a.audit_receipt({'command': old}, audit, closed, selected)))
check('missing require-all-closed rejects', lambda: rejects(lambda: a.audit_receipt({'command': command[:-1]}, audit, closed, selected)))
check('inventory-only result rejects', lambda: rejects(lambda: a.audit_receipt({'command': command}, dict(audit, mode='inventory-only-not-validation'), closed, selected)))
failed = copy.deepcopy(audit)
failed['records'][0]['exit_code'] = 1
check('failed inner complete-validation rejects', lambda: rejects(lambda: a.audit_receipt({'command': command}, failed, closed, selected)))
check('missing record rejects', lambda: rejects(lambda: a.audit_receipt({'command': command}, dict(audit, records=audit['records'][:-1]), closed, selected)))
check('out-of-order or duplicate record rejects', lambda: rejects(lambda: a.audit_receipt({'command': command}, dict(audit, records=list(reversed(audit['records']))), closed, selected)))
check('path escape rejects', lambda: rejects(lambda: reader.path('../outside')))
check('absolute path rejects', lambda: rejects(lambda: reader.path('/tmp/outside')))
check('wrong actual helper digest rejects', lambda: rejects(lambda: reader.bound(dict(selected['helpers']['closed'], sha256='0' * 64))))
check('duplicate JSON key rejects', lambda: rejects(lambda: json.loads('{"x":1,"x":2}', object_pairs_hook=a.unique_pairs)))

check('exact eleven global dependency refs retained', lambda: a.require(len(selected['validator_dependencies']) == 11, 'Expected 11'))
check('new support selected consistently', lambda: a.require(selected['helpers']['support']['path'].endswith('/qualified_row_support_package_command_v1.py'), 'Mixed support'))
check('actual installed helper suite is bound', lambda: a.require('physical-dim-package-runtime-preparation/installation-01/receipt.json' in selected['pins'], 'Missing installation'))
check('actual coordinator adoption is bound', lambda: a.require('physical-dim-package-runtime-preparation/root-adoption-receipt.json' in selected['pins'], 'Missing adoption'))
old_helpers = dict(a.HELPERS)
try:
    a.HELPERS['closed'] = 'gate-helpers/validate-closed-row-audits-dim-roots-v2.py'
    check('mixed old helper selection rejects', lambda: rejects(lambda: a.suite(a.Reader())))
finally:
    a.HELPERS.clear()
    a.HELPERS.update(old_helpers)

reader.unchanged()
print(json.dumps({'format': 'pure-final-evidence-guards-1', 'passed': len(passed), 'checks': passed,
                  'real_suite': selected, 'real_effective_fingerprints': fingerprints,
                  'operational_assembler_invoked': False, 'gate_mutation': False, 'audit_roles': False,
                  'actual_source_acceptance_claim': False,
                  'inputs': [{'path': p.relative_to(a.R).as_posix(), 'sha256': digest}
                             for p, digest in sorted(reader.observed.items())]}, indent=2))
