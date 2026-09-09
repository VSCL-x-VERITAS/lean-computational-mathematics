"""Place four authorized additive owners and run focused native checks.

No old owner, aggregate, tier manifest, Git index/ref, gate or audit is edited.
"""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,os,subprocess,time
P=Path(__file__).resolve().parent
F=P.parent/'riemann-certified-draft'
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
SHIM=P.parent/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
parser=argparse.ArgumentParser();parser.add_argument('--scratch-receipt-sha256',required=True);a=parser.parse_args()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
now=lambda:datetime.now(timezone.utc).isoformat()
def create(p,b):
    with p.open('xb') as out:out.write(b)
def write(p,v):create(p,(json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode())
assert sha(F/'receipt.json')==a.scratch_receipt_sha256
scratch=read(F/'receipt.json');assert scratch['actual_native_exit_code']==0
manifest=read(R/scratch['manifest']['path'])
assert sha(R/scratch['manifest']['path'])==scratch['manifest']['sha256']
for pin in manifest['files']+manifest['unchanged_producers']+manifest['source_boundary_inputs']:
    assert sha(R/pin['path'])==pin['sha256'],pin['path']
assert not (P/'initial-placement.json').exists()
base='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
source='ComputationalMathematics/Source/LeVeque/Chapter01/RiemannCertifiedRoutineInterface.lean'
prefix='NumStability.LocalRiemannInformation.'
examples=(F/'Examples.lean.fragment').read_text(encoding='utf-8')
separator='namespace NumStability.CertifiedRiemannRoutineDraft'
assert examples.count(separator)==1
example_body,witness=examples.split(separator)
specs=[
 ('Accuracy',base+'LocalRiemannRoutineAccuracy.lean',
  [base+'LocalRiemannRoutine.lean'],
  'Certified accuracy of information routines',
  'A supplied routine is certified against a physical reference for every admitted\nordered problem on its finite time horizon. The reference need not be returned.\nExact equal-state consistency remains a separate property.',
  (F/'Accuracy.lean.fragment').read_text(encoding='utf-8'),
  [prefix+'Routine.HasRiemannAccuracy',prefix+'Method.toRoutine_hasRiemannAccuracy',prefix+'Routine.HasRiemannAccuracy.reference_comparison']),
 ('Update',base+'CertifiedRiemannRoutineUpdate.lean',
  [base+'LocalRiemannRoutineAccuracy.lean',base+'LocalRiemannRoutineUpdate.lean'],
  'Local updates from certified Riemann information routines',
  'The actual two admitted face executions supply same-problem finite-time\nreferences and certified mean-flux errors. Independent physical error bounds\nretain the existing normalized update and conservative error propagation.',
  (F/'Update.lean.fragment').read_text(encoding='utf-8'),
  [prefix+'certifiedRoutine_local_interface_contract']),
 ('Examples',base+'Examples/BiasedCertifiedRiemannRoutine.lean',
  [base+'LocalRiemannRoutineAccuracy.lean',base+'Examples/BiasedLocalRiemannRoutine.lean'],
  'Biased information routines with genuine Riemann accuracy certificates',
  'Existing scalar transport references certify arbitrary additive bias on every\nadmitted problem in the proper state domain. A half-unit bias is certified\nwhile violating exact equal-state consistency.',
  example_body,['NumStability.BiasedLocalRiemannRoutine.hasRiemannAccuracy','NumStability.BiasedLocalRiemannRoutine.certified_nonconsistent']),
 ('Source',source,[base+'CertifiedRiemannRoutineUpdate.lean'],
  'Chapter 1: certified Riemann information and physical flux errors',
  'A supplied certified information routine produces fluxes and a normalized\nlocal update. Actual same-problem references link the two executions to\nRiemann data and finite-slab rectangle conservation. Direct and reference-based\nphysical error propagation follow under explicit bounds. The recorded Q7\nconvention and inherited rectangle interpretation remain separate from printed\nsource assertions; no arbitrary-law routine availability is claimed here.',
  (F/'Source.lean.fragment').read_text(encoding='utf-8'),
  ['NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract'])]
outputs=[]
for label,path,imports,title,doc,body,declarations in specs:
    target=R/path
    assert not target.exists(),path
    assert target.parent.is_dir() and target.resolve().is_relative_to(R.resolve())
    content='/-\nSPDX-License-Identifier: MIT\n-/\n\n'
    content+='\n'.join('import '+name.removesuffix('.lean').replace('/','.') for name in imports)
    content+='\n\n/-!\n# '+title+'\n\n'+doc+'\n-/\n\nopen MeasureTheory\n\n'+body
    outputs.append((target,content.encode(),label,declarations,hashlib.sha256(body.encode()).hexdigest()))
assert len(outputs)==4 and sum(len(item[3]) for item in outputs)==7
for target,raw,_,_,_ in outputs:create(target,raw)
records=[{'path':target.relative_to(R).as_posix(),'module':target.relative_to(R).as_posix().removesuffix('.lean').replace('/','.'),
 'sha256':sha(target),'fragment_label':label,'body_sha256':body_hash,'declarations':decls}
 for target,_,label,decls,body_hash in outputs]
write(P/'initial-placement.json',{'format':'certified-riemann-production-placement-1','created_at_utc':now(),
    'scratch_receipt':ref(F/'receipt.json'),'files':records,'source_acceptance':False,
    'old_owners_modified':False,'aggregate_tier_git_gate_writes':False})
write(P/'files.json',{'files':records})
def stable():
    for item in records+manifest['unchanged_producers']:
        assert sha(R/item['path'])==item['sha256'],item['path']
def run(label,arguments):
    stable();command=[str(Path.home()/'.elan/bin/lake.exe'),*arguments]
    started=now();clock=time.monotonic()
    with (P/(label+'-output.txt')).open('xb') as out,(P/(label+'-stderr.txt')).open('xb') as err:
        result=subprocess.run(command,cwd=R,stdout=out,stderr=err)
    receipt={'command':command,'started_at_utc':started,'completed_at_utc':now(),
       'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,
       'stdout':ref(P/(label+'-output.txt')),'stderr':ref(P/(label+'-stderr.txt')),
       'inputs':records,'old_producers_unchanged':True,'git_invocations':0}
    stable();write(P/(label+'-exit.json'),receipt)
    print(json.dumps(receipt),flush=True)
    assert result.returncode==0
    return receipt
run('build',['build',*[item['module'] for item in records]])
declarations=read(R/scratch['native']['path'])['authored_declarations']
check='import '+source.removesuffix('.lean').replace('/','.')+'\n'
check+='import '+(base+'Examples/BiasedCertifiedRiemannRoutine').replace('/','.')+'\n\nopen MeasureTheory\n\n'
check+=separator+witness
check+='''
set_option pp.universes false
set_option pp.fullNames true
set_option pp.explicit true
set_option pp.proofs false
set_option pp.deepTerms true
set_option pp.maxSteps 1000000
set_option maxRecDepth 10000
'''
check+='\n'.join('#check @'+name+'\n#print axioms '+name for name in declarations)+'\n'
create(P/'DeclarationsAndApplication.lean',check.encode())
run('declarations',['env','lean',(P/'DeclarationsAndApplication.lean').relative_to(R).as_posix()])
assert (P/'declarations-output.txt').read_bytes()==(F/'native-types.txt').read_bytes(), 'Native whole types or axiom reports changed during placement'
write(P/'checks-complete.json',{'completed_at_utc':now(),'actual_build_exit_code':0,'actual_declarations_exit_code':0,
    'whole_native_output_byte_equal_to_scratch':True,'declarations':declarations,
    'files':ref(P/'files.json'),'scratch_receipt':ref(F/'receipt.json'),
    'build':ref(P/'build-exit.json'),'declarations_check':ref(P/'declarations-exit.json')})
print(json.dumps({'checks_complete':ref(P/'checks-complete.json')},indent=2))
