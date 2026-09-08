# Second-order wave classification candidate

The selected immutable source states after (1.7), printed 3/raw 25, that this
pressure wave equation is hyperbolic under the standard classification of
second-order linear equations. Its earlier material parameters supply
`c = sqrt(K/rho)`. The external reference [234] has not been imported as an
additional source. The proposed explicit convention is a reconstruction to be
judged against the selected book, not a claim that the book printed a
discriminant formula here.

Whole-library and pinned Mathlib searches for principal symbols/parts,
second-order hyperbolicity, hyperbolic polynomials, and PDE discriminants
found no direct PDE-classification producer. Unrelated number-theory
“principal part” matches were rejected. Mathlib's
`Matrix.IsHyperbolic` in the GL2 family is a different matrix classification,
so it was not substituted.

Mathlib/Algebra/QuadraticDiscriminant.lean supplies `discrim` (line 48) and
`quadratic_eq_zero_iff` (line 84). The reusable numeric discriminant is
selected; the root formula is available context but unnecessary for the
positive-discriminant check. The scratch candidate explicitly records the
coefficients of p_tt, p_tx, p_xx and uses the full mixed coefficient, avoiding
a hidden factor-of-two convention.

The candidate principal part is (1,0,-c²), with discriminant 4c². Positivity
is supplied by the source's positive bulk modulus and density through
`Real.sqrt_pos` and `div_pos`. No initial data, particular pressure field,
or regularity premise is needed for a classification of these coefficients.
No second-order existence, uniqueness, or equivalence to the full acoustics
system is claimed. Independent auditing must still check that this convention
faithfully expresses the book's classification sentence.
