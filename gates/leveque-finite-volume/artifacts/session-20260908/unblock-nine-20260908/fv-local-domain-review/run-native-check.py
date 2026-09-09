"""Capture the additive local draft only; obtain Git identity via POSIX."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, subprocess, sys, time

F = Path(__file__).resolve().parent
R = F.parents[5]
launcher = R.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'
head_script = F.parent / 'final-fingerprints/capture-posix-head.py'
sha = lambda data: hashlib.sha256(data).hexdigest()

def main():
    label = sys.argv[1]
    assert label.isalnum()
    path = F / 'LocalCellErrorDraft.lean'
    relative = path.relative_to(R).as_posix()
    raw = path.read_bytes()
    def identity():
        result = subprocess.run([sys.executable, '-B', str(launcher), str(head_script)],
            cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert result.returncode == 0, result.stderr
        return json.loads(result.stdout)
    before = identity()
    out, receipt = F / ('native-' + label + '-output.txt'), F / ('native-' + label + '-exit.json')
    assert not out.exists() and not receipt.exists()
    native_lake = 'C:/Users/qed_s/.elan/bin/lake.exe'
    start = time.monotonic()
    with out.open('xb') as stream:
        result = subprocess.run([native_lake, 'env', 'lean', relative], cwd=R, stdout=stream, stderr=subprocess.STDOUT)
    elapsed = time.monotonic() - start
    after = identity()
    r = {'schema': 1, 'command': 'lake env lean ' + relative, 'argv': ['lake', 'env', 'lean', relative],
        'exit_code': result.returncode, 'elapsed_ms': round(elapsed * 1000), 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
        'input_commit': before['head'], 'input_tree': before['tree'], 'identity_after': after,
        'source_path': relative, 'source_sha256': sha(raw), 'source_unchanged': path.read_bytes() == raw,
        'output_sha256': sha(out.read_bytes()), 'native_lake': native_lake,
        'capture_script_sha256': sha(Path(__file__).read_bytes()), 'native_git_invoked': False}
    with receipt.open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(r, stream, indent=2); stream.write('\n')
    print(json.dumps(r))
    return result.returncode

if __name__ == '__main__': raise SystemExit(main())
