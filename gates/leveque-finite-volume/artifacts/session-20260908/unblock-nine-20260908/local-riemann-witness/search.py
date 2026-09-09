"""Scoped reuse search receipt; no claim of exhaustive library absence."""
from pathlib import Path
import hashlib
import json
import subprocess

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lean-toolchain').is_file())
P = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
M = R / '.lake/packages/mathlib/Mathlib/Analysis/Normed'
queries = [
    ['rg', '-n', 'selected_flux_eq_reference_average|reference_rectangle|reference_initial|OrderedResult|half.*flux|perturbed.*flux', str(P)],
    ['rg', '-n', 'pi_norm_const|norm_le_pi_norm', str(M / 'Group/Constructions.lean')],
    ['rg', '-n', '^lemma norm_smul|^theorem norm_smul', str(M / 'MulAction.lean')],
    ['rg', '-n', 'IsHyperbolicFluxOn|hyperbolicConservationLaw_isHyperbolicFluxAt', str(P.parent / 'ConservationLaws/Hyperbolicity.lean')],
]
out = D / 'reuse-search'
out.mkdir()
records = []
for i, argv in enumerate(queries, 1):
    result = subprocess.run(argv, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    p = out / f'{i:02d}.txt'
    p.write_bytes(result.stdout)
    records.append({'argv': argv, 'exit_code': result.returncode, 'output': p.name,
                    'sha256': hashlib.sha256(result.stdout).hexdigest()})
(out / 'receipt.json').write_text(json.dumps({'schema': 1, 'scope': 'listed paths only',
    'queries': records}, indent=2) + '\n', encoding='utf-8', newline='\n')
print(json.dumps(records, indent=2))
