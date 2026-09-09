"""Root's exact rendered-helper review; no audit, installation or gate mutation."""
from pathlib import Path
import ast
import hashlib
import json
import os

assert os.name != 'nt', 'Use the prepared POSIX launcher'
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').exists())
sha = lambda b: hashlib.sha256(b).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p.read_bytes())}
def read(pin):
    path = R / pin['path']
    raw = path.read_bytes()
    assert sha(raw) == pin['sha256'], pin['path']
    return raw
manifest_path = P / 'suite/actual-render-01/manifest.json'
assert sha(manifest_path.read_bytes()) == '8906052ebcd027fc8f473825f780e98f7647e22b4c68681b439e8014b913e5cb'
m = json.loads(manifest_path.read_bytes())
assert len(m['derivations']) == 7
for item in m['derivations']:
    text = read(item['parent']).decode()
    for replacement in item['replacements']:
        assert text.count(replacement['before']) == 1
        text = text.replace(replacement['before'], replacement['after'])
    assert text.encode() == read(item['staged_file'])
    assert item['staged_file']['sha256'] == item['proposed_installed_ref']['sha256']
    assert not (R / item['proposed_installed_ref']['path']).exists()
    ast.parse(text)
dd = m['dependency_derivation']
before = json.loads(read(dd['parent']))
after = json.loads(read(dd['staged_file']))
assert {k for k in before if before[k] != after[k]} == {'audit_validator', 'validator_dependencies', 'producer', 'source_context_protocol_inputs'}
assert after['validator_dependencies'][1:] == before['validator_dependencies']
assert after['source_context_protocol_inputs'][:len(before['source_context_protocol_inputs'])] == before['source_context_protocol_inputs']
assert not (R / dd['proposed_installed_ref']['path']).exists()
for pin in m['compiler_environment_inputs']:
    read(pin)
for name, expected in [('runtime-receipt.json', 'f8c5e049561703b9213d03dfd5561909bfadcf3d2388fd3a0f875a5850f9fa6a'),
                       ('spec-01/audit-spec.json', 'f050bb7c1480b80b9f36c2b730f543ecfc825f0ef1e6b7d708af666a8bc53da8'),
                       ('spec-01/preflight.json', 'b274916c63d25fed697f9958bc0efe312d22043aa0890c4dc16c4dd9882de5bf')]:
    assert sha((P / name).read_bytes()) == expected
runtime = json.loads((P / 'runtime-receipt.json').read_bytes())
assert runtime['actual_fixture_exit_codes'] == [0, 0, 0, 0, 0]
gate = R / 'gates/leveque-finite-volume/chapter-01.json'
assert sha(gate.read_bytes()) == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
note = P / 'ROOT-ADOPTION.md'
with note.open('x', encoding='utf-8', newline='\n') as f:
    f.write('''Root adopts the exact production runtime and eight new helper/dependency paths in actual-render-01. Review covered the adapter, native environment capture, actual 42-module production order, compiler extension, exact preparer and qualified-support changes, downstream pin cascade, native positive/negative dossier diagnostics, successful POSIX adapter fixture and successful spec preflight. The old branches, declared source interpretation, target, original predecessor, sealed validators and acceptance rules remain intact. All seven Python renderings were independently reconstructed from the pinned parents using their exact listed replacements, and every old dependency/protocol entry was retained.

The supported command uses the pinned native Lean executable, the actual three Mathlib package options for the two exact sources, and a complete temporary compiled dependency prefix. Every writable cached artifact is detached before compilation. The adapter records native execution before postchecks, requires all 42 fresh production snapshots before the final dossier, and rechecks canonical inputs. The three-source fixture establishes the runtime mechanism; the actual complete production preparation is still required.

The raw full environment capture and the separately named private failure stdout remain private local evidence. No source verdict or operator authority is supplied by this coordinator review. Install only the exact new helper bytes, run the unchanged official preparation through the reviewed wrapper, measure actual role inputs, then run the independent semantic roles. Preserve every prior failure and require a real accepted decision before binding a row.
''')
receipt = P / 'root-adoption-receipt.json'
with receipt.open('x', encoding='utf-8', newline='\n') as f:
    json.dump({'kind': 'root-exact-package-runtime-suite-adoption', 'review': ref(note),
        'rendered_manifest': ref(manifest_path), 'runtime': ref(P / 'runtime-receipt.json'),
        'spec_preflight': ref(P / 'spec-01/preflight.json'), 'gate_unchanged': ref(gate),
        'reconstructed_python_helpers': 7, 'old_dependencies_retained': True,
        'installation_run': False, 'official_preparation_run': False}, f, indent=2)
    f.write('\n')
print(json.dumps(ref(receipt)))
