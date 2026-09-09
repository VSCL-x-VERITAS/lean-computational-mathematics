"""Repair the one casefold-order finding, preserving the exact import set."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
assert os.name != 'nt', 'Use POSIX for worktree Git.'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
F = D / 'analysis-casefold-order-repair'
F.mkdir()
path = R / 'ComputationalMathematics/Analysis.lean'
assert sha(path) == '17639d25ac0b0c097990cc921d528ccb3bd52b8b6503a8b01a61c2afd1f08a9c'
layout = S / 'unblock-nine-final-current-layout-exit.json'
assert json.loads(layout.read_bytes())['exit_code'] == 1
raw = path.read_bytes()
prefix = b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.'
wrong = prefix + b'CFLUnitShift\n' + prefix + b'CellVolumeAverage\n'
right = prefix + b'CellVolumeAverage\n' + prefix + b'CFLUnitShift\n'
assert raw.count(wrong) == 1
fixed = raw.replace(wrong, right)
imports = lambda data: [line for line in data.decode().splitlines() if line.startswith('import ')]
before_imports = imports(raw)
after_imports = imports(fixed)
assert sorted(before_imports) == sorted(after_imports)
assert after_imports == sorted(set(after_imports), key=str.casefold)
assert len(raw) == len(fixed)
git = lambda *args: subprocess.check_output(['git', '-c', 'core.longpaths=true', *args], cwd=R)
head = git('rev-parse', 'HEAD').decode().strip()
assert head == '5e3f63594aa964263469ada134aee2809559d50d'
assert git('show', ':ComputationalMathematics/Analysis.lean') == raw
with (F / 'before.lean.snapshot').open('xb') as stream:
    stream.write(raw)
path.write_bytes(fixed)
git('add', '--', 'ComputationalMathematics/Analysis.lean')
assert git('show', ':ComputationalMathematics/Analysis.lean') == fixed
record = {'format': 'analysis-casefold-order-repair-1', 'input_commit': head,
    'before': ref(F / 'before.lean.snapshot'), 'after': ref(path), 'runner': ref(Path(__file__)),
    'trigger': ref(layout), 'change': 'Swap only CellVolumeAverage and CFLUnitShift imports to satisfy str.casefold ordering.',
    'same_import_set': True, 'casefold_sorted': True, 'declaration_bodies_changed': False,
    'reviewer': 'Codex root; exact two-line import-only change reviewed before execution',
    'fresh_layout_and_affected_build_graph_checks_required': True}
with (F / 'receipt.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
