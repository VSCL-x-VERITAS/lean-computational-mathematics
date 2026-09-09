# Unit-dependent availability bound: diagnosed limitation

The frozen `dim-time-step-admission-draft` remains unchanged and valid within its stated sufficient interface. Its fixed bound `dt ≤ mesh` must not be inherited as a generic source requirement. The coefficient 1 is not unit-invariant: a scalar advection method with speed 0.1 and only CFL-one steps has `dt = 10 * h`; it can be exact on translated profiles but fails that availability bound. This is a scope counterexample to the proposed generic interface, not a claim that the frozen Lean theorem is false.

A subsequent general family needs an explicit positive availability scale with appropriate units, a supplied physical horizon/step domain, or another actually justified normalization. It must retain inputwise availability without claiming a state-independent CFL for unbounded nonlinear states. This packet does not select or implement that broader API.

The present certificate repair is independent: it uses existing fixed-step line families under the frozen C-infinity overlay and repairs only the placement of accuracy constants/thresholds relative to a later execution. All admission, capacity, realization, stability-separation and broader source-domain findings remain recorded.
