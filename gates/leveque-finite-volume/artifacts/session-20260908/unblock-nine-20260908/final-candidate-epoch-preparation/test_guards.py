"""Pure synthetic rejection/parity tests; no candidate or semantic validation."""
from pathlib import Path
import ast
import contextlib
import copy
import io
import json
import hashlib
import unittest
from unittest.mock import patch
import candidate_checks as c
import capture_checks as cap
import assemble_epoch as a
import prepare_organization as org


def encoded(x):
    return json.dumps(x, sort_keys=True).encode()


class Guards(unittest.TestCase):
    def rejected(self, fn):
        with self.assertRaises((ValueError, KeyError, TypeError)):
            fn()

    def test_portable_paths(self):
        for value in ('../x', '/tmp/x', 'C:/x', 'a\\b', '', 'x:y'):
            self.rejected(lambda: c.relative(value))
        self.assertEqual(c.relative('gates/a.json').as_posix(), 'gates/a.json')

    def test_eight_exact_commands(self):
        commands = cap.commands('gates/final.json', 'a' * 64, 'b' * 40)
        self.assertEqual(tuple(commands), c.CHECKS)
        for key, cmd in commands.items():
            self.assertEqual(cmd[0], 'python3')
            self.assertEqual(cmd[1], c.HERE + '/candidate_checks.py')
            self.assertEqual(cmd[-4:], ['--check', key, '--candidate-tree', 'b' * 40])
            self.assertNotIn('{repository}', ' '.join(cmd))

    def test_committed_blob_identity(self):
        raw = b'synthetic LF bytes\n'
        oid = hashlib.sha1(b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest()
        listing = ('100644 blob ' + oid + '\tfile.txt\0').encode()
        c.COMMITTED_INDEX.clear()
        with patch.object(c, 'git', return_value=listing):
            c.committed_blob(Path('.'), 'file.txt', raw)
            self.rejected(lambda: c.committed_blob(Path('.'), 'file.txt', raw.replace(b'\n', b'\r\n')))
            self.rejected(lambda: c.committed_blob(Path('.'), 'not-tracked.txt', raw))
        c.COMMITTED_INDEX.clear()

    def test_actual_frozen_native_output_parser(self):
        session = Path(__file__).resolve().parents[2]
        raw = (session / 'unblock-nine-local-complete-declarations-02-output.txt').read_text(encoding='utf-8')
        import re
        reports = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", raw, re.S)
        self.assertEqual(len(reports), 41)
        for _, values in reports:
            self.assertLessEqual(set(x.strip() for x in values.split(',') if x.strip()), c.ALLOWED_AXIOMS)

    def test_receipt_guards(self):
        raw = b'actual synthetic test stdout'
        receipt = {'command': ['python3', 'x.py'], 'exit_code': 0, 'input_commit': 'a' * 40,
                   'elapsed_ms': 1, 'output_sha256': c.digest(raw)}
        item = {'command': receipt['command'], 'receipt': {}, 'output': {}}
        with patch.object(c, 'decoded', return_value=receipt), patch.object(c, 'bound', return_value=raw):
            c.frozen_execution(Path('.'), item)
            for key, value in (('exit_code', False), ('exit_code', 1), ('elapsed_ms', -1),
                               ('elapsed_ms', True), ('output_sha256', 'b' * 64), ('input_commit', '')):
                bad = {**receipt, key: value}
                with patch.object(c, 'decoded', return_value=bad):
                    self.rejected(lambda: c.frozen_execution(Path('.'), item))

    def fixture(self):
        blobs, rows, records = {}, [], []
        def add(path, data):
            blobs[path] = encoded(data)
            return {'path': path, 'sha256': c.digest(blobs[path])}
        for i in range(41):
            name, ident, out = 'Example.x' + str(i), 'synthetic-' + str(i), 'test/' + str(i)
            target = add(out + '/Target.lean', {'synthetic_only': i})
            task = {'task_id': ident, 'audit_output': out, 'target': {'path': target['path'], 'declaration': name}}
            task_ref = add(out + '/task.json', task)
            config = add(out + '/config.json', {'synthetic': True})
            dec = {'task_id': ident, 'accepted': True, 'classification': 'faithful-equivalent',
                   'implications': {k: {'verdict': 'yes'} for k in ('lean_implies_source', 'source_implies_lean')}}
            dec_ref = add(out + '/decision.json', dec)
            man_ref = add(out + '/manifest.json', {'task_id': ident, 'task_metadata': task_ref, 'target': target})
            row = {'id': ident, 'status': 'PROVED', 'faithfulness_task': task_ref['path'],
                   'lean_declarations': [name], 'classification': 'faithful-equivalent',
                   'lean_implies_source': 'yes', 'source_implies_lean': 'yes'}
            record = {'row': ident, 'task': ident, 'declaration': name, 'config': config,
                'manifest_sha256': man_ref['sha256'], 'decision_sha256': dec_ref['sha256'],
                'classification': 'faithful-equivalent', 'lean_implies_source': 'yes',
                'source_implies_lean': 'yes', 'exit_code': 0}
            if i == 0:
                row['coordinator_selected_interpretation'] = record['coordinator_selected_interpretation'] = {'synthetic': 'choice'}
            rows.append(row); records.append(record)
        def bound(root, ref, committed=False):
            raw = blobs[ref['path']]
            c.need(c.digest(raw) == ref['sha256'], 'Synthetic changed bytes')
            return raw
        return {'rows': rows}, {'mode': 'released-complete-validation', 'closed_rows': 41, 'records': records}, blobs, bound

    def test_41_record_guards(self):
        gate, output, blobs, bound = self.fixture()
        with patch.object(c, 'bound', side_effect=bound), patch.object(Path, 'read_bytes', lambda p: blobs[p.as_posix()]):
            c.verify_audit_records(Path('.'), gate, encoded(output))
            mutations = [lambda x: x.update(mode='inventory-only-not-validation'),
                         lambda x: x.update(closed_rows=40), lambda x: x['records'].pop(),
                         lambda x: x['records'][0].update(exit_code=False),
                         lambda x: x['records'][0].update(declaration='wrong'),
                         lambda x: x['records'][0].pop('coordinator_selected_interpretation'),
                         lambda x: x['records'][0].update(manifest_sha256='f' * 64)]
            for mutate in mutations:
                bad = copy.deepcopy(output); mutate(bad)
                self.rejected(lambda: c.verify_audit_records(Path('.'), gate, encoded(bad)))

    def test_conflicts_and_content_gap(self):
        topology = {'instances': [{'id': 'a', 'role': 'formalization'}, {'id': 'b', 'role': 'reorganization'}]}
        assets = [{'asset_id': 'a', 'concept_id': 'x', 'lane_id': 'a', 'kind': 'gate', 'content_sha256': 'a' * 64},
                  {'asset_id': 'b', 'concept_id': 'x', 'lane_id': 'b', 'kind': 'gate', 'content_sha256': 'b' * 64}]
        plan = a.expected_plan(topology, assets)
        self.assertEqual(plan[0]['classification'], 'identical')  # actual released planner limitation
        review = {'status': 'reviewed-for-candidate-assembly', 'bundle_sha256': 'a' * 64, 'plan': plan,
                  'concept_decisions': [], 'transports': [], 'collisions': [], 'additional_transport_evidence': []}
        self.rejected(lambda: a.checked_reviews(Path('.'), topology, {'epoch_fields': {'assets': assets}}, review))

    def test_transport_semantics(self):
        old = {k: 'a' * 64 for k in ('source', 'type', 'policy', 'producer', 'proof')}
        t = {'id': 't', 'change_class': 'producer', 'faithfulness': 'full-reaudit',
             'old_hashes': old, 'new_hashes': {**old, 'producer': 'b' * 64}}
        topology = {'instances': []}; bundle = {'epoch_fields': {'assets': []}}
        review = {'status': 'reviewed-for-candidate-assembly', 'bundle_sha256': 'a' * 64, 'plan': [],
                  'concept_decisions': [], 'collisions': [], 'transports': [t],
                  'additional_transport_evidence': [{'transport_id': 't', 'evidence': [{}]}]}
        with patch.object(a, 'bound', return_value=b'synthetic'):
            a.checked_reviews(Path('.'), topology, bundle, review)
            for key, value in (('change_class', 'move'), ('faithfulness', 'reuse')):
                bad = copy.deepcopy(review); bad['transports'][0][key] = value
                self.rejected(lambda: a.checked_reviews(Path('.'), topology, bundle, bad))

    def test_no_operational_entry_on_import(self):
        for name in ('candidate_checks.py', 'capture_checks.py', 'assemble_epoch.py', 'prepare_organization.py'):
            tree = ast.parse((Path(__file__).parent / name).read_text(encoding='utf-8'))
            self.assertTrue(any(isinstance(n, ast.If) for n in tree.body))

    def test_organization_scope_path_boundary(self):
        for path in ('ComputationalMathematics.lean', 'NumStability.lean',
                     'ComputationalMathematics/Analysis/X.lean', 'NumStability/Source/A.lean'):
            self.assertTrue(org.source_path(path))
        for path in ('gates/test.lean', 'ComputationalMathematics/Analysis/X.py',
                     'ComputationalMathematicsFake/X.lean', 'NumStabilityTest/X.lean'):
            self.assertFalse(org.source_path(path))

    def test_released_schema_full_object(self):
        session = Path(__file__).resolve().parents[2]
        root = session.parents[3]
        helper = session / 'final-epoch-asset-helper-draft/prepare_asset_bundle.py'
        schema_path = root.parent / 'formalization-collaboration-v5.0.1/skills/book-formalization-migration/references/schemas/reconciliation-epoch.schema.json'
        schema = json.loads(schema_path.read_bytes())
        checker = a.schema_checker({'path': str(helper), 'sha256': c.digest(helper.read_bytes())})
        top = {k: v for k, v in schema.items() if k not in ('$schema', '$id', '$defs')}
        fixture = {'schema_version': 2, 'workflow_schema_version': 3, 'epoch_id': 'synthetic-test-only',
            'campaign_id': 'test', 'status': 'candidate', 'topology_sha256': 'a' * 64, 'anchor': 'b' * 40,
            'lane_heads': [{'instance_id': 'a', 'head': 'b' * 40}, {'instance_id': 'b', 'head': 'b' * 40}],
            'candidate': {'instance_id': 'test', 'commit': 'c' * 40, 'tree': 'd' * 40},
            'assets': [], 'transports': [], 'collisions': [], 'branches': [],
            'affected_books': [{'book_id': 'synthetic', 'status': 'reopened', 'rows': ['synthetic'],
                'tree': 'd' * 40, 'stored_verdict': 'PASS', 'current_verdict': 'ACTIVE', 'certificate_disposition': 'rejected-stale'}],
            'organization': {'unit_scope': {k: [] for k in schema['$defs']['organization']['properties']['unit_scope']['required']},
                             'repository_ratchet': []},
            'validations': {k: {'status': 'PASS', 'tree': 'd' * 40, 'command': ['python3', 'synthetic.py'],
                               'output_sha256': 'e' * 64, 'elapsed_ms': 1} for k in c.CHECKS}}
        checker(fixture, top, schema, 'pure synthetic schema test')
        bad = copy.deepcopy(fixture); bad['validations']['full_build']['elapsed_ms'] = True
        self.rejected(lambda: checker(bad, top, schema, 'synthetic negative'))
        bad = copy.deepcopy(fixture); bad['bogus_authority'] = 'none'
        self.rejected(lambda: checker(bad, top, schema, 'synthetic negative'))


if __name__ == '__main__':
    unittest.main(verbosity=2)
