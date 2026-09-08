from pathlib import Path
import hashlib,json,re

P=Path(__file__).resolve().parent; R=P.parents[4]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
seen={}; occurrences=0
def visit(x):
    global occurrences
    if isinstance(x,dict):
        if isinstance(x.get('path'),str) and isinstance(x.get('sha256'),str):
            p=R/x['path']; assert sha(p)==x['sha256'],p
            occurrences+=1; seen[x['path']]=x['sha256']
        for v in x.values(): visit(v)
    elif isinstance(x,list):
        for v in x: visit(v)

final=json.loads((P/'final-receipt.json').read_bytes()); manifest=json.loads((P/'manifest.json').read_bytes())
assert final['status']=='PASS' and final['native_exit']==0 and final['selected'] is False and final['source_acceptance'] is False
visit(final); visit(manifest)
r=json.loads((R/final['native_receipt']['path']).read_bytes())
assert r['exit_code']==0 and r['inputs_unchanged']
for p,h in (r['input_files']|r['compiled_imports']).items():
    assert sha(R/p)==h,p; occurrences+=1; seen[p]=h
raw=(R/final['native_output']['path']).read_bytes(); assert hashlib.sha256(raw).hexdigest()==r['output_sha256']
text=raw.decode(); assert not re.search(r'error:|warning:|sorryAx',text)
ax={n:[v.strip() for v in a.split(',') if v.strip()] for n,a in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.S)}
ax.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",text)})
source=(R/final['complete_input']['path']).read_bytes()
names=re.findall(r'^#print axioms (\S+)',source.decode(),re.M)
assert len(names)==final['all_declaration_checks'] and len(r['checked_declarations'])==final['new_declarations']==31
for n in names: assert n in ax and set(ax[n]) <= {'propext','Classical.choice','Quot.sound'},n
for b in manifest['fragments']+[manifest['frozen_cartesian_input']]: assert source.count((R/b['path']).read_bytes())==1
pf=manifest['proof_free_native_output']; assert (R/pf['path']).read_bytes()==raw[pf['byte_offset']:pf['byte_offset']+pf['byte_length']]
for a in manifest['attempts']:
    ar=json.loads((R/a['receipt']['path']).read_bytes()); assert ar['exit_code']==a['exit_code'] and ar['inputs_unchanged']
    assert ar['output_sha256']==a['output']['sha256']
    assert ar['input_files'][a['input']['path']]==a['input']['sha256']
result=dict(status='PASS',binding_occurrences=occurrences,unique_bound_files=len(seen),new_declarations=31,all_declaration_checks=len(names),native_exit=0,source_acceptance=False,manifest_sha256=sha(P/'manifest.json'),final_receipt_sha256=sha(P/'final-receipt.json'))
out=P/'verification.json'; assert not out.exists(); out.write_bytes((json.dumps(result,indent=2)+'\n').encode()); print(json.dumps(result))
