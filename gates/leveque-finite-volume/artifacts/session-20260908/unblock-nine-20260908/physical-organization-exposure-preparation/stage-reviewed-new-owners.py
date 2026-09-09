"""Stage only the twelve reviewed, successfully built new reusable owner files."""
from pathlib import Path
import datetime, hashlib, json, os, subprocess

assert os.name == 'posix', 'Use the prepared POSIX launcher for all Git operations'
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
D = P.parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
pin = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
build_path = D / 'physical-production-promotion/owners-native-03-receipt.json'
assert sha(build_path) == '662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb'
build = json.loads(build_path.read_bytes())
assert build['actual_exit_code'] == 0 and build['sources_unchanged']
source_pins = {x['path']: x['sha256'] for x in build['input_sources']}
for path, digest in source_pins.items():
    assert sha(R / path) == digest
placement_path = D / 'physical-production-promotion/owner-placement-01/receipt.json'
assert sha(placement_path) == '73c9027cfd4f55e272ddf56dc545a82195651b90401da3f0c2e3ac6b88a3188b'
files = json.loads(placement_path.read_bytes())['actual_changed_files']
paths = sorted(x['path'] for x in files if x['change'] == 'new')
assert len(paths) == 12 and all(path in source_pins for path in paths)
out = P / 'stage-01'
out.mkdir(exist_ok=False)
commands = []
def git(label, args):
    command = ['git', '--no-replace-objects', '-c', 'core.longpaths=true', *args]
    result = subprocess.run(command, cwd=R, capture_output=True)
    for suffix, data in [('stdout.bin', result.stdout), ('stderr.bin', result.stderr)]:
        with (out / (label + '-' + suffix)).open('xb') as stream:
            stream.write(data)
    commands.append({'command': command, 'actual_exit': result.returncode,
        'stdout': pin(out / (label + '-stdout.bin')), 'stderr': pin(out / (label + '-stderr.bin'))})
    assert result.returncode == 0
    return result.stdout
head = git('head-before', ['rev-parse', 'HEAD']).decode().strip()
assert head == '5e3f63594aa964263469ada134aee2809559d50d'
before = git('index-before', ['ls-files', '-s', '-z'])
before_entries = {row.split(b'\t', 1)[1]: row for row in before.split(b'\0') if row}
assert not set(path.encode() for path in paths) & set(before_entries)
git('add', ['add', '--', *paths])
after = git('index-after', ['ls-files', '-s', '-z'])
after_entries = {row.split(b'\t', 1)[1]: row for row in after.split(b'\0') if row}
assert set(after_entries) - set(before_entries) == {path.encode() for path in paths}
assert all(after_entries[path] == value for path, value in before_entries.items())
assert git('head-after', ['rev-parse', 'HEAD']).decode().strip() == head
for path, digest in source_pins.items():
    assert sha(R / path) == digest
receipt = {'format': 'reviewed-physical-new-owner-index-addition-1',
    'completed_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'actual_head': head, 'staged_paths': paths, 'commands': commands,
    'native_build': pin(build_path), 'placement': pin(placement_path),
    'other_index_entries_unchanged': True, 'sources_unchanged': True,
    'source_acceptance': False, 'commit_created': False, 'runner': pin(Path(__file__))}
with (out / 'receipt.json').open('x', encoding='utf-8', newline='\n') as stream:
    json.dump(receipt, stream, indent=2)
    stream.write('\n')
print(json.dumps(pin(out / 'receipt.json'), indent=2))
