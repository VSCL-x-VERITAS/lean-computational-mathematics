/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal
import Mathlib.Analysis.Calculus.ContDiff.Basic

/-!
# LeVeque equation (2.13): smooth translated profiles

Proof-free source target for the forward assertion on printed pages 17–18.
The source's smooth profile is represented by `ContDiff ℝ ∞`. Position and
time range over the whole real line, as in the boundary-free setting here.
The existing solution predicate includes actual partial derivative witnesses.
The separately inventoried converse and initial-value problem are not part of
this target. Independent statement auditing is still required.
-/

namespace NumStability.Leveque02Tracer

open scoped ContDiff

/-- Every smooth real profile, translated at constant velocity, solves the
classical scalar advection equation on the whole space–time plane. -/
def advectionProfileTarget : Prop :=
  ∀ (profile : ℝ → ℝ) (velocity : ℝ), ContDiff ℝ ∞ profile →
    IsLinearAdvectionSolution (travelingWave profile velocity) velocity

end NumStability.Leveque02Tracer
