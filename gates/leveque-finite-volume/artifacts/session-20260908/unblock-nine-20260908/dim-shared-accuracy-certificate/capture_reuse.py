from pathlib import Path
import datetime,hashlib,json,subprocess
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
base='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
queries=[['rg','-n','Certificate|perturbed_accuracy|extract_error_le|advance_eq',base+'RefiningLineMethod.lean',base+'CoordinateLineMethodEstimates.lean',base+'CoordinateLineMethod.lean'],
 ['rg','-n','family_quality|smooth_local_reference|smoothProfile_nonconstant',base+'Examples/HighResolutionAdvectionLine.lean',base+'Examples/CFLUnitShift.lean'],
 ['rg','-n','getUsedConstants','C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/src/lean/Lean/Util/FoldConsts.lean']]
records=[]
for i,argv in enumerate(queries,1):
 p=h/f'reuse-{i:02}.txt'
 assert not p.exists()
 started=datetime.datetime.now(datetime.timezone.utc).isoformat()
 proc=subprocess.run(argv,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);p.write_bytes(proc.stdout)
 records.append({'command':argv,'cwd':str(r),'started_at_utc':started,'actual_exit_code':proc.returncode,
 'output':{'path':str(p),'sha256':hashlib.sha256(proc.stdout).hexdigest(),'bytes':len(proc.stdout)}})
(h/'reuse.json').write_text(json.dumps({'searches':records,'review':'REVIEW.md'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'exits':[x['actual_exit_code'] for x in records]},indent=2))
