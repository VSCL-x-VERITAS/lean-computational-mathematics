"""Write one immutable v1 audit input for an existing canonical definition theorem.

This records only the source locator and target; it does not create a judgment.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

SESSION = Path(__file__).resolve().parent
ROOT = SESSION.parents[3]
BASELINE = '9e2225705fed906b1120d55105d607baabef57c9'
SOURCE_SHA = 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--id', required=True)
parser.add_argument('--target', required=True)
parser.add_argument('--declaration', required=True)
parser.add_argument('--location', required=True)
parser.add_argument('--anchor', required=True)
args = parser.parse_args()
source = SESSION / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert hashlib.sha256(source.read_bytes()).hexdigest() == SOURCE_SHA
assert args.target.startswith('ComputationalMathematics/Source/LeVeque/Chapter01/')
subprocess.run(['git', 'merge-base', '--is-ancestor', BASELINE, 'HEAD'], cwd=ROOT, check=True)
subprocess.run(['git', 'cat-file', '-e', BASELINE + ':' + args.target], cwd=ROOT, check=True)
subprocess.run(['git', 'diff', '--exit-code', BASELINE, '--', args.target], cwd=ROOT, check=True)
taskdir = SESSION / 'audits' / args.id
task = {
    'schema_version': 'formalization-faithfulness-task-1',
    'task_id': args.id,
    'target': {'path': args.target, 'declaration': args.declaration},
    'source': {
        'path': source.relative_to(ROOT).as_posix(), 'sha256': SOURCE_SHA,
        'version': 'First published in printed format 2002 (PDF copyright 2004)',
        'locations': [{'location': args.location, 'anchor': args.anchor}],
    },
    'audit_output': (taskdir / 'faithfulness').relative_to(ROOT).as_posix(),
    'source_group': 'leveque-chapter01-definitions-canonical-20260908',
}
payload = (json.dumps(task, indent=2, ensure_ascii=False) + '\n').encode('utf-8')
path = taskdir / 'audit-task.json'
if path.exists():
    assert path.read_bytes() == payload, 'immutable task already exists with different input'
else:
    taskdir.mkdir(parents=True, exist_ok=True)
    path.write_bytes(payload)
print(path.relative_to(ROOT))
