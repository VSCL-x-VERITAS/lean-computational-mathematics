# Cartesian coordinate-line composition

This scratch fragment proves that the canonical supplied-volume operation `CoordinateLineBalance.advance` specializes to the actual frozen `TensorLinesDraft.advanceDirection`. Neither an equality of their outputs nor a conservation conclusion is assumed. The equality follows from their existing mass identities and the positive measured cell volume.

## Geometry and face provenance

The cell is exactly the frozen Cartesian product of its axis-grid half-open intervals. Its supplied volume equals the real value of its Lebesgue measure by the existing `TensorGrid.cellBox_volume`. The face area is the product of the transverse widths. `tangentialFaceBox_volume` identifies that number with Lebesgue measure in the transverse coordinate space `{e // e ≠ d} → ℝ`; ambient D-dimensional measure of a codimension-one face is not used as its area.

`facePoint` embeds those transverse coordinates at the left boundary of the indexed right cell. Its normal/transverse coordinate theorems expose the actual coordinates. `shared_face_position` uses the axis-grid adjacency proof to identify that location with the preceding cell's right boundary. The transverse face box and area are unchanged when only the normal cell index changes. Thus the two cells use the same transverse geometry at their shared face.

The positive-coordinate orientation is explicit. `coordinate_normal_flux` contracts the supplied directional physical-flux family with the positive coordinate normal and obtains the selected direction's physical flux. The new `cartesianRule` multiplies that solver flux by the transverse area. `normalFaceFlux_physical_trace` identifies it with the area times the physical flux of that exact returned solver field. `selected_face_problem` exposes both ordered neighboring initial states from the actual numerical line and rectangle solutionhood for the same law. The law carried by the frozen solver retains the actual differentiable physical flux and hyperbolic Jacobian; no unrelated hyperbolicity tag is introduced.

The transferred quantity is an area-weighted face value in the numerical finite-volume model. No theorem says an arbitrary multidimensional exact field is constant along the face or that this value equals its exact face integral. Such an approximation relation would need additional data. The physical geometry here is Cartesian; no arbitrary logical chart is used to infer missing metric meaning.

## Executed update and sweeps

The canonical right-minus-left shared flux simplifies to the frozen transverse area times the same two numerical line fluxes. Multiplying either update by the positive cell volume gives the same mass balance, proving `advance_eq_advanceDirection`. This proof reuses `CoordinateLineBalance.advance_mass_balance` and `TensorLinesDraft.advanceDirection_full_volume_balance`; it does not duplicate their numerical update or integral definitions.

`line_advance` and `strict_line_locality` retain the exact restriction to the same one-dimensional old data. Equality of directional operators transports every finite direction-duration list through the existing ordered executor. The cons and two-stage theorems explicitly pass the preceding result into the next step. The measured two-stage mass formula evaluates its second flux on that first updated state. Every step of the frozen fractional schedule agrees with the canonical operation on every supplied intermediate input.

The existing positive-dimensional identity-system solver and stripe array supply nonvacuity. The canonical Cartesian operation fails the exact broadcast-origin map rejected by the historical audit. Its two-step execution agrees with the corresponding actual tensor composition. No new Riemann solver is postulated.

## Exact retained scope

The frozen `LineSolver` is a total exact-interface class: its numerical flux equals its own selected returned solution's ray-zero trace at time one. The new rule retains the executor's duration argument but does not use it to assert that every such time-one trace is a time average. The linear subfamily's previously proved time-average identity remains available separately. No broader approximate-solver class, high-resolution guarantee, error order, stability, CFL condition, entropy selection or nonlinear existence claim is added.

The algebra permits arbitrary real stage durations; positive physical durations are included. Stage order matters, and no commutation claim is made. The pending logical-grid question `call_axfTXsEjNKG3lawf5Dq10qQv` remains unanswered. This bridge is reusable Cartesian mathematics and does not decide the full source row.

## Reuse and validation

`reuse-provenance.json` records the bounded project/Mathlib searches and exact frozen inputs. The whole frozen `dimensional-splitting-lines-draft/final-05-input.lean` is included byte-for-byte after the new canonical import. Its SHA is `51d5b881df63950ebcbfc3e1d2f51fb8b66d3c4ac9d730dd167b5545f65f0e33`. No old scratch or canonical owner is edited. Mathlib's Cartesian box-volume theorem, finite product/subtype identity and function-update laws supply the new geometry proofs.

Each attempt preserves its complete assembled input, native raw output, actual exit, direct source/compiled-import hashes and runtime pins. The first attempt already checked the executed-update and sweep equalities, but the run failed on three geometric/solver helper elaborations; its output contains the resulting unaccepted incomplete declarations and is retained as failure evidence. Final acceptance of this scratch check requires native exit zero, all new declaration checks, allowed axioms only, and no warnings/errors. `final-receipt.json` records those actual checks; `verify.py` rechecks its bindings without writes.

Reproduce with a fresh immutable label from the repository:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -B 'gates/leveque-finite-volume/artifacts/session-20260908/cartesian-coordinate-line-composition-draft/run.py' review01
```

Only this new scratch directory was written. Production placement, aggregate/tier changes, source wrappers, independent source audits and interpretation decisions remain outside this task.
