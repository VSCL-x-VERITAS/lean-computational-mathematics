"""Pin the reviewed certified-routine production before root-owned placement."""
from pathlib import Path
import hashlib
import json
import sys

F = Path(__file__).resolve().parent
D = F.parent
R = D.parent.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
assert len(sys.argv) == 5, 'PRODUCTION_RECEIPT SHA256 INVENTORY_SHA256 NATIVE_RECEIPT_SHA256'
receipt = Path(sys.argv[1]).resolve()
assert receipt.is_relative_to((D / 'riemann-certified-production').resolve())
assert sha(receipt) == sys.argv[2]
files = D / 'riemann-certified-production/production-files-frozen.json'
assert sha(files) == sys.argv[3]
items = read(files)['files']
assert len(items) == 4 and sum(len(x['declarations']) for x in items) == 7
for item in items:
    assert sha(R / item['path']) == item['sha256']
native_matches = [p for p in receipt.parent.rglob('*.json') if sha(p) == sys.argv[4]]
assert len(native_matches) == 1
native = read(native_matches[0])
actual_exit = native.get('exit_code', native.get('actual_exit_code'))
assert type(actual_exit) is int and actual_exit == 0
before = [R / name for name in ['docs/architecture/tiers.json',
    'ComputationalMathematics/Analysis.lean', 'ComputationalMathematics/Source/LeVeque/Chapter01.lean']]
plan = {'format': 'certified-routine-organization-placement-plan-1',
    'input_commit': '5e3f63594aa964263469ada134aee2809559d50d',
    'review': ref(F / 'REVIEW.md'), 'runner': ref(F / 'place.py'),
    'production_receipt': ref(receipt), 'production_files': ref(files),
    'before': [ref(path) for path in before], 'source_acceptance': False,
    'native_receipt': ref(native_matches[0])}
path = F / 'plan.json'
with path.open('xb') as stream:
    stream.write((json.dumps(plan, indent=2) + '\n').encode())
print(json.dumps(ref(path)))
