import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

open MeasureTheory Set

theorem intervalIntegrable_piecewise_probe {s : Set ℝ} [DecidablePred (· ∈ s)]
    {f g : ℝ → ℝ} {a b : ℝ} (hs : MeasurableSet s)
    (hf : IntervalIntegrable f volume a b) (hg : IntervalIntegrable g volume a b) :
    IntervalIntegrable (s.piecewise f g) volume a b := by
  rw [intervalIntegrable_iff]
  exact Integrable.piecewise (s := s) (μ := volume.restrict (uIoc a b)) hs
    hf.def'.integrableOn hg.def'.integrableOn

#print axioms intervalIntegrable_piecewise_probe

example (a b t : ℝ) :
    IntervalIntegrable (fun x : ℝ => if x < 0 then t - x else -t - x) volume a b := by
  apply intervalIntegrable_piecewise_probe measurableSet_Iio
  · exact (continuous_const.sub continuous_id).intervalIntegrable a b
  · exact (continuous_const.sub continuous_id).intervalIntegrable a b
