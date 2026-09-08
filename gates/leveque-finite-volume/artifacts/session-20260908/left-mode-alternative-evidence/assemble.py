"""Compose an immutable reused domain draft and separate new fixture evidence."""
from pathlib import Path
import hashlib,json,os
D=Path(__file__).resolve().parent
R=D.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bound(p):return {'path':os.path.relpath(p,R).replace('\\','/'),'sha256':sha(p)}
source=D.parent/'left-mode-domain-draft/candidate.lean'
assert sha(source)=='6084110138b1c51ef783797a1dfe442ef9dbd5985daaa5919610e665cd9de92e'
prefix=b'import Mathlib.Analysis.Calculus.Deriv.Abs\nimport Mathlib.Analysis.Calculus.ContDiff.Operations\n\n'
fragment=D/'Fixtures.lean.fragment'
candidate=D/'Candidate.lean'
candidate.write_bytes(prefix+source.read_bytes()+fragment.read_bytes())
assert source.read_bytes() in candidate.read_bytes()
receipt=D/'assembly.json'
if not receipt.exists():
    receipt.write_text(json.dumps({'reused_source':bound(source),'frozen_receipt':bound(source.parent/'final-receipt.json'),
       'composition':'Additional imports + exact frozen candidate bytes + separate fixture fragment.',
       'pending_interpretation_call':'call_ctzCZ7YK8zbx2yUzmX59YBdC','adoption':'not_authorized'},indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'candidate':bound(candidate),'new_fixture':bound(fragment),'exact_reused_source':bound(source)}))
