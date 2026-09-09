# Finite Cartesian physical geometry constructor

The scratch constructor `NumStability.FiniteCartesianDraft.data` realizes the frozen `FiniteDirectionalRepair.PhysicalData` interface for any finite coordinate type, existing Cartesian axis family, and nonempty finite active set of integer cell positions. Its cell type is the active-set subtype. Its face IDs are integer coordinate positions; physical and face points are coordinate vectors. Actual physical cells are the existing Cartesian `Ico` boxes, with ordinary product Lebesgue measure. Their domain is exactly the union of active boxes.

The construction proves disjointness from the existing axis adjacency and positive-width hypotheses. It does not assume that the axes cover the whole real line. Positive finite cell measure follows from the existing `CartesianGrid.cellBox_volume` and positive product of widths. No exterior cell or global physical solution extension is required.

For direction `d` and face ID `face`, the actual face measure is

```text
Measure.map (CartesianGrid.facePoint axes d face)
  (volume.restrict (CartesianGrid.tangentialFaceBox axes d face))
```

The stored `facePoint` is identity. Each active cell's left face is its position; its right face updates coordinate `d` by `+1`. The left and right incidence proofs use membership in the restricted transverse `Ico` box almost everywhere and map it into the closure of the active cell. An exterior face is incident only to its active cell; shared interior face IDs identify the very same physical measure and numerical-flux location. The constructor accepts a supplied directional flux and its hyperbolicity on supplied admissible states. It sets `normalFlux d face point` to that exact directional flux.

The following theorems supply the fields needed by Laplace's separate `CartesianIdentification` consumer:

- `data_left_position`, `data_right_position`: exact active-cell and face coordinates.
- `data_cell_measure`: equality of actual restricted measures, rather than only their real-valued masses.
- `data_face_measurable`: measurability of the stored physical face map.
- `data_face_measure`: equality of the actual pushforward physical face measure.
- `data_normal_flux`: almost-everywhere equality to the supplied directional law for every state.

Additional results give actual `data_cellVolume`, `faceMeasure_area`, both a.e. incidence claims, and `data_shared_face`. All mathematical construction remains in `Cartesian.lean.fragment`, SHA256 `926ae4ab17980f2820d3af1e6c50a153d6c67414fffb2848acbdddd44e04585c`.

The independent fixture in `Fixture.lean.fragment` instantiates two adjacent active cells in dimension two using the existing unit-width axis and identity-flux hyperbolicity from canonical `Examples.PhysicalIntervalSweep`. The two active cells are distinct, share one internal face, have actual cell volumes one, and have actual face areas one. It is a geometry nonvacuity witness, not a high-resolution method or full solution-quality witness.

The exact frozen finite interface comes from `directional-reference-repair/Finite.lean` SHA256 `e9a5e7ef93ff71d8c9ecc39449cb741f2d400d684d2d78893b5884f8bf80054c`. Its namespace body was mechanically matched to immutable `execution07-Execution.lean` SHA256 `84336c591b80a110c053dd170481dcb4d783af7ea8e0d7818d4597bf508836f0`. The final scratch input retains this existing mathematics and appends the constructor and fixture. Production modules were imported and source/compiled-byte pinned, not edited.

`geometry01` is a preserved failed draft check: a missing integer argument in two closure rewrites and unused section-variable warnings. `geometry02` passed without warnings. `final01` checks the complete constructor and fixture and prints all 39 authored declaration types and axiom reports. It passed with actual native exit 0, without diagnostics or `sorryAx`; reports use only `propext`, `Classical.choice`, and `Quot.sound`. All source and compiled input bytes remained unchanged across that native run. `native-types.json` contains only exact final proof-free native output; the failed draft is excluded from that packet.

The coordinate-face pushforward is the stated measure model. No additional Hausdorff-measure identification, unit-normal theorem, arbitrary chart, boundary condition, quality-class witness, source interpretation, or source-faithfulness verdict is asserted. Laplace owns the physical-reference transport and composite source consumer. Root owns production placement and all gate, audit, organization, and Git operations.
