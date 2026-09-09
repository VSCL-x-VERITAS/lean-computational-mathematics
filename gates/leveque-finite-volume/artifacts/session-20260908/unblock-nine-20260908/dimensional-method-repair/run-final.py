"""Exact native declaration/axiom capture, with immutable inputs and output."""
from pathlib import Path
import hashlib, json, re, shutil, subprocess, time
P=Path(__file__).resolve().parent
R=next(x for x in P.parents if (x/'lean-toolchain').exists())
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
ref=lambda f:dict(path=f.relative_to(R).as_posix(),sha256=sha(f))
source=P/'Candidate.lean';checks=P/'Checks.lean.fragment'
candidate=source.read_bytes();checks_bytes=checks.read_bytes()
snapshot=P/'final-input.lean';output=P/'final-output.txt';receipt=P/'final-native-receipt.json'
assert not any(x.exists() for x in (snapshot,output,receipt))
snapshot.write_bytes(candidate+b'\n'+checks_bytes)
imports=[line.split()[1] for line in candidate.decode('utf-8-sig').splitlines() if line.startswith('import ')]
pins=[ref(R/'lean-toolchain'),ref(R/'lake-manifest.json'),ref(R/'lakefile.toml')]
for mod in imports:
 for f in [R/(mod.replace('.','/')+'.lean'),R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')]:
  assert f.exists(),f
  pins.append(ref(f))
lake=shutil.which('lake');assert lake
argv=[lake,'env','lean',snapshot.relative_to(R).as_posix()]
start=time.monotonic()
with output.open('xb') as f:run=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
record=dict(command=argv,actual_exit_code=run.returncode,elapsed_ms=int((time.monotonic()-start)*1000),
 candidate=ref(source),checks=ref(checks),exact_native_input=ref(snapshot),output=ref(output),dependencies_pre=pins,
 inputs_preserved=source.read_bytes()==candidate and checks.read_bytes()==checks_bytes,
 dependencies_post_equal=all(sha(R/x['path'])==x['sha256'] for x in pins),runner=ref(Path(__file__)),
 no_model_or_audit_role=True,no_git_or_production_mutation=True)
names=[line.split(' ',1)[1] for line in checks_bytes.decode('utf-8').splitlines() if line.startswith('#check ')]
out=output.read_text(encoding='utf-8-sig')
reports=[]
for name in names:
 match=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',out)
 types=re.findall(r'(?m)^'+re.escape(name)+r'(?=\s|\.\{)',out)
 axioms=sorted({v.strip() for v in match[0].split(',') if v.strip()}) if len(match)==1 else None
 reports.append(dict(name=name,type_reports=len(types),axiom_reports=len(match),axioms=axioms,
                     allowed=axioms is not None and set(axioms)<={'propext','Classical.choice','Quot.sound'}))
record['declaration_reports']=reports
record['checks_passed']=run.returncode==0 and record['inputs_preserved'] and record['dependencies_post_equal'] and all(
 x['type_reports']==1 and x['axiom_reports']==1 and x['allowed'] for x in reports) and not re.search(r'\berror:|uses \'sorry\'|warning:',out)
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'receipt':ref(receipt),'checks_passed':record['checks_passed'],'declarations':len(reports),
                  'actual_exit_code':run.returncode,'output':ref(output)},indent=2))
if not record['checks_passed']:print(out)
raise SystemExit(0 if record['checks_passed'] else 1)
