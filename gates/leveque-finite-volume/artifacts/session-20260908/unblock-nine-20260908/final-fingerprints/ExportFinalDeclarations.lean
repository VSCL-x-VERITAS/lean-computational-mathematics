/- Evidence program only: inspect compiled declaration expressions, never prove a source claim.
The type/proof representation removes metadata and bound-variable display names.
It is an alpha-canonical structural serialization, not full definitional normalization.
Compiler-generated declarations are filtered using the existing architecture convention. -/
import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsLeftSolutionDomains
import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateSplittingBalance
import ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeUpdateError
import ComputationalMathematics.Source.LeVeque.Chapter01.MaterialCellVolumeAveraging
import ComputationalMathematics.Source.LeVeque.Chapter01.MaterialInterfaceLocalRiemannData
import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInformationInterfaceFlux
import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannProblemDataClassification
import ComputationalMathematics.Source.LeVeque.Chapter01.SourceTermsRectangleBalance
import Lean

open Lean Lean.Elab.Command

namespace Chapter01ExpressionEvidence

private def generated : Name → Bool
  | .anonymous => false
  | .num _ _ => true
  | .str parent part =>
      part.startsWith "_" ||
      (part.startsWith "match_" && (Name.mkSimple part).isInternalDetail) ||
      generated parent

private def canonicalExpression : Expr → Expr
  | .mdata _ body => canonicalExpression body
  | .app fn arg => .app (canonicalExpression fn) (canonicalExpression arg)
  | .lam _ type body info => .lam .anonymous (canonicalExpression type) (canonicalExpression body) info
  | .forallE _ type body info => .forallE .anonymous (canonicalExpression type) (canonicalExpression body) info
  | .letE _ type value body nondep =>
      .letE .anonymous (canonicalExpression type) (canonicalExpression value) (canonicalExpression body) nondep
  | .proj typeName idx expr => .proj typeName idx (canonicalExpression expr)
  | expr => expr

private def kind : ConstantInfo → String
  | .axiomInfo _ => "axiom"
  | .defnInfo _ => "definition"
  | .thmInfo _ => "theorem"
  | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quotient"
  | .inductInfo _ => "inductive"
  | .ctorInfo _ => "constructor"
  | .recInfo _ => "recursor"

private def selectedModules : Array String := #[
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting",
  "ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsLeftSolutionDomains",
  "ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateSplittingBalance",
  "ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeUpdateError",
  "ComputationalMathematics.Source.LeVeque.Chapter01.MaterialCellVolumeAveraging",
  "ComputationalMathematics.Source.LeVeque.Chapter01.MaterialInterfaceLocalRiemannData",
  "ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInformationInterfaceFlux",
  "ComputationalMathematics.Source.LeVeque.Chapter01.RiemannProblemDataClassification",
  "ComputationalMathematics.Source.LeVeque.Chapter01.SourceTermsRectangleBalance"
]

run_cmd do
  let env ← getEnv
  let mut records : Array (String × Json) := #[]
  for h : idx in *...env.header.moduleData.size do
    let moduleName := env.header.moduleNames[idx]!
    if selectedModules.contains moduleName.toString then
      let data := env.header.moduleData[idx]
      for name in data.constNames, info in data.constants do
        if env.getModuleIdxFor? name == some idx &&
            !isReservedName env name && !generated (privateToUserName name) then
          let body := match info.value? true with
            | some value => Json.str (reprStr (canonicalExpression value))
            | none => Json.null
          let recursorBodies := match info with
            | .recInfo value => value.rules.map fun (rule : RecursorRule) =>
                Json.str (reprStr (canonicalExpression rule.rhs))
            | _ => []
          let record := Json.mkObj [
            ("name", Json.str name.toString), ("module", Json.str moduleName.toString),
            ("kind", Json.str (kind info)),
            ("level_params", toJson (info.levelParams.map Name.toString)),
            ("type", Json.str (reprStr (canonicalExpression info.type))),
            ("value", body), ("recursor_values", toJson recursorBodies)]
          records := records.push (name.toString, record)
  records := records.qsort fun a b => a.1 < b.1
  let text := String.intercalate "\n" (records.toList.map fun record => record.2.compress) ++ "\n"
  liftIO <| IO.FS.writeFile "gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/final-fingerprints/native-expression-stream.jsonl" text
  liftIO <| IO.println s!"Chapter 1 declaration expressions exported: {records.size}"

end Chapter01ExpressionEvidence
