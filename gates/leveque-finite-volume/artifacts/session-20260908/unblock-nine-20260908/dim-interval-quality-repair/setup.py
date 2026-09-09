from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent
prior=h.parent/'dim-shared-accuracy-certificate/run.py'
s=prior.read_text(encoding='utf-8').replace('assert len(project)==2,project','assert len(project)==1,project').replace('no old fixed-level lemma used.','interval-only quality separation and uniform certificates.')
assert not (h/'run.py').exists()
(h/'run.py').write_text(s,encoding='utf-8')
names=[('Geometry','structure'),('Geometry.Projection','def'),('Method','structure'),('Method.advance','def'),
 ('SmoothCertificate','structure'),('CoreQuality','structure'),('SameStepStability','def'),
 ('SmoothCertificate.perturbed_at','theorem'),('SmoothCertificate.projected_step_exists','theorem'),
 ('Method.two_state_step','theorem'),('CFL1.geometry','def'),('CFL1.method','def'),
 ('CFL1.advance_eq','theorem'),('CFL1.core_quality','theorem'),('CFL1.separate_stability','theorem'),
 ('CFL1.smooth_nonconstant_certificate','theorem'),('CFL1.every_jump_available','theorem'),('cinfty_definition','theorem')]
decls=[{'name':'IntervalQualityRepairDraft.'+n,'kind':k} for n,k in names]
(h/'declarations.json').write_text(json.dumps({'declarations':decls},indent=2)+'\n',encoding='utf-8')
checks='\nset_option pp.fullNames true\nset_option pp.deepTerms true\nset_option pp.maxSteps 10000000\n'
for item in decls:checks+='\n#check '+item['name']+'\n#print axioms '+item['name']+'\n'
checks+='''
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let some info := env.find? `IntervalQualityRepairDraft.CoreQuality.mk | throwError "Missing core constructor"
  if info.type.getUsedConstantsAsSet.contains `IntervalQualityRepairDraft.SameStepStability then
    throwError "Stability must remain separate from core quality"
  logInfo "CORE_QUALITY_STABILITY_SEPARATE"
'''
(h/'Checks.lean.fragment').write_text(checks,encoding='utf-8')
p=h/'Candidate.lean';p.write_text(p.read_text(encoding='utf-8')+checks,encoding='utf-8')
(h/'helper-derivation.json').write_text(json.dumps({'source':str(prior),'source_sha256':hashlib.sha256(prior.read_bytes()).hexdigest(),
 'successor':str(h/'run.py'),'successor_sha256':hashlib.sha256((h/'run.py').read_bytes()).hexdigest(),
 'changes':['Expect one direct project import instead of two','Adjust scope text only']},indent=2)+'\n',encoding='utf-8')
