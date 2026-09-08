from pathlib import Path
import hashlib,json,subprocess,sys,time
P=Path(__file__).resolve().parent
label=sys.argv[1];assert label.isalnum()
source=P/'freeze.py';snapshot=P/(label+'-helper.py');out=P/(label+'-output.txt');receipt=P/(label+'-exit.json')
assert not any(p.exists() for p in [snapshot,out,receipt])
snapshot.write_bytes(source.read_bytes())
cmd=[sys.executable,'-B',str(source)];tick=time.monotonic()
run=subprocess.run(cmd,cwd=P.parents[4],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
out.write_bytes(run.stdout)
record={'command':cmd,'exit_code':run.returncode,'elapsed_ms':int((time.monotonic()-tick)*1000),
 'helper_sha256':hashlib.sha256(snapshot.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(run.stdout).hexdigest()}
receipt.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record));sys.stdout.flush();sys.stdout.buffer.write(run.stdout)
sys.exit(run.returncode)
