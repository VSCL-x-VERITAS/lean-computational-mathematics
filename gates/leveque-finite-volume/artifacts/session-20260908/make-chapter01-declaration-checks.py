"""Generate Lean resolution/axiom commands for current Chapter 1 public theorems."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[4]
source = root / 'ComputationalMathematics/Source/LeVeque/Chapter01'
selected = []
for path in sorted(source.glob('*.lean')):
    for name in re.findall(r'^theorem\s+(leveque01\w+)', path.read_text(encoding='utf-8'), re.M):
        selected.append('NumStability.' + name)
assert selected and len(selected) == len(set(selected))
destination = Path(__file__).resolve().parent / 'chapter01-all-declaration-checks.lean'
lines = ['import ComputationalMathematics.Source.LeVeque.Chapter01', '']
for declaration in sorted(selected):
    lines.extend(['#check ' + declaration, '#print axioms ' + declaration])
destination.write_text('\n'.join(lines) + '\n', encoding='utf-8', newline='\n')
print(f'Generated resolution and axiom checks for {len(selected)} current public source theorems.')
