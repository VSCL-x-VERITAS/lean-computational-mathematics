"""Record the ContDiffOn direct-import repair without rewriting placement/build history."""
from pathlib import Path
import datetime, hashlib, json, os

P = Path(__file__).resolve().parent
R = P.parents[5]
native = lambda p: '\\\\?\\' + os.path.abspath(p) if os.name == 'nt' else str(p)
def raw(p):
    with open(native(p), 'rb') as stream:
        return stream.read()
def sha(p):
    return hashlib.sha256(raw(p)).hexdigest()
def put(p, data):
    with open(native(p), 'xb') as stream:
        stream.write(data)
def pin(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}

placement = P / 'real-norm-import-repair-01/receipt.json'
assert sha(placement) == '80c8c763b82fa662fb9115970836bf038ffe8b2ec4a42ad81753257a35ac5aaa'
failed = P / 'owners-native-02-receipt.json'
assert sha(failed) == 'b0f90079b0d56f80b1ce67955a7926216f6357808c6f8e9861012825c804363d'
failure = json.loads(raw(failed))
assert failure['actual_exit_code'] == 1 and failure['sources_unchanged']
original = json.loads(raw(placement))
files = original['actual_changed_files']
for item in files:
    assert sha(R / item['path']) == item['after_sha256']
target_item = next(f for f in files if f['path'].endswith('/PhysicalRefinementQuality.lean'))
target = R / target_item['path']
assert target.name == 'PhysicalRefinementQuality.lean'
before = raw(target)
needle = b'import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries\n'
assert before.count(needle) == 1
after = before.replace(needle, b'import Mathlib.Analysis.Calculus.ContDiff.Defs\n' + needle)
out = P / 'contdiff-import-repair-01'
out.mkdir(exist_ok=False)
put(out / 'before.lean', before)
put(out / 'after.lean', after)
with open(native(target), 'wb') as stream:
    stream.write(after)
assert raw(target) == after
current = [{**f, 'after_sha256': sha(R / f['path'])} for f in files]
record = {
    'format': 'physical-owner-current-build-inputs-1',
    'completed_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'actual_changed_files': current,
    'prior_placement': pin(placement),
    'prior_failed_native_build': pin(failed),
    'repair': {'path': target_item['path'], 'before_sha256': hashlib.sha256(before).hexdigest(),
               'after_sha256': hashlib.sha256(after).hexdigest(),
               'reason': 'The extracted quality module needs the direct ContDiffOn definition import; the explicit FTaylorSeries import remains visible to the source scanner. No declarations or proof terms changed.'},
    'snapshots': [pin(out / 'before.lean'), pin(out / 'after.lean')],
    'runner': pin(Path(__file__)),
    'source_acceptance': False,
}
put(out / 'receipt.json', (json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(pin(out / 'receipt.json'), indent=2))
