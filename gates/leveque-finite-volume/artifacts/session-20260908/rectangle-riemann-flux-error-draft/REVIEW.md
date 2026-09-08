# Conditional interface-error foundation

The three scratch results apply to the actual selected `RectangleRiemannInterfaceFluxMethod`, with its explicit domain for each ordered adjacent-cell problem. They support arbitrary finite-dimensional nonlinear physical fluxes under the existing law representation. The returned local solutions supply actual rectangle integrability.

The first estimate bounds the difference between the selected numerical flux and the global field's time-averaged physical face flux by the sum of two independently supplied bounds: numerical flux versus returned local trace, and returned local trace versus global trace. It uses normalized interval-average estimates twice and the norm triangle inequality. Constant-state consistency cannot establish either error premise for unequal data.

The next-cell and contiguous-block mass estimates reuse the existing finite-volume error producers. The block estimate controls the norm of total weighted mass error, so cancellation is allowed. The rule passed to that producer selects the already fixed admissible `old` array and its actual method flux; it does not assert a solver domain for other arrays.

Proposed canonical placement: `Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannFluxError`, using names `rectangleRiemannInterfaceFlux_error_le`, `rectangleRiemannInterfaceFlux_update_error_le`, and `rectangleRiemannInterfaceFlux_block_mass_error_le`. No new predicate or duplicated conservation proof is needed. An independent review is pending; this document does not approve source-row closure.

These are conditional generic foundations. There is no claim about high resolution, an accuracy order, CFL conditions, convergence, or general nonlinear solvability. The existing linear method provides the stronger exact local-trace special case. Source interpretation questions and source audits remain separate obligations.
