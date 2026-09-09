"""Capture focused native checks for the two approved additive owners."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, subprocess, sys, time

F = Path(__file__).resolve().parent
R = F.parents[5]
sha = lambda data: hashlib.sha256(data).hexdigest()

def main():
    mode = sys.argv[1]
    assert mode in ('build', 'declarations')
    manifest_raw = (F / 'production-inputs.json').read_bytes()
    manifest = json.loads(manifest_raw)
    refs = manifest['files'] + [manifest['consumer_check']]
    for item in refs: assert sha((R / item['path']).read_bytes()) == item['sha256']
    launcher = R.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'
    head_script = F.parent / 'final-fingerprints/capture-posix-head.py'
    def identity():
        result = subprocess.run([sys.executable, '-B', str(launcher), str(head_script)],
            cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert result.returncode == 0, result.stderr
        return json.loads(result.stdout)
    before = identity()
    arguments = (['build'] + [f['path'][:-5].replace('/', '.') for f in manifest['files']]
        if mode == 'build' else ['env', 'lean', manifest['consumer_check']['path']])
    out, receipt = F / ('production-' + mode + '-output.txt'), F / ('production-' + mode + '-exit.json')
    assert not out.exists() and not receipt.exists()
    start = time.monotonic()
    with out.open('xb') as stream:
        result = subprocess.run(['C:/Users/qed_s/.elan/bin/lake.exe', *arguments], cwd=R, stdout=stream, stderr=subprocess.STDOUT)
    elapsed = time.monotonic() - start
    after = identity()
    unchanged = all(sha((R / item['path']).read_bytes()) == item['sha256'] for item in refs)
    r = {'schema': 1, 'command': 'lake ' + ' '.join(arguments), 'argv': ['lake', *arguments],
        'exit_code': result.returncode, 'elapsed_ms': round(elapsed * 1000),
        'completed_at_utc': datetime.now(timezone.utc).isoformat(), 'input_commit': before['head'],
        'input_tree': before['tree'], 'identity_after': after, 'source_inputs': refs,
        'sources_unchanged': unchanged, 'manifest_sha256': sha(manifest_raw),
        'output_sha256': sha(out.read_bytes()), 'capture_script_sha256': sha(Path(__file__).read_bytes()),
        'native_git_invoked': False}
    with receipt.open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(r, stream, indent=2); stream.write('\n')
    print(json.dumps(r))
    assert unchanged
    return result.returncode

if __name__ == '__main__': raise SystemExit(main())
