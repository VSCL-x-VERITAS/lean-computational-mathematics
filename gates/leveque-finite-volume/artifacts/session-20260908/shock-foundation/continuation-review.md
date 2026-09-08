# Separate continuation assessment after freezing the two checked increments

The previously checked Burgers and moving-step source/output files and their `final-verification.json` are left unchanged. This note records proposed next work and rejected candidates; it is not a new validation receipt.

## Rejected nonentropy bubble

The self-similar Burgers states `0, -1, +1, 0`, separated by rays of speeds `-1/2, 0, +1/2`, satisfy the three algebraic Rankine–Hugoniot relations and have zero initial trace. However, the central `-1 → +1` jump is an expansion shock and violates the usual entropy admissibility. It is rejected as the chapter's intended smooth-data shock-formation witness. No Lean implementation or source closure is claimed for it.

## Coordinator's Huber-flux construction

The proposed scalar flux is `f(q)=q²/2` for `|q|≤1`, and `f(q)=|q|-1/2` otherwise. It is convex, nonlinear, and continuously differentiable; these remain proof obligations rather than imported source facts. Its derivative is the clipped identity with values in `[-1,1]`. The initial data `q₀(x)=-x` are smooth on the whole real line and locally integrable but unbounded. Chapter 1's selected assertion does not itself impose boundedness or compact support on the initial data.

For `t<1`, the proposed solution equals `t-x` if `x<t-1`, `-x/(1-t)` if `|x|≤1-t`, and `-t-x` if `1-t<x`. The traces agree at both moving interfaces, so no jump is asserted before time one. For `t≥1`, it equals `t-x` to the left of zero and `-t-x` to the right. At zero choose one of the actual traces, for example `q(0,t)=t`.

For `t≥1` the two traces are `t` and `-t`, the flux traces agree at `t-1/2`, and the stationary jump speed is zero. The characteristic speeds of the outer flux branches are `+1` and `-1`, respectively, which is the compressive ordering around the zero shock speed. This avoids the expansion-shock defect of the rejected bubble. At a stationary interface the chosen representative matters to a rectangle law stated with pointwise boundary flux over time: choosing the unrelated value zero would give the wrong flux along a rectangle edge at `x=0`. Choosing either actual trace preserves the common flux. This differs from the earlier moving-step counterexample, where a fixed boundary meets the jump only at an isolated time.

The suggested potential is `U=-x²/[2(1-t)]` in the central region and `U=-x²/2-t|x|+t/2-t²/2` in the outer region and after collapse. Direct algebra gives matching values at `|x|=1-t`, `U_x=q` away from interfaces, and `U_t=-f(q)` away from the collapse point. At fixed `x=0`, the time derivative has a corner at `t=1`; the rectangle proof therefore needs piecewise FTC or an absolutely-continuous formulation. A classical derivative at every point must not be smuggled into the potential hypotheses. The flux is only C1 at `q=±1`, and the solution can have spatial derivative jumps at the moving interfaces even before the discontinuity forms. The intended theorem must distinguish continuity before collapse from global C1 regularity before collapse.

This construction appears to avoid inverse-function foundations. A useful next checked increment is its exact initial condition, the pre-collapse matching traces, the post-collapse flux equality/compressive ordering, and scalar flux differentiability. Full source closure additionally needs the actual complete space-time solution, local integrability, rectangle balance for all relevant endpoints/times, and a proved discontinuity at positive time. Algebraic Rankine–Hugoniot alone cannot certify the complete weak solution.
