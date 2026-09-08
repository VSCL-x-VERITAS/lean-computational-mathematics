from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;S=P.parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=S/'returned-field-coordinate-sweep-draft/Specializations.lean.fragment'
assert sha(source)=='41d6d5c2cf1878755a5e8817422ec545e35e9eab3cbfce68a1fb1dbc79f268a6'
t=source.read_text(encoding='utf-8');begin=t.index('variable {laws :');end=t.index('/-- Reuse the actual stationary')
t='''namespace NumStability.InformationCoordinateSweepDraft

open TensorLinesDraft MeasureTheory
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

'''+t[begin:end].replace('RiemannFieldFluxMethod','RiemannInformationFluxMethod')+'\nend NumStability.InformationCoordinateSweepDraft\n'
dest=P/'Cartesian.lean.fragment';assert not dest.exists();dest.write_bytes(t.encode())
p=P/'cartesian-derivation.json';assert not p.exists();p.write_bytes((json.dumps(dict(source=dict(path=source.relative_to(R).as_posix(),sha256=sha(source)),output=dict(path=dest.relative_to(R).as_posix(),sha256=sha(dest)),changes=['Reuse four exact line/measured correspondence proof compositions with the canonical information-only type.','No new geometry or integral definitions; independent native validation remains required.']),indent=2)+'\n').encode())
print(sha(dest))
