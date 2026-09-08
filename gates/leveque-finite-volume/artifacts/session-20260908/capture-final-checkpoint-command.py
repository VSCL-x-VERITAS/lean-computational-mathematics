"""Capture actual post-checkpoint commands outside the self-referential Git evidence tree."""
from pathlib import Path
import hashlib,json,os,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
OUT=R.parent/'workflow-v5.0.1-local/chapter01-final-checks'
assert os.name!='nt'
label=sys.argv[1];assert label.replace('-','').isalnum()
OUT.mkdir(exist_ok=True)
log=OUT/(label+'-output.txt');receipt=OUT/(label+'-exit.json')
assert not log.exists() and not receipt.exists()
command=[sys.executable,*sys.argv[2:]]
run=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
with log.open('xb') as f:f.write(run.stdout)
record={'kind':'actual-post-checkpoint-command','command':command,'exit_code':run.returncode,'raw_output_sha256':hashlib.sha256(run.stdout).hexdigest(),'capture_script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'output_path':str(log)}
with receipt.open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(run.stdout.decode('utf-8',errors='replace'))
print(json.dumps(record))
raise SystemExit(run.returncode)
