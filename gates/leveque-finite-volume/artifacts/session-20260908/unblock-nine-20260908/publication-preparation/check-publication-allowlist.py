"""Read-only changed-path screening and proposed allowlist; never stages or certifies completeness."""
from pathlib import Path, PurePosixPath
from datetime import datetime, timezone
import argparse
import gzip
import hashlib
import json
import os
import re
import stat
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SESSION = 'gates/leveque-finite-volume/artifacts/session-20260908/'
GIT = ['git', '--no-optional-locks', '-c', 'core.longpaths=true', '-c', 'diff.autoRefreshIndex=false']

def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''): h.update(chunk)
    return h.hexdigest()

def safe_name(name):
    p = PurePosixPath(name)
    return bool(name) and not p.is_absolute() and '\\' not in name and ':' not in name and not any(x in ('', '.', '..') for x in name.split('/'))

def disposition(path, policy):
    if not safe_name(path): return 'hold', 'unsafe relative path'
    if path in policy['exclude_exact']: return 'exclude', policy['exclude_exact'][path]
    if any(path.startswith(x) for x in policy['exclude_prefixes']): return 'exclude', 'unowned preexisting prefix'
    if any(part in policy['generated_cache_parts'] for part in PurePosixPath(path).parts) or any(path.endswith(x) for x in policy['generated_cache_suffixes']):
        return 'hold', 'generated cache; preserve locally, explicit review required'
    if path in policy['allow_exact']: return 'select', 'explicit owned file'
    if any(path.startswith(x) for x in policy['allow_prefixes']): return 'select', 'owned evidence prefix; historical attempts retained'
    return 'exclude', 'unowned or newly unreviewed path'

def parse_status(data):
    chunks = data.split(b'\0'); records = []; i = 0
    while i < len(chunks) and chunks[i]:
        item = chunks[i]; i += 1
        status = item[:2].decode('ascii'); path = item[3:].decode('utf-8')
        record = {'path': path, 'status': status}
        if 'R' in status or 'C' in status:
            record['original_path'] = chunks[i].decode('utf-8'); i += 1
        records.append(record)
    return records

def verify_policy(policy):
    expected = {'schema', 'scope', 'snapshot_head', 'path_discovery', 'allow_exact', 'allow_prefixes',
                'exclude_exact', 'exclude_prefixes', 'generated_cache_suffixes', 'generated_cache_parts',
                'size_limit_bytes', 'archives', 'notes'}
    assert set(policy) == expected and policy['schema'] == 1
    assert policy['size_limit_bytes'] == 90000000
    for key in ('allow_exact', 'allow_prefixes', 'exclude_prefixes'):
        assert len(policy[key]) == len(set(policy[key]))
        assert all(safe_name(x.rstrip('/')) for x in policy[key])
    assert all(p.endswith('/') for p in policy['allow_prefixes'] + policy['exclude_prefixes'])
    assert all(safe_name(p) for p in policy['exclude_exact'])
    assert len(policy['archives']) == 2

def main():
    a = argparse.ArgumentParser(description=__doc__)
    a.add_argument('--policy', type=Path, required=True)
    a.add_argument('--policy-sha256', required=True)
    a.add_argument('--label', required=True)
    args = a.parse_args()
    assert os.name != 'nt', 'Run through unchanged native-Python to POSIX launcher'
    assert re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9-]{0,60}', args.label)
    policy_path = args.policy.resolve()
    assert policy_path.is_relative_to(HERE) and digest(policy_path) == args.policy_sha256
    policy = json.loads(policy_path.read_text()); verify_policy(policy)
    out = HERE / ('snapshot-' + args.label); out.mkdir()
    commands = []
    def git(args, name):
        command = GIT + args
        result = subprocess.run(command, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        (out / (name + '.stdout.bin')).write_bytes(result.stdout)
        (out / (name + '.stderr.txt')).write_bytes(result.stderr)
        commands.append({'command': command, 'exit_code': result.returncode,
                         'stdout_sha256': hashlib.sha256(result.stdout).hexdigest(),
                         'stderr_sha256': hashlib.sha256(result.stderr).hexdigest()})
        assert result.returncode == 0
        return result.stdout
    head = git(['rev-parse', 'HEAD'], 'head').decode().strip()
    index = Path(git(['rev-parse', '--git-path', 'index'], 'index-path').decode().strip())
    if not index.is_absolute(): index = ROOT / index
    index_before = digest(index)
    records = parse_status(git(['status', '--porcelain=v1', '-z', '--untracked-files=all'], 'status'))
    indexed = {}
    for item in git(['ls-files', '--stage', '-z'], 'index').split(b'\0'):
        if not item: continue
        metadata, filename = item.split(b'\t', 1)
        mode, oid, stage = metadata.decode('ascii').split()
        indexed.setdefault(filename.decode('utf-8'), []).append({'mode': mode, 'oid': oid, 'stage': stage})
    issues = []; historical = []; archives = []
    for entry in policy['archives']:
        receipt = ROOT / entry['receipt']['path']
        archive = ROOT / entry['archive']['path']
        raw = ROOT / entry['raw']['path']
        assert disposition(entry['archive']['path'], policy)[0] == 'select'
        assert disposition(entry['raw']['path'], policy)[0] == 'exclude'
        assert digest(receipt) == entry['receipt']['sha256']
        assert digest(archive) == entry['archive']['sha256'] and archive.stat().st_size == entry['archive']['bytes']
        h = hashlib.sha256(); count = 0
        with gzip.open(archive, 'rb') as handle:
            for data in iter(lambda: handle.read(1024 * 1024), b''):
                h.update(data); count += len(data)
        assert h.hexdigest() == entry['raw']['sha256'] and count == entry['raw']['bytes']
        assert raw.is_file() and raw.stat().st_size == count
        archives.append({'archive': entry['archive'], 'receipt': entry['receipt'],
                         'decompressed_sha256': h.hexdigest(), 'decompressed_bytes': count,
                         'raw_local_size_matches': True, 'raw_bytes_rehashed': False})
    for record in records:
        path = record['path']; selected, reason = disposition(path, policy)
        record.update(disposition=selected, reason=reason)
        p = ROOT / path
        if selected == 'hold': issues.append({'path': path, 'issue': reason})
        record['index_entries'] = indexed.get(path, [])
        staged = record['status'][0] not in (' ', '?')
        if staged and selected != 'select': issues.append({'path': path, 'issue': 'excluded or held path is already staged'})
        if selected == 'select' and (any(x in record['status'] for x in 'DRCU') or record['status'] in ('AA', 'DD')):
            record['disposition'] = 'hold'; issues.append({'path': path, 'issue': 'deletion, rename, copy or conflict needs explicit review'})
        if not safe_name(path): continue
        try:
            info = p.lstat()
            record['bytes'] = info.st_size
            if info.st_size >= policy['size_limit_bytes']:
                record['at_least_90MB'] = True
                if selected == 'select':
                    record['disposition'] = 'hold'; issues.append({'path': path, 'issue': 'file is at least 90,000,000 bytes'})
            parts = [p, *p.parents]
            linked = any(x.is_symlink() for x in parts if x.is_relative_to(ROOT) and x != ROOT)
            if linked or any(x['mode'] in ('120000', '160000') for x in record['index_entries']) or not stat.S_ISREG(info.st_mode):
                if selected == 'select': record['disposition'] = 'hold'
                issues.append({'path': path, 'issue': 'symlink, gitlink, or nonregular path'})
                continue
            if selected != 'select': continue
            if not p.resolve().is_relative_to(ROOT):
                record['disposition'] = 'hold'; issues.append({'path': path, 'issue': 'resolved path escapes repository'}); continue
            if info.st_size >= policy['size_limit_bytes']: continue
            record['sha256'] = digest(p)
            end = p.stat()
            if (info.st_size, info.st_mtime_ns) != (end.st_size, end.st_mtime_ns):
                record['disposition'] = 'hold'; issues.append({'path': path, 'issue': 'file changed while read'})
            if path.endswith(('.lean', '.lean.fragment', '.lean.snapshot', '.lean.txt')):
                text = p.read_text(encoding='utf-8', errors='replace')
                lines = [i for i, line in enumerate(text.splitlines(), 1) if re.search(r'\b(sorry|admit)\b|^\s*axiom\s', line)]
                if lines:
                    history = {'path': path, 'lines': lines, 'classification': 'historical evidence only; lexical hits may include comments'}
                    if path.startswith('ComputationalMathematics/'):
                        record['disposition'] = 'hold'; issues.append({'path': path, 'issue': 'production lexical placeholder requires review', 'lines': lines})
                    else: historical.append(history)
        except FileNotFoundError:
            record['disposition'] = 'hold' if selected == 'select' else selected
            issues.append({'path': path, 'issue': 'path disappeared or is absent in live snapshot'})
    index_after = digest(index)
    head_after = git(['rev-parse', 'HEAD'], 'head-after').decode().strip()
    if index_before != index_after or head != head_after:
        issues.append({'issue': 'HEAD or index changed concurrently; repeat snapshot before staging'})
    assert digest(policy_path) == args.policy_sha256
    selected_paths = sorted(x['path'] for x in records if x['disposition'] == 'select')
    (out / 'proposed-paths.nul').write_bytes(b''.join(x.encode() + b'\0' for x in selected_paths))
    (out / 'proposed-paths.txt').write_text('\n'.join(selected_paths) + '\n')
    result = {'schema': 1, 'status': 'LIVE_SNAPSHOT_REVIEW_REQUIRED', 'publication_complete': False,
              'created_at_utc': datetime.now(timezone.utc).isoformat(),
              'policy': {'path': policy_path.relative_to(ROOT).as_posix(), 'sha256': args.policy_sha256},
              'helper_sha256': digest(Path(__file__)), 'head_before': head, 'head_after': head_after,
              'index_sha256_before': index_before, 'index_sha256_after': index_after,
              'counts': {k: sum(x['disposition'] == k for x in records) for k in ('select', 'exclude', 'hold')},
              'files': records, 'issues': issues, 'historical_placeholder_hits': historical,
              'archives': archives, 'commands': commands,
              'pathspec_sha256': digest(out / 'proposed-paths.nul'),
              'git_mutations_invoked': 0, 'gate_modified': False,
              'limits': 'Live audit output may continue to change. No current or future completeness or acceptance assertion. Root must review final policy, rerun against frozen paths, and verify final staged bytes.'}
    (out / 'inventory.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'inventory_sha256': digest(out / 'inventory.json'), 'counts': result['counts'],
                      'issues': issues, 'large_files': [{'path': x['path'], 'bytes': x['bytes'], 'disposition': x['disposition']} for x in records if x.get('at_least_90MB')],
                      'historical_placeholder_files': len(historical), 'archives_verified': len(archives)}, indent=2))

if __name__ == '__main__': main()
