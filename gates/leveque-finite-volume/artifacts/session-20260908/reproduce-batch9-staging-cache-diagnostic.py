"""Capture the same ignored-cache Git staging diagnostic without changing any source."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
spec=S/'root-batch9-checkpoint-pathspec.bin'
selection=json.loads((S/'root-batch9-checkpoint-selection.json').read_bytes())
ignored=[p for p in selection['files'] if '__pycache__' in Path(p).parts]
assert ignored and all(p.startswith('gates/leveque-finite-volume/artifacts/session-20260908/batch9-capstone-independent-review/__pycache__/') and p.endswith('.pyc') for p in ignored)
cmd=['git','-c','core.longpaths=true','add','--pathspec-from-file='+str(spec),'--pathspec-file-nul']
print(json.dumps({'scope':'Reproduction of the observed actual staging exit 1; source/evidence unchanged',
 'original_exec_session':87020,'original_observed_exit_code':1,'pathspec_sha256':hashlib.sha256(spec.read_bytes()).hexdigest(),
 'ignored_cache_paths':ignored,'command':cmd}),flush=True)
result=subprocess.run(cmd,cwd=R)
raise SystemExit(result.returncode)
