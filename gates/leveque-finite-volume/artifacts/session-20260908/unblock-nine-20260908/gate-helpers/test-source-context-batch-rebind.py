"""Inherited synthetic guards plus source-context preservation; no operational calls."""
from pathlib import Path
import copy
import hashlib
import importlib.util
import json
import unittest
from unittest.mock import patch

H = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, H / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

assert sha(H / 'test-batch-rebind.py') == '75f4770fd10f485cd1ce83247bdfb900f1431914789bbd7edc8eeeaf78732a0c'
prior = load('unchanged_batch_tests', 'test-batch-rebind.py')
b = load('context_batch_under_test', 'rebind-accepted-row-batch-v2.py')
prior.b = b  # Reuse the ten original test methods against the additive implementation.

def refs():
    return {k: {'path': 'synthetic/' + k + '.json', 'sha256': str(i) * 64}
            for i, k in enumerate(b.q.SOURCE_CONTEXT_KEYS, 1)}

def validation_fixture(context=True):
    row = prior.row('qualified', True)
    if context:
        row.update(refs())
    record = {'row': 'qualified', 'declaration': 'Synthetic.target', 'exit_code': 0,
              **{key: row[key] for key in ('classification', *b.q.DIRECTIONS,
                 'qualified_binding_request', 'coordinator_selected_interpretation', 'native_evidence')}}
    if context:
        record.update(refs())
    ref = {'path': 'synthetic/proposal', 'sha256': 'c' * 64}
    bindings = prior.gate()['bindings']
    result = {'mode': 'released-complete-validation', 'closed_rows': 1, 'records': [record],
              'validated_gate_input': ref, 'current_bindings': bindings}
    return result, ref, bindings, {'qualified': row}

class Guards(prior.Guards):
    def test_source_context_request_copy(self):
        original = {'row': 'synthetic', 'current_bindings': prior.gate()['bindings'],
                    'native': {'check': 'original'}, **refs()}
        copied = b.request_copy(original, {**original['current_bindings'], 'lean_worktree_sha256': 'f' * 64})
        for key in b.q.SOURCE_CONTEXT_KEYS:
            self.assertEqual(copied[key], original[key])
            copied[key]['sha256'] = 'mutation'
            self.assertNotEqual(copied[key], original[key])

    def test_source_context_row_fields_immutable(self):
        before = prior.gate()
        before['rows'][1].update(refs())
        after = copy.deepcopy(before)
        after['bindings']['lean_worktree_sha256'] = 'f' * 64
        after['rows'][1]['qualified_binding_request'] = {'path': 'synthetic/new', 'sha256': 'e' * 64}
        b.preserve(before, after, {'legacy', 'qualified'}, {'qualified'})
        for key in b.q.SOURCE_CONTEXT_KEYS:
            for mutation in ('remove', 'change'):
                bad = copy.deepcopy(after)
                if mutation == 'remove':
                    del bad['rows'][1][key]
                else:
                    bad['rows'][1][key]['sha256'] = '0' * 64
                with self.subTest(key=key, mutation=mutation), self.assertRaises(ValueError):
                    b.preserve(before, bad, {'legacy', 'qualified'}, {'qualified'})

    def test_complete_validation_context_exact(self):
        result, ref, bindings, rows = validation_fixture()
        b.validation_result(result, ref, bindings, rows)
        for key in b.q.SOURCE_CONTEXT_KEYS:
            for mutation in ('remove', 'change', 'null'):
                bad = copy.deepcopy(result)
                if mutation == 'remove':
                    del bad['records'][0][key]
                elif mutation == 'null':
                    bad['records'][0][key] = None
                else:
                    bad['records'][0][key]['sha256'] = '0' * 64
                with self.subTest(key=key, mutation=mutation), self.assertRaises(ValueError):
                    b.validation_result(bad, ref, bindings, rows)

    def test_unextended_validation_no_extra_context(self):
        result, ref, bindings, rows = validation_fixture(False)
        b.validation_result(result, ref, bindings, rows)
        for key in b.q.SOURCE_CONTEXT_KEYS:
            bad = copy.deepcopy(result)
            bad['records'][0][key] = refs()[key]
            with self.subTest(key=key), self.assertRaises(ValueError):
                b.validation_result(bad, ref, bindings, rows)

    def test_successor_derivations_exact(self):
        derivation = json.loads((H / 'source-context-batch-rebind-derivation.json').read_text())
        for name in ('validator', 'batch'):
            entry = derivation[name]
            source = H / entry['source']['path']
            output = H / entry['output']['path']
            self.assertEqual(sha(source), entry['source']['sha256'])
            self.assertEqual(sha(output), entry['output']['sha256'])
            text = source.read_text()
            for change in entry['exact_replacements']:
                self.assertEqual(text.count(change['before']), 1)
                text = text.replace(change['before'], change['after'])
            self.assertEqual(text.encode(), output.read_bytes())
            compile(text, str(output), 'exec')
        old_derivation = json.loads((H / derivation['prior_validator_derivation']['path']).read_text())
        self.assertEqual(derivation['validator']['exact_replacements'], old_derivation['exact_replacements'])
        self.assertEqual(len(derivation['batch']['exact_replacements']), 7)
        for name, expected in b.PINNED.items():
            self.assertEqual(sha(H / name), expected)

if __name__ == '__main__':
    forbidden = AssertionError('Operational call forbidden in synthetic guard tests')
    with patch.object(b, 'main', side_effect=forbidden), \
         patch.object(b.q, 'validate_bound_row', side_effect=forbidden), \
         patch.object(b.q, 'gate_checker', side_effect=forbidden), \
         patch.object(b.subprocess, 'run', side_effect=forbidden), \
         patch.object(b.subprocess, 'check_output', side_effect=forbidden):
        unittest.main(verbosity=2)
