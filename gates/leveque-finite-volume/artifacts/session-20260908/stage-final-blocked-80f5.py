"""Stage only the final reviewed Chapter 1 artifacts and ledger/gate increment."""
from pathlib import Path
import hashlib,json,os,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
read=lambda p:json.loads(p.read_bytes());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
assert os.name!='nt'
assert git('rev-parse','HEAD').decode().strip()=='80f5d4340d507dbc347a806717ff31c5a9aace72'
assert not git('diff','--cached','--name-only').strip(),'unexpected staged input'
G=R/'gates/leveque-finite-volume/chapter-01.json';expected='e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
assert sha(G)==expected
terminal=read(S/'blocked-gate-binding-transcript-order-v2/runs/final-80f5/root-final-80f5-terminal.json')
assert terminal['exit_code']==0 and terminal['derived_verdict']=='BLOCKED' and terminal['actionable_rows']==0 and terminal['gate_sha256']==expected
helper=S/'stage-reviewed-audit-batch-v2.py'
assert sha(helper)=='38e62a21253e5fc594e1b83c25feacfadd5720cc69c23c6649cee7df17f376a5'
cache=read(S/'generated-capstone-cache-preservation/preservation.json')
excluded={x['original_path'] for x in cache['files']}
excluded.add((S/'blocked-gate-installation.lock').relative_to(R).as_posix())
folders=['final-material-choice-review-80f5','blocked-route-input-preparation-batch10/runs/final-80f5','blocked-gate-binding-transcript-order-v2/runs/final-80f5','blocked-gate-installation/final-80f5','final-material-choice-independent-review-80f5','final-blocked-proposal-independent-review-80f5','chapter01-final-report-preparation-80f5']
files=set()
for folder in folders:
 root=S/folder;assert root.is_dir() and not root.is_symlink()
 for directory,dirs,names in os.walk(root):
  assert '__pycache__' not in dirs
  for name in names:
   p=Path(directory)/name;assert p.is_file() and not p.is_symlink()
   files.add(p.relative_to(R).as_posix())
for raw in git('ls-files','--modified','--others','--exclude-standard','-z').split(b'\0'):
 if raw:
  p=R/raw.decode()
  if p.parent==S and p.relative_to(R).as_posix() not in excluded:
   assert p.is_file() and not p.is_symlink()
   files.add(p.relative_to(R).as_posix())
for name in ['chapter01-final-report.md','chapter01-final-report.json']:
 assert (S/name).is_file() and (S/name).relative_to(R).as_posix() in files
assert not files&excluded
assert not any(p.endswith(('.olean','.ilean','.pyc')) for p in files)
args=[sys.executable,str(helper),'--label','root-final-blocked-80f5','--task','LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908=df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e']
for label in ['final-material-choice-install-80f5','final-material-choice-installed-check-80f5','final-material-choice-trackers-80f5','chapter01-final-declarations-80f5-retry','chapter01-final-focused-build-80f5','chapter01-final-full-build-80f5']:
 args+=['--verified-check',label]
for path in sorted(files):args+=['--file',path]
subprocess.run(args,cwd=R,check=True)
assert not git('diff','--cached','--no-renames','--name-only','--diff-filter=D').strip()
for item in cache['files']:
 assert not git('ls-files','--',item['original_path']).strip()
 assert git('show','HEAD:'+item['snapshot_path'])==(R/item['original_path']).read_bytes()
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics','NumStability','lakefile.lean','lake-manifest.json','lean-toolchain','architecture').strip()
assert sha(G)==expected
print(json.dumps({'status':'FINAL_BLOCKED_STAGE_VERIFIED','explicit_extra_files':len(files),'gate_sha256':expected,'source_diff_from_80f5':False}))
