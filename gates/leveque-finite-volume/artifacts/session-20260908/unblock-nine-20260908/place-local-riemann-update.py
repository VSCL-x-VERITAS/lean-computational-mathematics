"""Place the checked reusable update and thin same-law Chapter 1 wrapper."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
R = D.parent.parents[3]
draft = D / 'LocalRiemannSourceDraft.lean'
assert hashlib.sha256(draft.read_bytes()).hexdigest() == '0bec1611baa7d7558e085cc6e6eea91d6e8054b9c02bd4dbd490645348eaa3ef'
text = draft.read_text(encoding='utf-8')
marker = '\nnamespace NumStability\nopen LocalRiemannInformation\n'
assert text.count(marker) == 1
generic, source = text.split(marker)
generic = generic.replace('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformation\n'
                          'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds',
                          'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds\n'
                          'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformation')
generic = generic.replace('\nopen MeasureTheory\n', '''
/-!
# Riemann information in a local finite-volume update

Ordered admissible cell values supply the actual interface problems. A
physically constrained Riemann reference certifies each numerical flux up to
its stated error; a separate comparison to the physical cell flux then gives
the local conservative next-step bound. All accuracy statements are conditional.
-/

open MeasureTheory
''', 1)
source = source[:source.index('\n#check NumStability.leveque01_localRiemannInformationInterface_sourceContract')]
header = '/-\nSPDX-License-Identifier: MIT\n-/\n\n'
source = header + '''import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformationUpdate

/-!
# Chapter 1: local Riemann information and the physical flux

The source contract uses the same law for the ordered Riemann problems and the
physical cell balance. Only the selected cell and time slab require integrability
and conservation. The algorithm can return information without a complete field.
Its specified error is compared with some physically constrained weak Riemann
reference; entropy and uniqueness are not supplied by this introductory passage.
The separately recorded accuracy convention gives conditional bounds, without
an unstated tolerance, order, convergence claim or global solution extension.
-/

open MeasureTheory

namespace NumStability
open LocalRiemannInformation
''' + source
paths = {
    R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformationUpdate.lean': header + generic,
    R / 'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalInformationInterface.lean': source,
}
for path, body in paths.items():
    with path.open('x', encoding='utf-8', newline='\n') as f:
        f.write(body)
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
receipt = {'checked_draft': {'path': draft.relative_to(R).as_posix(), 'sha256': sha(draft)},
           'native_output_sha256': '169c320293afcb45c9211b4f525ebe65200d404033802cd03c7b8cfe1e13e236',
           'placed': [{'path': p.relative_to(R).as_posix(), 'sha256': sha(p)} for p in paths],
           'scope': 'Statement and proof preserved in canonical leaves; only imports, module documentation and source/reusable file separation changed. Canonical check pending.'}
with (D / 'local-riemann-update-placement.json').open('xb') as f:
    f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
