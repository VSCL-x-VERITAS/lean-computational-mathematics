# Time-integrated transport balance prerequisite

The current Riemann-interface certificate uses
`IsIntegralConservationLawSolution`, whose body demands `HasDerivAt` for the
mass of every spatial interval at every time. A moving discontinuity crossing
an endpoint is a suspected effective-domain problem for this classical-rate
predicate. This review has not yet proved a counterexample and does not label
the existing theorem false. The pending source audit must distinguish the
displayed classical rate in (1.10) from the discontinuous Riemann solution
construction on printed page 5.

Before writing a prerequisite, `rg` searched the current PDE family and pinned
Mathlib interval-integral modules for `Riemann`, `translation`, `translate`,
`integral.*transport`, `rectangle.*balance`, `spaceTime.*[Bb]alance`,
`integral_comp_(sub|add|mul|div)`, and adjacent-interval identities. The project
already supplies `travelingWave`, `riemannData`, eigenmode waves, and a complete
eigenbasis. No time-integrated transport rectangle theorem was selected in
these searches. This is not a claim of global semantic absence.

The exact selected Mathlib producers are:

- `intervalIntegral.integral_comp_sub_right` for spatial translation;
- `intervalIntegral.smul_integral_comp_sub_mul` for the temporal boundary
  integrals, valid also at zero speed;
- `intervalIntegral.integral_interval_sub_interval_comm` for cancellation
  across all four rectangle edges, without endpoint-order restrictions;
- `IntervalIntegrable.comp_sub_right`, `.comp_sub_left`, `.comp_mul_left`,
  and `.smul` for actual integrability of the spatial and temporal slices;
- `intervalIntegral.integral_sub` and `.integral_smul` to combine the two
  physical boundary fluxes.

These exact substitutions eliminate any need to re-prove special Heaviside
integral formulas for the basic balance. The checked scratch theorem works
for any real normed vector space and every profile integrable on all finite
intervals; it needs neither differentiability nor a complete-space hypothesis.
The proposed rectangle predicate explicitly includes spatial and boundary-flux
integrability, as well as the time-integrated equality. It does not require
pointwise differentiability at a moving jump.

Native command `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/transport-rectangle-candidate.lean`
exited 0. `transport-rectangle-output.txt` records only the allowed foundational
axioms for the final theorem. Two earlier unsuccessful outputs are retained
as `transport-rectangle-first-output.txt` and `transport-rectangle-second-output.txt`:
they show an incorrect API name and a rewrite-matching failure respectively,
including Lean's temporary `sorryAx` from the failed elaborations. Neither is
used as proof evidence. The final source contains no admitted proof.

This is a checked scratch prerequisite only. It does not close a source row,
construct a Riemann solution by itself, or establish source faithfulness. The
next construction must instantiate genuinely integrable jump profiles, combine
the eigenmodes, and prove the required initial-data and similarity properties.
