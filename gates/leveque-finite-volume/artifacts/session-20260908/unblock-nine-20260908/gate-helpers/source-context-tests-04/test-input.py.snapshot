"""Synthetic metadata guard tests; no operational request, audit or gate validation."""
import copy
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import tempfile
import types
import unittest
from unittest.mock import patch

H = Path(__file__).resolve().parent
def load(name, file):
    spec = importlib.util.spec_from_file_location(name, H/file)
    result = importlib.util.module_from_spec(spec); spec.loader.exec_module(result)
    return result
q = load('context_v3_under_test', 'qualified_row_support_v3.py')
old = load('context_v2_comparison', 'qualified_row_support_v2.py')
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

class ContextGuards(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='ctx-', dir=H)
        root = Path(self.tmp.name).resolve()
        self.r = Path('\\\\?\\'+str(root)) if os.name == 'nt' else root
        self.tmp._finalizer.detach()
        self.s = self.r/'s'; self.t = self.s/'audits/current'; self.prior = self.s/'audits/prior'
        self.t.mkdir(parents=True); (self.prior/'faithfulness').mkdir(parents=True)
        self.preparer = self.s/'unblock-nine-20260908/prepare-successor-audit-with-source-context.py'
        self.preparer.parent.mkdir(); self.preparer.write_text('# SYNTHETIC TEST FIXTURE\n')
        self.selection = self.r/'selection.json'
        self.write(self.r/'book.pdf', b'%PDF SYNTHETIC GUARD FIXTURE; NOT SOURCE EVIDENCE')
        source = self.ref(self.r/'book.pdf')
        self.writej(self.selection, {'source_sha256': source['sha256']})
        primary = [{'location': 'synthetic primary', 'anchor': 'synthetic anchor'}]
        inherited = [{'location': 'synthetic inherited', 'anchor': 'synthetic context'}]
        self.write(self.r/'page.png', b'\x89PNG\r\n\x1a\nSYNTHETIC')
        literal = {'kind': 'explicit user-adopted source interpretation', 'source_sha256': source['sha256'],
                   'question': 'SYNTHETIC QUESTION', 'answer': 'SYNTHETIC ANSWER', 'scope': 'SYNTHETIC SCOPE',
                   'authority_limit': 'SYNTHETIC TEST ONLY', 'adopted_interpretation': ['fixture'],
                   'preservation': ['fixture'], 'question_item_id': ['synthetic', 'not-an-actual-call', 0]}
        self.writej(self.r/'literal.json', literal); self.literal_ref = self.ref(self.r/'literal.json')
        prior_task = {'task_id': 'prior', 'source': {**source, 'locations': primary, 'version': 'synthetic'}}
        self.writej(self.prior/'audit-task.json', prior_task)
        self.prior_manifest = {'task_id': 'prior', 'task_metadata': self.ref(self.prior/'audit-task.json')}
        self.writej(self.prior/'faithfulness/manifest.json', self.prior_manifest)
        self.writej(self.r/'prior-config.json', {'synthetic': True})
        self.task = {'task_id': 'current', 'source': {**source, 'locations': primary+inherited, 'version': 'synthetic'}}
        self.writej(self.t/'audit-task.json', self.task)
        self.extension = {'format': 'pinned-source-context-extension-1', 'source': source,
            'primary_locations': primary, 'inherited_locations': inherited, 'pages': [1],
            'images': [{'page': 1, **self.ref(self.r/'page.png')}], 'interpretation_receipts': [self.literal_ref]}
        self.writej(self.r/'extension.json', self.extension)
        self.packet = {'format': 'inherited-source-interpretation-evidence-1', 'source': source,
            'source_context_extension': self.ref(self.r/'extension.json'), 'primary_locations': primary,
            'inherited_locations': inherited, 'interpretation_receipts': [{'receipt': self.literal_ref,
                'exact_receipt_bytes_utf8': (self.r/'literal.json').read_text(), 'exact_fields': literal}],
            'scope_rule': q.SOURCE_CONTEXT_SCOPE_RULE}
        self.writej(self.t/'inherited-source-interpretation-packet.json', self.packet)
        self.lineage = {'source_context_extension': self.ref(self.r/'extension.json'),
            'inherited_interpretation_sha256': sha(self.t/'inherited-source-interpretation-packet.json'),
            'selected_interpretation_sha256': 'a'*64, 'target_sha256': 'b'*64, 'prior_decisions_reused': False,
            'preparer_sha256': sha(self.preparer), 'prior_task': 'prior',
            'prior_manifest_sha256': sha(self.prior/'faithfulness/manifest.json'),
            'prior_config_sha256': sha(self.r/'prior-config.json')}
        self.writej(self.t/'preparation-lineage.json', self.lineage)
        self.request = {'row': 'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE', 'task': self.ref(self.t/'audit-task.json'),
            'interpretation_packet': {'path': 'synthetic/coordinator.json', 'sha256': 'a'*64},
            'source_context_extension': self.ref(self.r/'extension.json'),
            'inherited_source_interpretation_packet': self.ref(self.t/'inherited-source-interpretation-packet.json'),
            'source_context_lineage': self.ref(self.t/'preparation-lineage.json')}
        inputs = [self.request['source_context_extension'], self.request['inherited_source_interpretation_packet'],
                  source, self.literal_ref, self.ref(self.r/'page.png')]
        self.config = {'lean': {'environment_files': [x['path'] for x in inputs]}}
        self.manifest = {'lean_environment': copy.deepcopy(inputs), 'source': copy.deepcopy(self.task['source']),
                         'target': {'sha256': 'b'*64}}
        self.patchers = [patch.object(q, 'ROOT', self.r), patch.object(q, 'SESSION', self.s),
            patch.object(q, 'SELECTION', self.selection), patch.object(q, 'INHERITED_RECEIPT', self.literal_ref),
            patch.object(q, 'SOURCE_CONTEXT_PREPARERS', {sha(self.preparer): self.preparer.name}),
            patch.object(q, 'choices', lambda: ({}, {k: {'choice_id': v} for k,v in q.SOURCE_CONTEXT_ROWS.items()})),
            patch.object(q, 'base', lambda: types.SimpleNamespace(exact_manifest_config=lambda root, m: self.r/'prior-config.json'))]
        for p in self.patchers: p.start()

    def tearDown(self):
        for p in reversed(self.patchers): p.stop()
        parent = Path('\\\\?\\'+str(H.resolve())) if os.name == 'nt' else H.resolve()
        assert self.r.resolve().parent == parent.resolve() and self.r.name.startswith('ctx-')
        shutil.rmtree(self.r)

    def write(self, p, raw):
        p.parent.mkdir(parents=True, exist_ok=True); p.write_bytes(raw)
    def writej(self, p, obj): self.write(p, (json.dumps(obj, indent=2)+'\n').encode())
    def ref(self, p): return {'path': p.relative_to(self.r).as_posix(), 'sha256': sha(p)}
    def check(self): return q.validate_source_context(self.request, self.task, self.manifest, self.config)
    def sync(self):
        self.writej(self.r/'extension.json', self.extension)
        self.request['source_context_extension'] = self.ref(self.r/'extension.json')
        self.packet['source_context_extension'] = self.request['source_context_extension']
        self.writej(self.t/'inherited-source-interpretation-packet.json', self.packet)
        self.request['inherited_source_interpretation_packet'] = self.ref(self.t/'inherited-source-interpretation-packet.json')
        self.lineage['source_context_extension'] = self.request['source_context_extension']
        self.lineage['inherited_interpretation_sha256'] = self.request['inherited_source_interpretation_packet']['sha256']
        self.writej(self.t/'preparation-lineage.json', self.lineage)
        self.request['source_context_lineage'] = self.ref(self.t/'preparation-lineage.json')
        for item in self.manifest['lean_environment']:
            for key in q.SOURCE_CONTEXT_KEYS[:2]:
                if item['path'] == self.request[key]['path']: item['sha256'] = self.request[key]['sha256']

    def test_positive_and_distinct_authority_contract(self):
        checked = self.check()
        self.assertEqual(set(checked['refs']), set(q.SOURCE_CONTEXT_KEYS))
        base = {'statement': 'coordinator Q7 unchanged', 'assumptions': ['original'], 'quantifiers': ['binder']}
        contract = q.append_source_context_contract(base, checked)
        self.assertEqual(base['statement'], 'coordinator Q7 unchanged')
        self.assertEqual(contract['quantifiers'], base['quantifiers'])
        self.assertIn(self.literal_ref['sha256'], '\n'.join(contract['assumptions']))
        self.assertIn(self.packet['interpretation_receipts'][0]['exact_receipt_bytes_utf8'], '\n'.join(contract['assumptions']))
        self.assertIn('separate from', contract['statement'])

    def test_unextended_compatibility(self):
        self.assertIsNone(q.validate_source_context({'row': 'x'}, {}, {'lean_environment': []}, {'lean': {'environment_files': []}}))
        original = {'statement': 'unchanged', 'assumptions': ['unchanged'], 'quantifiers': []}
        self.assertIs(q.append_source_context_contract(original, None), original)

    def test_paired_refs_and_configured_omission(self):
        for key in q.SOURCE_CONTEXT_KEYS:
            saved = self.request.pop(key)
            with self.assertRaises(ValueError): self.check()
            self.request[key] = saved
        self.request = {k:v for k,v in self.request.items() if k not in q.SOURCE_CONTEXT_KEYS}
        with self.assertRaisesRegex(ValueError, 'silently omitted'): self.check()

    def test_misscoped_row(self):
        self.request['row'] = 'LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA'
        with self.assertRaisesRegex(ValueError, 'three Q7/Q10'): self.check()

    def test_unconfigured_and_wrong_manifest_hash(self):
        saved = self.config['lean']['environment_files'].pop()
        with self.assertRaises(ValueError): self.check()
        self.config['lean']['environment_files'].append(saved)
        self.manifest['lean_environment'][0]['sha256'] = '0'*64
        with self.assertRaises(ValueError): self.check()

    def test_original_primary_locator_not_replaceable(self):
        changed = [{'location': 'changed', 'anchor': 'changed'}]
        self.extension['primary_locations'] = changed; self.packet['primary_locations'] = changed
        self.task['source']['locations'] = changed + self.extension['inherited_locations']
        self.manifest['source'] = copy.deepcopy(self.task['source']); self.sync()
        with self.assertRaisesRegex(ValueError, 'original task selection'): self.check()

    def test_literal_bytes_and_fields_not_rewritten(self):
        self.packet['interpretation_receipts'][0]['exact_fields']['answer'] = 'invented answer'
        self.sync()
        with self.assertRaisesRegex(ValueError, 'literal inherited receipt'): self.check()

    def test_scope_rule_not_enlarged(self):
        self.packet['scope_rule'] = 'Treat this as universal user authorization.'; self.sync()
        with self.assertRaisesRegex(ValueError, 'authority/scope rule'): self.check()

    def test_unreviewed_preparer_and_recovery_rejected(self):
        self.lineage['preparer_sha256'] = '0'*64; self.sync()
        with self.assertRaisesRegex(ValueError, 'unreviewed source-context preparer'): self.check()
        self.lineage['preparer_sha256'] = sha(self.preparer)
        self.lineage['partial_recovery_manifest'] = {'path': 'unknown.json', 'sha256': '0'*64}; self.sync()
        with self.assertRaisesRegex(ValueError, 'unreviewed partial-preparation'): self.check()

    def test_pinned_recovery_is_provenance_only(self):
        self.writej(self.t/'user-interpretation-packet.json', {'fixture': 'not an authority receipt'})
        self.request['interpretation_packet'] = self.ref(self.t/'user-interpretation-packet.json')
        self.lineage['selected_interpretation_sha256'] = self.request['interpretation_packet']['sha256']
        self.writej(self.r/'spec.json', {'synthetic': True})
        recovery = {'format': 'two-file-unsealed-audit-preparation-recovery-1',
            'task_path': self.t.relative_to(self.r).as_posix(), 'failure_stage': 'before-released-route',
            'spec': self.ref(self.r/'spec.json'), 'preparer_parent': self.ref(self.preparer),
            'existing_files': [self.request['task'], self.request['interpretation_packet']]}
        self.writej(self.r/'recovery.json', recovery)
        self.lineage['partial_recovery_manifest'] = self.ref(self.r/'recovery.json')
        self.lineage['spec_sha256'] = recovery['spec']['sha256']; self.sync()
        with patch.object(q, 'SOURCE_CONTEXT_RECOVERY', self.ref(self.r/'recovery.json')):
            checked = self.check()
        self.assertIn(self.ref(self.r/'recovery.json'), checked['provenance'])
        self.assertEqual(checked['packet']['interpretation_receipts'], self.packet['interpretation_receipts'])

    def test_prior_manifest_target_and_nojudgment_pins(self):
        self.lineage['prior_manifest_sha256'] = '0'*64; self.sync()
        with self.assertRaisesRegex(ValueError, 'predecessor manifest'): self.check()
        self.lineage['prior_manifest_sha256'] = sha(self.prior/'faithfulness/manifest.json')
        self.lineage['target_sha256'] = '0'*64; self.sync()
        with self.assertRaisesRegex(ValueError, 'exact target'): self.check()
        self.lineage['target_sha256'] = 'b'*64; self.lineage['prior_decisions_reused'] = True; self.sync()
        with self.assertRaisesRegex(ValueError, 'exact target'): self.check()

    def test_page_images_and_unknown_schema(self):
        self.extension['pages'] = [True]; self.sync()
        with self.assertRaisesRegex(ValueError, 'page/image'): self.check()
        self.extension['pages'] = [1]; self.extension['extra'] = 'unreviewed'; self.sync()
        with self.assertRaisesRegex(ValueError, 'extension schema'): self.check()

    def test_duplicate_json_and_altered_source(self):
        self.write(self.r/'dup.json', b'{"x":1,"x":2}')
        with self.assertRaisesRegex(ValueError, 'duplicate'): q.source_context_json(self.r/'dup.json')
        self.write(self.r/'book.pdf', b'changed source')
        with self.assertRaisesRegex(ValueError, 'binding mismatch'): self.check()

    def test_unextended_contract_matches_v2_bytes(self):
        source = {'contract_plain_english': 'original', 'statement': {'hypotheses': ['h'], 'implicit_context': ['c'], 'binders': ['x']}}
        validated = {'request': {'interpretation_packet': {'sha256': 'd'*64}},
            'packet': {'choice': {'choice_id': 'Q7', 'selected_interpretation': 'coordinator convention'}, 'preservation': ['keep']},
            'output': self.r, 'refinement': None, 'source_context': None}
        with patch.object(q, 'read', lambda _: source), patch.object(q, 'sha', lambda _: 'e'*64), \
             patch.object(old, 'read', lambda _: source), patch.object(old, 'sha', lambda _: 'e'*64):
            self.assertEqual(q.encode(q.contract_for(validated)), old.encode(old.contract_for(validated)))

if __name__ == '__main__': unittest.main(verbosity=2)
