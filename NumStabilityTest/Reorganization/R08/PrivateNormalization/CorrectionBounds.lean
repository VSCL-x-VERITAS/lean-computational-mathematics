import NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds
import NumStabilityTest.Reorganization.ProjectIdentityPrivateNames

/-!
# CorrectionBounds private normalization

Constructs the 7 approved post-delivery private name(s) for this
destination and requires each present in the environment AND its
pre-delivery name absent.
-/

private def appendNameParts (baseName : Lean.Name) (parts : List String) : Lean.Name :=
  parts.foldl (fun name part => .str name part) baseName

private def mangledPrivateName (moduleName declarationName : String)
    (ordinal : Nat) : Lean.Name :=
  let modulePrefix := appendNameParts .anonymous ("_private" :: moduleName.splitOn ".")
  appendNameParts (.num modulePrefix ordinal) (declarationName.splitOn ".")

private def approvedPrivateNames : List Lean.Name := [
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_gjeInvCumProd_unit_upper" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_gjeInvStageMatrix_diag_one" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_gjeInvStageMatrix_upper_triangular" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_gje_Pabs_le" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_gje_Q_abs_le" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_matMul_diag_one_of_unit_upper" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Theorem05.PrintedEnvelopes.CorrectionBounds" "NumStability.Ch14Ext.ch14ext_matMul_upper_triangular" 0
]

private def retiredPrivateNames : List Lean.Name := [
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_gjeInvCumProd_unit_upper" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_gjeInvStageMatrix_diag_one" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_gjeInvStageMatrix_upper_triangular" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_gje_Pabs_le" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_gje_Q_abs_le" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_matMul_diag_one_of_unit_upper" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14GJEPrintedEnvelopeClosure" "NumStability.Ch14Ext.ch14ext_matMul_upper_triangular" 0
]

run_cmd do
  let environment ← Lean.getEnv
  for name in approvedPrivateNames do
    let name ← NumStabilityTest.Reorganization.ProjectIdentityPrivateNames.requireMapped name
    unless Lean.Environment.contains environment name do
      throwError "R08 CorrectionBounds private normalization: missing approved name {name}"
  for name in retiredPrivateNames do
    if Lean.Environment.contains environment name then
      throwError "R08 CorrectionBounds private normalization: retired name {name} still present"
    if let some mappedName := NumStabilityTest.Reorganization.ProjectIdentityPrivateNames.migrate? name then
      if Lean.Environment.contains environment mappedName then
        throwError "private normalization: canonical retired name {mappedName} still present"
