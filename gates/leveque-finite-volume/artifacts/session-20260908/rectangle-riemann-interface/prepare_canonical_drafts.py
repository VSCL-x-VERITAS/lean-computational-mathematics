from pathlib import Path
import hashlib
import json
import re

base = Path(__file__).resolve().parent
candidate = (base / 'candidate.lean').read_text(encoding='utf-8')
body = candidate.split('namespace NumStability\n', 1)[1].split('\n#check ', 1)[0]
linear_start = body.index('/-- A real hyperbolic matrix')
source_start = body.index('/-- LeVeque Chapter 1, printed page 5')
parts = [body[:linear_start], body[linear_start:source_start], body[source_start:]]
prefix = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.'
filenames = ['RectangleRiemannInterface.lean', 'LinearRectangleRiemannInterface.lean',
             'RectangleRiemannInterfaceFlux.lean']
canonical_paths = [
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/' + filenames[0],
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/' + filenames[1],
    'ComputationalMathematics/Source/LeVeque/Chapter01/' + filenames[2],
]
imports = [
    [prefix + 'FiniteVolume.RiemannInterface', prefix + 'ConservationLaws.Rectangle'],
    [prefix + 'FiniteVolume.RectangleRiemannInterface', prefix + 'FiniteVolume.LinearRiemannSolution',
     'Mathlib.Topology.Algebra.Module.FiniteDimension', 'Mathlib.LinearAlgebra.Matrix.ToLin',
     'Mathlib.Analysis.Calculus.FDeriv.Linear'],
    [prefix + 'FiniteVolume.LinearRectangleRiemannInterface'],
]
docs = [
    '''# Rectangle-certified Riemann interface methods

A method solves ordered local Riemann problems on an explicit domain. Its
certificate includes the Riemann initial trace and time-integrated rectangle
conservation, including the integrability required for the rectangle identity.
The workflow uses normalized cell averages, extracted information, a consistent
interface flux, and the existing conservative finite-volume update.
''',
    '''# Linear rectangle-certified Riemann interface methods

The explicit eigenbasis Riemann solution supplies a method on every ordered
pair of states for a real hyperbolic matrix. Its information is the actual
solution value on ray zero, and its physical matrix flux is constant-state
consistent. No general nonlinear existence or stability theorem is asserted.
''',
    '''# LeVeque Chapter 1, rectangle-certified interface workflow

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27), following equation (1.11).

This wrapper exposes the solver domain for the actual normalized cell averages.
Potentially discontinuous local solutions carry rectangle conservation and their
ordered Riemann initial traces. The imported linear construction inhabits the
method contract on all ordered state pairs. A positive time step is recorded;
no CFL, approximation-error, stability, convergence, or global gluing conclusion
is part of this interface workflow.
''',
]
drafts = base / 'canonical-drafts'
drafts.mkdir(exist_ok=True)
manifest = []
all_names = []
for filename, path, module_imports, doc, part in zip(filenames, canonical_paths, imports, docs, parts):
    text = '/-\nSPDX-License-Identifier: MIT\n-/\n\n'
    text += '\n'.join('import ' + name for name in module_imports)
    text += '\n\n/-!\n' + doc + '-/\n\nopen MeasureTheory\n\nnamespace NumStability\n'
    text += part.rstrip() + '\n\nend NumStability\n'
    raw = text.encode('utf-8')
    (drafts / filename).write_bytes(raw)
    names = re.findall(r'^(?:noncomputable )?(?:def|structure|theorem) ([A-Za-z0-9_]+)', text, re.M)
    all_names.extend(names)
    manifest.append({'canonical_path': path, 'draft_path': str((drafts / filename).relative_to(base)),
                     'sha256': hashlib.sha256(raw).hexdigest(), 'bytes': len(raw),
                     'lines': len(text.splitlines()), 'declarations': ['NumStability.' + name for name in names]})
(base / 'canonical-drafts-manifest.json').write_bytes((json.dumps(manifest, indent=2) + '\n').encode())
(base / 'canonical-declaration-checks.lean').write_bytes((
    'import ComputationalMathematics.Source.LeVeque.Chapter01.RectangleRiemannInterfaceFlux\n\n' +
    '\n'.join(f'#check NumStability.{name}\n#print axioms NumStability.{name}' for name in all_names) + '\n').encode())
print(json.dumps({'files': len(manifest), 'declarations': len(all_names),
                  'lines': [item['lines'] for item in manifest]}, indent=2))
