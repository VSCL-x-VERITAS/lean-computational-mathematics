"""Synthetic guard tests only. No Codex, collector, released script or audit is invoked."""
from pathlib import Path
import copy
import importlib.util
import json
import tempfile
import unittest

D=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('recovery',D/'recovery.py')
r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
F=D/'synthetic-fixtures';F.mkdir(exist_ok=True)

class GuardTests(unittest.TestCase):
    def setup_documents(self):
        directory=Path(tempfile.mkdtemp(prefix='case-',dir=F))
        data={'direct_review_packet.md':'# Exact direct\n\n```lean\n∀ x : ℝ, x = x\n```\n'.encode(),
            'declaration_dossier.md':None,'blind_dossier.md':b'# Complete blind\nUnique blind bytes.\n',
            'evidence.json':'{\n "field": "exact\\nstring", "unicode": "ℝ"\n}\n'.encode()}
        data['declaration_dossier.md']=data['direct_review_packet.md']+b'\n# Unique full-dossier content\n'
        records=[];prompt=b'Exact framing.\n'
        for name,raw in data.items():
            p=directory/name;p.write_bytes(raw)
            item={'path':str(p),'label':name,'sha256':r.digest(raw),'bytes':len(raw)}
            records.append(item)
            prompt+=('\n\n'+name+' SHA256 '+item['sha256']+'\n').encode()+raw
        return prompt,records
    def failure(self):
        prompt=b'x'*(r.LIMIT+1)
        return [{'type':'thread.started','thread_id':'failed-thread'}],\
            'input_too_large {"max_chars":1048576,"actual_chars":1048577}',\
            {'exit_code':1,'stdin_bytes':len(prompt),'stdin_sha256':r.digest(prompt)},prompt
    def test_exact_reconstruction_and_verbatim_json(self):
        prompt,records=self.setup_documents();compact,mapping=r.deduplicate(prompt,records)
        container=Path(mapping['container']['path']).read_bytes()
        expanded=compact.replace(mapping['marker_utf8'].encode(),container[mapping['start_byte']:mapping['end_byte_exclusive']])
        self.assertEqual(expanded,prompt)
        self.assertIn(Path(records[-1]['path']).read_bytes(),compact)
        self.assertIn(Path(records[2]['path']).read_bytes(),compact)
    def test_changed_source_hash_rejected(self):
        prompt,records=self.setup_documents();records[0]['sha256']='0'*64
        with self.assertRaises(AssertionError):r.deduplicate(prompt,records)
    def test_nonidentical_dossier_rejected(self):
        prompt,records=self.setup_documents();p=Path(records[1]['path']);p.write_bytes(b'unrelated')
        records[1].update(sha256=r.sha(p),bytes=p.stat().st_size)
        with self.assertRaises(AssertionError):r.deduplicate(prompt,records)
    def test_changed_markdown_prompt_rejected(self):
        prompt,records=self.setup_documents();prompt=prompt.replace(b'Unique blind bytes.',b'DIFFERENT blind bytes.')
        with self.assertRaises(AssertionError):r.deduplicate(prompt,records)
    def test_duplicate_json_keys_rejected(self):
        with self.assertRaises(AssertionError):r.decode(b'{"a":1,"a":2}')
    def test_nonfinite_json_rejected(self):
        with self.assertRaises(ValueError):r.decode(b'{"a":NaN}')
    def test_true_unstarted_limit_failure(self):
        self.assertEqual(r.unstarted_failure(*self.failure()),'failed-thread')
    def test_turn_started_rejected(self):
        e,s,t,p=self.failure();e.append({'type':'turn.started'})
        with self.assertRaises(AssertionError):r.unstarted_failure(e,s,t,p)
    def test_two_threads_rejected(self):
        e,s,t,p=self.failure();e.append(e[0])
        with self.assertRaises(AssertionError):r.unstarted_failure(e,s,t,p)
    def test_successful_exit_rejected(self):
        e,s,t,p=self.failure();t['exit_code']=0
        with self.assertRaises(AssertionError):r.unstarted_failure(e,s,t,p)
    def test_other_error_rejected(self):
        e,s,t,p=self.failure()
        with self.assertRaises(AssertionError):r.unstarted_failure(e,'timeout',t,p)
    def test_prompt_hash_mismatch_rejected(self):
        e,s,t,p=self.failure();t['stdin_sha256']='f'*64
        with self.assertRaises(AssertionError):r.unstarted_failure(e,s,t,p)
    def test_actual_length_mismatch_rejected(self):
        e,s,t,p=self.failure();s=s.replace('1048577','1048578')
        with self.assertRaises(AssertionError):r.unstarted_failure(e,s,t,p)
    def test_released_manifest_transition_allowed(self):
        before={'status':'prepared','source':{'sha256':'source'},'target':{'sha256':'target'}}
        after={**before,'status':'completed','completed_at_utc':'actual','outputs':{'decision':{'sha256':'d'}}}
        r.manifest_transition(before,after)
    def test_target_manifest_change_rejected(self):
        before={'status':'prepared','target':{'sha256':'target'}}
        after={'status':'completed','target':{'sha256':'changed'},'completed_at_utc':'actual','outputs':{'decision':{}}}
        with self.assertRaises(AssertionError):r.manifest_transition(before,after)
    def test_missing_final_output_manifest_rejected(self):
        with self.assertRaises(AssertionError):r.manifest_transition({}, {'status':'completed','completed_at_utc':'actual'})
    def test_new_adjudicator_append_allowed(self):
        old={'task_id':'synthetic','runs':[{'role':'direct-judge','agent_id':'old'}]}
        new=copy.deepcopy(old);new['runs'].append({'role':'adjudicator','agent_id':'fresh'})
        r.run_append(old,new,'fresh','failed')
    def test_reused_failed_thread_rejected(self):
        old={'runs':[{'role':'direct-judge','agent_id':'old'}]}
        new={'runs':old['runs']+[{'role':'adjudicator','agent_id':'failed'}]}
        with self.assertRaises(AssertionError):r.run_append(old,new,'failed','failed')
    def test_rewritten_old_run_rejected(self):
        old={'runs':[{'role':'direct-judge','agent_id':'old'}]}
        new={'runs':[{'role':'direct-judge','agent_id':'other'},{'role':'adjudicator','agent_id':'fresh'}]}
        with self.assertRaises(AssertionError):r.run_append(old,new,'fresh','failed')

if __name__=='__main__':unittest.main(verbosity=2)
