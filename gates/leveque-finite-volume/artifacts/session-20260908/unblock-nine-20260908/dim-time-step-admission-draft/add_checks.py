from pathlib import Path
import json
h=Path(__file__).resolve().parent
names=[
 ('Domain','structure'),('Domain.InputStates','def'),('jump','def'),('jump_eq','theorem'),
 ('jump_mem','theorem'),('Domain.jump_input','theorem'),('Domain.jump_available','theorem'),
 ('SameStepStability','def'),('OscillationControl','def'),('jump_available_with_oscillation','theorem'),
 ('CFL1.domain','def'),('CFL1.numericalFlux','def'),('CFL1.flux_locality','theorem'),
 ('CFL1.advance','def'),('CFL1.advance_at_h','theorem'),('CFL1.advance_admitted','theorem'),
 ('CFL1.same_step_stability','theorem'),('CFL1.oscillation_control','theorem'),
 ('CFL1.every_jump_available','theorem'),('CFL1.jump_moves','theorem'),('CFL1.nonconstant_jump','theorem')]
decls=[{'name':'TimeStepAdmissionDraft.'+n,'kind':k} for n,k in names]
p=h/'declarations.json'
if p.exists():raise SystemExit('Refusing overwrite')
p.write_text(json.dumps({'declarations':decls},indent=2)+'\n',encoding='utf-8')
s='\nset_option pp.universes false\nset_option pp.fullNames true\nset_option pp.deepTerms true\nset_option pp.maxSteps 10000000\n'
for item in decls:
 s+='\n#check '+item['name']+'\n#print axioms '+item['name']+'\n'
(h/'Checks.lean.fragment').write_text(s,encoding='utf-8')
p=h/'Candidate.lean'
p.write_text(p.read_text(encoding='utf-8')+s,encoding='utf-8')
