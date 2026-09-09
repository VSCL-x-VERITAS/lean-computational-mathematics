"""Synthetic guard tests only; no gate/checker/audit/native/Git invocation."""
import copy
import importlib.util
from pathlib import Path
import tempfile
import unittest

H = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('batch_under_test', H/'rebind-accepted-row-batch.py')
b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(b)

def row(name, qualified=False):
    result = {'id': name, 'status': 'PROVED', 'classification': 'faithful-equivalent',
        'lean_implies_source': 'yes', 'source_implies_lean': 'yes',
        'lean_declarations': ['Synthetic.target'], 'contract_hash': 'synthetic-contract',
        'faithfulness_task': 'synthetic/task', 'faithfulness_decision': 'synthetic/decision',
        'native_evidence': {'check': 'unchanged'}, 'adjudication_required': False}
    for field in b.old.MUTABLE:
        result[field] = 'before'
    if qualified:
        result.update(qualified_binding_request={'path': 'synthetic/old', 'sha256': 'a'*64},
                      coordinator_selected_interpretation={'path': 'synthetic/choice', 'sha256': 'b'*64})
    return result

def gate():
    return {'rows': [row('legacy'), row('qualified', True), {'id': 'skip', 'status': 'SKIPPED'},
                     {'id': 'open', 'status': 'IN_PROGRESS'}],
            'bindings': {'lean_worktree_sha256': 'a'*64, 'source': 'fixed'},
            'chapter_gate': 'ACTIVE', 'other': {'unchanged': True}}

class Guards(unittest.TestCase):
    def test_binding_scope(self):
        before = gate()['bindings']; after = {**before, 'lean_worktree_sha256': 'b'*64}
        b.refresh_bindings(before, after)
        for bad in ({**after, 'source': 'different'}, {**after, 'extra': 'key'}, {'source': 'fixed'},
                    {**after, 'lean_worktree_sha256': 'not-a-digest'}):
            with self.subTest(bad=bad), self.assertRaises(ValueError): b.refresh_bindings(before, bad)

    def test_request_only_current_bindings(self):
        original = {'row': 'synthetic', 'native': {'check': {'sha256': 'a'*64}},
                    'task': 'unchanged', 'current_bindings': gate()['bindings']}
        copied = b.request_copy(original, {**gate()['bindings'], 'lean_worktree_sha256': 'c'*64})
        self.assertEqual(copied['native'], original['native'])
        self.assertEqual(copied['task'], original['task'])
        self.assertEqual(original['current_bindings']['lean_worktree_sha256'], 'a'*64)
        copied['native']['check']['sha256'] = 'changed'
        self.assertEqual(original['native']['check']['sha256'], 'a'*64)
        with self.assertRaises(ValueError): b.request_copy({}, gate()['bindings'])

    def test_allowed_preservation(self):
        before = gate(); after = copy.deepcopy(before)
        after['bindings']['lean_worktree_sha256'] = 'd'*64
        for r in after['rows'][:2]:
            for field in b.old.MUTABLE: r[field] = 'fresh artifact'
        after['rows'][1]['qualified_binding_request'] = {'path': 'synthetic/new', 'sha256': 'c'*64}
        b.preserve(before, after, {'legacy', 'qualified'}, {'qualified'})

    def test_all_accepted_semantic_fields_protected(self):
        before = gate()
        for index in (0, 1):
            for key in before['rows'][index]:
                if key in b.old.MUTABLE or (index == 1 and key == 'qualified_binding_request'): continue
                after = copy.deepcopy(before); after['rows'][index][key] = 'MUTATION'
                with self.subTest(index=index, field=key), self.assertRaises(ValueError):
                    b.preserve(before, after, {'legacy', 'qualified'}, {'qualified'})

    def test_unselected_top_level_order_protected(self):
        before = gate()
        changes = [lambda g: g['rows'][2].update(reason='mutation'),
                   lambda g: g['rows'][3].update(status='PROVED'),
                   lambda g: g.update(other={'changed': True}),
                   lambda g: g.update(extra=True),
                   lambda g: g['rows'].reverse()]
        for mutation in changes:
            after = copy.deepcopy(before); mutation(after)
            with self.assertRaises(ValueError): b.preserve(before, after, {'legacy', 'qualified'}, {'qualified'})

    def test_payload_exact_spans(self):
        raw = b'{"schema_version":1,"check":"source-contract","bindings":{},"procedure":"old","exit_code":0,"payload": { "text" : "x", "array":[1,  2] }}'
        new = b.old.rebind_artifact(raw, {'current': 'context'}, 'new provenance')
        self.assertEqual(b.old.payload_span(raw), b.old.payload_span(new))
        self.assertNotEqual(raw, new)
        with self.assertRaises(ValueError): b.old.rebind_artifact(raw.replace(b'"exit_code":0', b'"exit_code":1'), {}, '')

    def test_duplicate_json_rejected(self):
        with self.assertRaises(ValueError): b.parse('{"row":1,"row":2}')

    def test_reader_hash_and_concurrency(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); p = root/'target.lean'; p.write_bytes(b'original')
            reader = b.old.Reader(root)
            reader.bound({'path': 'target.lean', 'sha256': b.sha(p)})
            p.write_bytes(b'changed dependency')
            with self.assertRaises(ValueError): reader.unchanged()
            with self.assertRaises(ValueError): reader.bound({'path': 'target.lean', 'sha256': '0'*64})
            for path in ('../outside', '/absolute', 'C:/native', 'a\\b', 'a/../b'):
                with self.subTest(path=path), self.assertRaises(ValueError): reader.path(path)

    def test_complete_validation_binding(self):
        r = row('qualified', True); rows = {'qualified': r}
        record = {'row': 'qualified', 'declaration': 'Synthetic.target', 'exit_code': 0,
                  **{key: r[key] for key in ('classification', *b.q.DIRECTIONS,
                     'qualified_binding_request', 'coordinator_selected_interpretation', 'native_evidence')}}
        ref = {'path': 'synthetic/proposal', 'sha256': 'c'*64}; bindings = gate()['bindings']
        result = {'mode': 'released-complete-validation', 'closed_rows': 1, 'records': [record],
                  'validated_gate_input': ref, 'current_bindings': bindings}
        b.validation_result(result, ref, bindings, rows)
        mutations = [lambda x: x.update(mode='inventory-only-not-validation'),
                     lambda x: x.update(closed_rows=True), lambda x: x.update(closed_rows=2),
                     lambda x: x.update(validated_gate_input={'wrong': 'proposal'}),
                     lambda x: x.update(current_bindings={}), lambda x: x['records'].append(record),
                     lambda x: x['records'][0].update(exit_code=True),
                     lambda x: x['records'][0].update(exit_code=1),
                     lambda x: x['records'][0].update(declaration='Other.target'),
                     lambda x: x['records'][0].update(classification='faithful-stronger'),
                     lambda x: x['records'][0].update(source_implies_lean='no'),
                     lambda x: x['records'][0].update(native_evidence={'changed': True})]
        for mutation in mutations:
            bad = copy.deepcopy(result); mutation(bad)
            with self.assertRaises(ValueError): b.validation_result(bad, ref, bindings, rows)

    def test_validator_derivation_exact(self):
        import json
        derivation = json.loads((H/'rebind-validator-derivation.json').read_text())
        source = (H/derivation['source']['path']).read_text()
        for item in derivation['exact_replacements']:
            self.assertEqual(source.count(item['before']), 1)
            source = source.replace(item['before'], item['after'])
        self.assertEqual(source, (H/'validate-closed-row-audits-rebind.py').read_text())
        for p in (H/'rebind-accepted-row-batch.py', H/'validate-closed-row-audits-rebind.py'):
            compile(p.read_text(), str(p), 'exec')

if __name__ == '__main__': unittest.main(verbosity=2)
