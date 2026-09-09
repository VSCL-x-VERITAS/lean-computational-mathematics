"""Read-only real-evidence and synthetic rejection tests; no canonical writes."""
from pathlib import Path
import copy, importlib.util, json, unittest
F=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('retry_recover',F/'recover.py')
mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)

class Guards(unittest.TestCase):
    def setUp(self):
        self.before={'schema_version':'fixture','task_id':'synthetic-only','runs':[
            {'role':'roundtrip-judge','agent_id':'old','notes':'retain malformed attempt'}]}
        self.after=copy.deepcopy(self.before)
        self.after['runs'].append({'role':'roundtrip-judge','agent_id':'new'})
    def test_append_retains_old(self):mod.append_check(self.before,self.after,'new')
    def test_replaced_history_rejected(self):
        self.after['runs'][0]['notes']='rewritten'
        with self.assertRaises(AssertionError):mod.append_check(self.before,self.after,'new')
    def test_reused_agent_rejected(self):
        self.after['runs'][-1]['agent_id']='old'
        with self.assertRaises(AssertionError):mod.append_check(self.before,self.after,'old')
    def test_wrong_role_rejected(self):
        self.after['runs'][-1]['role']='adjudicator'
        with self.assertRaises(AssertionError):mod.append_check(self.before,self.after,'new')
    def test_extra_runtime_rejected(self):
        self.after['runs'].append({'role':'roundtrip-judge','agent_id':'third'})
        with self.assertRaises(AssertionError):mod.append_check(self.before,self.after,'new')
    def test_changed_task_rejected(self):
        self.after['task_id']='other'
        with self.assertRaises(AssertionError):mod.append_check(self.before,self.after,'new')
    def test_allowed_finalizer_change(self):
        before={'status':'prepared','target':{'sha256':'fixed'}}
        after={**before,'status':'completed','completed_at_utc':'actual-fixture-time','outputs':{'decision':'fixture'}}
        mod.manifest_transition(before,after)
    def test_changed_source_rejected(self):
        before={'status':'prepared','source':{'sha256':'fixed'}}
        after={'status':'completed','source':{'sha256':'changed'},'completed_at_utc':'fixture','outputs':{'x':1}}
        with self.assertRaises(AssertionError):mod.manifest_transition(before,after)
    def test_absent_completion_rejected(self):
        with self.assertRaises(AssertionError):mod.manifest_transition({'status':'prepared'},{'status':'completed'})
    def failure_args(self):
        return [mod.read(mod.T/'role-run-receipt.json'),(mod.T/'role-run-output.txt').read_bytes(),
                (mod.T/'role-run-stderr.txt').read_bytes(),(mod.P/'r_final.json').read_bytes()]
    def test_real_original_failure(self):mod.original_failure(*self.failure_args())
    def test_passing_original_rejected(self):
        args=self.failure_args();args[0]['exit_code']=0
        with self.assertRaises(AssertionError):mod.original_failure(*args)
    def test_wrong_failure_log_rejected(self):
        args=self.failure_args();args[2]+=b'changed'
        with self.assertRaises(AssertionError):mod.original_failure(*args)
    def test_silently_repaired_original_rejected(self):
        args=self.failure_args();bad=json.loads(args[3]);bad['source_sha256']=mod.SOURCE_HASH
        args[3]=json.dumps(bad).encode()
        with self.assertRaises(AssertionError):mod.original_failure(*args)
    def test_wrong_pin_rejected(self):
        pin=mod.ref(F/'fresh-retry-receipt.json');pin['sha256']='0'*64
        with self.assertRaises(AssertionError):mod.verify(pin)
    def test_fresh_actual_collector_prefix(self):
        actual=mod.session_preflight()
        self.assertEqual(actual['agent_id'],mod.read(F/'fresh-retry-receipt.json')['actual_agent_id'])
        self.assertEqual(actual['tool_calls'],0)

if __name__=='__main__':unittest.main(verbosity=2)
