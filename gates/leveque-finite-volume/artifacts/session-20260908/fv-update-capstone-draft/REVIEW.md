# Conditional finite-volume update capstone

This is an unselected scratch statement for the pending accuracy convention
`call_1UY4fVuKrjpIIQfhLdeuFoRH`. It introduces no source judgment.

The statement binds the old spatial average, physical time-averaged face flux,
weighted numerical error identity, and conditional next-cell error estimate to
the same grid, independently supplied conserved field, old numerical array,
two times and full-array flux rule. It uses only the canonical producers named
in `reuse.json`. No draft averaging or update alias is introduced.

The relocated witness is the previously checked unit-speed field q(x,t)=x-t on
unit cells, with zero numerical old data and a full-array, time-dependent rule.
Its old numerical value differs from the exact initial average; its physical
face time average differs from the initial point flux; its numerical flux is
nonzero. Its actual weighted error identity uses the same canonical theorem as
the capstone. `inputs-v1.json` records every substitution from the preserved
witness fragment. The original draft and receipts remain unchanged.

The error estimate is an implication from explicit old and face-error bounds.
It does not choose an order, tolerance, stability condition or convergence claim.
The rectangle predicate retains its spatial and temporal integrability
requirements. Positivity is supplied by cell widths and the strict time ordering.
The field and numerical array are independent; the numerical rule may depend on
the whole array. Real finite-vector norms use the inherited function norm.

Native check `fv-update-capstone-native01` returned zero on the exact
`Checks.lean` bytes. All ten authored declarations are checked and their actual
axioms are verified. This is proof and assembly evidence for a prospective
interpretation, not a replacement for a fresh source audit after that
interpretation is adopted.

