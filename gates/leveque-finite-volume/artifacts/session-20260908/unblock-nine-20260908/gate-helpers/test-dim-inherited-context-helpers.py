"""Inherited metadata guards and exact two-context regression tests; no audit/gate calls."""
from pathlib import Path
import ast, copy, hashlib, importlib.util, json, unittest

H=Path(__file__).resolve().parent; P=H/'dim-inherited-context-successors';R=H.parents[5]
def load(name,filename):
    spec=importlib.util.spec_from_file_location(name,H/filename)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def read(path):return json.loads(path.read_bytes())
def ref(path):return {'path':path.relative_to(R).as_posix(),'sha256':sha(path)}
def functions(filename):
    return {n.name:ast.dump(n,include_attributes=False) for n in ast.parse((H/filename).read_text()).body
            if isinstance(n,(ast.FunctionDef,ast.AsyncFunctionDef))}
prior=load('inherited_high_resolution_guards','test-high-resolution-context-helpers.py')
q=load('dim_inherited_q5','qualified_row_support_v5.py')
batch=load('dim_inherited_batch4','rebind-accepted-row-batch-v4.py')
global_binder=load('dim_inherited_global4','bind-final-global-evidence-v4.py')
prior.q=q;prior.prior_context.q=q;prior.batch=batch
prior.prior_batch.b=batch;prior.prior_batch.prior.b=batch
prior.global_binder=global_binder

class Page25ContextGuards(prior.LiteralReceiptGuards):
    def setUp(self):
        super().setUp()
        self.request['source_context_extension']=copy.deepcopy(q.DIM_INHERITED_HYPERBOLICITY_CONTEXT)
        self.context=q.source_context_json(q.bound(q.DIM_INHERITED_HYPERBOLICITY_CONTEXT))
        self.source=self.context['source']

class ExactContextGuards(unittest.TestCase):
    def setUp(self):
        self.fixture=Page25ContextGuards()
        self.fixture.setUp()
    def test_only_two_reviewed_refs(self):
        self.assertEqual(q.REVIEWED_HIGH_RESOLUTION_CONTEXTS,
          (q.HIGH_RESOLUTION_CONTEXT,q.DIM_INHERITED_HYPERBOLICITY_CONTEXT))
        self.assertEqual(q.HIGH_RESOLUTION_CONTEXT['sha256'],'71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d')
        self.assertEqual(q.DIM_INHERITED_HYPERBOLICITY_CONTEXT['sha256'],'d7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206')
    def test_new_actual_context_adds_only_inherited_page25(self):
        old=q.source_context_json(q.bound(q.HIGH_RESOLUTION_CONTEXT));new=self.fixture.context
        self.assertEqual(set(old),set(new))
        for k in ('format','source','primary_locations','interpretation_receipts'):
            self.assertEqual(old[k],new[k])
        self.assertEqual(new['pages'],[25,*old['pages']])
        self.assertEqual(new['images'][1:],old['images'])
        self.assertEqual(new['inherited_locations'][1:],old['inherited_locations'])
        self.assertEqual(new['images'][0]['sha256'],'ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8')
        for item in [new['source'],*new['images'],*new['interpretation_receipts']]:
            self.assertEqual(sha(R/item['path']),item['sha256'])
    def test_missing_context_reference(self):
        del self.fixture.request['source_context_extension']
        with self.assertRaises(KeyError):self.fixture.check()
    def test_context_ref_path_and_hash_are_jointly_exact(self):
        for base in q.REVIEWED_HIGH_RESOLUTION_CONTEXTS:
            for key,value in [('path','unreviewed/context.json'),('sha256','0'*64)]:
                bad=copy.deepcopy(base);bad[key]=value
                self.fixture.request['source_context_extension']=bad
                with self.subTest(key=key),self.assertRaisesRegex(ValueError,'exact reviewed'):self.fixture.check()
    def test_extra_context_ref_fields_rejected(self):
        self.fixture.request['source_context_extension']['invented_authority']=True
        with self.assertRaisesRegex(ValueError,'exact reviewed'):self.fixture.check()
    def test_mutated_bound_context_is_not_readable(self):
        bad=copy.deepcopy(q.DIM_INHERITED_HYPERBOLICITY_CONTEXT);bad['sha256']='0'*64
        with self.assertRaisesRegex(ValueError,'binding mismatch'):q.source_context_ref(bad)
    def test_wrong_rows_include_fv_and_info(self):
        for row in ['LEV-CH01-FINITE-VOLUME-FLUX-UPDATE','LEV-CH01-RIEMANN-INTERFACE-FLUX','arbitrary']:
            self.fixture.request['row']=row
            with self.subTest(row=row),self.assertRaisesRegex(ValueError,'scoped only'):self.fixture.check()
    def test_old_receipt_fields_and_bytes_immutable(self):
        for index in (0,1):
            for field in ('answer','question','scope','authority_limit'):
                original=copy.deepcopy(self.fixture.packet)
                self.fixture.packet['interpretation_receipts'][index]['exact_fields'][field]='MUTATED TEST VALUE'
                with self.subTest(index=index,field=field),self.assertRaisesRegex(ValueError,'literal inherited receipt'):self.fixture.check()
                self.fixture.packet=original
    def test_no_future_info_receipt_branch(self):
        source=(H/'qualified_row_support_v5.py').read_text()
        predecessor=(H/'qualified_row_support_v4.py').read_text()
        self.assertEqual(source.count('INHERITED_RECEIPT'),predecessor.count('INHERITED_RECEIPT'))
        self.assertEqual(source.count('HIGH_RESOLUTION_RECEIPT'),predecessor.count('HIGH_RESOLUTION_RECEIPT'))
        self.fixture.context['interpretation_receipts'].append({'path':'pending/info.json','sha256':'a'*64})
        with self.assertRaisesRegex(ValueError,'recorded order'):self.fixture.check()

class StructuralGuards(unittest.TestCase):
    def test_every_successor_is_exact_declared_derivation(self):
        records=read(P/'derivation.json')['derivations'];self.assertEqual(len(records),6)
        for record in records:
            oldpath=R/record['parent']['path'];newpath=R/record['output']['path']
            self.assertEqual(sha(oldpath),record['parent']['sha256'])
            self.assertEqual(sha(newpath),record['output']['sha256'])
            text=oldpath.read_text()
            for item in record['exact_replacements']:
                self.assertEqual(text.count(item['before']),1)
                text=text.replace(item['before'],item['after'])
            self.assertEqual(text,newpath.read_text())
            compile(text,str(newpath),'exec')
    def test_q5_all_other_functions_identical(self):
        old=functions('qualified_row_support_v4.py');new=functions('qualified_row_support_v5.py')
        self.assertEqual(set(old),set(new))
        for name in old.keys()-{'validate_scoped_context_receipts'}:
            with self.subTest(name=name):self.assertEqual(old[name],new[name])
        text=(H/'qualified_row_support_v5.py').read_text()
        text=text.replace("request['source_context_extension'] in REVIEWED_HIGH_RESOLUTION_CONTEXTS",
                          "request['source_context_extension'] == HIGH_RESOLUTION_CONTEXT")
        text=text.replace("request['source_context_extension'] not in REVIEWED_HIGH_RESOLUTION_CONTEXTS",
                          "request['source_context_extension'] != HIGH_RESOLUTION_CONTEXT")
        target=next(n for n in ast.parse(text).body if isinstance(n,ast.FunctionDef) and n.name=='validate_scoped_context_receipts')
        self.assertEqual(old['validate_scoped_context_receipts'],ast.dump(target,include_attributes=False))
    def test_support_only_two_new_constants(self):
        def nodes(filename):
            result={}
            for n in ast.parse((H/filename).read_text()).body:
                if isinstance(n,ast.Assign):result[ast.dump(n.targets[0])]=ast.dump(n,include_attributes=False)
            return result
        old=nodes('qualified_row_support_v4.py');new=nodes('qualified_row_support_v5.py')
        self.assertEqual(len(new),len(old)+2)
        for k in old:self.assertEqual(old[k],new[k])
    def test_binder_and_both_validators_functions_identical(self):
        for old,new in [('bind-qualified-row-v4.py','bind-qualified-row-v5.py'),
                        ('validate-closed-row-audits-v7.py','validate-closed-row-audits-v8.py'),
                        ('validate-closed-row-audits-rebind-v3.py','validate-closed-row-audits-rebind-v4.py')]:
            with self.subTest(new=new):self.assertEqual(functions(old),functions(new))
    def test_global_payloads_unchanged(self):
        old=functions('bind-final-global-evidence-v3.py');new=functions('bind-final-global-evidence-v4.py')
        self.assertEqual(set(old),set(new))
        for name in old.keys()-{'load_final_validator_support','validate_audit_records'}:
            with self.subTest(name=name):self.assertEqual(old[name],new[name])
        self.assertEqual(old['validate_audit_records'].replace('exact v7 support','exact v8 support'),new['validate_audit_records'])
        normalized=new['load_final_validator_support'].replace('v8','v7').replace('support_v5','support_v4').replace('qualified_v5','qualified_v4')
        self.assertEqual(old['load_final_validator_support'],normalized)
    def test_dependency_manifest_only_expected_changes(self):
        old=read(H/'source-context-v4-validator-dependencies.json');new=read(H/'source-context-v5-validator-dependencies.json')
        self.assertEqual(set(old),set(new))
        for key in old.keys()-{'audit_validator','validator_dependencies','source_context_protocol_inputs','producer'}:
            self.assertEqual(old[key],new[key])
        self.assertEqual(old['validator_dependencies'][1:],new['validator_dependencies'][1:])
        self.assertEqual(new['validator_dependencies'][0],ref(H/'qualified_row_support_v5.py'))
        self.assertEqual(new['audit_validator'],ref(H/'validate-closed-row-audits-v8.py'))
        self.assertEqual(new['source_context_protocol_inputs'],old['source_context_protocol_inputs']+[q.DIM_INHERITED_HYPERBOLICITY_CONTEXT])
        self.assertEqual(global_binder.FINAL_VALIDATOR_PIN,new['audit_validator'])
        self.assertEqual(global_binder.FINAL_VALIDATOR_DEPENDENCIES[0],new['validator_dependencies'][0])

if __name__=='__main__':
    baseline=unittest.TestSuite()
    for cls in (prior.prior_context.ContextGuards,prior.prior_batch.Guards,prior.LiteralReceiptGuards,prior.ProjectionRegressions):
        baseline.addTests(unittest.defaultTestLoader.loadTestsFromTestCase(cls))
    inherited=baseline.countTestCases();assert inherited==43,inherited
    suite=unittest.TestSuite([baseline])
    for cls in (Page25ContextGuards,ExactContextGuards,StructuralGuards):
        suite.addTests(unittest.defaultTestLoader.loadTestsFromTestCase(cls))
    total=suite.countTestCases()
    result=unittest.TextTestRunner(verbosity=2).run(suite)
    summary={'schema':1,'inherited_tests':inherited,'added_tests':total-inherited,'total_tests':total,
       'run':result.testsRun,'failures':len(result.failures),'errors':len(result.errors),'skipped':len(result.skipped),
       'passed':result.wasSuccessful(),'test_script':ref(Path(__file__)),
       'actual_operational_validations':0,'gate_mutations':0,'source_acceptance':False}
    with (P/'guard-summary.json').open('x') as f:json.dump(summary,f,indent=2);f.write('\n')
    raise SystemExit(0 if result.wasSuccessful() else 1)
