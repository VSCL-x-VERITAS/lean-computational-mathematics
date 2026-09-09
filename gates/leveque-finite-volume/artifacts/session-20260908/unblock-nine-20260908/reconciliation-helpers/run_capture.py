"""Immutable actual command capture; outputs confined to this helper directory."""
import argparse,hashlib,json,subprocess,time
from pathlib import Path
P=Path(__file__).resolve().parent;R=P.parents[5];W=R.parent
PY='C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe'
WRAP=W/'workflow-v5.0.1-local/run_workflow_posix.py'
p=argparse.ArgumentParser();p.add_argument('label');p.add_argument('script');p.add_argument('arguments',nargs=argparse.REMAINDER);a=p.parse_args()
assert a.label.replace('-','').isalnum()
script=(P/a.script).resolve();assert script.parent==P and script.is_file()
output=P/(a.label+'-output.txt');receipt=P/(a.label+'-receipt.json')
assert not output.exists() and not receipt.exists()
cmd=[PY,'-B',str(WRAP),str(script),*a.arguments]
start=time.monotonic();cp=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,check=False)
output.write_bytes(cp.stdout)
record={'command':cmd,'exit_code':cp.returncode,'elapsed_ms':round((time.monotonic()-start)*1000),
        'output_sha256':hashlib.sha256(cp.stdout).hexdigest(),'script_sha256':hashlib.sha256(script.read_bytes()).hexdigest(),
        'scope':'Owned helper directory only; no candidate/epoch/admission execution'}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record));raise SystemExit(cp.returncode)
