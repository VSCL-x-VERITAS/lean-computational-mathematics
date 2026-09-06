import NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError
import NumStabilityTest.Reorganization.ProjectIdentityPrivateNames

/-!
# ForwardError private normalization

Constructs the 5 approved post-delivery private name(s) for this
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
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError" "NumStability.Ch14Ext.ch14ext_double_sum_add_scaled" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError" "NumStability.Ch14Ext.ch14ext_matMulVec_matrix_add_scaled" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError" "NumStability.Ch14Ext.ch14ext_matMulVec_triple_matrix_add_scaled" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError" "NumStability.Ch14Ext.ch14ext_matMulVec_vector_add_scaled" 0,
  mangledPrivateName "NumStability.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ScaledPerturbationEndpoints.ForwardError" "NumStability.Ch14Ext.ch14ext_sq_mul_isBigO_of_continuousAt" 0
]

private def retiredPrivateNames : List Lean.Name := [
  mangledPrivateName "NumStability.Algorithms.Ch14ForwardErrorEndpoint" "NumStability.Ch14Ext.ch14ext_double_sum_add_scaled" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14ForwardErrorEndpoint" "NumStability.Ch14Ext.ch14ext_matMulVec_matrix_add_scaled" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14ForwardErrorEndpoint" "NumStability.Ch14Ext.ch14ext_matMulVec_triple_matrix_add_scaled" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14ForwardErrorEndpoint" "NumStability.Ch14Ext.ch14ext_matMulVec_vector_add_scaled" 0,
  mangledPrivateName "NumStability.Algorithms.Ch14ForwardErrorEndpoint" "NumStability.Ch14Ext.ch14ext_sq_mul_isBigO_of_continuousAt" 0
]

run_cmd do
  let environment ← Lean.getEnv
  for name in approvedPrivateNames do
    let name ← NumStabilityTest.Reorganization.ProjectIdentityPrivateNames.requireMapped name
    unless Lean.Environment.contains environment name do
      throwError "R08 ForwardError private normalization: missing approved name {name}"
  for name in retiredPrivateNames do
    if Lean.Environment.contains environment name then
      throwError "R08 ForwardError private normalization: retired name {name} still present"
    if let some mappedName := NumStabilityTest.Reorganization.ProjectIdentityPrivateNames.migrate? name then
      if Lean.Environment.contains environment mappedName then
        throwError "private normalization: canonical retired name {mappedName} still present"
