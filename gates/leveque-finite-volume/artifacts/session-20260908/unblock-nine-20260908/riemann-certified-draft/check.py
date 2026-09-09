"""Native scratch elaboration with exact input pins; no Git or role commands."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,os,subprocess,time
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
SHIM=F.parent/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
parser=argparse.ArgumentParser();parser.add_argument('label');args=parser.parse_args()
assert args.label.isalnum()
E=F/args.label;E.mkdir()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
now=lambda:datetime.now(timezone.utc).isoformat()
def create(path,raw):
    with path.open('xb') as out:out.write(raw)
def write(path,value):create(path,(json.dumps(value,indent=2)+'\n').encode())
imports='''import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutineUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.BiasedLocalRiemannRoutine
open MeasureTheory
'''
names=['NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy',
 'NumStability.LocalRiemannInformation.Method.toRoutine_hasRiemannAccuracy',
 'NumStability.LocalRiemannInformation.Routine.HasRiemannAccuracy.reference_comparison',
 'NumStability.LocalRiemannInformation.certifiedRoutine_local_interface_contract',
 'NumStability.leveque01_certifiedRiemannRoutineInterface_sourceContract',
 'NumStability.BiasedLocalRiemannRoutine.hasRiemannAccuracy',
 'NumStability.BiasedLocalRiemannRoutine.certified_nonconsistent',
 'NumStability.CertifiedRiemannRoutineDraft.leftProblem',
 'NumStability.CertifiedRiemannRoutineDraft.rightProblem',
 'NumStability.CertifiedRiemannRoutineDraft.both_problems_nonconstant',
 'NumStability.CertifiedRiemannRoutineDraft.actual_two_face_source_application',
 'NumStability.CertifiedRiemannRoutineDraft.both_actual_reference_errors',
 'NumStability.CertifiedRiemannRoutineDraft.actual_update_error',
 'NumStability.CertifiedRiemannRoutineDraft.references_from_actual_primary']
parts=[F/(name+'.lean.fragment') for name in ('Accuracy','Update','Source','Examples')]
body=imports+'\n'.join(p.read_text(encoding='utf-8') for p in parts)
options='''
set_option pp.universes false
set_option pp.fullNames true
set_option pp.explicit true
set_option pp.proofs false
set_option pp.deepTerms true
set_option pp.maxSteps 1000000
set_option maxRecDepth 10000
'''
checks='\n'.join('#check @'+name+'\n#print axioms '+name for name in names)+'\n'
create(E/'Check.lean',(body+options+checks).encode())
pins=json.loads((F/'reuse-inputs.json').read_bytes())
pins += [{'path':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in [*parts,E/'Check.lean',R/'lean-toolchain',R/'lake-manifest.json']]
assert all(sha(R/x['path'])==x['sha256'] for x in pins)
command=[str(Path.home()/'.elan/bin/lake.exe'),'env','lean',(E/'Check.lean').relative_to(R).as_posix()]
start=now();clock=time.monotonic()
with (E/'output.txt').open('xb') as out,(E/'stderr.txt').open('xb') as err:
    result=subprocess.run(command,cwd=R,stdout=out,stderr=err)
receipt={'command':command,'started_at_utc':start,'completed_at_utc':now(),
 'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,
 'output_sha256':sha(E/'output.txt'),'stderr_sha256':sha(E/'stderr.txt'),
 'input_pins':pins,'inputs_unchanged':all(sha(R/x['path'])==x['sha256'] for x in pins),
 'authored_declarations':names,'runner_sha256':sha(Path(__file__)),
 'git_invocations':0,'model_role_invocations':0}
write(E/'receipt.json',receipt)
print(json.dumps({k:v for k,v in receipt.items() if k not in ('input_pins','authored_declarations')},indent=2))
assert receipt['inputs_unchanged']
raise SystemExit(result.returncode)
