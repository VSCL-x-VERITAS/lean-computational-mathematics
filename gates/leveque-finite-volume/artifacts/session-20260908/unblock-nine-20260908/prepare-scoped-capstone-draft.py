from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
first = D / 'ScopedRiemannInformationDraft.lean'
tail = D / 'ScopedRiemannCapstoneTail.lean.txt'
destination = D / 'ScopedRiemannCapstoneDraft.lean'
body = first.read_bytes().replace(
    b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage',
    b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds\n'
    b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage')
with destination.open('xb') as f:
    f.write(body + tail.read_bytes())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
print(json.dumps({'inputs': {str(p): sha(p) for p in (first, tail)}, 'draft_sha256': sha(destination)}))
