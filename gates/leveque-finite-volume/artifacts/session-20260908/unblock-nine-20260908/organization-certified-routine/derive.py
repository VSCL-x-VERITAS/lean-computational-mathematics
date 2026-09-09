"""Derive a bounded additive placement runner from the reviewed DIM runner."""
from pathlib import Path
import ast
import hashlib
import json

F = Path(__file__).resolve().parent
D = F.parent
parent = D / 'organization-high-resolution/place.py'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(parent) == '05d86cb2483b26dc080c5a69ba6850a17267026c88be9c25ce9dd3cdfb29ed2d'
source = parent.read_text()
replacements = [
    ('sixteen-file high-resolution increment', 'four-file certified Riemann routine increment'),
    ('high-resolution-organization-placement-plan-1', 'certified-routine-organization-placement-plan-1'),
    ('high-resolution-organization-placement-1', 'certified-routine-organization-placement-1'),
    ('assert len(files) == 16 and len({x[\'path\'] for x in files}) == 16',
     'assert len(files) == 4 and len({x[\'path\'] for x in files}) == 4'),
    ("initial = read(D / 'directional-high-resolution-production/initial-placement.json')\nexpected = {x['path'] for x in initial['files']} | {\n    'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'}",
     "expected = {\n    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannRoutineAccuracy.lean',\n    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CertifiedRiemannRoutineUpdate.lean',\n    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/BiasedCertifiedRiemannRoutine.lean',\n    'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannCertifiedRoutineInterface.lean'}"),
    ("assert sum(len(x['declarations']) for x in files) == 150", "assert sum(len(x['declarations']) for x in files) == 7"),
    ('f25519b47f039f35a9e8c5b5dd6dad187e18165f4ff431c342a4cfe694fa3ce7', 'dec437407b4f6432b291921fbe807114c9bfcb5b808bf5da4ae0f055e1d00c2a'),
    ('bd0b3e2040dc852eec89c226081fe67ffcbf26bb19371f9e031deb3b408b36df', 'b47a4ed8b1c7403278b71016292a5cb6b945342cc2b37d67a728245b85d480de'),
    ('f050b48048086e9405bdb2abff9bc8276cdcbbd032aab85e14e7be62575883a8', '0d9c7704cd7afd0705f1aef4a8ec53c30389c6bd25ca4949f9474b52e2ea6bb9'),
    ('assert len(reusable) == 15 and len(source) == 1', 'assert len(reusable) == 3 and len(source) == 1'),
    ('Generic finite measured geometry, local conservation, refining line method quality, coordinate execution, error propagation or advection example; the book-specific contract resides in Source/LeVeque.',
     'Generic supplied Riemann routine accuracy, certified local finite-volume error comparison or biased admissible example; the book-specific contract resides in Source/LeVeque.'),
]
for old, new in replacements:
    assert source.count(old) == 1, old
    source = source.replace(old, new)
ast.parse(source)
destination = F / 'place.py'
with destination.open('xb') as stream:
    stream.write(source.encode())
record = {'parent_sha256': sha(parent), 'successor_sha256': sha(destination),
          'exact_replacements': replacements, 'syntax_valid': True,
          'executed_placement': False}
with (F / 'derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
