from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;S=P.parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=S/'returned-field-coordinate-sweep-draft/Core.lean.fragment'
assert sha(source)=='9eb686053e36bcb0d206098abcff29a938da9a0b93fa434de2d10d2ae1b3c2aa'
t=source.read_text(encoding='utf-8').replace('ReturnedFieldCoordinateSweepDraft','InformationCoordinateSweepDraft').replace('RiemannFieldFluxMethod','RiemannInformationFluxMethod')
start=t.index('/-- The admitted observation retains');end=t.index('\ntheorem normalFaceFlux_fallback_independent',start)
t=t[:start]+'''/-- The actual ordered local problem and extraction from its selected result.
No space-time field or trace property is part of this observation. -/
theorem admitted_face_observation (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    let problem := adjacentCellRiemannProblem (laws d)
      (fun j => state (Function.update cell d j)) (cell d)
    let result := (methods d dt).solve problem h
    problem.leftState = state (Function.update cell d (cell d - 1)) ∧
      problem.rightState = state cell ∧
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
        area d cell • (methods d dt).numericalFlux ((methods d dt).extract result) := by
  refine ⟨rfl, ?_, normalFaceFlux_of_admitted methods area fallback d dt state cell h⟩
  simp [adjacentCellRiemannProblem]
''' +t[end:]
dest=P/'Core.lean.fragment';assert not dest.exists();dest.write_bytes(t.encode())
record=dict(schema=1,source=dict(path=source.relative_to(R).as_posix(),sha256=sha(source)),output=dict(path=dest.relative_to(R).as_posix(),sha256=sha(dest)),changes=['Distinct scratch namespace and canonical information-only method type.','Admitted observation retains exact ordered problem and selected extraction; no field/initial-trace/integrability conjuncts.','Other statements and proof composition initially derived mechanically; native verification is separate.'])
p=P/'derivation.json';assert not p.exists();p.write_bytes((json.dumps(record,indent=2)+'\n').encode());print(sha(dest))
