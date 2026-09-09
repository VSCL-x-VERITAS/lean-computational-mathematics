"""Pure/mocked rejection tests and frozen-file checks; no operational entry point.

Synthetic packet/config/manifest shapes below are never written as audit evidence.
They exercise local input guards only and cannot establish audit completeness.
"""
import ast
import copy
import importlib.util
import json
import os
from pathlib import Path
from unittest.mock import patch

import qualified_row_support as old
import qualified_row_support_v2 as q


def main():
    tests = []
    def passed(name):
        tests.append(name)
    def rejected(name, action):
        try:
            action()
        except (ValueError, KeyError, TypeError):
            passed(name)
        else:
            raise AssertionError('expected rejection: ' + name)
    for name in ('qualified_row_support_v2.py', 'bind-qualified-row-v2.py',
                 'validate-closed-row-audits-v5.py', 'test-qualified-refinement-v2.py'):
        ast.parse((q.HERE/name).read_text())
        passed('syntax ' + name)
    old_ast = ast.parse((q.HERE/'qualified_row_support.py').read_text())
    new_ast = ast.parse((q.HERE/'qualified_row_support_v2.py').read_text())
    unchanged = ['validate_preserved_rows', 'validate_native', 'stronger_fields', 'accepted_pair',
                 'declaration_axioms', 'choices', 'base', 'bound', 'repo_path', 'gate_checker']
    for name in unchanged:
        extract = lambda tree: ast.dump(next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == name))
        assert extract(old_ast) == extract(new_ast), name
        passed('unchanged protection AST ' + name)
    # Existing tests cover the original protected32/skipped16 and real native receipts.
    spec = importlib.util.spec_from_file_location('original_qualified_selftest', q.HERE/'selftest.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    with patch.object(module, 'q', q):
        module.main()
    passed('original 28 tests rerun against v2 support')
    material_decision = q.SESSION/'audits/LEV-CH01-MATERIAL-INTERFACE-TOPOLOGY-INTERPRETED-PRODUCTION-20260908/faithfulness/decision.json'
    completed_decision = q.read(material_decision)
    assert q.accepted_pair(completed_decision) == ('faithful-equivalent', ('yes', 'yes'))
    assert q.validate_interpretation_qualification(completed_decision, 'Q5') == 'explicit-rationale-and-both-implications'
    passed('actual completed material topology decision uses rationale and both implications without prescribed finding category')
    for field in ('rationale', *q.DIRECTIONS):
        changed = copy.deepcopy(completed_decision)
        if field == 'rationale':
            changed[field] = 'Unqualified equivalence.'
        else:
            changed['implications'][field]['reasoning'] = 'Unqualified implication.'
        rejected('missing explicit qualification in ' + field,
                 lambda changed=changed: q.validate_interpretation_qualification(changed, 'Q5'))
    rejected('rationale identifies wrong choice', lambda: q.validate_interpretation_qualification(completed_decision, 'Q6'))
    selection, mapping = q.choices()
    observed_addenda = []
    for row, pin in q.REFINEMENTS.items():
        label = pin['choice_id']
        ref = {key: pin[key] for key in ('path', 'sha256')}
        content = q.read(q.bound(ref))
        observed_addenda.append(ref)
        packet = {key: copy.deepcopy(selection[key]) for key in
                  ('authority', 'exact_user_objective', 'goal_observation_sha256', 'preservation')}
        packet.update(scope_row=row, choice=mapping[row], selection_receipt=q.reference(q.SELECTION),
                      interpretation_refinement_ref=ref, interpretation_refinement=content)
        task = {'target': {key: content['unchanged_target'][key] for key in ('path', 'declaration')},
                'source': content['source']}
        manifest = {'lean_environment': [ref]}
        config = {'lean': {'environment_files': [ref['path']]}}
        def check(p=packet, t=task, m=manifest, c=config):
            return q.validate_refinement(p, t, m, c)
        valid = check()
        assert valid == {'reference': ref, 'content': content}
        passed(label + ' actual pinned addendum and source/target/provenance bytes; synthetic audit envelope')
        for missing in ('interpretation_refinement_ref', 'interpretation_refinement'):
            p = copy.deepcopy(packet); del p[missing]
            rejected(label + ' missing ' + missing, lambda p=p: check(p=p))
        p = copy.deepcopy(packet)
        p['interpretation_refinement_ref']['sha256'] = '0' * 64
        rejected(label + ' mutated pointer', lambda: check(p=p))
        p = copy.deepcopy(packet)
        p['interpretation_refinement']['selected_model']['synthetic'] = 'mutation'
        rejected(label + ' altered embedded JSON', lambda: check(p=p))
        p = copy.deepcopy(packet); p['scope_row'] = 'LEV-CH01-HETEROGENEOUS-CELL-AVERAGING'
        rejected(label + ' unsupported row', lambda: check(p=p))
        p = copy.deepcopy(packet)
        p['scope_row'] = next(other for other in q.REFINEMENTS if other != row)
        rejected(label + ' cross Q6/Q9 pairing', lambda: check(p=p))
        rejected(label + ' absent configuration addendum', lambda: check(c={'lean': {'environment_files': []}}))
        rejected(label + ' duplicate configuration addendum', lambda: check(c={'lean': {'environment_files': [ref['path']] * 2}}))
        rejected(label + ' absent manifest addendum', lambda: check(m={'lean_environment': []}))
        rejected(label + ' duplicate manifest addendum', lambda: check(m={'lean_environment': [ref, ref]}))
        rejected(label + ' wrong manifest addendum hash', lambda: check(m={'lean_environment': [{**ref, 'sha256': '0' * 64}]}))
        other = next(item for key, item in q.REFINEMENTS.items() if key != row)
        rejected(label + ' other row addendum in configuration',
                 lambda: check(c={'lean': {'environment_files': [ref['path'], other['path']]}}))
        p = {key: value for key, value in packet.items() if not key.startswith('interpretation_refinement')}
        rejected(label + ' omitted packet refinement but configured addendum', lambda: check(p=p))
        assert check(p=p, m={'lean_environment': []}, c={'lean': {'environment_files': []}}) is None
        passed(label + ' unrefined compatibility with neither addendum key')
        # Mock decoded content only to reach each explicit semantic guard after pin checks.
        # This is a test double, not evidence for any modified real file or accepted task.
        def malformed(key, value):
            altered = copy.deepcopy(content); altered[key] = value
            p = copy.deepcopy(packet); p['interpretation_refinement'] = altered
            original_read = q.read
            def read(path):
                return altered if Path(path) == q.repo_path(ref['path']) else original_read(path)
            with patch.object(q, 'read', read):
                return check(p=p)
        for key, value in [('selected_model', {}), ('selected_model', {'x': ''}),
                           ('source_ambiguities_preserved', []), ('source_ambiguities_preserved', 'wrong type'),
                           ('prior_choice_id', 'Q0'), ('prior_choice_exact', {}),
                           ('authority', 'literal user reply'), ('preservation', []),
                           ('prior_selection_receipt', {**ref, 'sha256': '0' * 64}),
                           ('source', {**content['source'], 'sha256': '0' * 64}),
                           ('unchanged_target', {**content['unchanged_target'], 'declaration': 'Synthetic.wrong'}),
                           ('no_production_or_native_supplement_change', False)]:
            rejected(label + ' explicit guard ' + key + ' ' + repr(value)[:35], lambda k=key, v=value: malformed(k, v))
        # Exact contract preservation and append-only mathematical refinement.
        source = {'contract_plain_english': 'Synthetic original source account.',
                  'statement': {'hypotheses': ['H'], 'implicit_context': ['I'], 'binders': ['B']}}
        v = {'request': {'interpretation_packet': {'sha256': '1' * 64}},
             'packet': packet, 'output': Path('synthetic'), 'refinement': None}
        with patch.object(old, 'read', return_value=source), patch.object(old, 'sha', return_value='2' * 64), \
             patch.object(q, 'read', return_value=source), patch.object(q, 'sha', return_value='2' * 64):
            original = old.contract_for(v)
            assert q.encode(original) == q.encode(q.contract_for(v))
            passed(label + ' unrefined contract bytes identical')
            v['refinement'] = valid
            extended = q.contract_for(v)
            assert extended['statement'].startswith(original['statement'])
            assert extended['quantifiers'] == original['quantifiers']
            assert extended['assumptions'][:len(original['assumptions'])] == original['assumptions']
            assert ref['sha256'] in extended['statement']
            for key, value in content['selected_model'].items():
                assert 'Selected model [' + key + ']: ' + value in extended['assumptions']
            for value in content['source_ambiguities_preserved']:
                assert 'Preserved source ambiguity: ' + value in extended['assumptions']
            passed(label + ' every exact mathematical clause/ambiguity/hash appended')
    # The addendum is not a Lean file or a substitute for the actual native receipt.
    d = q.SESSION/'unblock-nine-20260908/material-review'
    proof = q.read(d/'production-manifest.json')
    target = next(item for item in proof['files'] if item['path'].endswith('/SourceTermsRectangleBalance.lean'))
    native = {'receipt_kind': 'snapshots', 'check': q.reference(d/'Checks.lean'),
              'output': q.reference(d/'checks-final/output.txt'),
              'receipt': q.reference(d/'checks-final/receipt.json'),
              'proof_manifest': q.reference(d/'production-manifest.json'),
              'declarations': target['declarations']}
    task = {'target': {'path': target['path'], 'declaration': target['declarations'][0]}}
    q.validate_native(native, task)
    receipt = q.read(q.bound(native['receipt']))
    assert not any('interpretation-refinement.json' in item['path'] for item in receipt['inputs'])
    passed('real native Lean target evidence remains valid without nonnative addendum in native snapshot')
    rejected('JSON addendum cannot substitute for native Lean check', lambda: q.validate_native(
        {**native, 'check': observed_addenda[0]}, task))
    rejected('nonnative invented receipt kind rejected', lambda: q.validate_native(
        {**native, 'receipt_kind': 'coordinator-json'}, task))
    original_read = q.read
    for field, value in [('exit_code', 1), ('command', ['python.exe', 'env', 'lean', str(d/'Checks.lean')])]:
        def read(path, field=field, value=value):
            return {**receipt, field: value} if Path(path) == q.bound(native['receipt']) else original_read(path)
        with patch.object(q, 'read', read):
            rejected('native guard remains mandatory: ' + field, lambda: q.validate_native(native, task))
    # Current closed unrefined rows are already-completed audits; no live outputs read.
    gate = q.read(q.ROOT/'gates/leveque-finite-volume/chapter-01.json')
    real_unreffined = []
    for row in gate['rows']:
        if row.get('status') not in ('PROVED', 'REUSED') or 'qualified_binding_request' not in row:
            continue
        request = q.read(q.bound(row['qualified_binding_request']))
        packet = q.read(q.bound(request['interpretation_packet']))
        if 'interpretation_refinement_ref' in packet:
            continue
        task = q.read(q.bound(request['task']))
        output = q.repo_path(task['audit_output'])
        if os.name == 'nt':
            output = Path('\\\\?\\' + str(output))
        value = {'request': request, 'packet': packet, 'output': output, 'refinement': None}
        assert q.encode(old.contract_for(value)) == q.encode(q.contract_for(value))
        assert row['contract_hash'] == q.canonical_sha256(q.contract_for(value))
        real_unreffined.append(row['id'])
    passed('actual closed unrefined contract bytes/hash preserved: ' + ', '.join(real_unreffined))
    print(json.dumps({'status': 'PASS', 'tests': tests, 'count': len(tests),
                      'original_tests_also_passed': 28, 'actual_closed_unrefined_rows': real_unreffined,
                      'completed_qualification_regression': q.reference(material_decision),
                      'bound_refinements': observed_addenda,
                      'audit_commands': 0, 'git_commands': 0, 'gate_writes': 0,
                      'synthetic_objects_are_not_audit_evidence': True}, indent=2))


if __name__ == '__main__':
    main()
