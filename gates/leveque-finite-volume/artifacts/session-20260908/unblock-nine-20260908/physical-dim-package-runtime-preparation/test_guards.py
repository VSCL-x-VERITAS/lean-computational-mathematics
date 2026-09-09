"""Pure guard fixtures; no Lean execution, released code, or audit task writes."""
from pathlib import Path
import hashlib
import importlib.util
import json
import os
import tempfile
from types import SimpleNamespace
from unittest.mock import patch
P = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('runtime', P / 'lean_runtime.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
checks = []
def reject(label, action):
    try:
        action()
    except ValueError as error:
        checks.append({'name': label, 'pass': True, 'reason': str(error)})
    else:
        raise AssertionError(label)
def ok(label, condition):
    assert condition, label
    checks.append({'name': label, 'pass': True})

with tempfile.TemporaryDirectory(prefix='formalization-faithfulness-unit-') as directory:
    root = Path(directory).resolve()
    source = root / 'A.lean'
    source.write_text('theorem fixture : True := True.intro\n')
    output = source.with_suffix('.olean')
    item = {'module': 'A', 'relative_source': 'A.lean', 'source': {'path': 'A.lean', 'sha256': m.sha(source)}}
    descriptor = {'expected_compiles': [item], 'artifacts': []}
    args = ['--root', str(root), '-o', str(output), str(source)]
    state = {'compiled': []}
    with patch.object(m, 'bound', lambda ref: source):
        op = m.compile_input(args, root, descriptor, state)
        ok('ordinary compile receives no Mathlib options', op['options'] == [])
        reject('unexpected extra compile', lambda: m.compile_input(args, root, descriptor, {'compiled': [{}]}))
        bad = dict(descriptor, expected_compiles=[dict(item, relative_source='Other.lean')])
        reject('compile order mismatch', lambda: m.compile_input(args, root, bad, state))
        bad = dict(descriptor, expected_compiles=[dict(item, source={'path': 'A.lean', 'sha256': '0'*64})])
        reject('snapshot hash mismatch', lambda: m.compile_input(args, root, bad, state))
        reject('output escape', lambda: m.compile_input(['-o', str(root.parent / 'A.olean'), str(source)], root, descriptor, state))
        output.write_bytes(b'not an initialized hardlink')
        reject('existing non-hardlink output', lambda: m.compile_input(args, root, descriptor, state))
        output.unlink()
        original = root / 'original.olean'
        original.write_bytes(b'original compiled bytes')
        os.link(original, output)
        linked = dict(descriptor, artifacts=[{'overlay': 'A.olean', 'path': str(original)}])
        m.compile_input(args, root, linked, state)
        ok('temporary hardlink detached', not output.exists())
        ok('original hardlink bytes preserved', original.read_bytes() == b'original compiled bytes')
    reject('missing expected snapshot', lambda: m.verify_fresh(state, descriptor, root))
    output.write_bytes(b'fresh')
    valid = {'compiled': [{'module': 'A', 'outputs': [{'path': str(output), 'sha256': m.sha(output)}]}]}
    m.verify_fresh(valid, descriptor, root)
    ok('complete exact snapshot accepted', True)
    output.write_bytes(b'changed')
    reject('fresh output changed', lambda: m.verify_fresh(valid, descriptor, root))
    post = {}
    m.finish_execution(SimpleNamespace(returncode=7), None, state, descriptor, root, root/'state', 'record', post, False)
    ok('failed native exit does not fabricate successful outputs', post == {'completed': True} and not state['compiled'])

receipt = {'status': 'PURE-GUARDS-PASSED', 'adapter_sha256': m.sha(P/'lean_runtime.py'), 'checks': checks, 'count': len(checks)}
with (P/'guard-test-receipt.json').open('x', encoding='utf-8') as stream:
    stream.write(json.dumps(receipt, indent=2)+'\n')
print(json.dumps(receipt))
