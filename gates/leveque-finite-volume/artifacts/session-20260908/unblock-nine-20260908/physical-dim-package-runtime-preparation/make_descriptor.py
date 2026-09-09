"""Freeze actual imported compiled closure and successful runtime diagnostics."""
from pathlib import Path
import hashlib
import json

P = Path(__file__).resolve().parent
D = P.parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
read = lambda path: json.loads(path.read_bytes())
diagnostic = D / 'physical-dim-overlay-diagnostic'
receipt = diagnostic / 'overlay01/receipt.json'
assert sha(receipt) == '3b93bf6c23856bab231e1a15f239c07598208c948ba575370671e0d876f396d7'
result = read(receipt)
assert result['canonical_pins_unchanged'] and [item['exit_code'] for item in result['records']] == [0, 0, 0, 0, 1, 1]
for name in ('Defs', 'FTaylorSeries'):
    error = (diagnostic / 'overlay01' / ('dossier-missing-' + name + '-stderr.txt')).read_text()
    assert name + '.olean' in error and 'physical-dim-overlay01' in error and 'does not exist' in error
closure = read(diagnostic / 'closure01/closure-stdout.txt')
artifacts = []
for item in closure:
    if not item['module'].startswith(('Mathlib.', 'ComputationalMathematics.')):
        continue
    olean = Path(item['olean'])
    prefix = R / ('.lake/packages/mathlib/.lake/build/lib/lean' if item['module'].startswith('Mathlib.')
                  else '.lake/build/lib/lean')
    assert olean.resolve().is_relative_to(prefix.resolve())
    for suffix in ('.olean', '.olean.private', '.olean.server', '.ir'):
        path = olean.with_suffix(suffix)
        if path.exists():
            artifacts.append({**ref(path), 'overlay': path.relative_to(prefix).as_posix(), 'bytes': path.stat().st_size})
assert len({item['overlay'] for item in artifacts}) == len(artifacts)
runtime = read(diagnostic / 'overlay01/runtime.json')
descriptor = {'format': 'exact-direct-lean-package-overlay-1', 'artifacts': artifacts,
    'native_lean': runtime['lean'], 'lean_toolchain': ref(R / 'lean-toolchain'),
    'lake_manifest': ref(R / 'lake-manifest.json'), 'mathlib_package': ref(R / '.lake/packages/mathlib/lakefile.lean'),
    'mathlib_options': ['-DautoImplicit=false', '-DmaxSynthPendingDepth=3', '-Dpp.unicode.fun=true'],
    'mathlib_sources': [ref(R / '.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff' / (name + '.lean'))
                        for name in ('Defs', 'FTaylorSeries')],
    'released_order': ref(D / 'physical-failed-preparation-module-order.json'),
    'diagnostic': ref(receipt), 'closure_receipt': ref(diagnostic / 'closure01/receipt.json'),
    'closure_output': ref(diagnostic / 'closure01/closure-stdout.txt'),
    'scope': 'Exact cached imported Mathlib/project closure, overridden only by actual fresh temporary compilation. Not source acceptance.'}
with (P / 'runtime-descriptor.json').open('x', encoding='utf-8') as stream:
    stream.write(json.dumps(descriptor, indent=2) + '\n')
print(json.dumps({'descriptor': ref(P / 'runtime-descriptor.json'), 'artifacts': len(artifacts),
                  'bytes': sum(item['bytes'] for item in artifacts)}))
