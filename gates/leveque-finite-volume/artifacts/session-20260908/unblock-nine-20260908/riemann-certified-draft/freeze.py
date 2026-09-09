"""Freeze exact successful scratch evidence without production or audit writes."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,os,re
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
S=F.parent.parent
SHIM=F.parent/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
p=argparse.ArgumentParser();p.add_argument('label');a=p.parse_args();E=F/a.label
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def create(p,b):
    with p.open('xb') as out:out.write(b)
def write(p,v):create(p,(json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode())
read=lambda p:json.loads(p.read_bytes())
native=read(E/'receipt.json')
assert native['exit_code']==0 and native['inputs_unchanged']
assert sha(E/'output.txt')==native['output_sha256'] and sha(E/'stderr.txt')==native['stderr_sha256']
assert all(sha(R/x['path'])==x['sha256'] for x in native['input_pins'])
out=(E/'output.txt').read_text(encoding='utf-8')
assert not any(word in out for word in ('error:','warning:','sorryAx'))
reports=re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",out,re.S)
assert [name for name,_ in reports]==native['authored_declarations']
assert len(reports)==14
axioms=[]
for name,raw in reports:
    used=[x.strip() for x in raw.split(',') if x.strip()]
    assert set(used)<={'propext','Classical.choice','Quot.sound'},(name,used)
    axioms.append({'declaration':name,'axioms':used})
create(F/'native-types.txt',(E/'output.txt').read_bytes())
write(F/'axioms.json',axioms)
T=S/'audits/LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908'
evidence=[T/'audit-task.json',T/'faithfulness/inputs/source_locator.json',T/'user-interpretation-packet.json',
    T/'inherited-source-interpretation-packet.json',S/'user-discontinuity-interpretation-20260908.json',
    F.parent/'selected-interpretations.json',S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf']
evidence += [T/'faithfulness/orchestration'/('page-'+str(n).zfill(3)+'.png') for n in (26,27,28)]
assert sha(evidence[6])=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
def files(d):
    for x in d.iterdir():
        if x.is_dir():yield from files(x)
        elif x.is_file():yield x
manifest={'format':'certified-riemann-routine-scratch-manifest-1','created_at_utc':datetime.now(timezone.utc).isoformat(),
    'files':[ref(x) for x in files(F)],'unchanged_producers':read(F/'reuse-inputs.json'),
    'source_boundary_inputs':[ref(x) for x in evidence],
    'repair_decision':ref(T/'faithfulness/decision.json'),
    'repair_decision_is_not_fresh_audit_input':True,'production_edits':False,'audit_edits':False}
write(F/'manifest.json',manifest)
receipt={'format':'certified-riemann-routine-scratch-receipt-1','completed_at_utc':datetime.now(timezone.utc).isoformat(),
    'manifest':ref(F/'manifest.json'),'review':ref(F/'REVIEW.md'),'native':ref(E/'receipt.json'),
    'native_types':ref(F/'native-types.txt'),'axioms':ref(F/'axioms.json'),
    'fragments':[ref(F/(n+'.lean.fragment')) for n in ('Accuracy','Update','Source','Examples')],
    'actual_native_exit_code':0,'authored_declaration_count':14,'prospective_production_declaration_count':7,
    'separate_applicability_declaration_count':7,'all_axioms_permitted':True,
    'all_native_inputs_unchanged':True,'source_acceptance':False,'production_placement_performed':False,
    'actual_new_primary_application':'NumStability.CertifiedRiemannRoutineDraft.actual_two_face_source_application',
    'joint_reference_consumer':'NumStability.CertifiedRiemannRoutineDraft.references_from_actual_primary'}
write(F/'receipt.json',receipt)
print(json.dumps({'receipt':ref(F/'receipt.json'),**receipt},indent=2))
