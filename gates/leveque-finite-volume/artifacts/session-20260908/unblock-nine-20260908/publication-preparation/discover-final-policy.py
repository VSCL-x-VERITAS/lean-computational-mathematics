"""Read-only POSIX path discovery for a final-policy draft, not publication."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
import subprocess

P = Path(__file__).resolve().parent
R = P.parents[5]
assert os.name != 'nt', 'Use unchanged run_workflow_posix.py'
O = P/'discovery-final-policy-01'
O.mkdir()
spec = importlib.util.spec_from_file_location('allowlist_v3',P/'check-publication-allowlist-v3.py')
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
assert m.digest(P/'check-publication-allowlist-v3.py') == '8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
commands = []

def git(args,name):
    argv = m.GIT + args
    result = subprocess.run(argv,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    (O/(name+'.stdout.bin')).write_bytes(result.stdout)
    (O/(name+'.stderr.txt')).write_bytes(result.stderr)
    commands.append({'command':argv,'exit_code':result.returncode,
        'stdout_sha256':hashlib.sha256(result.stdout).hexdigest(),
        'stderr_sha256':hashlib.sha256(result.stderr).hexdigest()})
    assert result.returncode == 0
    return result.stdout

head = git(['rev-parse','HEAD'],'head').decode().strip()
index = Path(git(['rev-parse','--git-path','index'],'index-path').decode().strip())
if not index.is_absolute(): index = R/index
before = m.digest(index)
records = m.parse_status(git(['status','--porcelain=v1','-z','--untracked-files=all'],'status'))
staged = [x.decode() for x in git(['diff','--cached','--name-only','-z'],'staged').split(b'\0') if x]
for item in records:
    p = R/item['path']
    item['regular_file_observed'] = p.is_file() and not p.is_symlink()
    if item['regular_file_observed']: item['bytes_observed'] = p.stat().st_size
after = m.digest(index)
head_after = git(['rev-parse','HEAD'],'head-after').decode().strip()
assert head == head_after and before == after, 'HEAD/index changed; preserve this failed capture and use a fresh successor'
data = {'schema':1,'status':'LIVE_READONLY_PATH_DISCOVERY_NOT_PUBLICATION',
    'created_at_utc':datetime.now(timezone.utc).isoformat(),'head':head,
    'head_after':head_after,'index_sha256_before':before,'index_sha256_after':after,
    'records':records,'staged_paths':staged,'commands':commands,
    'git_mutations_invoked':0,'publication_complete':False}
(O/'paths.json').write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8')
session = 'gates/leveque-finite-volume/artifacts/session-20260908/'
audit = session+'audits/'
print(json.dumps({'paths_sha256':m.digest(O/'paths.json'),'records':len(records),
    'staged_paths':len(staged),'staged_sources':[x for x in staged if x.endswith('.lean')],
    'changed_sources':[x['path'] for x in records if x['path'].startswith('ComputationalMathematics/') and x['path'].endswith('.lean')],
    'audit_ids':sorted({x['path'][len(audit):].split('/')[0] for x in records if x['path'].startswith(audit)}),
    'non_owned_candidates':[x['path'] for x in records if not x['path'].startswith(session) and not x['path'].startswith('ComputationalMathematics/')],
    'large_jsonl':[x for x in records if x['path'].endswith('.jsonl') and x.get('bytes_observed',0)>=90000000],
    'head_and_index_unchanged':True},indent=2))
