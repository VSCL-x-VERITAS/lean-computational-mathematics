"""Place the reviewed scoped core with corrected reference-selection wording."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
R = D.parent.parents[3]
source = D / 'ScopedRiemannInformationDraft.lean'
assert hashlib.sha256(source.read_bytes()).hexdigest() == 'c7f31c93c0a151557301fb13d517206820aed4adc309c61396ab1e9af9f4f965'
text = source.read_text(encoding='utf-8')
text = text[:text.index('\n#check ScopedRiemannInformationDraft.Method.reference_comparison')]
text = text.replace('/- Draft of a local-time, admissible-state numerical Riemann contract. -/', '/-\nSPDX-License-Identifier: MIT\n-/')
text = text.replace('namespace ScopedRiemannInformationDraft', '''/-!
# Riemann information with local physical comparison

A numerical procedure returns arbitrary problem-indexed information. Its
specified flux error is certified against some rectangle-conserved Riemann
reference on the same finite time slab and with the same ordered states.
The reference is existentially selected and can depend on the method. No
entropy condition, uniqueness, prescribed tolerance or convergence is asserted.
Hyperbolicity uses the ambient flux derivative only at admissible states.
-/

namespace NumStability.LocalRiemannInformation''')
text = text.replace('end ScopedRiemannInformationDraft', 'end NumStability.LocalRiemannInformation')
text = text.replace('/-- An independent physical Riemann reference on the selected finite time slab.',
                    '/-- A physical Riemann reference on the selected finite time slab.')
text = text.replace('contract compares the resulting flux with an independent physical solution of',
                    'contract compares the resulting flux with some physical solution of')
text = text.replace('The numerical result type does not contain this field.',
                    'Existential selection may depend on the method; its numerical result type need not contain this field.')
destination = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannInformation.lean'
with destination.open('x', encoding='utf-8', newline='\n') as f:
    f.write(text)
receipt = {'source': {'path': source.relative_to(R).as_posix(), 'sha256': hashlib.sha256(source.read_bytes()).hexdigest()},
           'placed': {'path': destination.relative_to(R).as_posix(), 'sha256': hashlib.sha256(destination.read_bytes()).hexdigest()},
           'scope': 'Reviewed definitions and theorem unchanged apart from namespace; documentation corrects existential selection. Native canonical check pending.'}
with (D / 'local-riemann-core-placement.json').open('xb') as f:
    f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
