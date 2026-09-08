"""Freeze the checked prototype and extract canonical drafts without placement."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
D = S / 'equation03-transport'
p = D / 'candidate.lean'
original = p.read_bytes()
(D / ('first-candidate-' + hashlib.sha256(original).hexdigest() + '.lean')).write_bytes(original)
text = original.decode('utf-8')
text = text.replace('variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n', '')
text = text.replace('theorem travelingWave_characteristic_translate (profile : ℝ → E)',
    'theorem travelingWave_characteristic_translate {E : Type*} (profile : ℝ → E)')
text = text.replace('/-- The restriction to each characteristic',
    'variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n/-- The restriction to each characteristic')
p.write_text(text, encoding='utf-8', newline='\n')
first = text.index('/-- Translation along')
rectangle = text.index('/-- The full rectangle')
source = text.index('/-- The translated profile')
end = text.index('\nend NumStability', source)
header = '/-\nSPDX-License-Identifier: MIT\n-/\n\n'
drafts = [
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAdvection/Transport.lean',
  header + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal\n\n'
  + '/-!\n# Transport along linear advection characteristics\n\nArbitrary profiles are invariant along characteristics. Classical solvability\non the whole plane is equivalent to differentiability of the initial profile.\n-/\n\n'
  + 'namespace NumStability\n\n' + text[first:rectangle].rstrip() + '\n\nend NumStability\n',
  ['travelingWave_characteristic_translate', 'travelingWave_hasDerivAt_characteristic', 'travelingWave_isLinearAdvectionSolution_iff']),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TravelingWaveCharacterization.lean',
  header + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle\n\n'
  + '/-!\n# Rectangle solution domain for a translated profile\n\nFor every real speed, rectangle conservation with its integrability conditions\nholds exactly when the profile is integrable on every bounded interval.\n-/\n\n'
  + 'open MeasureTheory\n\nnamespace NumStability\n\n'
  + 'variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n'
  + text[rectangle:source].rstrip() + '\n\nend NumStability\n',
  ['travelingWave_isRectangleConservationLawSolution_iff']),
 ('ComputationalMathematics/Source/LeVeque/Chapter01/Equation03TransportSolution.lean',
  header + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection.Transport\n'
  + 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization\n\n'
  + '/-!\n# LeVeque Chapter 1, equation (1.3): translated-profile solutions\n\nRandall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, equation\n(1.3), printed page 1 (raw PDF page 23), with the classical/integral distinction\nin Section 1.1.2, printed pages 4–5 (raw PDF pages 26–27).\n\nTransport preserves every profile and its initial trace. The classical PDE\nconclusion explicitly requires differentiability; the time-integrated rectangle\nconclusion explicitly requires interval integrability. The derivative along\na characteristic is not asserted to be a pair of classical partial derivatives.\n-/\n\n'
  + 'open MeasureTheory\n\nnamespace NumStability\n\n'
  + text[source:end].rstrip() + '\n\nend NumStability\n',
  ['leveque01_equation03_transportSolution'])]
records = []
out = D / 'canonical-drafts'
out.mkdir(exist_ok=True)
for path, content, decls in drafts:
    target = out / Path(path).name
    assert not target.exists()
    data = content.encode('utf-8')
    target.write_bytes(data)
    records.append({'path': path, 'draft': target.relative_to(S).as_posix(),
        'sha256': hashlib.sha256(data).hexdigest(), 'declarations': ['NumStability.' + d for d in decls]})
manifest = {'schema': 1, 'original_candidate_sha256': hashlib.sha256(original).hexdigest(),
    'candidate_sha256': hashlib.sha256(p.read_bytes()).hexdigest(), 'files': records,
    'production_placement': 'pending; no production file changed',
    'canonical_import_validation': 'pending actual production placement'}
(D / 'canonical-drafts-manifest.json').write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8')
print(json.dumps(manifest, indent=2))
