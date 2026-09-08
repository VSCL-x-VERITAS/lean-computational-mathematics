"""Freeze actual native results; no source acceptance is inferred."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return {'path':str(p),'sha256':sha(p)}
candidate=(P/'Candidate.lean').read_bytes();checks=(P/'Checks.lean').read_bytes()
decl=json.loads((P/'declarations.json').read_bytes())
native=json.loads((P/'final-checks-exit.json').read_bytes())
assert checks.startswith(candidate+b'\n')
assert sha(P/'Candidate.lean')==decl['candidate_sha256']
assert sha(P/'Checks.lean')==decl['checks_sha256']
assert native['exit_code']==0 and native['inputs_unchanged']
assert sha(P/'final-checks-output.txt')==native['output_sha256']
for path,digest in native['input_sha256'].items():assert sha(R/path)==digest,path
output=(P/'final-checks-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(?:warning|error):',output)
axioms={}
for name in decl['declarations']:
 assert re.search('^'+re.escape(name)+r'(?:\.|\s|:)',output,re.M),name
 match=re.search("'"+re.escape(name)+r"' depends on axioms: \[(.*?)\]",output,re.S)
 if match:
  raw=re.sub(r'\.\{[^}]*\}','',match[1])
  actual=[x.strip() for x in raw.split(',') if x.strip()]
 else:
  assert "'"+name+"' does not depend on any axioms" in output,name
  actual=[]
 assert set(actual)<={'propext','Classical.choice','Quot.sound'},(name,actual)
 axioms[name]=actual
code=re.sub(r'/\-.*?\-/','',candidate.decode(),flags=re.S)
assert not re.search(r'\b(?:sorry|admit|axiom|unsafe)\b',code)
support=[R/x for x in native['input_sha256'] if '/heterogeneous-volume-average-draft/' not in x]
support += [
 R/'.lake/build/lib/lean/ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.olean',
 R/'.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/MeasureTheory/Integral/Average.olean',
 R/'.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.olean',
 R/'.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.olean',
 Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin/lean.exe'),
 Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin/lake.exe')]
local=[p for p in sorted(P.iterdir()) if p.is_file() and p.name not in ['final-receipt.json']]
record=dict(created_at_utc=datetime.now(timezone.utc).isoformat(),
 scope='Scratch-only normalized-volume alternative. No interpretation adoption or source acceptance.',
 native_exit_code=0,checked_declarations=len(axioms),axioms=axioms,
 exact_candidate_prefix=True,no_warnings=True,no_placeholders=True,
 pending_interpretation_question='call_1JnoPOtxdApI1F5hUmt5F9Q7',
 artifacts=[bind(p) for p in local],support=[bind(p) for p in support])
out=P/'final-receipt.json';assert not out.exists()
out.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(dict(receipt_sha256=sha(out),candidate_sha256=sha(P/'Candidate.lean'),
 output_sha256=native['output_sha256'],checked_declarations=len(axioms))))
