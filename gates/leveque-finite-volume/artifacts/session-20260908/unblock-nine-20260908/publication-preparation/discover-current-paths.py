"""Read-only POSIX Git path inventory; no content, stage, ref, or index writes."""
from pathlib import Path
import hashlib
import json
import os
import subprocess
from datetime import datetime, timezone

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
assert os.name != 'nt', 'Use unchanged run_workflow_posix.py'
OUT = HERE / 'discovery-01'
OUT.mkdir()
cmd = ['git', '--no-optional-locks', '-c', 'core.longpaths=true', '-c', 'diff.autoRefreshIndex=false']
commands = []

def run(args, name):
    argv = cmd + args
    p = subprocess.run(argv, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (OUT / (name + '.stdout.bin')).write_bytes(p.stdout)
    (OUT / (name + '.stderr.txt')).write_bytes(p.stderr)
    commands.append({'command': argv, 'exit_code': p.returncode,
                     'stdout_sha256': hashlib.sha256(p.stdout).hexdigest(),
                     'stderr_sha256': hashlib.sha256(p.stderr).hexdigest()})
    assert p.returncode == 0
    return p.stdout

head = run(['rev-parse', 'HEAD'], 'head').decode().strip()
index = Path(run(['rev-parse', '--git-path', 'index'], 'index-path').decode().strip())
if not index.is_absolute(): index = ROOT / index
before = hashlib.sha256(index.read_bytes()).hexdigest()
data = run(['status', '--porcelain=v1', '-z', '--untracked-files=all'], 'status')
after = hashlib.sha256(index.read_bytes()).hexdigest()
parts = data.split(b'\0'); records = []; i = 0
while i < len(parts) and parts[i]:
    item = parts[i]; i += 1
    status = item[:2].decode('ascii'); path = item[3:].decode('utf-8')
    record = {'status': status, 'path': path}
    if 'R' in status or 'C' in status:
        record['original_path'] = parts[i].decode('utf-8'); i += 1
    records.append(record)
result = {'schema': 1, 'label': 'LIVE_READONLY_PATH_SNAPSHOT_NOT_PUBLICATION_COMPLETENESS',
          'created_at_utc': datetime.now(timezone.utc).isoformat(), 'head': head,
          'index_sha256_before': before, 'index_sha256_after': after,
          'records': records, 'commands': commands,
          'gate_modified': False, 'git_mutations_invoked': 0}
(OUT / 'paths.json').write_text(json.dumps(result, indent=2) + '\n')
prefix = 'gates/leveque-finite-volume/artifacts/session-20260908/'
outside = [x for x in records if not x['path'].startswith(prefix + 'unblock-nine-20260908/')]
audit_dirs = sorted({x['path'].split('/')[6] for x in outside if x['path'].startswith(prefix + 'audits/')})
non_audit = [x for x in outside if not x['path'].startswith(prefix + 'audits/')]
print(json.dumps({'head': head, 'count': len(records), 'non_audit': non_audit,
                  'audit_dirs': audit_dirs, 'index_unchanged': before == after}, indent=2))
