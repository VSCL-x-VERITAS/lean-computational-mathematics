"""Capture actual candidate-local commands. Does not construct/check out a candidate.

Run only after the launcher has produced a real CANDIDATE. Output must be a new
directory outside its checkout. This is receipt capture, not released validation.
"""
from pathlib import Path
import argparse
import json
import os
import subprocess
import sys
import time
from candidate_checks import CHECKS, HERE, bound, digest, git, need, relative


def commands(inputs, sha256, tree):
    return {name: ['python3', HERE + '/candidate_checks.py', '--inputs', inputs,
                   '--inputs-sha256', sha256, '--check', name, '--candidate-tree', tree]
            for name in CHECKS}


def capture(candidate, commit, tree, inputs, output):
    need(os.name != 'nt', 'Use the reviewed POSIX workflow launcher')
    need(not output.exists() and not output.resolve().is_relative_to(candidate.resolve()),
         'Fresh capture directory outside candidate required')
    need(git(candidate, 'rev-parse', 'HEAD').decode().strip() == commit, 'Wrong actual candidate commit')
    need(git(candidate, 'rev-parse', 'HEAD^{tree}').decode().strip() == tree, 'Wrong actual candidate tree')
    bound(candidate, inputs, committed=True)
    need(not git(candidate, 'status', '--porcelain', '--untracked-files=all').strip(), 'Dirty candidate')
    output.mkdir(parents=True)
    refs = []
    for name, command in commands(inputs['path'], inputs['sha256'], tree).items():
        start = time.monotonic_ns()
        result = subprocess.run(command, cwd=candidate,
            env=dict(os.environ, PYTHONDONTWRITEBYTECODE='1'), stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        elapsed = (time.monotonic_ns() - start) // 1000000
        raw_path = output / (name + '.txt')
        raw_path.write_bytes(result.stdout)
        receipt = {'schema_version': 1, 'kind': 'actual-candidate-check', 'check': name,
            'command': command, 'input_commit': commit, 'candidate_tree': tree,
            'exit_code': result.returncode, 'elapsed_ms': elapsed, 'output_sha256': digest(result.stdout)}
        receipt_path = output / (name + '.json')
        receipt_path.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8', newline='\n')
        refs.append({'receipt': {'path': str(receipt_path), 'sha256': digest(receipt_path.read_bytes())},
                     'output': {'path': str(raw_path), 'sha256': digest(result.stdout)}})
        need(result.returncode == 0, 'Failed actual check; raw output and receipt retained: ' + name)
        need(git(candidate, 'rev-parse', 'HEAD').decode().strip() == commit
             and not git(candidate, 'status', '--porcelain', '--untracked-files=all').strip(), 'Candidate mutated')
    (output / 'receipts.json').write_text(json.dumps({'schema_version': 1,
        'candidate_commit': commit, 'candidate_tree': tree, 'checks': refs}, indent=2) + '\n',
        encoding='utf-8', newline='\n')
    print('Captured eight actual candidate check receipts; released epoch validation remains required.')


def main():
    p = argparse.ArgumentParser(description=__doc__)
    for field in ('candidate', 'commit', 'tree', 'inputs', 'inputs-sha256', 'output'):
        p.add_argument('--' + field, required=True)
    a = p.parse_args()
    capture(Path(a.candidate), a.commit, a.tree, {'path': relative(a.inputs).as_posix(),
            'sha256': a.inputs_sha256}, Path(a.output))


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError, TypeError) as exc:
        raise SystemExit('REFUSED: ' + str(exc))
