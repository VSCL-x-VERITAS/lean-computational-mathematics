"""Synthetic path-policy/parser tests only; no Git or operational execution."""
from pathlib import Path
import copy
import importlib.util
import json
import unittest
from unittest.mock import patch

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('screen', HERE / 'check-publication-allowlist.py')
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
policy = json.loads((HERE / 'policy.json').read_text())

class Policy(unittest.TestCase):
    def test_schema(self):
        m.verify_policy(policy)
        for mutate in (lambda x: x.update(size_limit_bytes=100000000), lambda x: x.update(extra=True),
                       lambda x: x['allow_prefixes'].append('../'), lambda x: x['allow_exact'].append('/absolute')):
            p = copy.deepcopy(policy); mutate(p)
            with self.assertRaises(AssertionError): m.verify_policy(p)

    def test_scope(self):
        for p in policy['allow_exact']: self.assertEqual(m.disposition(p, policy)[0], 'select')
        for p in policy['exclude_exact']: self.assertEqual(m.disposition(p, policy)[0], 'exclude')
        for p in policy['allow_prefixes']: self.assertEqual(m.disposition(p + 'failed-attempt-01/output.txt', policy)[0], 'select')
        self.assertEqual(m.disposition('unrelated/new.lean', policy)[0], 'exclude')
        self.assertEqual(m.disposition(m.SESSION + 'audits/UNREVIEWED/decision.json', policy)[0], 'exclude')
        self.assertEqual(m.disposition(m.SESSION + 'unblock-nine-future-output.txt', policy)[0], 'exclude')

    def test_raw_and_archive(self):
        for a in policy['archives']:
            self.assertEqual(m.disposition(a['raw']['path'], policy)[0], 'exclude')
            self.assertEqual(m.disposition(a['archive']['path'], policy)[0], 'select')
            self.assertGreater(a['raw']['bytes'], policy['size_limit_bytes'])
            self.assertLess(a['archive']['bytes'], policy['size_limit_bytes'])

    def test_caches_and_inert_history(self):
        prefix = policy['allow_prefixes'][0]
        for suffix in policy['generated_cache_suffixes']:
            self.assertEqual(m.disposition(prefix + 'example' + suffix, policy)[0], 'hold')
        self.assertEqual(m.disposition(prefix + '__pycache__/code.pyc', policy)[0], 'hold')
        self.assertEqual(m.disposition(prefix + 'historical.olean.snapshot.bin', policy)[0], 'select')
        self.assertEqual(m.disposition(prefix + 'failed-candidate.lean.snapshot', policy)[0], 'select')

    def test_path_safety(self):
        for p in ('../escape', 'a/../b', '/absolute', 'a//b', 'C:/native', 'a\\b', './a', ''):
            self.assertEqual(m.disposition(p, policy)[0], 'hold')

    def test_status_parser(self):
        actual = m.parse_status(b' M a\0?? space file\0R  new\0old\0A  unicode-\xce±.lean\0')
        self.assertEqual(actual, [{'path': 'a', 'status': ' M'}, {'path': 'space file', 'status': '??'},
                                  {'path': 'new', 'status': 'R ', 'original_path': 'old'},
                                  {'path': 'unicode-\u03b1.lean', 'status': 'A '}])

    def test_source_syntax_and_git_commands(self):
        import ast
        tree = ast.parse((HERE / 'check-publication-allowlist.py').read_text())
        calls = [node for node in ast.walk(tree) if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id == 'git']
        verbs = [node.args[0].elts[0].value for node in calls]
        self.assertEqual(sorted(verbs), ['ls-files', 'rev-parse', 'rev-parse', 'rev-parse', 'status'])
        self.assertIn('--no-optional-locks', m.GIT)
        self.assertIn('diff.autoRefreshIndex=false', m.GIT)
        self.assertEqual(len([p for p in policy['allow_exact'] if p.startswith('ComputationalMathematics/')]), 22)

if __name__ == '__main__':
    with patch.object(m.subprocess, 'run', side_effect=AssertionError('No subprocess in synthetic tests')):
        unittest.main(verbosity=2)
