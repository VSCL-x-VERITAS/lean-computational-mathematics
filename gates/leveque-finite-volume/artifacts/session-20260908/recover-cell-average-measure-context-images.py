"""Continue successful sealed preparation using unchanged frozen source PNG bytes."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,sys
def xp(p):
    p=str(p); prefix=chr(92)*2+'?'+chr(92)
    return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
R=xp(Path(__file__).resolve().parents[4]);S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
OLD='LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908'
TASK='LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908'
CONFIG='audit-cell-average-measure-context.config.json'
T=S/'audits'/TASK;out=T/'faithfulness';tr=out/'orchestration';helpers=T/'role-helpers'
sha=lambda p:hashlib.sha256(xp(p).read_bytes()).hexdigest()
def writej(p,data):
    p=xp(p);assert not p.exists(),p
    p.write_text(json.dumps(data,indent=2,ensure_ascii=True)+'\n',encoding='utf-8',newline='')
for label in ['route','prepare','prepared-validation']:
    receipt=json.loads((T/(label+'-exit.json')).read_bytes())
    assert receipt['exit_code']==0
    assert sha(T/(label+'-output.txt'))==receipt['stdout_sha256']
    assert sha(T/(label+'-stderr.txt'))==receipt['stderr_sha256']
assert not any((out/'agent_outputs').iterdir())
assert not (tr/'b_input.txt').exists()
task=json.loads((T/'audit-task.json').read_bytes())
expected={p.name:sha(p) for p in helpers.glob('*.py')}
for name,h in expected.items():assert sha(tr/name)==h
old_hashes={'manifest.json':'ec4853918b6f85788e5dd7881b1509821783e9d6ecb2418b12d211a821ba408f','decision.json':'d1c97d14be0ffaaf83897b80df8759ebeb4f7167c597a84cddd2a95efb54d843','report.md':'f622d4cf078d59e7ab9f8d0b43a028745ead9019d9f17393e915629d39b50ee3'}
writej(T/'coordinator-image-recovery.json',{'recorded_at_utc':datetime.now(timezone.utc).isoformat(),'failed_coordinator':'prepare-cell-average-measure-context.py','coordinator_exit_code':1,'failed_stage':'After released prepare=0 and prepared-validation=0, expected frozen page-026 PNG hash did not match current shared render.','original_script_sha256':sha(S/'prepare-cell-average-measure-context.py'),'shared_current_hashes':{page:sha(R.parent/'workflow-v5.0.1-local/chapter01-source-review'/('page-'+page+'.png')) for page in ['023','026','027']},'recovery':'Use exact hash-verified PNG copies already preserved in the old CELL audit. No source judgment is copied. Retain the original expected render hashes. Continue only helper/preflight receipt assembly; do not rerun prepare or launch roles.','sealed_preparation_repeated':False,'semantic_role_invoked':False})
code=(S/'prepare-cell-average-measure-context.py').read_text(encoding='utf-8')
suffix=code[code.index('image_hashes='):]
suffix=suffix.replace("R.parent/'workflow-v5.0.1-local/chapter01-source-review'", "S/'audits'/OLD/'faithfulness/orchestration'")
assert 'subprocess.run' not in suffix
exec(compile(suffix,'recovered_source_images_and_blind_preflight','exec'),globals())
