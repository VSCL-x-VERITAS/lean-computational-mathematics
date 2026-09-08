from pathlib import Path
import re

base = Path(__file__).resolve().parent
path = base / 'candidate.lean'
text = path.read_text(encoding='utf-8')
text = text[:text.index('#check rectangleRiemannInterface_finiteVolumeStep')]
generic = text[text.index('theorem rectangleRiemannInterface_finiteVolumeStep'):]
generic = generic[:generic.index(' := by')]
source = generic.replace('rectangleRiemannInterface_finiteVolumeStep',
                        'leveque01_rectangleRiemannInterfaceFlux_sourceContract', 1)
source = source.replace('{Component Information : Type*} [Fintype Component]',
                        '{m : ℕ} (hm : 0 < m) {Information : Type*}', 1)
source = source.replace('Component', 'Fin m')
source = source.replace('(timeStep : ℝ) :',
                        '(timeStep : ℝ) (htimeStep : 0 < timeStep) :\n    0 < m ∧ 0 < timeStep ∧', 1)
source += ''' := by
  exact ⟨hm, htimeStep, rectangleRiemannInterface_finiteVolumeStep
    law grid initialState hintegrable method hdomain timeStep⟩
'''
text += '''/-- LeVeque Chapter 1, printed page 5 (raw PDF page 27), following equation
(1.11): the interface workflow on the explicit solver domain, using rectangle
conservation for the potentially discontinuous local Riemann solutions. The
averages are actual normalized cell integrals, and left/right order is explicit. -/
'''
text += source
names = re.findall(r'^(?:noncomputable )?(?:def|structure|theorem) ([A-Za-z0-9_]+)', text, re.M)
text += '\n' + '\n'.join(f'#check {name}\n#print axioms {name}' for name in names)
text += '\n\nend NumStability\n'
path.write_bytes(text.encode('utf-8'))
