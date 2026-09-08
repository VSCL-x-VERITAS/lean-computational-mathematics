"""Prepare narrowly scoped recovery of an ignored generated Python cache selection."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,v):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(v)
parent=S/'stage-root-batch9.py';src=parent.read_text(encoding='utf-8')
changes=[
 ("assert not git('diff','--cached','--name-only').strip()",
  "previous=read(S/'root-batch9-checkpoint-selection.json')\ncache='gates/leveque-finite-volume/artifacts/session-20260908/batch9-capstone-independent-review/__pycache__/verify.cpython-312.pyc'\nassert cache in previous['files']\nstaged=set(git('diff','--cached','--name-only').decode().splitlines())\nassert staged<=set(previous['files']) and cache not in staged\nassert read(S/'batch9-staging-cache-diagnostic-exit.json')['exit_code']==1"),
 ("'--label','root-batch9-checkpoint'","'--label','root-batch9-checkpoint-retry'"),
 ("files={'docs/architecture/tiers.json'}", "files=set(previous['files'])-{cache}\nfiles.add('docs/architecture/tiers.json')\nargs+=['--verified-check','batch9-trackers-after-staging-recovery']"),
 ("if p.is_file():files.add(p.relative_to(R).as_posix())", "if p.is_file() and p.relative_to(R).as_posix()!=cache:files.add(p.relative_to(R).as_posix())")
]
for old,new in changes:assert old in src,old;src=src.replace(old,new)
target=S/'stage-root-batch9-retry.py';write(target,src)
out=S/'batch9-staging-recovery-derivation.json'
write(out,json.dumps({'schema':1,'parent_sha256':sha(parent),'child_sha256':sha(target),
 'original_selection_sha256':sha(S/'root-batch9-checkpoint-selection.json'),
 'original_pathspec_sha256':sha(S/'root-batch9-checkpoint-pathspec.bin'),'changes':changes,
 'excluded':'Only the identified ignored generated __pycache__/verify.cpython-312.pyc; retained on disk. All prior selected evidence remains selected and will be reverified as actual Git blob bytes.',
 'original_observed_session':87020,'original_observed_exit':1,
 'reproduction_receipt_sha256':sha(S/'batch9-staging-cache-diagnostic-exit.json')},indent=2)+'\n')
spec={'label':'root-batch9-staging-recovery','audits':[],'process_entries':[
 '| LEV-SKILL-STAGING-GENERATED-CACHE-042 | codex-start-1-v5-0-1-20260908 | exact artifact staging | The first recursive selection included one ignored generated Python bytecode cache, so Git staging actually exited 1 after partially staging the valid selection | Preserve the original selection/pathspec and separately captured same-command diagnostic; exclude only that cache, retain it on disk, and reverify every selected Git blob | recovery prepared; exact retry required | original session 87020 exit 1; diagnostic raw 70aae0244d9be619fb23a12bc2bc7f5456a6b078c460130b50d4a9fa8a54fd5d | No forced cache addition, source edit, deletion or blanket unstage is used. The retry checks that preexisting staged paths are a subset of the originally authorized selection. |'
 ]}
write(S/'root-batch9-staging-recovery-spec.json',json.dumps(spec,indent=2)+'\n')
print(json.dumps({'status':'PREPARED','derivation_sha256':sha(out),'retry_sha256':sha(target)}))
