"""Record bounded reuse searches and immutable input provenance."""
from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
queries=[
 ['rg','-n','advance_mass_balance|advance_line_local|sweep_two|finite_line_mass_balance',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineBalance.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineSweep.lean'],
 ['rg','-n','faceArea|cellBox_volume|faceFlux_physical_trace|face_problem_solves|advanceDirection_full_volume_balance|scheduled_step_is_line_update|concrete_nonvacuity',
  (S/'dimensional-splitting-lines-draft/TensorLines.lean.fragment').relative_to(R).as_posix()],
 ['rg','-n','theorem prod_subtype|volume_pi_Ico_toReal',
  '.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean']]
records=[]
for i,cmd in enumerate(queries):
 out=P/f'search-{i+1:02d}.txt';assert not out.exists()
 run=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);out.write_bytes(run.stdout)
 assert run.returncode==0
 records.append(dict(command=cmd,exit_code=run.returncode,output=out.name,output_sha256=sha(out)))
files=[S/'dimensional-splitting-lines-draft/final-evidence.json',
 S/'dimensional-splitting-lines-draft/TensorLines.lean.fragment',
 S/'dimensional-splitting-lines-draft/final-05-input.lean',
 S/'dimensional-splitting-lines-draft/REVIEW.md',
 S/'coordinate-line-production/manifest.json',S/'coordinate-line-production/final-receipt.json',
 S/'coordinate-line-production/REVIEW.md',S/'logical-line-balance-draft/final-receipt.json',
 S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf',
 S/'current-thread-clarification-provenance-batch8.json',P/'research.py']
out=P/'reuse-provenance.json';assert not out.exists()
out.write_bytes((json.dumps(dict(searches=records,
 inputs=[dict(path=p.relative_to(R).as_posix(),sha256=sha(p)) for p in files],
 source_interpretation_adopted=False,pending_question='call_axfTXsEjNKG3lawf5Dq10qQv',
 reuse='Existing measured tensor volume, selected exact-interface solver, positive-volume mass identities, locality and ordered sweep; new work only identifies their Cartesian specialization.',
 limits='Bounded searches are not global absence claims. No smooth logical chart, general approximate-solver semantics, or multidimensional accuracy theorem is inferred.'),indent=2)+'\n').encode())
print(sha(out))
