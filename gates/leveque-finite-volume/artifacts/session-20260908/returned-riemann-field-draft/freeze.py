"""Validate observed native evidence and bind scratch artifacts; no external writes."""
from pathlib import Path
import hashlib, json, os, re
D=Path(__file__).resolve().parent
R=D.parents[4]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def bound(p): return {'path':os.path.relpath(p,R).replace('\\','/'),'sha256':sha(p)}
def check(b):
    p=(R/b['path']).resolve()
    assert p.is_file() and sha(p)==b['sha256'],b
    return b
def read(p): return json.loads(p.read_text(encoding='utf-8'))
def write(p,x):
    assert not p.exists(),p
    p.write_text(json.dumps(x,indent=2)+'\n',encoding='utf-8',newline='\n')
names=read(D/'declaration-list.json')
inputs=read(D/'inputs-before-final.json')
bindings=[inputs['candidate'],*inputs['dependencies'],*inputs['source_and_context']]
for b in bindings: check(b)
candidate=D/'Candidate.lean'
assert b'\r' not in candidate.read_bytes()
assert not re.search(r'\b(sorry|admit|unsafe|axiom)\b',candidate.read_text(encoding='utf-8').split('-- Proof-free declaration signatures')[0])
attempts=[]
for p in sorted(D.glob('native*.json')):
    r=read(p)
    assert r['argv'][1:]==['env','lean',str(candidate.relative_to(R))]
    check(r['input']);check(r['output'])
    attempts.append({'receipt':bound(p),'input':r['input'],'output':r['output'],'actual_exit':r['exit_code']})
assert len(attempts)==6
assert [a['actual_exit'] for a in attempts]==[1,1,1,1,0,0]
final=read(D/'native06-final.json')
assert final['exit_code']==0
assert final['input']['sha256']==sha(candidate)
raw=(D/'native06-final.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(error|warning):|sorryAx',raw)
axioms={}
for name,body in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",raw,re.S):
    assert name not in axioms,name
    axioms[name]=[a.strip() for a in body.split(',') if a.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms",raw):
    assert name not in axioms,name
    axioms[name]=[]
expected=names['authored']+names['reused_checks']
assert set(axioms)==set(expected),(set(axioms)^set(expected))
allowed={'propext','Classical.choice','Quot.sound'}
assert all(set(a)<=allowed for a in axioms.values())
runtime=read(D/'runtime.json');check(runtime['output']);assert runtime['exit_code']==0
assert '4.29.0-rc3' in (D/'runtime.txt').read_text(encoding='utf-8')
assert runtime['mathlib_head']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
for label in ['reuse-method','reuse-witness']:
    r=read(D/(label+'.json'));check(r['output']);assert r['exit_code']==0
write(D/'verification.json',{'candidate':bound(candidate),'final_native_receipt':bound(D/'native06-final.json'),
 'actual_native_exit':final['exit_code'],'authored_declarations':len(names['authored']),
 'existing_producer_checks':len(names['reused_checks']),'all_axiom_results':axioms,
 'allowed_axioms':sorted(allowed),'unchanged_dependency_and_source_bindings':len(bindings)-1,
 'candidate_matches_checked_snapshot':True,'candidate_lf':True,'placeholder_scan_clean':True,
 'native_attempts':attempts})
artifacts=[bound(p) for p in sorted(D.iterdir()) if p.is_file()]
for b in artifacts:check(b)
manifest={'schema':'returned-riemann-field-scratch-foundation-1','candidate':bound(candidate),
 'proof_free_api_review':bound(D/'API-REVIEW.md'),'review':bound(D/'REVIEW.md'),
 'native_receipt':bound(D/'native06-final.json'),'verification':bound(D/'verification.json'),
 'declaration_list':names,'source_and_context':inputs['source_and_context'],
 'dependencies_unchanged':inputs['dependencies'],'runtime':runtime,
 'candidate_lines_including_inspection':len(candidate.read_text(encoding='utf-8').splitlines()),
 'artifacts':artifacts,'source_faithfulness':'not_assessed','canonical_placement':'none'}
write(D/'manifest.json',manifest)
write(D/'final-receipt.json',{'schema':'scratch-foundation-freeze-receipt-1',
 'manifest':bound(D/'manifest.json'),'candidate':bound(candidate),'verification':bound(D/'verification.json'),
 'native_receipt':bound(D/'native06-final.json'),'actual_native_exit':final['exit_code'],
 'artifact_count':len(artifacts),'authored_declarations':24,'existing_producer_checks':9,
 'limitations':'Conditional generic foundation only. No source adoption, acceptance or production placement.'})
print(json.dumps({'receipt':bound(D/'final-receipt.json'),'manifest':bound(D/'manifest.json'),
 'candidate':bound(candidate),'artifacts':len(artifacts),'axiom_checks':len(axioms),'actual_native_exit':0}))
