"""Summarize successful current Chapter 1 native outputs without closing the gate."""
from __future__ import annotations
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--gate-checker', required=True, type=Path)
parser.add_argument('--gate', required=True, type=Path)
args = parser.parse_args()
spec = importlib.util.spec_from_file_location('chapter_gate', args.gate_checker)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)
context = checker.current_context(args.gate.resolve(), 1)
root = context['lean_root']
session = Path(__file__).resolve().parent

def record(name):
    path = session / name
    return {'path': path.relative_to(root).as_posix(),
            'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}

input_path = session / 'chapter01-all-declaration-checks.lean'
output_path = session / 'chapter01-all-declaration-output.txt'
expected = re.findall(r'^#print axioms (\S+)$', input_path.read_text(), re.M)
output = output_path.read_text(encoding='utf-8-sig')
axioms = {}
for name, axiom_list in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", output):
    assert name not in axioms
    axioms[name] = [a.strip() for a in axiom_list.split(',') if a.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms", output):
    assert name not in axioms
    axioms[name] = []
owners_paths = sorted((root / 'ComputationalMathematics/Source/LeVeque/Chapter01').glob('*.lean'))
current_declarations = []
for path in owners_paths:
    current_declarations.extend('NumStability.' + name for name in
        re.findall(r'^theorem\s+(\w+)', path.read_text(encoding='utf-8'), re.M))
assert expected and len(expected) == len(set(expected))
assert set(expected) == set(current_declarations), 'regenerate and rerun checks after source changes'
assert set(expected) == set(axioms)
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
assert all(set(items) <= allowed for items in axioms.values())
assert not re.search(r'(^error:|: error:|sorryAx)', output, re.M)

builds = [
    ('chapter01-build-output.txt', ['lake', 'build',
      'ComputationalMathematics.Source.LeVeque.Chapter01',
      'NumStability.Source.LeVeque.Chapter01']),
    ('chapter01-import-test-output.txt', ['lake', 'build',
      'NumStabilityTest.Import.Canonical.Source.LeVeque',
      'NumStabilityTest.Import.ProjectIdentity.Canonical.LeVeque',
      'NumStabilityTest.Import.ProjectIdentity.Old.LeVeque']),
]
commands = []
for filename, argv in builds:
    text = (session / filename).read_text(encoding='utf-8-sig')
    successes = re.findall(r'Build completed successfully \((\d+) jobs\)\.', text)
    assert len(successes) == 1
    jobs = int(successes[0])
    commands.append({'argv': argv, 'exit_code': 0, 'jobs': jobs, 'output': record(filename)})
commands.append({'argv': ['lake', 'env', 'lean', input_path.relative_to(root).as_posix()],
                 'exit_code': 0, 'input': record(input_path.name), 'output': record(output_path.name)})
owners = {path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
          for path in owners_paths}
payload = {'schema_version': 1, 'scope': 'current Chapter 1 focused Lean checks',
           'bindings': context['bindings'], 'commands': commands,
           'source_owner_sha256': owners, 'resolved_public_theorems': expected,
           'axioms_by_declaration': axioms, 'unexpected_axioms': [],
           'full_library_build': 'not established by this receipt',
           'source_faithfulness': 'requires separate independent audits',
           'gate_mutated': False}
encoded = (json.dumps(payload, indent=2, sort_keys=True) + '\n').encode()
digest = hashlib.sha256(encoded).hexdigest()
destination = session / 'verification-receipts' / (digest + '.json')
destination.parent.mkdir(exist_ok=True)
if destination.exists():
    assert destination.read_bytes() == encoded
else:
    destination.write_bytes(encoded)
print(json.dumps({'receipt': destination.relative_to(root).as_posix(),
                  'sha256': digest, 'resolved': len(expected), 'unexpected_axioms': []}))
