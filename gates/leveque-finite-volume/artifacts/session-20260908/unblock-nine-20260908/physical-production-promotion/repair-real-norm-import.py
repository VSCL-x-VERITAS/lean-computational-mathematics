"""Record the actual direct-import repair without rewriting placement/build history."""
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

placement = P / 'owner-placement-01/receipt.json'
assert sha(placement) == '73c9027cfd4f55e272ddf56dc545a82195651b90401da3f0c2e3ac6b88a3188b'
failed = P / 'owners-native-01-receipt.json'
assert sha(failed) == 'd7dbb7913e4a2affb68b3124234325e30d0dfa46024e4128927b7ddd64a8bcf4'
failure = json.loads(raw(failed))
assert failure['actual_exit_code'] == 1 and failure['sources_unchanged']
original = json.loads(raw(placement))
files = original['actual_changed_files']
for item in files:
    assert sha(R / item['path']) == item['after_sha256']
target = R / files[0]['path']
assert target.name == 'FiniteLineCoordinates.lean'
before = raw(target)
needle = b'import Mathlib.Analysis.Normed.Group.Constructions\n'
assert before.count(needle) == 1
after = before.replace(needle, needle + b'import Mathlib.Analysis.Normed.Group.Real\n')
out = P / 'real-norm-import-repair-01'
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
    'repair': {'path': files[0]['path'], 'before_sha256': hashlib.sha256(before).hexdigest(),
               'after_sha256': hashlib.sha256(after).hexdigest(),
               'reason': 'The extracted coordinate module needs the direct Real norm instance import; no declarations or proof terms changed.'},
    'snapshots': [pin(out / 'before.lean'), pin(out / 'after.lean')],
    'runner': pin(Path(__file__)),
    'source_acceptance': False,
}
put(out / 'receipt.json', (json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(pin(out / 'receipt.json'), indent=2))
