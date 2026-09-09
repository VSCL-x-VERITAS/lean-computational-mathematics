from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[5];D=P.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
receipt=json.loads((P/'core-final02-receipt.json').read_text())
assert receipt['actual_exit_code']==0 and receipt['dependencies_unchanged']
raw=R/receipt['output']['path'];assert sha(raw)==receipt['output']['sha256']
text=raw.read_text(encoding='utf-8-sig')
assert 'error:' not in text and 'error(' not in text and 'sorryAx' not in text
axioms={name:set(x.strip() for x in values.split(',') if x.strip()) for name,values in
    re.findall(r"'([^']+)' depends on axioms:\s*\[([^]]*)\]",text,re.S)}
for name in re.findall(r"'([^']+)' does not depend on any axioms",text):axioms[name]=set()
decls=json.loads((P/'core-authored-check-input.json').read_text())['declarations']
for d in decls:
    assert d['name'] in axioms,d
    assert axioms[d['name']]<={'propext','Classical.choice','Quot.sound'},d
    d['actual_axioms']=sorted(axioms[d['name']])
sources=['Finite.lean','Quality.lean','Execution.fragment','Propagation.lean','Composition.fragment',
 'FiniteCartesian.fragment','Primary.fragment','Primary.lean','CoreChecks.lean','make_primary.py',
 'prepare_core_checks.py','core-authored-check-input.json','native.py','freeze_complete_core.py']
assert not (P/'complete-core-manifest.json').exists()
attempts=[]
for p in sorted(P.glob('*-receipt.json')):
    j=json.loads(p.read_text())
    if 'actual_exit_code' not in j:continue
    attempts.append({'receipt':ref(p),'actual_exit_code':j['actual_exit_code'],'output':j['output']})
manifest={'status':'native-verified-complete-core-awaiting-joint-applicability-and-production',
 'source_acceptance':False,'canonical_files_mutated_by_this_freezer':False,
 'sources':[ref(P/n) for n in sources],'declared_authored_count':len(decls),'declarations':decls,
 'final_native_receipt':ref(P/'core-final02-receipt.json'),'final_native_output':ref(raw),
 'known_warnings':'The unchanged frozen Lift.lean helper includes an unused Fintype D section-variable warning; no proof or axiom warning.',
 'attempts':attempts,'frozen_reference_basis':ref(P/'basis-final-receipt.json'),
 'independent_instances':[ref(D/'dim-quality-family-witness'/'receipt.json'),
    ref(D/'finite-cartesian-geometry-draft'/'final-receipt.json'),
    ref(D/'dim-local-characteristic-witness'/'receipt.json'),ref(D/'dim-cfl1-witness'/'receipt.json')],
 'qualification':'Full uniform family order is stated before arbitrary refinement level. Finite-stage threshold applications are conditional. Actual finite physical-reference error retains splitting and boundary defects. No composite temporal order, arbitrary-law solver existence, or audit acceptance is asserted.'}
(P/'complete-core-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
final={'status':manifest['status'],'manifest':ref(P/'complete-core-manifest.json'),
 'final_native_receipt':manifest['final_native_receipt'],'authored_count':len(decls),'source_acceptance':False}
(P/'complete-core-receipt.json').write_text(json.dumps(final,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(ref(P/'complete-core-receipt.json'),indent=2))
