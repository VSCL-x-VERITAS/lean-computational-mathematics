import ComputationalMathematics.Source.Bhatia.Chapter01.IncreasingIndicesTarget

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

theorem increasingIndices_definition : Targets.increasingIndicesDefinition := by
  intro n k _hk
  exact ⟨fun _ => Iff.rfl, fun _ _ => Iff.rfl⟩

end NumStability.Bhatia.Chapter01
