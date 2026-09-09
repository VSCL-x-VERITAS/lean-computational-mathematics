"""Retain earlier tests and add rejection cases for the new archive-list guard."""
from pathlib import Path
import hashlib
import json
H = Path(__file__).resolve().parent
old = H / 'test-allowlist-v3.py'
text = old.read_text()
assert text.count('check-publication-allowlist-v2.py') == 2
text = text.replace('check-publication-allowlist-v2.py', 'check-publication-allowlist-v3.py')
marker = "if __name__ == '__main__':"
addition = '''class ExtraArchives(unittest.TestCase):
    def third(self):
        p = copy.deepcopy(policy)
        record = json.loads((HERE.parent / 'riemann-routine-fingerprints/final-receipt.json').read_text())
        a = record['archive']
        p['archives'].append({'receipt': record['fingerprint_receipt'],
            'archive': {key: a[key] for key in ('path', 'sha256', 'bytes')},
            'raw': {'path': a['path'][:-3], 'sha256': a['uncompressed_sha256'],
                    'bytes': a['uncompressed_bytes']}})
        return p

    def test_three_explicit_archives(self):
        m.verify_policy(self.third())

    def test_duplicate_archive_receipt_or_raw(self):
        for key in ('archive', 'receipt', 'raw'):
            p = self.third()
            p['archives'][-1][key]['path'] = p['archives'][0][key]['path']
            with self.assertRaises(AssertionError): m.verify_policy(p)

    def test_malformed_archive_entry(self):
        for key, field, value in (('raw', 'path', '../escape'), ('receipt', 'sha256', 'x'),
                                  ('raw', 'bytes', 0), ('archive', 'bytes', True),
                                  ('archive', 'path', 'uncompressed.jsonl')):
            p = self.third()
            p['archives'][-1][key][field] = value
            with self.assertRaises(AssertionError): m.verify_policy(p)

    def test_missing_or_extra_archives(self):
        p = self.third()
        p['archives'] = p['archives'][:1]
        with self.assertRaises(AssertionError): m.verify_policy(p)
        p = self.third()
        p['archives'][-1]['unreviewed'] = True
        with self.assertRaises(AssertionError): m.verify_policy(p)

'''
assert text.count(marker) == 1
text = text.replace(marker, addition + marker)
new = H / 'test-allowlist-v4.py'
compile(text, str(new), 'exec')
with new.open('xb') as stream:
    stream.write(text.encode())
record = {'source_sha256': hashlib.sha256(old.read_bytes()).hexdigest(),
          'output_sha256': hashlib.sha256(new.read_bytes()).hexdigest(),
          'existing_tests_preserved': 7, 'additional_tests': 4, 'tests_executed': False}
with (H / 'checker-v3-tests-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
