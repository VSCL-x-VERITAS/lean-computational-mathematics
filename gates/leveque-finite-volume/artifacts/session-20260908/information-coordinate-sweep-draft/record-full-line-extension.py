from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;S=P.parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
old=S/'returned-field-coordinate-sweep-draft/Specializations.lean.fragment'
assert sha(old)=='41d6d5c2cf1878755a5e8817422ec545e35e9eab3cbfce68a1fb1dbc79f268a6'
t=old.read_text(encoding='utf-8');a=t.index('variable {laws :');b=t.index('/-- Reuse the actual stationary')
prior=('namespace NumStability.InformationCoordinateSweepDraft\n\nopen TensorLinesDraft MeasureTheory\nopen scoped BigOperators\n\nvariable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}\n\n'+t[a:b].replace('RiemannFieldFluxMethod','RiemannInformationFluxMethod')+'\nend NumStability.InformationCoordinateSweepDraft\n').encode()
assert hashlib.sha256(prior).hexdigest()=='601ced140601f6e4af8babed1032fc9af693a4554fb5cf960acf7a9deb6fa6ea'
assert (P/'full02-input.lean').read_bytes().count(prior)==1
p=P/'Cartesian-before-full-line.fragment';assert not p.exists();p.write_bytes(prior)
helpers=[]
for name in ['freeze','verify']:
 src=P/(name+'.py');dest=P/(name+'-final.py');assert not dest.exists()
 data=src.read_text().replace('==34','==37').replace('=34','=37');dest.write_bytes(data.encode())
 helpers.append(dict(source=bind(src),derived=bind(dest)))
record=dict(schema=1,prior_cartesian=bind(p),prior_successful_input=bind(P/'full02-input.lean'),prior_native_receipt=bind(P/'full02-exit.json'),extension_start=bind(P/'Cartesian.lean.fragment'),changes=['Add areaWeightedRule and actual arbitrary-full-line Cartesian line-update correspondence.','Express guarded information rules as area-weighted unweighted rules with explicitly rescaled off-domain fallback.','Derive admitted information line restriction from the generic correspondence.','No reconstruction algorithm, consistency-to-accuracy inference, or source convention.'],helpers=helpers)
out=P/'full-line-extension.json';assert not out.exists();out.write_bytes((json.dumps(record,indent=2)+'\n').encode());print(bind(out))
