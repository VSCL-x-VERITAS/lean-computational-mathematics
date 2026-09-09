# Three interpreted source capstones

This implementation follows the coordinator-selected Q5/Q6/Q8 record in
`../selected-interpretations.json`, SHA256
`cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34`.
The user's request delegates unblocking the nine remaining rows; it is not
represented as a literal answer selecting every detailed convention. The
original source wording and prior rejected or undetermined audits remain intact.

Three new canonical source leaves contain one theorem each. No existing owner,
aggregate, tier, gate, ledger or audit was edited:

| File in `ComputationalMathematics/Source/LeVeque/Chapter01/` | Declaration in `NumStability` |
|---|---|
| `SourceTermsRectangleBalance.lean` | `leveque01_sourceTermsRectangleBalance` |
| `MaterialInterfaceLocalRiemannData.lean` | `leveque01_materialInterfaceLocalRiemannData` |
| `MaterialCellVolumeAveraging.lean` | `leveque01_materialCellVolumeAveraging` |

The source-term theorem keeps the contaminant in `Fin 1 → ℝ` and identifies its
actual flux as `speed • state`. Its given density-bearing model has the exact
four integrability requirements of `IsRectangleBalanceLawSolution`. It derives
the integrated production/mass-defect identity, both zero/nonzero source
equivalences, and the mass-rate derivative almost everywhere for each fixed
spatial interval. These conclusions reuse canonical rectangle-balance producers;
there is no new derivative or integration proof. The target does not assert that
every arbitrary nonconservative field admits an ordinary density, identify the
iterated conditions with joint space-time L1_loc, or cover singular production
measures. Signed production and depletion are both admitted.

The material theorem selects only local medium traces, with two distinct
constant initial states on the strict half-lines. It produces both component
jumps, the paired one-sided limits with separate material/state inequalities,
actual discontinuity in Hausdorff target spaces, and the existing free-origin
Riemann representation. It does not impose global material constancy. There is
no constitutive law or reflection/transmission theorem in this source target.

The averaging theorem uses the existing normalized Bochner volume integral. It
constructs the actual assigned values, proves uniqueness, ties locality to those
same values, and reproduces constants on finite positive-volume cells. Its
hypotheses require only cellwise integrability. It imposes no unequal-average
condition. Arithmetic averaging's physical adequacy for every possible material
model is not asserted; the source leaves room for model-dependent alternatives.

`Checks.lean` applies the actual new source theorems. The density example is
literally vector-valued in `Fin 1`, has the full new capstone as a theorem, and
computes positive and negative unit-rectangle contributions using canonical
producers. The local-medium example has both jumps and no global half-line
material representation. The averaging examples separately exercise equal
averages of a field varying inside each cell and unequal averages of another
field. The final check prints exact declaration types and axioms; it also
exposes `Real.measureSpace`, the inner-product-space volume construction, the
Stieltjes identity and unit-interval normalization. No theorem proof bodies are
printed as audit inputs.

`run-native.py` uses native Lake without invoking Git. Every run writes into a
fresh label directory and retains exact source snapshots, raw output and actual
exit status. `build-01` builds all three new modules; `source-01` through
`source-03` elaborate each file directly. `checks-01` checks the first fixture
version. `checks-final` adds fully qualified proof-free listings and avoids an
ambiguous short `unitInterval` lookup; theorem bodies and all production bytes
are unchanged. No native Lean failure occurred. Final results and hashes are
recorded by the separate production manifest after those commands finish.

The prior `review.json`, `REVIEW.md` and `receipt.json` describe the earlier
read-only phase and are unchanged. This implementation is an additive phase,
not a rewrite of that evidence. Root owns new statement audits, exposure,
organization, full-library checks and gate disposition. Compilation does not
itself accept a source interpretation or close a row.
