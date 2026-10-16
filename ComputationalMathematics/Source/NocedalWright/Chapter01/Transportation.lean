import ComputationalMathematics.Source.NocedalWright.Chapter01.TransportationTarget

/-! # Nocedal--Wright transportation model (1.3) -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The set-based and explicit presentations of the transportation minimum agree. -/
theorem transportation13 : transportation13Target := by
  unfold transportation13Target
  aesop

end ComputationalMathematics.Source.NocedalWright.Chapter01
