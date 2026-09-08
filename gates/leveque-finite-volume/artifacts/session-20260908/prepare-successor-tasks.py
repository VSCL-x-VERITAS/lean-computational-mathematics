"""Create immutable canonical-path successors of selected historical v1 tasks.

This only prepares audit inputs. It never copies judgments or changes a gate.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

BASELINE = '9e2225705fed906b1120d55105d607baabef57c9'
SOURCE_SHA = 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
SESSION = Path(__file__).resolve().parent
ROOT = SESSION.parents[3]
ARTIFACTS = SESSION.parent

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('previous_ids', nargs='+')
args = parser.parse_args()
source = SESSION / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert hashlib.sha256(source.read_bytes()).hexdigest() == SOURCE_SHA
subprocess.run(['git', 'merge-base', '--is-ancestor', BASELINE, 'HEAD'], cwd=ROOT, check=True)
for previous_id in args.previous_ids:
    previous_path = ARTIFACTS / previous_id / 'audit-task.json'
    task = json.loads(previous_path.read_text(encoding='utf-8'))
    assert task['schema_version'] == 'formalization-faithfulness-task-1'
    assert task['source']['sha256'] == SOURCE_SHA
    assert task['target']['path'].startswith('NumStability/')
    task['target']['path'] = task['target']['path'].replace('NumStability/', 'ComputationalMathematics/', 1)
    subprocess.run(['git', 'cat-file', '-e', BASELINE + ':' + task['target']['path']], cwd=ROOT, check=True)
    subprocess.run(['git', 'diff', '--exit-code', BASELINE, '--', task['target']['path']], cwd=ROOT, check=True)
    current_id = previous_id + '-CANONICAL-20260908'
    task['task_id'] = current_id
    task['source']['path'] = source.relative_to(ROOT).as_posix()
    task.pop('context', None)
    task['source_group'] = task['source_group'] + '-canonical-20260908'
    taskdir = SESSION / 'audits' / current_id
    task['audit_output'] = (taskdir / 'faithfulness').relative_to(ROOT).as_posix()
    path = taskdir / 'audit-task.json'
    payload = (json.dumps(task, indent=2, ensure_ascii=False) + '\n').encode('utf-8')
    if path.exists():
        assert path.read_bytes() == payload, f'Existing immutable task differs: {path}'
    else:
        taskdir.mkdir(parents=True, exist_ok=True)
        path.write_bytes(payload)
    print(path.relative_to(ROOT))
