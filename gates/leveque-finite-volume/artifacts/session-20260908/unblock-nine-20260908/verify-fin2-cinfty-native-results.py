"""Verify completed native outputs, including Lean's empty-axiom sentence."""
from pathlib import Path
import hashlib, json, re

D = Path(__file__).resolve().parent
R = D.parent.parents[3]
out = D / 'dim-two-direction-cinfty-replay-02'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
before = json.loads((out / 'before.json').read_bytes())
assert sha(R / before['candidate']['path']) == before['candidate']['sha256']
assert before['candidate']['sha256'] == '48d57797ff3c2074dabb6f72417f4eba54c8131b588dc59cf47d67d9ecc1a6fe'
for path, digest in before['bindings_before'].items():
    assert sha(R / path) == digest, path
steps = []
for name in ['direct-dependencies', 'isolation', 'full-joint']:
    path = out / (name + '-exit.json')
    step = json.loads(path.read_bytes())
    assert step['exit_code'] == 0
    for stream in ['stdout', 'stderr']:
        assert sha(R / step[stream]['path']) == step[stream]['sha256']
    steps.append(ref(path))
assert sha(out / 'isolation-output.txt') == 'ed88acb83e7dac63448c21475960af390122d68669fdf4022985125b051ee0af'
text = (out / 'full-joint-output.txt').read_text(encoding='utf-8')
assert sha(out / 'full-joint-output.txt') == '69580a30866048124eaff3623f4af0fe8a8164140c6a6952c5610816e4caceb2'
assert 'error:' not in text and 'warning:' not in text and 'sorryAx' not in text
expected = [entry['name'] for entry in json.loads((D / 'dim-two-direction-joint-witness/declarations.json').read_bytes())['declarations']]
pattern = r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|(does not depend on any axioms))"
reports = re.findall(pattern, text)
assert len(reports) == len(expected) == 52
assert [name for name, _, _ in reports] == expected
for name, axioms, empty in reports:
    assert set(a.strip() for a in axioms.split(',') if a.strip()) <= {'propext', 'Classical.choice', 'Quot.sound'}
failure = {'parent_actual_exit_code': 1, 'native_full_joint_exit_code': 0,
           'reason': 'The parent postprocessor recognized only depends-on-axioms lists and omitted Lean empty-axiom sentences. No proof or compiled-input failure occurred.',
           'parent_script': ref(D / 'replay-fin2-under-cinfty-overlay-v2.py')}
with (out / 'parent-postprocessing-failure.json').open('xb') as f:
    f.write((json.dumps(failure, indent=2) + '\n').encode())
record = {'format': 'fin2-cinfty-completed-native-verification-1', 'verification_exit_code': 0,
          'native_step_receipts': steps, 'before': ref(out / 'before.json'),
          'parent_failure_retained': ref(out / 'parent-postprocessing-failure.json'),
          'complete_candidate': before['candidate'], 'declarations': 52,
          'empty_axiom_reports': sum(bool(empty) for _, _, empty in reports),
          'bound_files_unchanged': len(before['bindings_before']),
          'overlay': before['overlay_receipt'], 'canonical_placement': False, 'source_acceptance': False,
          'scope': 'Complete unchanged two-direction joint primary application under the exact C-infinity and explicit-choice overlay, with actual measured 16-cell data and both movements. Admission/threshold/general-quality/domain findings remain open.'}
with (out / 'verification.json').open('xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'verification': ref(out / 'verification.json'), 'verification_exit_code': 0, 'native_step_exits': [0, 0, 0], 'declarations': 52}))
