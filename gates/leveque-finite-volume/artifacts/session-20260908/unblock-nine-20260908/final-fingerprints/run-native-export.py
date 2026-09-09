"""Capture one bounded native Lean exporter, obtaining Git identity via POSIX."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, shutil, subprocess, sys, time

F = Path(__file__).resolve().parent
R = F.parents[5]
launcher = R.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'
sha = lambda data: hashlib.sha256(data).hexdigest()

def main():
    assert os.name == 'nt', 'Native Lean capture requires Windows Python'
    inputs_raw = (F / 'inputs.json').read_bytes()
    inputs = json.loads(inputs_raw)
    def identity():
        result = subprocess.run([sys.executable, '-B', str(launcher), str(F / 'capture-posix-head.py')],
                                cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert result.returncode == 0, result.stderr.decode(errors='replace')
        return json.loads(result.stdout)
    before = identity()
    assert before == {'head': inputs['input_commit'], 'tree': inputs['input_commit_tree']}
    for item in inputs['files'] + inputs['lean_environment']:
        assert sha((R / item['path']).read_bytes()) == item['sha256'], item['path']
    assert sha((R / inputs['exporter_path']).read_bytes()) == inputs['exporter_sha256']
    output, receipt = F / 'native-output.txt', F / 'native-exit.json'
    assert not output.exists() and not receipt.exists() and not (R / inputs['raw_stream_path']).exists()
    lake = shutil.which('lake')
    assert lake
    argv = [lake, 'env', 'lean', inputs['exporter_path']]
    started = datetime.now(timezone.utc).isoformat()
    timer = time.monotonic()
    with output.open('xb') as stream:
        result = subprocess.run(argv, cwd=R, stdout=stream, stderr=subprocess.STDOUT)
    elapsed = time.monotonic() - timer
    after = identity()
    unchanged = before == after and (F / 'inputs.json').read_bytes() == inputs_raw
    unchanged = unchanged and all(sha((R / item['path']).read_bytes()) == item['sha256'] for item in inputs['files'] + inputs['lean_environment'])
    record = {'schema': 1, 'command': 'lake env lean ' + inputs['exporter_path'],
        'argv': ['lake', 'env', 'lean', inputs['exporter_path']], 'native_argv': argv,
        'exit_code': result.returncode, 'started_at_utc': started, 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
        'elapsed_ms': round(elapsed * 1000), 'output_sha256': sha(output.read_bytes()),
        'input_commit': before['head'], 'input_commit_tree': before['tree'], 'identity_after': after,
        'input_manifest_sha256': sha(inputs_raw), 'input_bytes_and_head_unchanged': unchanged,
        'native_lake': lake, 'capture_script_sha256': sha(Path(__file__).read_bytes()),
        'posix_head_script_sha256': sha((F / 'capture-posix-head.py').read_bytes()),
        'launcher_sha256': sha(launcher.read_bytes()), 'native_git_invoked': False}
    with receipt.open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(record, stream, indent=2); stream.write('\n')
    print(json.dumps(record))
    assert unchanged, 'Inputs or HEAD changed during native export'
    return result.returncode

if __name__ == '__main__': raise SystemExit(main())
