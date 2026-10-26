import ComputationalMathematics.Source.Eymard.Chapter01.LocalConservativityTarget

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- The introductory local-conservativity terminology is precisely the
opposite-sign identity for the outward numerical fluxes at each interface. -/
theorem localConservativity : localConservativityTarget := by
  intro Cell Face Time Value inst left right _distinct flux
  rfl

end NumStability.Eymard.Chapter01
