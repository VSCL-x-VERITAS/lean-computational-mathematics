"""Freeze only a successful exact native composition check."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,sys
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def binding(p):return dict(path=str(p),sha256=sha(p))
label=sys.argv[1];assert re.fullmatch('[a-z0-9-]+',label)
native=json.loads((P/(label+'-exit.json')).read_bytes())
assert native['exit_code']==0 and native['inputs_unchanged'] and native['exact_frozen_base']
source=P/(label+'-input.lean');out=P/(label+'-output.txt')
assert sha(source)==native['assembled_input_sha256'] and sha(out)==native['output_sha256']
base=S/'dimensional-splitting-lines-draft/final-05-input.lean'
fragment=P/'Composition.lean.fragment'
prefix=b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep\n\n'
assert source.read_bytes().startswith(prefix+base.read_bytes()+b'\n\n'+fragment.read_bytes()+b'\n\n')
for path,digest in (native['input_files']|native['compiled_imports']).items():assert sha(R/path)==digest,path
output=out.read_text(encoding='utf-8')
assert not re.search(r'\b(?:error|warning):|\bsorryAx\b',output)
axioms={}
for name in native['checked_declarations']:
 assert re.search('^'+re.escape(name)+r'(?:\.|\s|:)',output,re.M),name
 match=re.search("'"+re.escape(name)+r"' depends on axioms: \[(.*?)\]",output,re.S)
 if match:actual=[x.strip() for x in re.sub(r'\.\{[^}]*\}','',match[1]).split(',') if x.strip()]
 else:
  assert "'"+name+"' does not depend on any axioms" in output,name
  actual=[]
 assert set(actual)<={'propext','Classical.choice','Quot.sound'},(name,actual)
 axioms[name]=actual
assert len(axioms)==24
code=re.sub(r'/\-.*?\-/','',fragment.read_text(encoding='utf-8'),flags=re.S)
assert not re.search(r'\b(?:sorry|admit|axiom|unsafe)\b',code)
reuse=json.loads((P/'reuse-provenance.json').read_bytes())
for row in reuse['inputs']:assert sha(R/row['path'])==row['sha256'],row['path']
support={str(R/x):h for x,h in (native['input_files']|native['compiled_imports']).items()}
support.update({str(R/x['path']):x['sha256'] for x in reuse['inputs']})
for exe in ['lean.exe','lake.exe']:
 p=Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin')/exe
 support[str(p)]=sha(p)
local=[p for p in sorted(P.iterdir()) if p.is_file() and p.name!='final-receipt.json']
record=dict(frozen_at_utc=datetime.now(timezone.utc).isoformat(),
 scope='Scratch Cartesian composition only. No source interpretation, source wrapper, audit, production, gate or topology change.',
 fragment_sha256=sha(fragment),native_input_sha256=sha(source),native_output_sha256=sha(out),
 native_exit_code=0,checked_declarations=24,actual_axioms=axioms,no_warnings=True,
 exact_frozen_base=True,retained_attempts=[p.name for p in sorted(P.glob('*-exit.json'))],
 artifacts=[binding(p) for p in local],
 support=[dict(path=x,sha256=h) for x,h in sorted(support.items())],
 pending_interpretation='call_axfTXsEjNKG3lawf5Dq10qQv',remaining_running_sessions=[])
receipt=P/'final-receipt.json';assert not receipt.exists()
receipt.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(dict(receipt_sha256=sha(receipt),fragment_sha256=sha(fragment),native_output_sha256=sha(out),checks=24)))
