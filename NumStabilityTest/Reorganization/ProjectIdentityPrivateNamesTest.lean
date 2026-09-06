import NumStabilityTest.Reorganization.ProjectIdentityPrivateNames

/-! Exact private-owner adaptation must preserve numeric ordinals and authored
suffixes, reject unknown owners, and never rewrite ordinary public names. -/

namespace NumStabilityTest.Reorganization.ProjectIdentityPrivateNamesTest

open Lean
open NumStabilityTest.Reorganization.ProjectIdentityPrivateNames

private def privateName (owner : String) (ordinal : Nat) : Name :=
  let namePrefix := (owner.splitOn ".").foldl (fun name part => .str name part) `_private
  .str (.str (.num namePrefix ordinal) "NumStability") "protected_mathematical_suffix"

run_cmd do
  let oldOwner := "NumStability.Source.Higham.Chapter17.Results.Equation20.DiagonalizableBounds"
  let newOwner := "ComputationalMathematics.Source.Higham.Chapter17.Results.Equation20.DiagonalizableBounds"
  let old := privateName oldOwner 37
  let expected := privateName newOwner 37
  unless migrate? old == some expected do
    throwError "private owner adaptation changed the nonzero ordinal or authored NumStability suffix"
  unless migrate? (.num (.str old "nested_suffix") 19) ==
      some (.num (.str expected "nested_suffix") 19) do
    throwError "private owner adaptation changed a nested numeric declaration suffix"
  unless (← requireMapped old) == expected do
    throwError "approved-name lookup did not use the exact owner pair"
  let parent := "NumStability.Source.Higham.Chapter14.Problem15"
  let parentExpected := "ComputationalMathematics.Source.Higham.Chapter14.Problem15"
  unless migrate? (privateName parent 5) == some (privateName parentExpected 5) do
    throwError "exact mapped parent owner was not recognized"
  let nested := parent ++ ".SingularValueGuards.DeterminantSignAndRelativeBounds"
  let nestedExpected := parentExpected ++ ".SingularValueGuards.DeterminantSignAndRelativeBounds"
  unless migrate? (privateName nested 11) == some (privateName nestedExpected 11) do
    throwError "nested module owner was not matched at its exact numeric boundary"
  let unknown := privateName (parent ++ ".UnapprovedOwner") 5
  unless migrate? unknown == none do
    throwError "an unmapped nested owner inherited a parent prefix rewrite"
  unless migrate? (privateName "NumStability.UnapprovedOwner" 7) == none do
    throwError "an unknown owner received a blanket project-root rewrite"
  unless migrate? `NumStability.isNumericallyStable == none do
    throwError "ordinary public mathematical names must never be rewritten"
  unless migrate? expected == none do
    throwError "an already canonical private name was rewritten again"
  let rejected ← try
    let _ ← requireMapped unknown
    pure false
  catch _ => pure true
  unless rejected do
    throwError "an unknown approved private owner was silently accepted"

end NumStabilityTest.Reorganization.ProjectIdentityPrivateNamesTest
