"""Add exact released compile sequence and append-only runtime record location."""
from pathlib import Path
import hashlib
import json
P = Path(__file__).resolve().parent
D = P.parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
parent = P / 'runtime-descriptor.json'
assert sha(parent) == 'a3b4afe72373c700b71d41d55362022928e9680d2fd5171c560554e057c0637a'
data = json.loads(parent.read_bytes())
order_path = D / 'physical-failed-preparation-module-order.json'
assert sha(order_path) == '182e24a56efb9d11e1dbc69611a9e86b2ec46222845e977471902e7a173d64c1'
order = json.loads(order_path.read_bytes())['ordered_modules']
assert len(order) == len(set(order)) == 41
target = 'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'
compiles = []
for module in order:
    source = module.replace('.', '/') + '.lean'
    actual = (D / 'dim-blind-evidence-repair/m' / source if module.startswith('Mathlib.') else R / source)
    compiles.append({'module': module, 'relative_source': source, 'source': ref(actual)})
compiles.append({'module': 'AuditTarget', 'relative_source': 'AuditTarget.lean', 'source': ref(R / target)})
data['artifacts'] = [item for item in data['artifacts'] if item['overlay'] != target.removesuffix('.lean') + '.olean']
data.update(expected_compiles=compiles,
            task_id='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908',
            runtime_records='gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908/compiler-command-records',
            parent_descriptor=ref(parent),
            lifecycle='Validate original compiled closure on initialization and final dossier completion; exact source/tool/option/output checks per call; no unexecuted expected module may pass final dossier guard.')
with (P / 'runtime-descriptor-v2.json').open('x', encoding='utf-8') as stream:
    stream.write(json.dumps(data, indent=2) + '\n')
print(json.dumps({'descriptor': ref(P / 'runtime-descriptor-v2.json'), 'expected_compiles': len(compiles), 'artifacts': len(data['artifacts'])}))
