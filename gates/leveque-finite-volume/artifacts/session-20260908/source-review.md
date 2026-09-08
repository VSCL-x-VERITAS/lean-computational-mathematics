# Chapter 1 source reinspection, 2026-09-08

Session: `codex-start-1-v5-0-1-20260908`. Stage:
`leveque-chapter01-codex-20260908`. Workflow tag:
`formalization-workflow-v5.0.1`, commit
`7d9cbf158607ace1c94d9ce13e26106c43e12a23`.

Source SHA-256:
`b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
Profile SHA-256:
`b140898932e6b43e2340459f2d7b4cfee42fddc18ef1ae307ed1c11e55b2d9ea`.

## Procedure and provenance

The coordinator verified the PDF and profile with native `Get-FileHash`.
Poppler rendered raw pages 23-33 with
`pdftoppm -f 23 -l 33 -scale-to 1600 -png SOURCE OUTPUT_PREFIX`.
The coordinator inspected every page image, and a separate source-only agent
(`/root/source_inventory`, fresh context, no Lean or proof access) independently
inspected all eleven images and compared the 47 inherited gate rows against them.
The extracted text was used only for navigation. Source images and extraction
are retained in `workflow-v5.0.1-local/chapter01-source-review` outside the Lean
repository; the immutable PDF remains in the selected book package.
Runtime model and effort for the independent agent were not exposed by the
spawn result. This is an inventory review, not a sealed theorem-faithfulness audit.

All numbered equations (1.1)-(1.11) are represented. There are no exercises,
figures, or tables in this chapter. The inherited inventory is not yet certified
complete: the findings below must be reconciled before coverage closure.

## Definite inventory findings

1. Equations (1.1), (1.5), (1.8), and (1.10), at printed pages 1, 2, 3, and 4
   respectively, define substantive mathematical forms. Their lack of a
   standalone existence theorem does not justify omitting definition coverage.
   Reopen the skipped rows for definition correspondence; preserve prior failed
   theorem encodings as evidence rather than repeating them.
2. Equation (1.10), printed page 4/raw page 26, explicitly covers any two spatial
   endpoints. Its skip rationale must not suggest that the source has no
   quantification. Time domain, regularity and integral conventions still need
   explicit correspondence review.
3. Printed page 4/raw page 26 states both exact algebraic conservation form for
   linear acoustics and an empirical small-disturbance caveat. These need
   separate source rows or an explicit completed correspondence link. The
   empirical caveat cannot dispose of the exact assertion.
4. Printed page 3/raw page 25, after (1.7), calls the second-order wave equation
   hyperbolic under the standard second-order classification. Add its missing
   coverage record without importing source facts from the cited external book.
5. Printed page 10/raw page 32 describes one-step methods by dependence of the
   next state solely on the current state. Index notation alone does not cover
   this separate mathematical definition.
6. Dimensional splitting on printed page 6/raw page 28 covers rectangular or
   logically rectangular grids. Preserve both and avoid silently requiring a
   physical rectangular geometry, a particular sweep order, or a time integrator.
7. The linear Riemann eigensolution assertion starts on printed page 5/raw page
   27 and continues on page 6/raw page 28. Correct the start locator. Missing
   construction foundations do not by themselves justify skipping this claim.
8. The smooth-data shock-formation sentence spans printed pages 4-5/raw pages
   26-27. Preserve the continuation locator.

## Explicit judgment calls still to resolve

- Printed page 4/raw page 26: loss of contaminant conservation requires source
  terms, but no formula is specified here.
- Printed page 7/raw page 29: the assertion that shocks only arise from nonlinear
  phenomena needs a distinction between shock formation and prescribed linear
  discontinuities.
- Printed page 7/raw page 29: typical second-order accuracy is a qualified claim
  about an unspecified method class, not a supplied error theorem.
- Printed page 8/raw page 30: variable-coefficient equations may lack conservation
  form; separate this assertion from the broad wave-propagation-method description.
- Printed page 3/raw page 25: system-level decomposition into scalar waves must
  be covered beyond mere algebraic vector decomposition if the selected
  eigenmode-speed row does not already provide that coverage.
- Printed page 11/raw page 33: evaluation of a selected similarity solution at
  ray zero is a definition. Do not require canonical uniqueness that the source
  does not assert; review a parameterized solution/trace convention.

## Source-to-Lean contract risks

- Printed page 1/raw page 23 says any translated profile. Unrestricted translation
  and classical PDE satisfaction with differentiability must remain distinct.
- Printed page 2/raw page 24 prints q-superscript-2 after introducing w-superscript-2.
  Preserve and adjudicate this notation mismatch in the left-mode row.
- Material positivity and nonzero assumptions need explicit physical-context
  justification when inverting characteristic variables.
- Riemann initial data at x=0 is unspecified; preserve that freedom.
- Finite-volume and splitting prose specifies method patterns. A convenient
  forward-Euler, uniform-grid, telescoping, or composition theorem is not by
  itself proof that the source stated that particular algorithm.

These findings concern inventory and source correspondence. They do not change
the pinned source, profile, module readiness seal, or unit-index seal, and they
do not count as newly formalized mathematical objects.
