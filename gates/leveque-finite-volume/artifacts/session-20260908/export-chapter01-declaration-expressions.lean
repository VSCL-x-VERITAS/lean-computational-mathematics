/- Evidence program only: inspect compiled declaration expressions, never prove a source claim.
The type/proof representation removes metadata and bound-variable display names.
It is an alpha-canonical structural serialization, not full definitional normalization.
Compiler-generated declarations are filtered using the existing architecture convention. -/
import ComputationalMathematics
import NumStability
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
  "ComputationalMathematics.Analysis.Calculus.Deriv.Abs",
  "ComputationalMathematics.Analysis.Calculus.Piecewise",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Discontinuity",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Conservation",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Jump",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Potential",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Regularity",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingStep",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VariableCoefficient",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.CharacteristicPropagation",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection",
  "ComputationalMathematics.Analysis.SpecialFunctions.Huber",
  "ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation",
  "ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise",
  "ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsEigenvalues",
  "ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsModes",
  "ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsRightModeAlgebraic",
  "ComputationalMathematics.Source.LeVeque.Chapter01.AdvectionWaveIdentity",
  "ComputationalMathematics.Source.LeVeque.Chapter01.DiscontinuityGeneralComparison",
  "ComputationalMathematics.Source.LeVeque.Chapter01.DiscontinuityWitnesses",
  "ComputationalMathematics.Source.LeVeque.Chapter01.EigenbasisDecoupling",
  "ComputationalMathematics.Source.LeVeque.Chapter01.EigenvaluePropagation",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation01",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation02SolutionDomains",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation02UniformTransport",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation03SolutionDomains",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation03TransportSolution",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation04AcousticModel",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation05Definition",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation06",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation07",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation08",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation09",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation10Definition",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Equation11",
  "ComputationalMathematics.Source.LeVeque.Chapter01.FluxJacobianHyperbolicity",
  "ComputationalMathematics.Source.LeVeque.Chapter01.Hyperbolicity",
  "ComputationalMathematics.Source.LeVeque.Chapter01.IntegralToDifferential",
  "ComputationalMathematics.Source.LeVeque.Chapter01.LinearFluxSpecialization",
  "ComputationalMathematics.Source.LeVeque.Chapter01.LinearRiemannEigensolution",
  "ComputationalMathematics.Source.LeVeque.Chapter01.MaterialInterfaceRiemannData",
  "ComputationalMathematics.Source.LeVeque.Chapter01.NonconservationSourceTerms",
  "ComputationalMathematics.Source.LeVeque.Chapter01.NonlinearShockFormation",
  "ComputationalMathematics.Source.LeVeque.Chapter01.OneStepMethod",
  "ComputationalMathematics.Source.LeVeque.Chapter01.RectangleRiemannInterfaceFlux",
  "ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration",
  "ComputationalMathematics.Source.LeVeque.Chapter01.RiemannRayZero",
  "ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity",
  "ComputationalMathematics.Source.LeVeque.Chapter01.SecondOrderHyperbolicity",
  "ComputationalMathematics.Source.LeVeque.Chapter01.VariableCoefficientConservationForm"
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
            | .recInfo value => value.rules.map fun rule =>
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
  liftIO <| IO.FS.writeFile ".lake/chapter01-declaration-expressions.jsonl" text
  liftIO <| IO.println s!"Chapter 1 declaration expressions exported: {records.size}"

end Chapter01ExpressionEvidence
