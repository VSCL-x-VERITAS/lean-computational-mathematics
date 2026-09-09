"""Synthetic retry-lineage guards only; no real task operation or role."""
from pathlib import Path
import ast,copy,importlib.util,unittest
F=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('recovery_v4',F/'recovery-v4.py')
r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)

class LineageGuards(unittest.TestCase):
    def setUp(self):
        self.old={'exit_code':1,'stdout_sha256':'50a2105fdfba5e3e1219e08d79325bdaf2526f0b3c1068b5351396b726d9089e',
                  'stderr_sha256':'f296ccb7e8a28efa15248ff685134d75f89043f78670fc4541668154a3943c1a'}
        self.cont={'name':'continuation','exit_code':1,'fixture':'synthetic only'}
        self.execution={'format':'malformed-roundtrip-recovery-execution-1','task_id':r.RETRY_TASK,
            'original_wrapper_exit_code':1,'canonical_collection_performed':True,'exit_code':1,
            'steps':[{'name':'collect-r2','exit_code':0},self.cont],'guard_error':'fixture failure'}
        self.before={'task_id':'synthetic-only','runs':[{'role':role,'agent_id':str(i)} for i,role in
            enumerate(['source-contract','blind-translation','direct-judge','roundtrip-judge'])]}
        self.after=copy.deepcopy(self.before)
        self.after['runs'].append({'role':'roundtrip-judge','agent_id':'fresh'})
    def check(self):r.continuation_contract(self.execution,self.cont,self.old)
    def history(self):r.retry_history(self.before,self.after,'3','fresh')
    def test_valid_distinct_failure_envelopes(self):self.check()
    def test_original_failure_not_substituted_for_continuation(self):
        with self.assertRaises((AssertionError,KeyError)):r.continuation_contract(self.execution,self.old,self.old)
    def test_missing_fresh_collection_rejected(self):
        self.execution['canonical_collection_performed']=False
        with self.assertRaises(AssertionError):self.check()
    def test_failed_collection_rejected(self):
        self.execution['steps'][0]['exit_code']=2
        with self.assertRaises(AssertionError):self.check()
    def test_passing_continuation_rejected(self):
        self.cont['exit_code']=0
        with self.assertRaises(AssertionError):self.check()
    def test_wrong_task_rejected(self):
        self.execution['task_id']='another-task'
        with self.assertRaises(AssertionError):self.check()
    def test_later_failure_not_adjudication_start_rejected(self):
        self.execution['steps'].append({'name':'complete-validation','exit_code':1})
        with self.assertRaises(AssertionError):self.check()
    def test_changed_original_log_rejected(self):
        self.old['stderr_sha256']='0'*64
        with self.assertRaises(AssertionError):self.check()
    def test_exact_five_run_lineage(self):self.history()
    def test_changed_old_history_rejected(self):
        self.after['runs'][0]['agent_id']='changed'
        with self.assertRaises(AssertionError):self.history()
    def test_missing_retry_runtime_rejected(self):
        self.after['runs'].pop()
        with self.assertRaises(AssertionError):self.history()
    def test_extra_unreviewed_retry_rejected(self):
        self.after['runs'].append({'role':'roundtrip-judge','agent_id':'other'})
        with self.assertRaises(AssertionError):self.history()
    def test_reused_agent_id_rejected(self):
        self.after['runs'][-1]['agent_id']='3'
        with self.assertRaises(AssertionError):r.retry_history(self.before,self.after,'3','3')
    def test_wrong_retry_role_rejected(self):
        self.after['runs'][-1]['role']='adjudicator'
        with self.assertRaises(AssertionError):self.history()
    def test_all_twenty_existing_unmodified_function_asts(self):
        base=F.parent/'adjudicator-transport-recovery-v3/recovery-v3.py'
        self.assertEqual(r.sha(base),'a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887')
        tree=lambda p:{n.name:ast.dump(n,include_attributes=False) for n in ast.parse(p.read_text(encoding='utf-8')).body if isinstance(n,ast.FunctionDef)}
        before,after=tree(base),tree(F/'recovery-v4.py')
        names=[name for name in before if name not in ('prepare','execute')]
        self.assertEqual(len(names),20)
        for name in names:self.assertEqual(before[name],after[name],name)

if __name__=='__main__':unittest.main(verbosity=2)
