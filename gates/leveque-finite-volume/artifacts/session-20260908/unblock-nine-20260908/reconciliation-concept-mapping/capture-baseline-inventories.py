"""Capture exact existing two-lane Git-object inventories through approved POSIX.

This creates draft inventory artifacts only, never candidate/ref/gate/runtime state.
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
D = HERE.parent
R = D.parents[4]
W = R.parent
PYTHON = 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    lane = sys.argv[1]
    assert lane in ('leveque-ch01-work', 'reorganization-baseline-inspection')
    directory = HERE/lane
    directory.mkdir()
    helper = D/'reconciliation-helpers/build_lane_inventory.py'
    topology = D/'linear-review/pass-checkpoint-review/topology.observed.json'
    assert sha(topology) == '1459fc684433d30e50e5e623e87a7a1772fcb2801ac65b9df4c94dbecbc70709'
    output = directory/'inventory.json'
    cmd = [PYTHON, '-B', str(W/'workflow-v5.0.1-local/run_workflow_posix.py'), str(helper),
           '--topology', str(topology), '--lane', lane,
           '--fingerprints', 'gates/leveque-finite-volume/artifacts/session-20260908/baseline-equation03-expression-fingerprints.json',
           '--fingerprints', 'gates/leveque-finite-volume/artifacts/session-20260908/chapter01-current-expression-fingerprints-24b3.json',
           '--output', str(output)]
    started = datetime.now(timezone.utc).isoformat()
    start = time.perf_counter()
    run = subprocess.run(cmd, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    elapsed = time.perf_counter() - start
    (directory/'stdout.txt').write_bytes(run.stdout)
    (directory/'stderr.txt').write_bytes(run.stderr)
    receipt = {'schema': 1, 'command': cmd, 'cwd': str(R), 'started_at_utc': started,
               'elapsed_seconds': elapsed, 'exit_code': run.returncode,
               'helper_sha256': sha(helper), 'topology_sha256': sha(topology),
               'capture_sha256': sha(Path(__file__)),
               'stdout_sha256': sha(directory/'stdout.txt'), 'stderr_sha256': sha(directory/'stderr.txt'),
               'inventory_sha256': sha(output) if output.exists() else None,
               'candidate_or_gate_created': False, 'source_acceptance': False}
    (directory/'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8', newline='\n')
    print(json.dumps(receipt, indent=2))
    return run.returncode


if __name__ == '__main__':
    raise SystemExit(main())
