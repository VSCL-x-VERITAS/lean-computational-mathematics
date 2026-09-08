"""Read-only hash/outcome replay for the prospective scratch package."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
count=0;paths=set()
def check(p,h):
 global count
 assert sha(R/p)==h,p
 count+=1;paths.add(p)
f=json.loads((P/'final-receipt.json').read_bytes());assert f['status']=='PASS' and not f['selected'] and not f['source_acceptance']
for k in ['manifest','candidate','native_receipt','native_output','review']:check(f[k]['path'],f[k]['sha256'])
m=json.loads((P/'manifest.json').read_bytes());assert m['status']=='prospective_unselected'
for b in m['artifacts']+m['canonical_inputs']+m['compiled_imports']:check(b['path'],b['sha256'])
r=json.loads((P/'native01-exit.json').read_bytes());assert r['exit_code']==0 and r['inputs_unchanged']
for p,h in (r['input_files']|r['compiled_imports']).items():check(p,h)
prep=json.loads((P/'preparation.json').read_bytes())
for b in prep['context']+prep['canonical_sources']:check(b['path'],b['sha256'])
for page in prep['primary_source_pages']:
 for k in ['text','render']:check(page[k]['path'],page[k]['sha256'])
text=(P/'native01-output.txt').read_text(encoding='utf-8');assert not re.search(r'error:|warning:|sorryAx',text)
ax={n:[x.strip() for x in a.split(',') if x.strip()] for n,a in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.S)}
ax.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",text)})
assert len(r['checked_declarations'])==7
for n in r['checked_declarations']:assert n in ax and set(ax[n])<={'propext','Classical.choice','Quot.sound'},n
print(json.dumps(dict(status='PASS',bindings=count,unique_paths=len(paths),declarations=7,final_receipt_sha256=sha(P/'final-receipt.json'))))
