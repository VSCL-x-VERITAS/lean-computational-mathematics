"""After coordinator commit, bind unchanged native fingerprint/source bytes to it.

Read-only POSIX Git. Writes only an additive receipt within this evidence folder.
This never changes the native input_commit or claims a native rerun at the later commit.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse, hashlib, json, os, re, subprocess

F = Path(__file__).resolve().parent
R = F.parents[5]
sha = lambda data: hashlib.sha256(data).hexdigest()

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--commit', required=True)
    p.add_argument('--label', required=True)
    a = p.parse_args()
    assert os.name != 'nt', 'Use the prepared POSIX launcher'
    assert re.fullmatch('[0-9a-f]{40}', a.commit)
    assert re.fullmatch('[A-Za-z0-9][A-Za-z0-9-]{0,79}', a.label)
    dest = F / ('committed-source-verification-' + a.label + '.json')
    assert not dest.exists()
    git = lambda *args: subprocess.check_output(['git', '--no-replace-objects', '-c', 'core.longpaths=true', *args], cwd=R)
    assert git('rev-parse', a.commit + '^{commit}').decode().strip() == a.commit
    additional_path = F / 'additional-expression-fingerprints.json'
    additional_raw = additional_path.read_bytes()
    additional = json.loads(additional_raw)
    old_ref = additional['prior_fingerprints']
    old_raw = (R / old_ref['path']).read_bytes()
    assert sha(old_raw) == old_ref['sha256']
    old = json.loads(old_raw)
    subprocess.run(['git', '--no-replace-objects', 'merge-base', '--is-ancestor', additional['input_commit'], a.commit], cwd=R, check=True)
    refs = [{'path': additional_path.relative_to(R).as_posix(), 'sha256': sha(additional_raw)}, old_ref]
    refs += additional['files'] + old['files']
    refs += [additional['input_manifest'], additional['native_receipt'], additional['native_output']]
    archive_receipt_path = F / 'raw-stream-archive-receipt.json'
    archive_receipt_raw = archive_receipt_path.read_bytes()
    archive_receipt = json.loads(archive_receipt_raw)
    assert archive_receipt['raw_stream'] == additional['native_raw_stream']
    assert archive_receipt['decompressed_sha256'] == additional['native_raw_stream']['sha256']
    refs += [{'path': archive_receipt_path.relative_to(R).as_posix(), 'sha256': sha(archive_receipt_raw)},
             archive_receipt['archive']]
    receipts = []
    for item in refs:
        blob = git('show', a.commit + ':' + item['path'])
        assert sha(blob) == item['sha256'], item['path']
        receipts.append({'path': item['path'], 'sha256': item['sha256'], 'committed_blob_matches': True})
    result = {'schema': 1, 'status': 'PASS', 'verified_at_utc': datetime.now(timezone.utc).isoformat(),
        'commit': a.commit, 'tree': git('rev-parse', a.commit + '^{tree}').decode().strip(),
        'actual_native_input_commit_retained': additional['input_commit'],
        'native_export_rerun_at_verified_commit': False, 'input_commit_is_ancestor': True,
        'committed_records': receipts, 'source_owner_count': len(additional['files']) + len(old['files']),
        'fingerprint_record_count': len(additional['records']) + len(old['records']),
        'scope': 'Exact origin commit blob association only. No source acceptance, gate result, candidate selection or lane mutation.'}
    with dest.open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(result, stream, indent=2); stream.write('\n')
    print(json.dumps({'receipt': dest.relative_to(R).as_posix(), 'sha256': sha(dest.read_bytes()), 'commit': a.commit}))

if __name__ == '__main__': main()
