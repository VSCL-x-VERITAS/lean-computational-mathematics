"""Root verification of the independently checked normalized-volume alternative."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'heterogeneous-volume-average-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
receipt=P/'final-receipt.json'
assert sha(receipt)=='c1c2bc1a00f25dcbc98a8eb33a401f01af0f3b572a9daa05b26b90682d4814c1'
f=read(receipt);bindings=f['artifacts']+f['support']
for b in bindings:assert sha(Path(b['path']))==b['sha256'],b['path']
native=read(P/'final-checks-exit.json')
assert type(native['exit_code']) is int and native['exit_code']==0 and native['inputs_unchanged'] is True
for p,h in native['input_sha256'].items():assert sha(R/p)==h,p
out=P/'final-checks-output.txt';assert sha(out)==native['output_sha256']
candidate=P/'Candidate.lean';check=P/'Checks.lean'
assert sha(candidate)=='d05321ada063fff739b5234a0d81c2cd1d91d1f42386fa3a60cde5d633e0d366'
assert check.read_bytes().startswith(candidate.read_bytes()+b'\n')
assert sha(check)==native['snapshot_sha256']==sha(P/'final-checks-input.lean')
assert [x.lower().replace('\\','/') for x in native['command']]==[
 'c:/users/qed_s/.elan/bin/lake.exe','env','lean',str(check).lower().replace('\\','/')]
source=check.read_text(encoding='utf-8')
names=re.findall(r'^#print axioms (\S+)$',source,re.M)
assert len(names)==len(set(names))==15
raw=out.read_text(encoding='utf-8');assert not re.search(r'warning:|error:|sorryAx',raw)
actual={}
for name,axioms in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",raw):
 assert name not in actual;actual[name]=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in axioms.split(',') if x.strip()]
assert set(actual)==set(names)==set(f['axioms'])
allowed={'propext','Classical.choice','Quot.sound'}
for name in names:assert set(actual[name])<=allowed and actual[name]==f['axioms'][name]
record={'schema':1,'status':'PASS','receipt_sha256':sha(receipt),
 'candidate_sha256':sha(candidate),'native_exit_code':native['exit_code'],
 'native_output_sha256':sha(out),'native_elapsed_ms':native['elapsed_ms'],
 'verified_bindings':len(bindings),'checked_declarations':len(names),
 'scope':'Root read the full candidate and review; independently checked every declared artifact and dependency binding, exact checked-source prefix, actual zero native receipt, output and allowed axioms. This verifies scratch mathematics only. It neither adopts the unanswered normalized-volume choice nor accepts a source claim.',
 'findings':['No unequal-average premise in either assignment theorem.',
 'The x-squared example has two finite positive cells and within-cell variation with equal averages.',
 'The x example has valid cell averages with distinct values.',
 'Average laws reuse existing project and Mathlib operators; no new average definition.']}
dest=S/'root-batch8-normalized-volume-verification.json'
with dest.open('x',encoding='utf-8',newline='') as h:h.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'path':dest.relative_to(R).as_posix(),'sha256':sha(dest),'bindings':len(bindings),'declarations':len(names)}))

