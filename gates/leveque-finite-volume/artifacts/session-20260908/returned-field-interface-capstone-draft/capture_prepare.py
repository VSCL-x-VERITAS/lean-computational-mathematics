from pathlib import Path
import hashlib,json,subprocess,sys
P=Path(__file__).resolve().parent;R=P.parents[4];label=sys.argv[1]
source=P/(label+'-prepare.py');out=P/(label+'-output.txt');record=P/(label+'-exit.json')
assert not any(p.exists() for p in [source,out,record])
source.write_bytes((P/'prepare.py').read_bytes())
cmd=[sys.executable,'-B',str(P/'prepare.py')]
with out.open('xb') as f:r=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
record.write_bytes((json.dumps(dict(command=cmd,exit_code=r.returncode,input_sha256=sha(source),output_sha256=sha(out)),indent=2)+'\n').encode())
print(out.read_text(encoding='utf-8'));print(json.dumps(dict(exit_code=r.returncode,receipt=str(record))))
sys.exit(r.returncode)
