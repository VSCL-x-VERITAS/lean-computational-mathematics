"""Focused pure guard tests; no Git, archive reconstruction or source changes."""
from pathlib import Path
import copy
import importlib.util
import json
import unittest
from unittest.mock import patch

P = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('extension',P/'extend-final-policy-receipts.py')
e = importlib.util.module_from_spec(spec); spec.loader.exec_module(e)
m = e.checker()
p = json.loads((P/'policy-final-01.json').read_bytes())

class FinalPolicy(unittest.TestCase):
    def test_exact_scope(self):
        m.verify_policy(p)
        self.assertEqual(len([x for x in p['allow_exact'] if x.startswith('ComputationalMathematics/')]),46)
        self.assertEqual(len([x for x in p['allow_prefixes'] if '/audits/' in x]),21)
        self.assertEqual(len(p['archives']),5)

    def test_five_raw_exclusions(self):
        for a in p['archives']:
            self.assertEqual(m.disposition(a['raw']['path'],p)[0],'exclude')
            self.assertEqual(m.disposition(a['archive']['path'],p)[0],'select')

    def test_historical_attempts_and_new_unknowns(self):
        for prefix in p['allow_prefixes']:
            self.assertEqual(m.disposition(prefix+'failed-attempt-01/native-output.txt',p)[0],'select')
        self.assertEqual(m.disposition(m.SESSION+'unblock-nine-not-yet-reviewed-exit.json',p)[0],'exclude')
        self.assertEqual(m.disposition(m.SESSION+'audits/UNREVIEWED/new.json',p)[0],'exclude')

    def test_exclusion_and_cache_precedence(self):
        for path in p['exclude_exact']: self.assertEqual(m.disposition(path,p)[0],'exclude')
        self.assertEqual(m.disposition(p['allow_prefixes'][0]+'__pycache__/x.pyc',p)[0],'hold')

    def addition(self,path=None):
        return {'schema':1,'status':'EXPLICIT_RECEIPTS_ROOT_REVIEW_REQUIRED',
            'base_policy':{'path':(P/'policy-final-01.json').relative_to(e.R).as_posix(),'sha256':e.sha((P/'policy-final-01.json').read_bytes())},
            'add_exact_files':[{'path':path or m.SESSION+'unblock-nine-future-reviewed-exit.json','sha256':'a'*64}],
            'rationale':'Synthetic field guard only.'}

    def test_receipt_only_extension(self):
        a=self.addition(); result=e.derive(p,a,m)
        self.assertEqual(set(result['allow_exact'])-set(p['allow_exact']),{a['add_exact_files'][0]['path']})
        for k in set(p)-{'allow_exact','notes'}: self.assertEqual(result[k],p[k])

    def test_denies_new_source_audit_raw_lock_and_broad_paths(self):
        paths=['ComputationalMathematics/Unreviewed.lean',m.SESSION+'audits/NEW/decision.json',
            m.SESSION+'unblock-nine-other/raw.jsonl',m.SESSION+'unblock-nine-future.lock',
            '../escape.json','/absolute.json',m.SESSION+'unblock-nine-cache.pyc']
        for path in paths:
            with self.subTest(path=path),self.assertRaises(AssertionError): e.derive(p,self.addition(path),m)

    def test_denies_duplicate_malformed_or_empty_extension(self):
        for change in [lambda a:a['add_exact_files'].append(a['add_exact_files'][0]),
                       lambda a:a.update(add_exact_files=[]),lambda a:a.update(extra=True),
                       lambda a:a['add_exact_files'][0].update(sha256='wrong'),
                       lambda a:a.update(status='APPROVED')]:
            a=self.addition(); change(a)
            with self.assertRaises(AssertionError): e.derive(p,a,m)

    def test_denies_already_allowed_receipt(self):
        path=next(x for x in p['allow_exact'] if x.startswith(m.SESSION+'unblock-nine-') and x.endswith('-exit.json'))
        with self.assertRaises(AssertionError): e.derive(p,self.addition(path),m)

if __name__=='__main__':
    with patch.object(m.subprocess,'run',side_effect=AssertionError('No subprocess in guard tests')):
        unittest.main(verbosity=2)
