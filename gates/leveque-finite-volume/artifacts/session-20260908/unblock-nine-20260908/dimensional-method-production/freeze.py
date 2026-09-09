from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
def verify(x):
 assert sha(R/x['path'])==x['sha256'],x
def write(name,value):
 p=P/name
 with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(value,f,indent=2);f.write('\n')
 return ref(p)
inv=read(P/'placement-inventory.json')
assert len(inv['files'])==7 and sum(len(x['declarations']) for x in inv['files'])==31
for x in inv['files']:verify(x)
build=read(P/'build05-receipt.json');native=read(P/'comparison02-receipt.json')
for rec in (build,native):
 assert rec['actual_exit_code']==0 and rec['sources_unchanged'] and rec['dependencies_unchanged']
 for x in rec['sources']+rec['dependencies']+[rec['output'],rec['runner']]:verify(x)
 assert not re.search(r'\berror:|\bwarning:|sorryAx', (R/rec['output']['path']).read_text(encoding='utf-8-sig'))
out=(R/native['output']['path']).read_text(encoding='utf-8-sig')
reports=[]
for name in inv['checked_declarations']:
 types=re.findall(r'(?m)^'+re.escape(name)+r'(?=\s|\.\{)',out)
 matches=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',out)
 empty=re.findall(re.escape("'"+name+"' does not depend on any axioms"),out)
 assert len(types)==1 and len(matches)+len(empty)==1,(name,len(types),matches,empty)
 axioms=sorted(set(x.strip() for x in matches[0].split(',') if x.strip())) if matches else []
 assert set(axioms)<={'propext','Classical.choice','Quot.sound'},(name,axioms)
 reports.append(dict(name=name,type_reports=1,axiom_reports=1,axioms=axioms))
assert len(reports)==47
checks=write('declaration-verification.json',dict(actual_exit_code=0,declarations=reports,raw_output=native['output'],native_receipt=ref(P/'comparison02-receipt.json'),all47_passed=True))
old=P.parent/'dimensional-method-repair'
pins=[ref(old/'Candidate.lean'),ref(old/'manifest.json'),ref(old/'final-receipt.json'),ref(P.parent/'selected-interpretations.json')]
assert pins[0]['sha256']=='eb9fd7e8a6a528a17cbf252db2c0877dc510303fe736873f1b69d1b9c9248657'
assert pins[3]['sha256']=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
oldsource=R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateSplittingBalance.lean'
assert sha(oldsource)=='97243527d30b5e798ec00646a7eb12ec0a5ab0c068e77d5ed7dd2dcd57c63445'
pins.append(ref(oldsource))
oldmanifest=read(old/'manifest.json')
# Bind the unchanged original source/audit manifest rather than reconstructing source facts.
frozen_artifacts=[ref(p) for p in sorted(P.rglob('*')) if p.is_file() and p.name not in ('manifest.json','final-receipt.json')]
manifest=write('manifest.json',dict(schema='directional-method-production-placement-v1',status='FROZEN-NATIVE-VERIFIED-FRESH-AUDIT-REQUIRED',files=inv['files'],primary='NumStability.leveque01_coordinateDirectionalMethods_sourceContract',generic_primary='NumStability.DirectionalFiniteVolume.directional_splitting_contract',simultaneous_witness='NumStability.PhysicalIntervalSweep.simultaneous_contract',nonconstant_execution='NumStability.PhysicalIntervalSweep.nonconstant_execution',preserved=pins,focused_build=ref(P/'build05-receipt.json'),native_comparison=ref(P/'comparison02-receipt.json'),declaration_verification=checks,nominal_transport='Explicit field-preserving fromDraft/toDraft and both round trips; nominal structures are not claimed definitionally equal.',full_type_preservation='47 actual declaration/axiom checks include full_contract_same after data transport and source_contract_same.',review=ref(P/'REVIEW.md'),reuse=ref(P/'reuse-review.json'),artifacts=frozen_artifacts,no_source_acceptance=True,no_aggregate_tier_gate_ledger_audit_git_edits=True))
receipt=write('final-receipt.json',dict(schema='directional-method-production-receipt-v1',manifest=manifest,inventory=ref(P/'placement-inventory.json'),review=ref(P/'REVIEW.md'),focused_build=ref(P/'build05-receipt.json'),native_comparison=ref(P/'comparison02-receipt.json'),declaration_verification=checks,files=7,public_authored_declarations=31,native_reports=47,allowed_axioms=['propext','Classical.choice','Quot.sound'],all_actual_exits_zero=True,all_current_bindings_verified=True,production_files_frozen=True,fresh_audit_required=True))
print(json.dumps({'manifest':manifest,'receipt':receipt,'inventory':ref(P/'placement-inventory.json'),'primary':inv['files'][-1],'checks':checks},indent=2))
