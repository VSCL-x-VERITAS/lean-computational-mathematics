"""Apply the authorized selected-cell q/f specialization, preserving prior bytes."""
from pathlib import Path
import hashlib, json
F=Path(__file__).resolve().parent
R=F.parents[5]
p=R/'ComputationalMathematics/Source/LeVeque/Chapter01/FiniteVolumeLocalFluxUpdate.lean'
raw=p.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='08cbd70cdd1833e82c6fb5f038252315c7c05472eeacfb6c0d2f07c2dafd86f4'
with (F/'FiniteVolumeLocalFluxUpdate-generic-superseded.lean.fragment').open('xb') as f:f.write(raw)
s=raw.decode()
s=s.replace('Physical face\nhistories are supplied with that balance; the theorem imposes no global solution\nextension or mandatory pointwise representative of a discontinuous state.', 'The two density slices and two physical face histories are explicitly those\nof the supplied state and flux law. Their integrability and conservation balance\nare required only on this cell and slab; no global solution extension is required.')
s=s.replace('(oldDensity newDensity : ℝ → (Fin m → ℝ)) (physicalFlux : Face → ℝ → (Fin m → ℝ))', '(q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))')
s=s.replace('oldDensity', '(fun x => q x s)').replace('newDensity', '(fun x => q x t)')
s=s.replace('(physicalFlux leftFace)', '(fun τ => flux (q a τ))').replace('(physicalFlux rightFace)', '(fun τ => flux (q b τ))')
s=s.replace('physicalFlux leftFace τ', 'flux (q a τ)').replace('physicalFlux rightFace τ', 'flux (q b τ)')
s=s[:s.index(' := by')]+''' := by
  exact ⟨hm, finiteVolumeLocalCell_error_contract (fun x => q x s) (fun x => q x t)
    (fun side τ => if side then flux (q b τ) else flux (q a τ)) numericalOld
    (fun values side => if side then rule values rightFace else rule values leftFace)
    cell false true hab hst holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance⟩

end NumStability
'''
# Identifier replacements are intentionally repaired separately from mathematical terms.
s=s.replace('h(fun x => q x s)', 'holdDensity').replace('h(fun x => q x t)', 'hnewDensity')
p.write_text(s,encoding='utf-8',newline='\n')
manifest=json.loads((F/'production-inputs.json').read_bytes())
manifest['files'][1]['sha256']=hashlib.sha256(p.read_bytes()).hexdigest()
manifest['normalization']='Generic public producer preserved. Selected source wrapper explicitly uses q at the two spatial slices and f(q) on the two faces of one slab.'
manifest['superseded_wrapper_snapshot']={'path':(F/'FiniteVolumeLocalFluxUpdate-generic-superseded.lean.fragment').relative_to(R).as_posix(),'sha256':hashlib.sha256(raw).hexdigest()}
with (F/'production-inputs-local-law.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(manifest,f,indent=2);f.write('\n')
runner=(F/'run-production-check.py').read_text().replace("'production-inputs.json'","'production-inputs-local-law.json'").replace("'production-' + mode", "'production-local-law-' + mode")
with (F/'run-production-local-law-check.py').open('x',encoding='utf-8',newline='\n') as f:f.write(runner)
print(json.dumps(manifest,indent=2))
