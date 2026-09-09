from pathlib import Path
import datetime,hashlib,json,subprocess
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
queries=[
 ['rg','-n','--glob','*.lean','riemannData|IsRiemannData','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean'],
 ['rg','-n','--glob','*.lean','grid_volume|advance_eq_shift|family_advance|line_local|theorem family_quality','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples'],
 ['rg','-n','--glob','*.lean','admitted|mesh_is_max|available|SameStepStability','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'],
 ['rg','-n','--glob','*.lean','ite_mem|piecewise_mem|mem_ite|ite_apply','\.lake/packages/mathlib/Mathlib/Logic','\.lake/packages/mathlib/Mathlib/Data/Set']
]
queries[-1]=[s.replace('\\.lake','.lake') for s in queries[-1]]
records=[]
for i,argv in enumerate(queries,1):
 p=h/f'reuse-search-{i:02}.txt'
 if p.exists():raise SystemExit('Refusing overwrite')
 began=datetime.datetime.now(datetime.timezone.utc).isoformat()
 result=subprocess.run(argv,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 p.write_bytes(result.stdout)
 records.append({'argv':argv,'cwd':str(r),'started_at_utc':began,'exit_code':result.returncode,
  'output':{'path':str(p.relative_to(r)), 'sha256':hashlib.sha256(result.stdout).hexdigest(),'bytes':len(result.stdout)}})
(h/'reuse-searches.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
print(json.dumps([{'exit':x['exit_code'],'output':x['output']} for x in records],indent=2))
