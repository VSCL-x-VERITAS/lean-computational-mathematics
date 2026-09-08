"""Preserve a deterministic replay of the root verifier failure, then derive a narrow recovery."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
S=Path(__file__).resolve().parent
P=S/'riemann-information-only-method-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
original=S/'verify-information-only-draft.py'
raw=S/'root-information-only-verifier-01-replay.txt'
receipt=S/'root-information-only-verifier-01-replay-exit.json'
assert not raw.exists() and not receipt.exists()
before=sha(original);start=time.perf_counter()
p=subprocess.run([sys.executable,'-B',str(original)],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
raw.write_bytes(p.stdout)
receipt.write_text(json.dumps({'command':[sys.executable,'-B',str(original)],'actual_exit':p.returncode,'elapsed_ms':round((time.perf_counter()-start)*1000),'script_sha256':before,'script_unchanged':sha(original)==before,'raw_sha256':sha(raw),'scope':'Deterministic replay of original verifier historical mutable fragment mismatch; not a Lean proof failure.'},indent=2)+'\n',encoding='utf-8')
assert p.returncode==1 and b'8b4b4508554070f31115591b7e171c2adc94dca3d35e015792607edb2fb3c4d9' in p.stdout
text=original.read_text(encoding='utf-8')
text=text.replace('def walk(x):','historical = False\nrecovered = []\ndef walk(x):',1)
old="p=resolve(x['path']);assert sha(p)==x['sha256'],x;bindings.append((str(p),x['sha256']))"
new="""p=resolve(x['path'])
   if historical and sha(p)!=x['sha256']:
    allowed={
     str(P/'Examples.lean.fragment'):('native-01-Examples.lean.fragment','8b4b4508554070f31115591b7e171c2adc94dca3d35e015792607edb2fb3c4d9'),
     str(P/'run.py'):('run-01.py','b60cd3821416b0cd97af26477ba1de830cb6b82ea64e33d0dedbcf9065901cbb')}
    assert str(p) in allowed,x
    replacement,h=allowed[str(p)];assert x['sha256']==h,x
    actual=P/replacement;assert sha(actual)==h,x
    if replacement.endswith('.fragment'):
     assert actual.read_bytes() in (P/'native-01.lean').read_bytes()
    recovered.append({'original_path':str(p),'historical_copy':str(actual),'sha256':h})
    p=actual
   assert sha(p)==x['sha256'],x;bindings.append((str(p),x['sha256']))"""
assert text.count(old)==1
text=text.replace(old,new)
old="n=read(resolve(m[field]['path']));walk(n)"
new="n=read(resolve(m[field]['path']));historical=field=='native_failed';walk(n);historical=False"
assert text.count(old)==1
text=text.replace(old,new)
text=text.replace("assert (P/'Candidate.lean').read_bytes()", "assert len(recovered)==2\nassert (P/'Candidate.lean').read_bytes()",1)
text=text.replace("'unique_paths':len({p for p,h in bindings}),", "'unique_paths':len({p for p,h in bindings}),'historical_bindings_resolved':recovered,",1)
dest=S/'verify-information-only-draft-v2.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(text)
out=S/'information-only-verifier-v2-derivation.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps({'original_sha256':before,'replay_receipt_sha256':sha(receipt),'derived_sha256':sha(dest),'scope':'Only native_failed exact two historical input bindings may resolve to already preserved exact-hash copies; original failed full Lean input and final current bindings remain strictly verified.'},indent=2)+'\n')
print(json.dumps({'reproduced_failure':p.returncode,'derived_sha256':sha(dest)}))

