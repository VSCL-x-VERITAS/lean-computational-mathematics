# Selected similarity-ray value

The source on printed page 11/raw page 33 assigns notation to the value of a
selected Riemann similarity solution along ray zero. The previously checked
linear eigendata construction supplies one such field but does not cover the
general notation definition by itself.

Current canonical and pinned Mathlib searches used `selfSimilar`,
`SelfSimilar`, `rayZero`, `ray_zero`, and `similarityProfile`; no matching
production declaration was selected. The existing session linear-Riemann
self-similarity and ray-zero theorems were read as an application. The generic
candidate uses real division identities and positive-time self-similarity
directly, avoiding a second eigenmode or solver proof. The scoped search is
not global semantic-absence evidence.

The time-one slice is the explicitly selected profile. Evaluation along any
positive-time ray equals that profile's value, and an iff characterizes the
unique value on that selected ray. The zero-ray corollary is therefore not
restricted to linear systems or to a particular Riemann solver. No continuity,
entropy condition, solver existence, or equality between different selected
traces is asserted. The eventual source wrapper must tie the selected field
to its prescribed Riemann initial data and equation separately.

Native `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/similarity-ray-candidate.lean`
exited 0, with only propext, Classical.choice, and Quot.sound in all four
printed theorem closures. The final output is `similarity-ray-output.txt`.
This candidate was developed after the fifth checkpoint's frozen staging
scope and remains for the next placement/audit increment.
