"""Apply the root-reviewed exposure snapshot after actual build, lookup and tracked census."""
from pathlib import Path
import datetime, hashlib, json, os, subprocess

assert os.name == 'posix', 'Use the prepared POSIX launcher'
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
pin = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def read(p):
    return json.loads(p.read_bytes())
snapshot = P / 'snapshot-02'
assert sha(snapshot / 'receipt.json') == '95dcce758cb5bc8de1068d0d33398f8fe7691e4176465e0c2d3692765425b8a7'
receipt = read(snapshot / 'receipt.json')
config = receipt['source_inputs']
census = read(snapshot / 'census-and-bindings.json')
assert not census['selected_not_yet_tracked']
assert census['actual_tracked_modules'] == census['prospective_modules_after_exact_twelve_presence']
assert census['actual_tracked_count'] == 6024
build = P.parent / 'physical-production-promotion/owners-native-03-receipt.json'
assert sha(build) == '662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb'
checked = P.parent / 'physical-canonical-checks/verified-01/receipt.json'
assert sha(checked) == '9a02c5d4eb91932313056f2a2784ab245a7195aded551ff5cfcb79324426e05f'
assert read(checked)['all_reports_permitted']
assert read(build)['actual_exit_code'] == 0
for item in read(build)['input_sources']:
    assert sha(R / item['path']) == item['sha256']
command = ['git', '--no-optional-locks', 'ls-files', '-z', '--',
           'ComputationalMathematics/*.lean', 'ComputationalMathematics.lean',
           'NumStability/*.lean', 'NumStability.lean']
result = subprocess.run(command, cwd=R, capture_output=True)
assert result.returncode == 0
paths = [x.decode() for x in result.stdout.split(b'\0') if x]
assert paths == census['actual_tracked_paths']
updates = []
for key, proposed_key in [('analysis', 'proposed_analysis'), ('tiers', 'proposed_tiers')]:
    target = R / config[key]['path']
    source = R / receipt[proposed_key]['path']
    assert sha(target) == config[key]['sha256']
    assert sha(source) == receipt[proposed_key]['sha256']
    updates.append((target, source, target.read_bytes()))
out = P / 'applied-01'
out.mkdir(exist_ok=False)
review = ('Root reviewed all twelve semantic rationales, the complete Analysis diff, and the '
          'proposal constructor preserving existing rules. The actual staged census equals '
          '6024 modules. All sixteen leaf modules build, and all 169 declarations plus '
          'three narrow import smoke checks pass. The two direct-import repairs are recorded '
          'separately from original placement. This adoption changes organization exposure '
          'only and supplies no source-faithfulness acceptance.\n')
with (out / 'ROOT-ADOPTION.md').open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(review)
changes = []
for target, source, before in updates:
    assert target.read_bytes() == before
    target.write_bytes(source.read_bytes())
    assert sha(target) == sha(source)
    changes.append({'path': target.relative_to(R).as_posix(),
                    'before_sha256': hashlib.sha256(before).hexdigest(),
                    'after_sha256': sha(target), 'proposal': pin(source)})
record = {'format': 'root-reviewed-physical-exposure-application-1',
    'completed_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'changes': changes, 'tracked_census_count': len(paths), 'fresh_census_command': command,
    'fresh_census_actual_exit': result.returncode, 'snapshot': pin(snapshot / 'receipt.json'),
    'native_build': pin(build), 'declaration_validation': pin(checked),
    'root_adoption': pin(out / 'ROOT-ADOPTION.md'), 'runner': pin(Path(__file__)),
    'source_acceptance': False, 'official_validation_pending': True}
with (out / 'receipt.json').open('x', encoding='utf-8', newline='\n') as stream:
    json.dump(record, stream, indent=2)
    stream.write('\n')
print(json.dumps(pin(out / 'receipt.json'), indent=2))
