from pathlib import Path
import json
h=Path(__file__).resolve().parent
names=[('Certificate','structure'),('certificate_exists','theorem'),('Certificate.projected_input_exists','theorem'),
 ('Certificate.executed_bound','theorem'),('scalar_cfl1_certificate','theorem'),
 ('scalar_nonconstant_reference_certificate','theorem'),('cinfty_definition','theorem')]
decls=[{'name':'SharedAccuracyCertificateDraft.'+n,'kind':k} for n,k in names]
assert not (h/'declarations.json').exists()
(h/'declarations.json').write_text(json.dumps({'declarations':decls},indent=2)+'\n',encoding='utf-8')
s='\nset_option pp.fullNames true\nset_option pp.deepTerms true\nset_option pp.maxSteps 10000000\n'
for item in decls:s+='\n#check '+item['name']+'\n#print axioms '+item['name']+'\n'
s+='''
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let names := [
    `SharedAccuracyCertificateDraft.certificate_exists,
    `SharedAccuracyCertificateDraft.Certificate.executed_bound,
    `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution.perturbed_accuracy,
    `NumStability.FiniteCoordinate.LineCoordinates.extract_error_le,
    `NumStability.FiniteCoordinate.LineRealization.advance_eq]
  let forbidden := `NumStability.FiniteCoordinate.LineRealization.smooth_accuracy
  for name in names do
    let some info := env.find? name | throwError "Missing inspected declaration {name}"
    let used := info.getUsedConstantsAsSet
    if used.contains forbidden then
      throwError "Forbidden old accuracy proof dependency in {name}"
    logInfo m!"NO_OLD_ACCURACY_DEPENDENCY {name}"
'''
(h/'Checks.lean.fragment').write_text(s,encoding='utf-8')
p=h/'Candidate.lean';p.write_text(p.read_text(encoding='utf-8')+s,encoding='utf-8')
