"""Disambiguate a formula continuation for the unchanged lexical layout scanner."""
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
def pin(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def put(p, data):
    with open(native(p), 'xb') as stream:
        stream.write(data)

build_path = P / 'owners-native-03-receipt.json'
assert sha(build_path) == '662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb'
build = json.loads(raw(build_path))
assert build['actual_exit_code'] == 0 and build['sources_unchanged']
prior_path = P / 'contdiff-import-repair-01/receipt.json'
assert sha(prior_path) == '75ab37a8614f92ef18099bc779628a98911616acece412ed08994dd45687c2cb'
files = json.loads(raw(prior_path))['actual_changed_files']
for item in files:
    assert sha(R / item['path']) == item['after_sha256']
layout_path = P.parent.parent / 'unblock-nine-physical-current-layout-exit.json'
layout = json.loads(raw(layout_path))
assert layout['exit_code'] == 1 and layout['output_sha256'] == '55b727ab9806a5bf3f89e4231d078f9f84073f2af31bdb53e86b0752c68ba96d'
layout_output = layout_path.with_name('unblock-nine-physical-current-layout-output.txt')
assert sha(layout_output) == layout['output_sha256']
target_item = next(f for f in files if f['path'].endswith('/PhysicalRefinementQuality.lean'))
target = R / target_item['path']
before = raw(target)
needle = b'      constant * dt * family.mesh n ^ p\n'
assert before.count(needle) == 1
after = before.replace(needle, b'      (constant * dt * family.mesh n ^ p)\n')
out = P / 'layout-rhs-parentheses-01'
out.mkdir(exist_ok=False)
put(out / 'before.lean', before)
put(out / 'after.lean', after)
with open(native(target), 'wb') as stream:
    stream.write(after)
assert raw(target) == after
record = {'format': 'physical-owner-current-build-inputs-1',
    'completed_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'actual_changed_files': [{**f, 'after_sha256': sha(R / f['path'])} for f in files],
    'prior_current_manifest': pin(prior_path), 'prior_successful_build': pin(build_path),
    'actual_layout_failure': pin(layout_path), 'layout_output': pin(layout_output),
    'repair': {'path': target_item['path'], 'before_sha256': hashlib.sha256(before).hexdigest(),
        'after_sha256': hashlib.sha256(after).hexdigest(),
        'reason': 'Parenthesize the complete error-bound RHS so the continuation does not resemble a constant declaration to the lexical scanner. This is the same expression and the same public names. No validator, axiom, assumption, or mathematical definition is changed.'},
    'snapshots': [pin(out / 'before.lean'), pin(out / 'after.lean')],
    'runner': pin(Path(__file__)), 'current_native_verification_pending': True,
    'source_acceptance': False}
put(out / 'receipt.json', (json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(pin(out / 'receipt.json'), indent=2))
