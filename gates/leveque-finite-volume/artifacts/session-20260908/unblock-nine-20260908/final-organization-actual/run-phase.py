"""Capture actual assembly/read-only helper runs, retaining every failed output."""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import sys
import time

P=Path(__file__).resolve().parent
R=P.parents[5]
H=P.parent/'final-organization-successor-preparation'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
p=argparse.ArgumentParser()
p.add_argument('phase',choices=('prepare','capture','draft'))
a=p.parse_args()
O=P/('run-'+a.phase+'-01');O.mkdir()
config=P/'config.json'
repo_posix='/c/'+R.as_posix()[3:] if R.as_posix().startswith('C:/') else R.as_posix()
if a.phase=='prepare':
    ready=P/'ready-inputs.json'
    command=[sys.executable,'-B',str(P/'prepare-config.py'),'--ready-inputs',str(ready),'--ready-sha256',sha(ready)]
else:
    script=H/('capture_current_v2.py' if a.phase=='capture' else 'prepare_draft_v2.py')
    command=[sys.executable,'-B',str(R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'),str(script),
        '--repo',repo_posix,'--config',config.relative_to(R).as_posix(),'--config-sha256',sha(config),
        '--out',(P/a.phase).relative_to(R).as_posix()]
    if a.phase=='draft':
        cap=P/'capture/capture-manifest.json'
        command.extend(['--capture-manifest',cap.relative_to(R).as_posix(),'--capture-sha256',sha(cap)])
start=time.monotonic_ns()
result=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
elapsed=(time.monotonic_ns()-start)//1000000
(O/'output.txt').write_bytes(result.stdout)
receipt={'schema':1,'phase':a.phase,'command':command,'exit_code':result.returncode,
    'elapsed_ms':elapsed,'output_sha256':hashlib.sha256(result.stdout).hexdigest(),
    'runner':pin(Path(__file__).resolve()),'operational_measurement_run':False,'gate_modified':False}
with (O/'receipt.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'receipt':pin(O/'receipt.json'),'actual_exit_code':result.returncode,'elapsed_ms':elapsed}))
raise SystemExit(result.returncode)
