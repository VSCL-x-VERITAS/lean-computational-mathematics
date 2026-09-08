from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda b:hashlib.sha256(b).hexdigest()
D=S/'discontinuity-general-capstone'
assert sha((D/'final-receipt.json').read_bytes())=='06db27f7742b7f9e6c72ee039c4b66034ad8151407bafcf7d44a5a116530bd6c'
assert sha((D/'input-provenance.json').read_bytes())=='31c7b04c61075516a4387a04e012f7adbbd8c97b1e7a7b8f173c10aeb5cdcf17'
def path(v):
 p=v.replace('\\','/')
 return Path('/'+p[0].lower()+p[2:]) if len(p)>2 and p[1]==':' else Path(p)
verified={}
def walk(v):
 if isinstance(v,dict):
  if 'path' in v and 'sha256' in v:
   p=path(v['path']);b=p.read_bytes();assert sha(b)==v['sha256'],p
   if 'bytes' in v:assert len(b)==v['bytes'],p
   verified[str(p)]=v['sha256']
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
receipt=json.loads((D/'final-receipt.json').read_text())
walk(receipt);walk(json.loads((D/'input-provenance.json').read_text()))
assert receipt['final_check_actual_exit_code']==0 and receipt['historical_actual_exit_codes']=={'first_elaboration':1,'second_elaboration':0}
assert len(receipt['new_declarations'])==7 and len(receipt['declaration_axiom_checks'])==12
for d in receipt['declaration_axiom_checks']:assert set(d['axioms'])<={'propext','Classical.choice','Quot.sound'}
assert (D/'declaration-checks.lean').read_bytes().startswith((D/'candidate.lean').read_bytes())
p=S/'general-discontinuity-root-verification.json';assert not p.exists()
p.write_text(json.dumps({'schema':1,'verified_hashes':verified,'receipt_sha256':sha((D/'final-receipt.json').read_bytes()),'checked_declarations':12,'new_declarations':7,'source_acceptance':'None; original source ambiguity preserved and fresh audit remains necessary.'},indent=2)+'\n',encoding='utf-8')
C=S/'characteristic-converse-draft';old=(C/'EigenbasisPropagation.lean').read_text();assert old.count('using 1 <;> simp')==1
final=C/'EigenbasisPropagationFinal.lean';assert not final.exists()
final.write_text(old.replace('using 1 <;> simp','using 1\n    simp'),encoding='utf-8',newline='\n')
print(json.dumps({'verified_worker_inputs':len(verified),'root_verification_sha256':sha(p.read_bytes()),'final_propagation_draft_sha256':sha(final.read_bytes())}))

