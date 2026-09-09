"""Synthetic guard tests only: no Git, scanner, capture, draft or certification call."""
import ast
import copy
import json
from pathlib import Path
import tempfile
import unittest
from support import Guard, schema, file_ref, sha

P=Path(__file__).resolve().parent
def valid():
    ref={'path':'synthetic/evidence.json','sha256':'a'*64}
    execution={'receipt':ref,'output':ref,'expected_command':['synthetic-check'],
               'applicability_rationale':'Synthetic shape fixture only; never operational.', 'evidence':[ref]}
    return {'schema':1,'kind':'current-organization-draft-config','pending_inputs':[],
        'expected_head':'a'*40,'anchor':'b'*40,'campaign_id':'synthetic','source_tree_sha256':'c'*64,
        'topology':ref,'gate':ref,'organization_template':ref,'complete_declaration_manifest':ref,
        'graph':{'json':ref,'markdown':ref},
        'expected_counts':{'production_modules':2,'native_constants':1,'native_owners':1,
            'total_rows':2,'formalizable_rows':1,'skipped_rows':1},
        'fingerprints':[{'inventory':ref,'expected_records':1,'expected_files':1,'provenance':[ref]}],
        'checker_executions':{k:execution for k in ('layout','tiers','compatibility','hygiene')},
        'complete_native':execution,'placement_reviews':[{'evidence':ref,'rationale':'synthetic','covered_source_paths':[]}],
        'scope_assessment':{'rationale':'Synthetic only','unit_scope':{k:[] for k in
            ('unexpected_changes','unclassified_modules','mixed_pending_split','duplicate_wrappers','placeholder_findings','canonical_placement_pending')}},
        'aggregate_boundaries':['ComputationalMathematics/Analysis.lean']}

class Guards(unittest.TestCase):
    def reject(self, mutation):
        c=copy.deepcopy(valid());mutation(c)
        with self.assertRaises(ValueError):schema(c)
    def test_valid_shape_only(self): schema(valid())
    def test_template_is_incomplete(self):
        with self.assertRaises(ValueError): schema(json.loads((P/'config.template.json').read_text()))
    def test_pending(self):self.reject(lambda c:c.update(pending_inputs=['future DIM']))
    def test_missing_head(self):self.reject(lambda c:c.update(expected_head=None))
    def test_missing_source_hash(self):self.reject(lambda c:c.update(source_tree_sha256=None))
    def test_missing_checker(self):self.reject(lambda c:c['checker_executions'].pop('layout'))
    def test_extra_checker(self):self.reject(lambda c:c['checker_executions'].update(extra=c['complete_native']))
    def test_boolean_count(self):self.reject(lambda c:c['expected_counts'].update(native_constants=True))
    def test_count_census(self):self.reject(lambda c:c['expected_counts'].update(total_rows=8))
    def test_missing_fp_count(self):self.reject(lambda c:c['fingerprints'][0].update(expected_files=None))
    def test_missing_fp_provenance(self):self.reject(lambda c:c['fingerprints'][0].update(provenance=[]))
    def test_missing_rationale(self):self.reject(lambda c:c['placement_reviews'][0].update(rationale=''))
    def test_changed_boundary_policy(self):self.reject(lambda c:c.update(aggregate_boundaries=[]))
    def test_unsafe_paths(self):
        for path in ('../x','/absolute','C:/x','a\\b','a//b'):
            with self.subTest(path=path),self.assertRaises(ValueError):file_ref({'path':path,'sha256':'a'*64})
    def test_missing_input(self):
        with tempfile.TemporaryDirectory(dir=P) as temp:
            with self.assertRaises(ValueError):Guard(Path(temp)).bind({'path':'absent','sha256':'a'*64})
    def test_mutated_input(self):
        with tempfile.TemporaryDirectory(dir=P) as temp:
            root=Path(temp);f=root/'evidence';f.write_bytes(b'synthetic')
            g=Guard(root);g.bind({'path':'evidence','sha256':sha(b'synthetic')})
            f.write_bytes(b'changed')
            with self.assertRaises(ValueError):g.unchanged()
    def test_hash_mismatch(self):
        with tempfile.TemporaryDirectory(dir=P) as temp:
            root=Path(temp);(root/'evidence').write_bytes(b'synthetic')
            with self.assertRaises(ValueError):Guard(root).bind({'path':'evidence','sha256':'a'*64})
    def test_syntax_only(self):
        for name in ('support.py','capture_current_v2.py','prepare_draft_v2.py'):
            ast.parse((P/name).read_text(),filename=name)

if __name__=='__main__':unittest.main()
