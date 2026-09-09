from pathlib import Path
import argparse,hashlib,json,os,shutil,subprocess,time
p=argparse.ArgumentParser();p.add_argument('label');p.add_argument('args',nargs=argparse.REMAINDER);a=p.parse_args()
S=Path(__file__).resolve().parent;R=S.parents[5]
assert os.name=='nt' and a.label.replace('-','').isalnum() and a.args
out=S/(a.label+'-output.txt');receipt=S/(a.label+'-receipt.json')
assert not out.exists() and not receipt.exists()
files=[R/('ComputationalMathematics/Source/LeVeque/Chapter01/'+n+'.lean') for n in ['FiniteVolumeUpdateError','RiemannInformationInterfaceFlux','CoordinateSplittingBalance']]
if a.args[:2]==['env','lean']: files.append(R/a.args[2])
pins={f.relative_to(R).as_posix():hashlib.sha256(f.read_bytes()).hexdigest() for f in files}
argv=[shutil.which('lake'),*a.args];start=time.monotonic()
with out.open('wb') as f: result=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
record={'schema':1,'kind':'actual-native-lake-check','argv':argv,'cwd':str(R),'exit_code':result.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),'input_files':pins,'inputs_unchanged':all(hashlib.sha256((R/f).read_bytes()).hexdigest()==h for f,h in pins.items()),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest()}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n');print(json.dumps(record))
if result.returncode: print('See full raw output:',str(out))
raise SystemExit(result.returncode)
