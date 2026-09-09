from pathlib import Path
import hashlib,json,subprocess,time
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
python='C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe'
launcher=r.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
script=h/'analyze_and_guard_v2.py'
def ref(p):
 b=p.read_bytes();return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
out=h/'guard-v2-output.txt';receipt=h/'guard-v2-receipt.json'
if out.exists() or receipt.exists():raise SystemExit('Refusing overwrite')
posix='/c/'+script.as_posix()[3:]
cmd=[python,'-X','utf8','-B',str(launcher),posix]
start=time.time();p=subprocess.run(cmd,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);out.write_bytes(p.stdout)
receipt.write_text(json.dumps({'command':cmd,'actual_exit_code':p.returncode,'elapsed_ms':round((time.time()-start)*1000),
 'script':ref(script),'launcher':ref(launcher),'output':ref(out)},indent=2)+'\n',encoding='utf-8')
print(p.stdout.decode('utf-8',errors='replace'));print(json.dumps(ref(receipt)))
raise SystemExit(p.returncode)
