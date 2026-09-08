"""Record read-only project/Mathlib searches and the actual rejected input."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, subprocess
P=Path(__file__).resolve().parent
R=P.parents[4]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
queries=[
 ['rg','-n','cellVolumeAverage|CellMaterialAveragingRule|heterogeneousMaterialCellAverage','ComputationalMathematics','-g','*.lean'],
 ['rg','-n','theorem (setAverage_eq|average_congr|setAverage_congr_fun|setAverage_const)|theorem integral_pow|theorem volume_Ioc|theorem integral_of_le|theorem intervalIntegrable_iff_integrableOn_Ioc_of_le',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Average.lean',
  '.lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']]
records=[]
for i,q in enumerate(queries):
 out=P/f'search-{i+1:02d}.txt'
 assert not out.exists()
 r=subprocess.run(q,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 out.write_bytes(r.stdout)
 records.append(dict(command=q,exit_code=r.returncode,output=out.name,output_sha256=sha(out)))
 assert r.returncode==0
audit=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING-CANONICAL-20260908'
files=[audit/'audit-task.json',audit/'faithfulness/decision.json',audit/'faithfulness/report.md',
 audit/'faithfulness/orchestration/page-030.png',
 R/'ComputationalMathematics/Source/LeVeque/Chapter01/HeterogeneousCellAveraging.lean',
 R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean',
 *[R/x for x in queries[1][3:]],P/'research.py']
decision=json.loads((audit/'faithfulness/decision.json').read_bytes())
assert sha(audit/'faithfulness/decision.json')=='6ee86257e622a3577b5e722e2def8d439ff3844d859c25ae6aea3831c9ed808e'
record=dict(created_at_utc=datetime.now(timezone.utc).isoformat(),
 head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=R).decode().strip(),
 searches=records,inputs=[dict(path=p.relative_to(R).as_posix(),sha256=sha(p)) for p in files],
 prior_classification=decision['classification'],pending_question='call_1JnoPOtxdApI1F5hUmt5F9Q7',
 adopted_interpretation=False,
 decision='Use existing normalized cellVolumeAverage; derive laws from Mathlib setAverage; drop hdifferent entirely. Do not use the arbitrary CellMaterialAveragingRule as averaging semantics.')
out=P/'research.json';assert not out.exists()
out.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(dict(path=str(out),sha256=sha(out))))
