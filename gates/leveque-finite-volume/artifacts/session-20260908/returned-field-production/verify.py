"""Read-only replay of frozen byte and actual native outcome evidence."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
f=json.loads((P/'final-receipt.json').read_bytes());assert f['status']=='PASS' and not f['source_acceptance']
count=0;unique=set()
def check(path,h):
 global count
 assert sha(R/path)==h,path
 count+=1;unique.add(path)
for b in f['production_sources']+f['compiled_outputs']+f['artifacts']:
 check(b['path'],b['sha256'])
for b in f['actual_native_receipts']:
 check(b['path'],b['sha256']);r=json.loads((R/b['path']).read_bytes())
 assert r['exit_code']==0 and r['inputs_unchanged']
 for path,h in (r['input_files']|r['compiled_imports']).items():check(path,h)
 out=R/b['path'].replace('-exit.json','-output.txt');check(out.relative_to(R).as_posix(),r['output_sha256'])
 assert not re.search(r'error:|warning:|sorryAx',out.read_text(encoding='utf-8'))
v=json.loads((P/'axiom-verification.json').read_bytes());assert v['status']=='PASS'
for reports in v['reports'].values():
 for n,axioms in reports.items():assert set(axioms)<={'propext','Classical.choice','Quot.sound'},n
assert len(v['reports']['checks01'])==23 and len(v['reports']['compare01'])==73
print(json.dumps(dict(status='PASS',binding_occurrences=count,unique_paths=len(unique),canonical_declarations=23,comparison_declarations=50,final_receipt_sha256=sha(P/'final-receipt.json'))))
