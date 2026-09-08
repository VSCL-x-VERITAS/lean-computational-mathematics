# Declaration dossier for LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_hyperbolicMatrix_uniqueEigenbasisDecomposition
    {m : ℕ} {coefficient : Matrix (Fin m) (Fin m) ℝ}
    (hcoefficient : leveque01IsHyperbolicMatrix coefficient) :
    ∃ (eigenvalues : Fin m → ℝ)
        (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ p, coefficient.mulVec (eigenbasis p) =
        eigenvalues p • eigenbasis p) ∧
      ∀ q : Fin m → ℝ,
        ∃! amplitudes : Fin m → ℝ,
          ∑ p, amplitudes p • eigenbasis p = q
```

## Elaborated target type

```lean
∀ {m : Nat} {coefficient : Matrix (Fin m) (Fin m) Real},
  NumStability.leveque01IsHyperbolicMatrix coefficient →
    Exists fun eigenvalues =>
      Exists fun eigenbasis =>
        And
          (∀ (p : Fin m),
            Eq (coefficient.mulVec (Module.Basis.instFunLike.coe eigenbasis p))
              (instHSMul.hSMul (eigenvalues p) (Module.Basis.instFunLike.coe eigenbasis p)))
          (∀ (q : Fin m → Real),
            ExistsUnique fun amplitudes =>
              Eq (Finset.univ.sum fun p => instHSMul.hSMul (amplitudes p) (Module.Basis.instFunLike.coe eigenbasis p))
                q)
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} {coefficient : Matrix.{0, 0, 0} (Fin m) (Fin m) Real}
  (hcoefficient : @NumStability.leveque01IsHyperbolicMatrix m coefficient),
  @Exists.{1} (Fin m → Real) fun (eigenvalues : Fin m → Real) =>
    @Exists.{1}
      (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
        (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
          (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
            (@NormedField.toNormedSpace.{0} Real Real.normedField))))
      fun
        (eigenbasis :
          @Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
            (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
            (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@NormedField.toNormedSpace.{0} Real Real.normedField)))) =>
      And
        (∀ (p : Fin m),
          @Eq.{1} (Fin m → Real)
            (@Matrix.mulVec.{0, 0, 0} (Fin m) (Fin m) Real
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (Fin.fintype m) coefficient
              (@DFunLike.coe.{1, 1, 1}
                (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                (Fin m) (fun (x : Fin m) => Fin m → Real)
                (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                eigenbasis p))
            (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
              (@instHSMul.{0, 0} Real (Fin m → Real)
                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                    (@Algebra.id.{0} Real Real.instCommSemiring))))
              (eigenvalues p)
              (@DFunLike.coe.{1, 1, 1}
                (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                (Fin m) (fun (x : Fin m) => Fin m → Real)
                (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                eigenbasis p)))
        (∀ (q : Fin m → Real),
          @ExistsUnique.{1} (Fin m → Real) fun (amplitudes : Fin m → Real) =>
            @Eq.{1} (Fin m → Real)
              (@Finset.sum.{0, 0} (Fin m) (Fin m → Real)
                (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                (@Finset.univ.{0} (Fin m) (Fin.fintype m)) fun (p : Fin m) =>
                @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                  (@instHSMul.{0, 0} Real (Fin m → Real)
                    (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                      (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                        (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                        (@Algebra.id.{0} Real Real.instCommSemiring))))
                  (amplitudes p)
                  (@DFunLike.coe.{1, 1, 1}
                    (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                    (Fin m) (fun (x : Fin m) => Fin m → Real)
                    (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                    eigenbasis p))
              q)
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.leveque01IsHyperbolicMatrix`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f56ff4e5bc3e10870857a370ba3d77514cd966519ab735d80f24d697a4effac8`

Hash-verified prior declaration review:

- Reuse SHA-256: `f07f138ffa24cebe10dcfeed8d9d95c2613b8e79dfb8d38e4d3f6e4b09ec98a2`
- Reviewed interpretation: The abbreviation applies IsRealHyperbolicMatrix to the same real matrix indexed by Fin m.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D002: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d47cd84c44b0c456ec06f4b48845c39c02daf4bc4240508afd66168e57eb795c`

Hash-verified prior declaration review:

- Reuse SHA-256: `f43749aa29c16aa5a98bbab1a45fed24cbf4159f7fff0b9ebcc561b1bffe8605`
- Reviewed interpretation: Its body existentially chooses real eigenvalues and a basis whose vectors satisfy the corresponding right-eigenvector equations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D003: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Hash-verified prior declaration review:

- Reuse SHA-256: `6508f5f013d84fb431d4c61c73e27bc110a680fb70a0b0117f30e4f4b074a6a4`
- Reviewed interpretation: The self-algebra uses the identity ring homomorphism and scalar multiplication supplied by multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D004: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Hash-verified prior declaration review:

- Reuse SHA-256: `ee215e8f901dafdde33ccf04d2ba50c167b45df5e369a207e46d80e254763acc`
- Reviewed interpretation: Projects the scalar action from an algebra structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D005: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `cd151ba84d48d1bf994e3d14e70d762a6eaa0c22a1915d66e16219cc3c2e9c4d`
- Reviewed interpretation: Logical conjunction at the external logical frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D006: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Hash-verified prior declaration review:

- Reuse SHA-256: `7ba93acd9d8a496b0fa7cf1e00a5a5b23db00cb4728597e52e9676497600bb4d`
- Reviewed interpretation: Projects the underlying semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D007: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Hash-verified prior declaration review:

- Reuse SHA-256: `38386b941aa3987380d67df842bb5435243ccd0212c76360a89d47c35eb1b9f1`
- Reviewed interpretation: Projects the function represented by a function-like object.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `ca81fd5cc4b65a081fa80e8e42ca2862b0cd0fdce0aae15f0cfac6b05501d473`
- Reviewed interpretation: Equality between terms of the same type at the logical frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D009: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `2e3ce7a62a74da0d9d5e24d39adbb3e6d2d6d91d994a33f3ab96f63f7825181b`
- Reviewed interpretation: Existential quantification over the specified witness type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D010: `ExistsUnique`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.ExistsUnique`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fda6eb0788417df924f8d45b4a573026c8317d8b526298c0d96eddb076f5ba1a`

Type:

```lean
{α : Sort u_1} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → (p : α → Prop) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} p => Exists fun x => And (p x) (∀ (y : α), p y → Eq y x)
```

### D011: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `13b5cf7ddc806a1e6aaccb30e11dd768dfeb7f6967d4408f1b64c3b45d3ec659`
- Reviewed interpretation: The standard finite index type of natural numbers below its size parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `de4d15de39fa95744423390f86caa5eb0e87ef28eb39b4a9dfeddaed23c95d51`
- Reviewed interpretation: Enumerates Fin n through List.finRange n with completeness and no duplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D013: `Finset.sum`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `931ceac4e9efb5833f58970d10ced4621362e020ea1119492a8d379b7e692372`

Type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid M] → Finset ι → (ι → M) → M
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid.{u_3} M] → (s : Finset.{u_1} ι) → (f : ι → M) → M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [AddCommMonoid M] s f => (Multiset.map f s.val).sum
```

### D014: `Finset.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `194413a784fbc0b27d0cb6b1ab67ed060210172bf16ba24045aa439e58f9a8c7`

Type:

```lean
{α : Type u_1} → [Fintype α] → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [Fintype.{u_1} α] → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Fintype α] => inst.elems
```

### D015: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Hash-verified prior declaration review:

- Reuse SHA-256: `6617b8545463388fdaa349dff26a42cb6ed418b2384184e822d46644cae451df`
- Reviewed interpretation: Lifts a scalar action to functions through the pointwise Pi action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D016: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Hash-verified prior declaration review:

- Reuse SHA-256: `95e850b89f31a666a9f8fb9555ffb23b269ebc15d1af38a42f08d54a9a72a966`
- Reviewed interpretation: Projects the operation from a heterogeneous scalar-action structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Hash-verified prior declaration review:

- Reuse SHA-256: `d1bf4cefb756413a430ea3d67075f770c6fb45334b46dc8f93f45cdd2b6013cc`
- Reviewed interpretation: Defined as a function from row indices to column indices to entries.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D018: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Hash-verified prior declaration review:

- Reuse SHA-256: `f838256c949cad931c478d71637796a82c87f37be1079bf2b0b21657ae76551e`
- Reviewed interpretation: For each row, takes the dot product of that matrix row with the input vector.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D019: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `91ccb83aac9752d74388b4b5edfdf55080a7f53ae5fb386c8f8ffab46ed2ceab`

Hash-verified prior declaration review:

- Reuse SHA-256: `7fca40fa62ee3f85c2673ef4820d9b51e50c4d3fcebfe1351e365367345ce868`
- Reviewed interpretation: The indexed module-basis structure at the stated Mathlib frontier; its coordinate representation is used explicitly in D042.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D020: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `09f2e6b4c6d86c2bb88f692b220637928f7ce01a1c3f043a706fedea853492be`

Hash-verified prior declaration review:

- Reuse SHA-256: `97fdaae2e2cd648bc42834b8da823be3218ed3a7d568265054cd48cf98b9c9e6`
- Reviewed interpretation: Maps an index to the inverse coordinate representation of the single coordinate vector having coefficient one there.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D021: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Hash-verified prior declaration review:

- Reuse SHA-256: `56ddb77053c9eda5016aeb027fcf03e8a24a492df0112058817546eb0927e879`
- Reviewed interpretation: The standard natural-number type, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D022: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Hash-verified prior declaration review:

- Reuse SHA-256: `b2f8ac7163da06de66b2cb8adf6095520aeb929f8af61e3154939f0d9ddb9bd2`
- Reviewed interpretation: Forgets associativity requirements while retaining the existing ring operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D023: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `95591bdb6312af29fe0767885eb845c2a23cfb732873574cf298cc370a513741`
- Reviewed interpretation: Projects the underlying noncommutativity-free requirement structure without replacing operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D024: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `7d6c1e52a0f8115653973f69b0145495cd435022b88a6caed0928a946934f359`
- Reviewed interpretation: Retains the original addition and multiplication while forgetting additive inverses from the required interface.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D025: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `51f2509d1d27220a7cbf6db65e0ec403cf434f12ad7984b5745b3fcd5054995c`
- Reviewed interpretation: Projects the underlying ring operations, discarding norm requirements.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D026: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `df997af9acc60fe438ab1681d49388368582803e6bf978421d06d2a6450118c3`
- Reviewed interpretation: Projects the underlying seminormed-ring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D027: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `073b08d0a10814b6231483dfaa24c8c3b36cf07e7913e949ebdc0df7888a9f29`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric from the ring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D028: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `05e23bccb818842ebb2ce043731c312ec82a35e752a433cd8181007e750a9618`
- Reviewed interpretation: Copies the existing arithmetic and norm while forgetting the unital requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D029: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `8df57e970d6e3174946e4239bb207c4b2dcb2cda02552016f58609d565ed8287`
- Reviewed interpretation: Copies the same ring and norm into the seminormed interface.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D030: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `918ebb8bc232a6c660b7cd83bdf8074f07c2a0f71b8e39acb77d2fd88de2175a`
- Reviewed interpretation: Equips a field with its self-module from Semiring.toModule.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D031: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `954a1e0fefe63a7d3c4817564168ebd3d18b6e01ce6fa7ced96c0983e78fafe2`
- Reviewed interpretation: Projects the module component from a normed space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Hash-verified prior declaration review:

- Reuse SHA-256: `15ce53d5fc00ebfbf9aed19b176712f8434287610b00e9b173170ead9c1c6e4f`
- Reviewed interpretation: Lifts a module to a function space through Pi.module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9b57724ac626ed82a5e3b9060068391fe112af839994c2304c9990493e8e9fbc`

Hash-verified prior declaration review:

- Reuse SHA-256: `e6c4e42c08e1673a73b1dca2b96bdc717f48344b58e228a46726c96c7aeb819d`
- Reviewed interpretation: Builds the pointwise additive commutative monoid on dependent functions.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `54ca72d31b22e25e9f2dc84f772978919f0849a614d311a65cdefc937d20a628`
- Reviewed interpretation: The real-number scalar type at the stated Mathlib external frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Hash-verified prior declaration review:

- Reuse SHA-256: `96d9a78eb27a0dfcaf2b34349d95d22513bccece57812981f8587d9ff64cdfd2`
- Reviewed interpretation: The inferred additive commutative monoid on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Hash-verified prior declaration review:

- Reuse SHA-256: `968d9a795521fbf3e01fe08dd43523cbb332b0a9ea2fd3d078733d7a871ac160`
- Reviewed interpretation: The inferred commutative semiring on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `0253920970641c712f5b13ceca69f65efab6d5d1f40137f2bea68806a31ef963`
- Reviewed interpretation: Combines Real's additive normed group with its commutative-ring operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `bbead61e037ba6d607b2f9c4cd7b9f2e88a3c38161a5ad800657ffcfbdb50d53`
- Reviewed interpretation: Combines the real field with its normed additive structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D039: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Hash-verified prior declaration review:

- Reuse SHA-256: `6f0459ecf1111417e2e8e06823a5cc4d15a1ddcc82fa7fe7cf90f2be7229d9a2`
- Reviewed interpretation: The inferred semiring structure on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D040: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `ad10afb364c29a475e784dda64b4db186ba722824516e1ff3e4a75220f6503a0`
- Reviewed interpretation: Copies existing arithmetic and seminorm while forgetting the unital interface.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D041: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Hash-verified prior declaration review:

- Reuse SHA-256: `2f2a274c3dfdcbddb4e611065df86be614439e487d8db04dc70950f49efb8462`
- Reviewed interpretation: Builds heterogeneous scalar multiplication directly from the supplied SMul operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D042: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1c9ac43c2f2e02a3e345036ace32d209b04abe0516407e31bcb54ee4c7201d0d`

Hash-verified prior declaration review:

- Reuse SHA-256: `98fb6bb2ce0b8b859fb38643b4621e032c56fac312257be84ac331e0bae439b1`
- Reviewed interpretation: Copies the original ring operations while forgetting the unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Hash-verified prior declaration review:

- Reuse SHA-256: `550aa6d0da98e525952a7d30620c21870979815fd0bb86765d84b844a0da4dd5`
- Reviewed interpretation: The finite enumeration structure at the stated library frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `da00a22f1d267a99bad32236c81af717f9f20a554bd227178f282f3393d64a7e`

Hash-verified prior declaration review:

- Reuse SHA-256: `57b94de0b60f5036ce4d024e22592a243b1efd691cd192aff165cb1961ec89d2`
- Reviewed interpretation: The supplied structure uses Real's addition, multiplication, zero, one, negation, and subtraction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ff102bae4edee1f1bb819368914caf0ac2ec810b7e80210cd357fd643729a472`

Hash-verified prior declaration review:

- Reuse SHA-256: `85554d83bb48f01146d77ec3057f580307fe4b76231e75a23f41e3e1c92120fb`
- Reviewed interpretation: Makes a semiring a module over itself using its multiplicative action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
