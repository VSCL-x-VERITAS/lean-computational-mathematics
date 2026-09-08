"""Bind observed scratch evidence after checking native outputs and unchanged inputs."""
from pathlib import Path
import hashlib,json,os,re
D=Path(__file__).resolve().parent
R=D.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bound(p):return {'path':os.path.relpath(p,R).replace('\\','/'),'sha256':sha(p)}
def read(p):return json.loads(p.read_text(encoding='utf-8'))
def check(b):
    p=(R/b['path']).resolve()
    assert p.is_file() and sha(p)==b['sha256'],b
def write(p,x):
    assert not p.exists()
    p.write_text(json.dumps(x,indent=2)+'\n',encoding='utf-8',newline='\n')
inputs=read(D/'inputs-before-final.json')
bindings=[inputs['candidate'],inputs['fragment'],*inputs['dependencies'],*inputs['source_and_frozen_evidence']]
for b in bindings:check(b)
candidate=D/'Candidate.lean'
old=D.parent/'left-mode-domain-draft/candidate.lean'
assert sha(old)=='6084110138b1c51ef783797a1dfe442ef9dbd5985daaa5919610e665cd9de92e'
assert old.read_bytes() in candidate.read_bytes()
assert (D/'Fixtures.lean.fragment').read_bytes() in candidate.read_bytes()
assert b'\r' not in candidate.read_bytes()
assert not re.search(r'\b(sorry|admit|unsafe|axiom)\b',candidate.read_text(encoding='utf-8'))
attempts=[]
for p in sorted(D.glob('native*.json')):
    r=read(p);check(r['input']);check(r['output'])
    assert r['argv'][1:]==['env','lean',str(candidate.relative_to(R))]
    attempts.append({'receipt':bound(p),'input':r['input'],'output':r['output'],'actual_exit':r['exit_code']})
assert [a['actual_exit'] for a in attempts]==[1,0,0]
final=read(D/'native03-final.json')
assert final['exit_code']==0 and final['input']['sha256']==sha(candidate)
raw=(D/'native03-final.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(error|warning):|sorryAx',raw)
names=read(D/'declaration-list.json')
expected=names['new_fixture_declarations']+names['reused_frozen_domain']+names['canonical_and_mathlib_checks']
axioms={}
for name,body in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",raw,re.S):
    assert name not in axioms
    axioms[name]=[a.strip() for a in body.split(',') if a.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms",raw):
    assert name not in axioms
    axioms[name]=[]
assert len(expected)==29 and set(axioms)==set(expected),(set(axioms)^set(expected))
allowed={'propext','Classical.choice','Quot.sound'}
assert all(set(a)<=allowed for a in axioms.values())
runtime=read(D/'runtime.json');check(runtime['output']);assert runtime['exit_code']==0
assert '4.29.0-rc3' in (D/'runtime.txt').read_text(encoding='utf-8')
assert runtime['mathlib_head']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
for label in ['reuse-domains','reuse-calculus']:
    r=read(D/(label+'.json'));check(r['output']);assert r['exit_code']==0
write(D/'verification.json',{'candidate':bound(candidate),'final_native_receipt':bound(D/'native03-final.json'),
 'actual_native_exit':final['exit_code'],'new_fixture_declarations':18,'unchanged_reused_domain_declarations':1,
 'canonical_and_mathlib_checks':10,'all_axiom_results':axioms,'allowed_axioms':sorted(allowed),
 'all_input_bindings_verified':len(bindings),'frozen_source_bytes_contained_unchanged':True,
 'candidate_lf':True,'candidate_placeholder_scan_clean':True,'native_attempts':attempts})
artifacts=[bound(p) for p in sorted(D.iterdir()) if p.is_file()]
for b in artifacts:check(b)
write(D/'manifest.json',{'schema':'left-mode-alternative-scratch-evidence-1','candidate':bound(candidate),
 'fixture_fragment':bound(D/'Fixtures.lean.fragment'),'prospective_contract':bound(D/'PROSPECTIVE-CONTRACT.md'),
 'review':bound(D/'REVIEW.md'),'native_receipt':bound(D/'native03-final.json'),
 'verification':bound(D/'verification.json'),'declarations':names,'runtime':runtime,
 'source_and_frozen_evidence':inputs['source_and_frozen_evidence'],'unchanged_dependencies':inputs['dependencies'],
 'pending_interpretation_call':'call_ctzCZ7YK8zbx2yUzmX59YBdC','interpretation_status':'unanswered; not adopted',
 'source_faithfulness':'not_assessed','canonical_placement':'none','artifacts':artifacts})
write(D/'final-receipt.json',{'schema':'scratch-evidence-freeze-receipt-1','manifest':bound(D/'manifest.json'),
 'candidate':bound(candidate),'verification':bound(D/'verification.json'),
 'native_receipt':bound(D/'native03-final.json'),'actual_native_exit':final['exit_code'],
 'artifact_count':len(artifacts),'new_fixture_declarations':18,'unchanged_reused_domain_declarations':1,
 'canonical_and_mathlib_checks':10,'pending_interpretation_call':'call_ctzCZ7YK8zbx2yUzmX59YBdC',
 'limitations':'Prospective alternative and separate nonvacuity evidence only; no adoption or source audit.'})
print(json.dumps({'receipt':bound(D/'final-receipt.json'),'manifest':bound(D/'manifest.json'),
 'candidate':bound(candidate),'artifacts':len(artifacts),'axiom_checks':len(axioms),'actual_native_exit':0}))
