"""Stage the user-requested checkpoint using the existing reviewed path policy."""
from pathlib import Path
import hashlib
import importlib.util
import json
import os
import stat
import subprocess

assert os.name == 'posix'
D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lakefile.toml').exists())
P = D / 'publication-preparation'
policy_path = P / 'policy-final-physical-05.json'
assert hashlib.sha256(policy_path.read_bytes()).hexdigest() == '40b9dda32a793b5aa588f0465b6150f39e85cb608a2c12db36c0694385246ab0'
helper = P / 'check-publication-allowlist-v3.py'
assert hashlib.sha256(helper.read_bytes()).hexdigest() == '8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
spec = importlib.util.spec_from_file_location('publication_policy', helper)
policy_api = importlib.util.module_from_spec(spec)
spec.loader.exec_module(policy_api)
policy = json.loads(policy_path.read_bytes())
policy_api.verify_policy(policy)
git = ['git', '--no-optional-locks', '-c', 'core.longpaths=true', '-c', 'diff.autoRefreshIndex=false']
def run(args):
    return subprocess.check_output(git + args, cwd=R)
assert run(['rev-parse', 'HEAD']).decode().strip() == policy['snapshot_head']
records = policy_api.parse_status(run(['status', '--porcelain=v1', '-z', '--untracked-files=all']))
chosen = []
omitted = []
parents_checked = set()
for record in records:
    name, state = record['path'], record['status']
    disposition, reason = policy_api.disposition(name, policy)
    if disposition != 'select':
        assert state[0] in (' ', '?'), ('Unselected path already staged', name)
        omitted.append({'path': name, 'reason': reason})
        continue
    assert not any(c in state for c in 'DRCU'), ('Unexpected deletion, rename or conflict', name)
    path = R / name
    info = path.lstat()
    assert stat.S_ISREG(info.st_mode) and info.st_size < policy['size_limit_bytes'], name
    for parent in path.parents:
        if parent == R:
            break
        if parent not in parents_checked:
            assert not parent.is_symlink(), parent
            parents_checked.add(parent)
    chosen.append({'path': name, 'bytes': info.st_size})
assert any(x['path'].endswith('/PUBLICATION-STATUS.md') for x in chosen)
assert len([x for x in chosen if x['path'].startswith('ComputationalMathematics/')]) >= 58
dest = P / 'stage-current-01'
dest.mkdir(exist_ok=False)
names = sorted(x['path'] for x in chosen)
pathspec = dest / 'paths.nul'
pathspec.write_bytes(b''.join(n.encode() + b'\0' for n in names))
selection = {'policy_sha256': hashlib.sha256(policy_path.read_bytes()).hexdigest(), 'selected': chosen, 'omitted': omitted, 'chapter_complete': False, 'note': 'User requested publication now. Long diagnostic stopped; no archive-replay or semantic-closure claim. Existing policy excludes private captures, large raw exports and generated caches.'}
(dest / 'selection.json').write_text(json.dumps(selection, indent=2) + '\n')
subprocess.run(git + ['add', '--pathspec-from-file=' + str(pathspec), '--pathspec-file-nul'], cwd=R, check=True)
staged = set(filter(None, run(['diff', '--cached', '--name-only', '-z']).decode().split('\0')))
assert staged <= set(names), 'Unexpected path in index'
assert set(n for n in names if n.startswith('ComputationalMathematics/')) <= staged
result = {'staged_count': len(staged), 'selected_bytes': sum(x['bytes'] for x in chosen), 'omitted_count': len(omitted), 'production_files': len([n for n in staged if n.startswith('ComputationalMathematics/')]), 'selection_sha256': hashlib.sha256((dest / 'selection.json').read_bytes()).hexdigest(), 'chapter_complete': False}
(dest / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result))
