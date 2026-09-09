from pathlib import Path
import subprocess,json,hashlib,datetime
h=Path(__file__).resolve().parent;r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
def ref(p):
 b=p.read_bytes();return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest()}
queries=[['rg','-n','cellBox|cellVolume|faceArea|facePoint','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CartesianGridGeometry.lean'],
 ['rg','-n','theorem|def data','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FiniteCartesianGeometry.lean','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FiniteCartesianReference.lean'],
 ['rg','-n','h_pos|h_eq|h_mul|h_le_half|h_tendsto|input_geometry|active_coverage|family_advance','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/HighResolutionAdvectionLine.lean'],
 ['rg','-n','ediam_pi_le_of_le|diam_Ico|diam_pos|diam_le_of_forall_dist_le|dist_le_diam_of_mem','\.lake/packages/mathlib/Mathlib/Topology/EMetricSpace/Diam.lean','\.lake/packages/mathlib/Mathlib/Topology/Instances/ENNReal/Lemmas.lean','\.lake/packages/mathlib/Mathlib/Topology/MetricSpace/Bounded.lean']]
queries[-1]=[s.lstrip('\\') for s in queries[-1]]
records=[]
for i,cmd in enumerate(queries):
 p=h/f'search-{i}.txt';assert not p.exists()
 start=datetime.datetime.now(datetime.timezone.utc).isoformat();out=subprocess.run(cmd,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 p.write_bytes(out.stdout)
 records.append({'command':cmd,'cwd':str(r),'started_at_utc':start,'actual_exit_code':out.returncode,'output':ref(p),'owners':[ref(r/a) for a in cmd[3:]]})
(h/'search-receipt.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
