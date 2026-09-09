"""Read-only attributes and filtered object hashes; never writes Git objects or index."""
from pathlib import Path
import hashlib
import importlib.util
import json
import os
import subprocess
from datetime import datetime, timezone

H = Path(__file__).resolve().parent; D = H.parent; S = D.parent; R = S.parents[3]
assert os.name != 'nt', 'Use unchanged POSIX launcher'
policy_path = D / 'publication-preparation/policy.json'
assert hashlib.sha256(policy_path.read_bytes()).hexdigest() == 'b48a272999d6fa83d2eeeb08115237d5988760e8d58a780e0c11cd89785fb91d'
policy = json.loads(policy_path.read_bytes())
module_path = D / 'publication-preparation/check-publication-allowlist-v2.py'
assert hashlib.sha256(module_path.read_bytes()).hexdigest() == '5419329812f0ec4aa7310fc01f3aa6d8910092a174f3c00c5861210709d27015'
spec = importlib.util.spec_from_file_location('selection_only', module_path)
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
out = H / 'snapshot-01'; out.mkdir()
commands = []
def git(args, label, data=None):
    command = m.GIT + args
    p = subprocess.run(command, cwd=R, input=data, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (out / (label + '.stdout.bin')).write_bytes(p.stdout)
    (out / (label + '.stderr.txt')).write_bytes(p.stderr)
    commands.append({'command': command, 'exit_code': p.returncode,
                     'input_sha256': hashlib.sha256(data).hexdigest() if data is not None else None,
                     'output_sha256': hashlib.sha256(p.stdout).hexdigest(),
                     'stderr_sha256': hashlib.sha256(p.stderr).hexdigest()})
    assert p.returncode == 0
    return p.stdout
head = git(['rev-parse', 'HEAD'], 'head').decode().strip()
index = Path(git(['rev-parse', '--git-path', 'index'], 'index-path').decode().strip())
if not index.is_absolute(): index = R / index
index_before = m.digest(index)
assert git(['rev-parse', '--show-object-format'], 'object-format').strip() == b'sha1'
status = m.parse_status(git(['status', '--porcelain=v1', '-z', '--untracked-files=all'], 'status'))
selected = {}; expanded = []; omitted = []
session_prefix = S.relative_to(R).as_posix() + '/'
for entry in status:
    path = entry['path']; action, reason = m.disposition(path, policy)
    followup = action == 'exclude' and reason == 'unowned or newly unreviewed path' and (
        path.startswith(session_prefix + 'audits/') or
        (path.startswith(session_prefix + 'unblock-nine-') and '/' not in path[len(session_prefix):]))
    if action != 'select' and not followup:
        omitted.append({'path': path, 'reason': reason}); continue
    p = R / path
    assert m.safe_name(path) and not any(x in path for x in ('\n', '\r', '"'))
    if not p.is_file() or p.is_symlink() or p.stat().st_size >= 90000000:
        omitted.append({'path': path, 'reason': 'not a regular sub-90MB file'}); continue
    selected[path] = 'policy-selected' if action == 'select' else 'new-session-evidence-attribute-check-only'
    if followup: expanded.append(path)
paths = sorted(selected)
attribute_data = git(['check-attr', '-z', '--stdin', 'text', 'eol', 'filter', 'working-tree-encoding'], 'attributes',
                     b''.join(x.encode() + b'\0' for x in paths)).split(b'\0')
attributes = {}
for i in range(0, len(attribute_data) - 1, 3):
    path, name, value = [x.decode('utf-8') for x in attribute_data[i:i+3]]
    attributes.setdefault(path, {})[name] = value
assert set(attributes) == set(paths)
before = {}
for path in paths:
    data = (R / path).read_bytes()
    before[path] = {'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data),
                    'raw_git_blob': hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest(),
                    'crlf_count': data.count(b'\r\n')}
hashes = git(['hash-object', '--stdin-paths'], 'filtered-hashes', ('\n'.join(paths) + '\n').encode()).decode().splitlines()
assert len(hashes) == len(paths)
differences = []; unstable = []; records = []
for path, filtered in zip(paths, hashes):
    entry = {'path': path, 'scope': selected[path], **before[path], 'attributes': attributes[path],
             'filtered_git_blob': filtered, 'would_change_bytes': filtered != before[path]['raw_git_blob']}
    entry['same_bytes_after'] = m.digest(R / path) == before[path]['sha256']
    if not entry['same_bytes_after']: unstable.append(path)
    if entry['would_change_bytes']: differences.append(entry)
    records.append(entry)
# Find literal FileRef-style hash references only in selected/new-session JSON evidence.
# This is a scoped index, not an exhaustive claim about all reference formats.
references = {}
for path in paths:
    if not path.endswith('.json') or before[path]['bytes'] > 20000000: continue
    try: value = json.loads((R / path).read_bytes())
    except (ValueError, UnicodeError): continue
    stack = [value]
    while stack:
        x = stack.pop()
        if isinstance(x, dict):
            if isinstance(x.get('path'), str) and isinstance(x.get('sha256'), str):
                target = x['path'].replace('\\', '/')
                root_native = str(R).replace('\\', '/')
                if target.startswith(root_native + '/'): target = target[len(root_native) + 1:]
                if target in before and x['sha256'] == before[target]['sha256']:
                    references.setdefault(target, set()).add(path)
            stack.extend(x.values())
        elif isinstance(x, list): stack.extend(x)
for entry in records:
    entry['exact_FileRef_sources'] = sorted(references.get(entry['path'], []))
index_after = m.digest(index)
head_after = git(['rev-parse', 'HEAD'], 'head-after').decode().strip()
result = {'schema': 1, 'scope': 'Read-only live publication attribute snapshot; no staging or completeness claim',
          'created_at_utc': datetime.now(timezone.utc).isoformat(), 'head_before': head, 'head_after': head_after,
          'index_sha256_before': index_before, 'index_sha256_after': index_after,
          'policy_sha256': m.digest(policy_path), 'helper_sha256': m.digest(Path(__file__)),
          'counts': {'checked_files': len(paths), 'policy_selected': sum(x == 'policy-selected' for x in selected.values()),
                     'additional_new_session_evidence': len(expanded),
                     'files_with_CRLF': sum(x['crlf_count'] > 0 for x in records),
                     'exact_FileRef_targets': len(references), 'normalization_differences': len(differences)},
          'differences': differences, 'unstable_paths': unstable, 'records': records,
          'additional_readonly_scope': expanded, 'omitted': omitted, 'commands': commands,
          'attributes_sources': [{'path': p.relative_to(R).as_posix(), 'sha256': m.digest(p)} for p in (R / '.gitattributes', S / '.gitattributes')],
          'git_object_writes': 0, 'staging_operations': 0, 'attribute_changes': 0,
          'limits': 'FileRef lookup recognizes exact path/sha256 pairs in JSON up to20MB only. Git filtering was checked for every selected regular file regardless of detected reference. Live audit files may change after this snapshot.'}
(out / 'report.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({'report_sha256': m.digest(out / 'report.json'), 'counts': result['counts'],
                  'differences': [{'path': x['path'], 'attributes': x['attributes'], 'FileRef_count': len(x['exact_FileRef_sources'])} for x in differences],
                  'unstable_paths': unstable, 'head_index_unchanged': head == head_after and index_before == index_after}, indent=2))
