"""Capture one native Lake check without replacing raw output bytes."""
from pathlib import Path
import argparse,hashlib,json,os,shutil,subprocess,sys,time
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('label');p.add_argument('arguments',nargs=argparse.REMAINDER)
a=p.parse_args();assert os.name=='nt' and a.arguments
assert a.label.replace('-','').isalnum()
S=Path(__file__).resolve().parent;R=S.parents[3]
out=S/(a.label+'-output.txt');receipt=S/(a.label+'-exit.json')
assert not out.exists() and not receipt.exists()
lake=shutil.which('lake');assert lake
head=subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()
start=time.monotonic()
with out.open('wb') as f:
 result=subprocess.run([lake,*a.arguments],cwd=R,stdout=f,stderr=subprocess.STDOUT)
record={'command':'lake '+' '.join(a.arguments),'argv':['lake',*a.arguments],
 'exit_code':result.returncode,'input_commit':head,'elapsed_ms':int((time.monotonic()-start)*1000),
 'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'native_lake':lake}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record))
if result.returncode:sys.stdout.buffer.write(out.read_bytes())
raise SystemExit(result.returncode)
