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
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateCoordinateSweep",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethodInformation",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxError",
  "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod"
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
  liftIO <| IO.FS.writeFile ".lake/chapter01-batch10-expressions.jsonl" text
  liftIO <| IO.println s!"Chapter 1 declaration expressions exported: {records.size}"

end Chapter01ExpressionEvidence
