"""Freeze an explicit placement plan after root selects the completed producer receipt."""
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
assert len(sys.argv) == 3, 'FINAL_PRODUCTION_RECEIPT SHA256'
receipt = Path(sys.argv[1]).resolve()
assert receipt.is_relative_to((D / 'directional-high-resolution-production').resolve())
assert sha(receipt) == sys.argv[2]
files = D / 'directional-high-resolution-production/production-files-frozen.json'
assert sha(files) == 'cb7623870ad874124148177f971a30c9e18e6b0172d2e21e59c6ae135f9c4538'
items = read(files)['files']
assert len(items) == 16 and sum(len(x['declarations']) for x in items) == 150
for item in items:
    assert sha(R / item['path']) == item['sha256']
for label, digest in [
    ('canonical01', '2cd8c95664dff95f45a754e8c0d5b586b807842d4b4d57b8ce19fb673bc0cd46'),
    ('sourcejoint01', '2da0360513cd7d9e45f590308288cebfc7a04734d84c759818f7e10794780b84')]:
    path = D / 'directional-high-resolution-production' / (label + '-receipt.json')
    assert sha(path) == digest
    native = read(path)
    assert native['actual_exit_code'] == 0 and native['dependencies_unchanged'] is True
    assert sha(R / native['output']['path']) == native['output']['sha256']
before = [R / name for name in ['docs/architecture/tiers.json',
    'ComputationalMathematics/Analysis.lean', 'ComputationalMathematics/Source/LeVeque/Chapter01.lean']]
plan = {'format': 'high-resolution-organization-placement-plan-1',
    'input_commit': '5e3f63594aa964263469ada134aee2809559d50d',
    'review': ref(F / 'REVIEW.md'), 'runner': ref(F / 'place.py'),
    'production_receipt': ref(receipt), 'production_files': ref(files),
    'before': [ref(path) for path in before], 'source_acceptance': False}
path = F / 'plan.json'
with path.open('xb') as stream:
    stream.write((json.dumps(plan, indent=2) + '\n').encode())
print(json.dumps(ref(path)))
