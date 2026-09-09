"""Metadata guard regressions only; no actual source verdict or gate mutation."""
from pathlib import Path
import ast
import copy
import importlib.util
import json
import unittest

H = Path(__file__).resolve().parent
def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, H / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

prior_context = load('context_regressions', 'test-source-context-helpers.py')
q = load('high_resolution_q4', 'qualified_row_support_v4.py')
prior_context.q = q
prior_batch = load('batch_regressions', 'test-source-context-batch-rebind.py')
batch = load('high_resolution_batch3', 'rebind-accepted-row-batch-v3.py')
prior_batch.b = batch
prior_batch.prior.b = batch
global_binder = load('high_resolution_global3', 'bind-final-global-evidence-v3.py')

class LiteralReceiptGuards(unittest.TestCase):
    def setUp(self):
        self.context = q.source_context_json(q.bound(q.HIGH_RESOLUTION_CONTEXT))
        self.source = self.context['source']
        self.request = {'row': 'LEV-CH01-DIMENSIONAL-SPLITTING',
                        'source_context_extension': copy.deepcopy(q.HIGH_RESOLUTION_CONTEXT)}
        self.environment = copy.deepcopy(self.context['interpretation_receipts'])
        self.configured = [item['path'] for item in self.environment]
        self.packet = {'interpretation_receipts': []}
        for item in self.environment:
            path = q.bound(item)
            self.packet['interpretation_receipts'].append({'receipt': copy.deepcopy(item),
                'exact_receipt_bytes_utf8': path.read_bytes().decode('utf-8'),
                'exact_fields': q.source_context_json(path)})
    def check(self):
        return q.validate_scoped_context_receipts(self.request, self.context, self.packet,
                                                 self.source, self.configured, self.environment)
    def test_real_pinned_pair_and_literal_answer(self):
        self.assertEqual(self.check(), [q.INHERITED_RECEIPT, q.HIGH_RESOLUTION_RECEIPT])
        receipt = self.packet['interpretation_receipts'][1]['exact_fields']
        self.assertEqual(receipt['answer'], 'Adopt this explicit convention')
        self.assertEqual(receipt['question_item_id'], ['request_user_input_async', 'call_1OyqIuAHK4eJ8CPSAKCpAt08', 0])
    def test_wrong_row(self):
        self.request['row'] = 'LEV-CH01-RIEMANN-INTERFACE-FLUX'
        with self.assertRaisesRegex(ValueError, 'scoped only'): self.check()
    def test_unreviewed_context(self):
        self.request['source_context_extension']['sha256'] = '0' * 64
        with self.assertRaisesRegex(ValueError, 'exact reviewed'): self.check()
    def test_answer_or_scope_rewrite(self):
        for key in ('answer', 'question', 'scope', 'authority_limit'):
            saved = self.packet['interpretation_receipts'][1]['exact_fields'][key]
            self.packet['interpretation_receipts'][1]['exact_fields'][key] = 'invented or enlarged'
            with self.subTest(key=key), self.assertRaisesRegex(ValueError, 'literal inherited receipt'): self.check()
            self.packet['interpretation_receipts'][1]['exact_fields'][key] = saved
    def test_exact_bytes_not_only_fields(self):
        self.packet['interpretation_receipts'][1]['exact_receipt_bytes_utf8'] += ' '
        with self.assertRaisesRegex(ValueError, 'literal inherited receipt'): self.check()
    def test_receipt_reordering(self):
        self.context['interpretation_receipts'].reverse()
        with self.assertRaisesRegex(ValueError, 'recorded order'): self.check()
    def test_missing_older_receipt(self):
        self.context['interpretation_receipts'].pop(0)
        with self.assertRaisesRegex(ValueError, 'exact original'): self.check()
    def test_omit_new_receipt_everywhere(self):
        self.context['interpretation_receipts'].pop()
        self.environment.pop()
        self.configured.pop()
        self.packet['interpretation_receipts'].pop()
        with self.assertRaisesRegex(ValueError, 'silently omitted'): self.check()
    def test_missing_configuration(self):
        self.configured.pop()
        with self.assertRaisesRegex(ValueError, 'absent or repeated'): self.check()
    def test_missing_or_stale_manifest(self):
        self.environment[-1]['sha256'] = '0' * 64
        with self.assertRaisesRegex(ValueError, 'manifest-bound'): self.check()
        self.environment.pop()
        with self.assertRaisesRegex(ValueError, 'manifest-bound'): self.check()
    def test_duplicated_manifest(self):
        self.environment.append(copy.deepcopy(self.environment[-1]))
        with self.assertRaisesRegex(ValueError, 'manifest-bound'): self.check()
    def test_configured_receipt_requires_context_request(self):
        with self.assertRaisesRegex(ValueError, 'silently omitted'):
            q.validate_source_context({'row': 'LEV-CH01-DIMENSIONAL-SPLITTING'}, {},
                {'lean_environment': self.environment}, {'lean': {'environment_files': self.configured}})

class ProjectionRegressions(unittest.TestCase):
    def test_all_global_payload_functions_unchanged(self):
        def functions(filename):
            return {node.name: ast.dump(node, include_attributes=False)
                    for node in ast.parse((H / filename).read_text(encoding='utf-8')).body
                    if isinstance(node, ast.FunctionDef)}
        old = functions('bind-final-global-evidence-v2.py')
        new = functions('bind-final-global-evidence-v3.py')
        self.assertEqual(set(old), set(new))
        for name in old.keys() - {'load_final_validator_support', 'validate_audit_records'}:
            with self.subTest(name=name): self.assertEqual(old[name], new[name])
        # validate_audit_records differs only in its validator version in an error string.
        self.assertEqual(old['validate_audit_records'].replace('exact v6 support', 'exact v7 support'), new['validate_audit_records'])
    def test_real_final_validator_dependency_closure(self):
        pins = {'audit_validator': global_binder.FINAL_VALIDATOR_PIN,
                'validator_dependencies': global_binder.FINAL_VALIDATOR_DEPENDENCIES}
        observed = {}
        support = global_binder.load_final_validator_support(q.ROOT, pins, observed)
        self.assertEqual(support.HIGH_RESOLUTION_RECEIPT, q.HIGH_RESOLUTION_RECEIPT)
        self.assertEqual(len(observed), 11)
        bad = copy.deepcopy(pins)
        bad['validator_dependencies'][0]['sha256'] = '0' * 64
        with self.assertRaises(ValueError): global_binder.load_final_validator_support(q.ROOT, bad, {})

if __name__ == '__main__':
    suite = unittest.TestSuite()
    for cls in (prior_context.ContextGuards, prior_batch.Guards, LiteralReceiptGuards, ProjectionRegressions):
        suite.addTests(unittest.defaultTestLoader.loadTestsFromTestCase(cls))
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    raise SystemExit(0 if result.wasSuccessful() else 1)
