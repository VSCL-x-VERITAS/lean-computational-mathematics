"""Add read-only staged-blob sizes while preserving the first actual snapshot/helper."""
from pathlib import Path
import hashlib
import json
H = Path(__file__).resolve().parent
old = H / 'check-publication-allowlist.py'
assert hashlib.sha256(old.read_bytes()).hexdigest() == '0b035cc1a660181b0beaa20035edd0e7228e175104b1bc178cc0dd3d5dd02ad1'
changes = [
    ('    def git(args, name):', '    def git(args, name, input_data=None):'),
    ('result = subprocess.run(command, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE)',
     'result = subprocess.run(command, cwd=ROOT, input=input_data, stdout=subprocess.PIPE, stderr=subprocess.PIPE)'),
    ('    issues = []; historical = []; archives = []',
     '''    changed_oids = sorted({x['oid'] for record in records for x in indexed.get(record['path'], []) if x['mode'] != '160000'})
    blob_sizes = {}
    if changed_oids:
        raw = git(['cat-file', '--batch-check=%(objectname) %(objecttype) %(objectsize)'], 'indexed-blob-sizes',
                  ('\\n'.join(changed_oids) + '\\n').encode())
        for line in raw.decode('ascii').splitlines():
            oid, kind, size = line.split()
            assert kind == 'blob'
            blob_sizes[oid] = int(size)
        assert set(blob_sizes) == set(changed_oids)
    issues = []; historical = []; archives = []'''),
    ("        staged = record['status'][0] not in (' ', '?')",
     """        for entry in record['index_entries']:
            if entry['oid'] in blob_sizes:
                entry['bytes'] = blob_sizes[entry['oid']]
                if entry['bytes'] >= policy['size_limit_bytes']:
                    record['index_blob_at_least_90MB'] = True
                    if selected == 'select': record['disposition'] = 'hold'
                    issues.append({'path': path, 'issue': 'index blob is at least 90,000,000 bytes', 'oid': entry['oid'], 'bytes': entry['bytes']})
        staged = record['status'][0] not in (' ', '?')"""),
    ("'historical_placeholder_files': len(historical), 'archives_verified': len(archives)",
     "'large_index_blobs': [x['path'] for x in records if x.get('index_blob_at_least_90MB')],\n                      'historical_placeholder_files': len(historical), 'archives_verified': len(archives)")]
text = old.read_text()
for before, after in changes:
    assert text.count(before) == 1
    text = text.replace(before, after)
new = H / 'check-publication-allowlist-v2.py'
compile(text, str(new), 'exec')
with new.open('xb') as f: f.write(text.encode())
tests = (H / 'test-allowlist-v2.py').read_text()
test_changes = [
    ("'check-publication-allowlist.py'", "'check-publication-allowlist-v2.py'"),
    ("['ls-files', 'rev-parse', 'rev-parse', 'rev-parse', 'status']", "['cat-file', 'ls-files', 'rev-parse', 'rev-parse', 'rev-parse', 'status']")]
for before, after in test_changes:
    assert tests.count(before) in (1, 2)
    tests = tests.replace(before, after)
with (H / 'test-allowlist-v3.py').open('xb') as f: f.write(tests.encode())
record = {'schema': 1, 'source_sha256': hashlib.sha256(old.read_bytes()).hexdigest(),
          'output_sha256': hashlib.sha256(new.read_bytes()).hexdigest(),
          'exact_replacements': [{'before': a, 'after': b} for a, b in changes],
          'test_source_sha256': hashlib.sha256((H / 'test-allowlist-v2.py').read_bytes()).hexdigest(),
          'test_output_sha256': hashlib.sha256((H / 'test-allowlist-v3.py').read_bytes()).hexdigest(),
          'test_replacements': [{'before': a, 'after': b} for a, b in test_changes],
          'git_mutations': 0}
with (H / 'checker-v2-derivation.json').open('xb') as f: f.write((json.dumps(record, indent=2) + '\n').encode())
