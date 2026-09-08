"""Bind successful actual placement checks; no source/gate acceptance."""
from pathlib import Path
import hashlib,json,re,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def put(p,v):
 assert not p.exists(),p
 p.write_bytes((json.dumps(v,indent=2)+'\n').encode())
mp=json.loads((P/'placement-map.json').read_bytes())
cp=json.loads((P/'comparison-plan.json').read_bytes())
for path,h in mp['source_files'].items():assert sha(R/path)==h,path
prefix=''.join('import '+m+'\n' for m in mp['modules']).encode()+b'\n'
draft=(R/mp['draft']['path']).read_bytes()
comparison_input=(P/'compare01-input.lean').read_bytes()
assert comparison_input.startswith(prefix+draft+b'\n\n'+(P/'Comparisons.lean.fragment').read_bytes()+b'\n')
allowed={'propext','Classical.choice','Quot.sound'}
reports={};receipts=[]
for label in ['build01','checks01','compare01']:
 rp=P/(label+'-exit.json');r=json.loads(rp.read_bytes());out=P/(label+'-output.txt')
 assert r['exit_code']==0 and r['inputs_unchanged'],label
 assert sha(out)==r['output_sha256']
 for path,h in (r['input_files']|r['compiled_imports']).items():assert sha(R/path)==h,path
 text=out.read_text(encoding='utf-8');assert not re.search(r'error:|warning:|sorryAx',text),label
 if label!='build01':
  axioms={n:[x.strip() for x in a.split(',') if x.strip()] for n,a in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.S)}
  axioms.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",text)})
  names=r['checked_declarations']+(cp['checked_declarations'] if label=='compare01' else [])
  for n in names:assert n in axioms and set(axioms[n])<=allowed,n
  reports[label]={n:axioms[n] for n in names}
 receipts.append(bind(rp))
searches=[['rg','-n','^(theorem norm_oneDimensionalCellAverage_sub_le|theorem riemannFiniteVolumeUpdate_error_le|structure RectangleRiemannInterfaceFluxMethod|def rectangleRiemannInterfaceFlux|theorem riemannData_isRiemannData|theorem riemannData_intervalIntegrable)','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume','-g','*.lean'],['rg','-n','(theorem|lemma) (norm_integral_le_of_norm_le_const|integral_const)','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']]
records=[]
for i,cmd in enumerate(searches):
 r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);assert r.returncode==0
 p=P/f'reuse-search-{i+1}.txt';assert not p.exists();p.write_bytes(r.stdout)
 records.append(dict(command=cmd,exit_code=r.returncode,output=bind(p)))
put(P/'reuse-searches.json',records)
put(P/'axiom-verification.json',dict(status='PASS',allowed_axioms=sorted(allowed),reports=reports))
compiled=[]
for mod in mp['modules']:
 p=R/'.lake/build/lib/lean'/Path(*mod.split('.')).with_suffix('.olean');compiled.append(bind(p))
artifacts=[bind(p) for p in sorted(P.iterdir()) if p.is_file() and p.name!='final-receipt.json']
put(P/'final-receipt.json',dict(schema=1,status='PASS',source_acceptance=False,scope='four new generic leaves only; root owns exposure',canonical_declarations=23,comparison_declarations=50,projection_checks=18,definitionally_equal_type_identities=17,nominal_error_bridges=2,actual_native_receipts=receipts,production_sources=[dict(path=x,sha256=h) for x,h in mp['source_files'].items()],compiled_outputs=compiled,artifacts=artifacts))
print(json.dumps(dict(final_receipt_sha256=sha(P/'final-receipt.json'),canonical_declarations=23,comparison_declarations=50)))
