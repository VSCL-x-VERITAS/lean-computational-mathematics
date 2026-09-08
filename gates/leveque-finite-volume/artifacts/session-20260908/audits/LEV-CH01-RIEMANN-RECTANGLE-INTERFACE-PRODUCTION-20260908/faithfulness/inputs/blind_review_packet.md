# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ {m : Nat},
  instLTNat.lt 0 m →
    ∀ {Information : Type u_1} (law : LocalDef010 (Fin m))
      (grid : LocalDef007) (initialState : Real → Fin m → Real),
      (∀ (i : Int), IntervalIntegrable initialState Real.measureSpace.volume (grid.cellLeft i) (grid.cellRight i)) →
        ∀ (method : LocalDef012 law Information),
          (∀ (i : Int),
              method.domain
                (LocalDef018 law (LocalDef019 grid initialState)
                  i)) →
            ∀ (timeStep : Real),
              Real.instLT.lt 0 timeStep →
                And (instLTNat.lt 0 m)
                  (And (Real.instLT.lt 0 timeStep)
                    (Exists fun cellAverages =>
                      And
                        (∀ (i : Int),
                          LocalDef004 initialState (grid.cellLeft i) (grid.cellRight i)
                            (cellAverages i))
                        (And (∀ (i : Int), Eq (grid.cellRight (instHSub.hSub i 1)) (grid.cellLeft i))
                          (And (∀ (i : Int), method.domain (LocalDef018 law cellAverages i))
                            (Exists fun solved =>
                              And
                                (∀ (i : Int),
                                  LocalDef006 (fun x => (solved i).solution x 0)
                                    (cellAverages (instHSub.hSub i 1)) (cellAverages i))
                                (And
                                  (∀ (i : Int),
                                    LocalDef005 (solved i).solution
                                      law.physicalFlux)
                                  (Exists fun information =>
                                    And (∀ (i : Int), Eq (information i) (method.extractInformation (solved i)))
                                      (Exists fun numericalFlux =>
                                        And
                                          (∀ (i : Int),
                                            Eq (numericalFlux i) (method.numericalFluxFromInformation (information i)))
                                          (And
                                            (∀ (state : Fin m → Real),
                                              Eq
                                                (method.numericalFluxFromInformation
                                                  (method.extractInformation
                                                    (method.solve { leftState := state, rightState := state } ⋯)))
                                                (law.physicalFlux state))
                                            (Exists fun updatedCellAverages =>
                                              ∀ (i : Int),
                                                Eq (updatedCellAverages i)
                                                  (LocalDef020 grid timeStep cellAverages
                                                    numericalFlux i)))))))))))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (hm : @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
  {Information : Type u_1} (law : @LocalDef010.{0} (Fin m) (Fin.fintype m))
  (grid : LocalDef007) (initialState : Real → Fin m → Real)
  (hintegrable :
    ∀ (i : Int),
      @IntervalIntegrable.{0} (Fin m → Real)
        (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@NormedAddGroup.toENormedAddMonoid.{0} (Fin m → Real)
          (@Pi.normedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
            @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
        initialState (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)
        (LocalDef008 grid i)
        (LocalDef009 grid i))
  (method : @LocalDef012.{0, u_1} (Fin m) (Fin.fintype m) law Information)
  (hdomain :
    ∀ (i : Int),
      @LocalDef014.{0, u_1} (Fin m) (Fin.fintype m) law Information method
        (@LocalDef018.{0} (Fin m) (Fin.fintype m) law
          (@LocalDef019.{0} (Fin m → Real)
            (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
              Real.normedAddCommGroup)
            (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
              (fun (i : Fin m) =>
                @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
              fun (i : Fin m) =>
              @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
            grid initialState)
          i))
  (timeStep : Real)
  (htimeStep :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) timeStep),
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) timeStep)
      (@Exists.{1} (Int → Fin m → Real) fun (cellAverages : Int → Fin m → Real) =>
        And
          (∀ (i : Int),
            @LocalDef004.{0} (Fin m → Real)
              (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                Real.normedAddCommGroup)
              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                (fun (i : Fin m) =>
                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                fun (i : Fin m) =>
                @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
              initialState (LocalDef008 grid i)
              (LocalDef009 grid i) (cellAverages i))
          (And
            (∀ (i : Int),
              @Eq.{1} Real
                (LocalDef009 grid
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                (LocalDef008 grid i))
            (And
              (∀ (i : Int),
                @LocalDef014.{0, u_1} (Fin m) (Fin.fintype m) law
                  Information method
                  (@LocalDef018.{0} (Fin m) (Fin.fintype m) law cellAverages i))
              (@Exists.{1}
                ((i : Int) →
                  @LocalDef001.{0} (Fin m) (Fin.fintype m) law
                    (@LocalDef018.{0} (Fin m) (Fin.fintype m) law cellAverages i))
                fun
                  (solved :
                    (i : Int) →
                      @LocalDef001.{0} (Fin m) (Fin.fintype m) law
                        (@LocalDef018.{0} (Fin m) (Fin.fintype m) law cellAverages i)) =>
                And
                  (∀ (i : Int),
                    @LocalDef006.{0} (Fin m → Real)
                      (fun (x : Real) =>
                        @LocalDef002.{0} (Fin m) (Fin.fintype m) law
                          (@LocalDef018.{0} (Fin m) (Fin.fintype m) law cellAverages i)
                          (solved i) x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
                      (cellAverages
                        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                      (cellAverages i))
                  (And
                    (∀ (i : Int),
                      @LocalDef005.{0} (Fin m → Real)
                        (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                          fun (i : Fin m) => Real.normedAddCommGroup)
                        (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real)
                          (Fin.fintype m)
                          (fun (i : Fin m) =>
                            @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          fun (i : Fin m) =>
                          @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                        (@LocalDef002.{0} (Fin m) (Fin.fintype m) law
                          (@LocalDef018.{0} (Fin m) (Fin.fintype m) law cellAverages i)
                          (solved i))
                        (@LocalDef011.{0} (Fin m) (Fin.fintype m)
                          law))
                    (@Exists.{u_1 + 1} (Int → Information) fun (information : Int → Information) =>
                      And
                        (∀ (i : Int),
                          @Eq.{u_1 + 1} Information (information i)
                            (@LocalDef015.{0, u_1} (Fin m)
                              (Fin.fintype m) law Information method
                              (@LocalDef018.{0} (Fin m) (Fin.fintype m) law cellAverages i)
                              (solved i)))
                        (@Exists.{1} (Int → Fin m → Real) fun (numericalFlux : Int → Fin m → Real) =>
                          And
                            (∀ (i : Int),
                              @Eq.{1} (Fin m → Real) (numericalFlux i)
                                (@LocalDef016.{0, u_1}
                                  (Fin m) (Fin.fintype m) law Information method (information i)))
                            (And
                              (∀ (state : Fin m → Real),
                                @Eq.{1} (Fin m → Real)
                                  (@LocalDef016.{0,
                                        u_1}
                                    (Fin m) (Fin.fintype m) law Information method
                                    (@LocalDef015.{0, u_1}
                                      (Fin m) (Fin.fintype m) law Information method
                                      (@LocalDef003.{0} (Fin m) (Fin.fintype m) law state
                                        state)
                                      (@LocalDef017.{0, u_1} (Fin m)
                                        (Fin.fintype m) law Information method
                                        (@LocalDef003.{0} (Fin m) (Fin.fintype m) law state
                                          state)
                                        (@LocalDef013.{0, u_1}
                                          (Fin m) (Fin.fintype m) law Information method state))))
                                  (@LocalDef011.{0} (Fin m)
                                    (Fin.fintype m) law state))
                              (@Exists.{1} (Int → Fin m → Real) fun (updatedCellAverages : Int → Fin m → Real) =>
                                ∀ (i : Int),
                                  @Eq.{1} (Fin m → Real) (updatedCellAverages i)
                                    (@LocalDef020.{0} (Fin m) grid timeStep cellAverages
                                      numericalFlux i)))))))))))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ad7b208324194dc2b00f33ad397b55406a1213aba11a9774c6ed4889c74ceb5d`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : LocalDef010 Component) →
      LocalDef022 law → Type u_1
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `17162b14965b9a7f324e9a71eddb865ec68adebdeb0c930140089375bac95799`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {problem : LocalDef022 law} →
        LocalDef001 law problem → Real → Real → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law problem self => self.1
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `5f2a16f85d2b80003fb80ed3245e4ce1b46cef93c017e75ebf4e2d8c42303cc8`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : LocalDef010 Component} →
      (Component → Real) → (Component → Real) → LocalDef022 _law
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ac4875f1788587b8337fca28f0d4ec0e9a076fe45ed035a31c5cd8fdac11ff`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right average =>
  And (Real.instLT.lt left right)
    (And (IntervalIntegrable field Real.measureSpace.volume left right)
      (Eq average (LocalDef027 field left right)))
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fbb14b5d2b7941d655b995775ba7559106550b42dada80ff310b1923062aded3`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → Real → E) → (E → E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] q flux =>
  And (∀ (a b t : Real), IntervalIntegrable (fun x => q x t) Real.measureSpace.volume a b)
    (And (∀ (x s t : Real), IntervalIntegrable (fun τ => flux (q x τ)) Real.measureSpace.volume s t)
      (∀ (a b s t : Real),
        Eq
          (instHSub.hSub (intervalIntegral (fun x => q x t) a b Real.measureSpace.volume)
            (intervalIntegral (fun x => q x s) a b Real.measureSpace.volume))
          (intervalIntegral (fun τ => instHSub.hSub (flux (q a τ)) (flux (q b τ))) s t Real.measureSpace.volume)))
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9986cca09fad513510d98d589879bd7b67d633458b39e176f9124be154775712`

Type:

```lean
{State : Type u_1} → (Real → State) → State → State → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} data leftState rightState =>
  And (∀ (x : Real), Real.instLT.lt x 0 → Eq (data x) leftState)
    (∀ (x : Real), Real.instLT.lt 0 x → Eq (data x) rightState)
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `f45b4f5e41b1c7954e0f18cce119693e8b371eeee4d32f4d849109d5363609ce`

Type:

```lean
Type
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b7710f4b704055e41f311498ad422f4456733c8825429083c430d39299154b76`

Type:

```lean
LocalDef007 → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D009: `LocalDef009`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e793c9aec7a283c6d560c9430d496d51051f9329f075b5c3daabfb5ebdc1e5fb`

Type:

```lean
LocalDef007 → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.2
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2d256393d65a30707d17543757fdaf16f312e530ad830b462498f9a004f47d13`

Type:

```lean
(Component : Type u_1) → [Fintype Component] → Type u_1
```

### D011: `LocalDef011`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `38e8edada8c0a662e811fec59ac2b9f5ec90a5208b05e306b00d9cadf14503fa`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    LocalDef010 Component → (Component → Real) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] self => self.1
```

### D012: `LocalDef012`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `818ac7446117674ee1119052a5ad287106f465d0a683e5e73b94d07ea90df093`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    LocalDef010 Component → Type u_2 → Type (max u_1 u_2)
```

### D013: `LocalDef013`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `35d98eaacc4a54db350b5f642457a15d41f89bfaf1eb50306f7030acab9b2d13`

Type:

```lean
∀ {Component : Type u_1} [inst : Fintype Component]
  {law : LocalDef010 Component} {Information : Type u_2}
  (self : LocalDef012 law Information) (state : Component → Real),
  self.domain { leftState := state, rightState := state }
```

### D014: `LocalDef014`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cd7cc84451905487fd98c8dc1299f3244cf4c6c50ab11b3680dda5d7fc8a8833`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {Information : Type u_2} →
        LocalDef012 law Information →
          LocalDef022 law → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.1
```

### D015: `LocalDef015`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4de896d39a34997877f4cf81b0d42024b15a51e413e53671aa18cd81b2f33f90`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {Information : Type u_2} →
        LocalDef012 law Information →
          {problem : LocalDef022 law} →
            LocalDef001 law problem → Information
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.3
```

### D016: `LocalDef016`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `01f45d21aa8bc4fd7533cc12b94eabf7cd4be50fb857ca6615d75b7cab897d73`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {Information : Type u_2} →
        LocalDef012 law Information → Information → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.4
```

### D017: `LocalDef017`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf5d2f21a9ba7596b8b7805a9959aec2a98f3df52bc5283ed1262dca5b5ec224`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {Information : Type u_2} →
        (self : LocalDef012 law Information) →
          (problem : LocalDef022 law) →
            self.domain problem → LocalDef001 law problem
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.2
```

### D018: `LocalDef018`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `56780f75b263e1f0d30a97d1fcf699bf801f6e3354096e62a8a4196cd271cd61`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : LocalDef010 Component) →
      (Int → Component → Real) → Int → LocalDef022 law
```

Definition body (one-level semantic boundary):

```lean
fun {Component} [Fintype Component] law cellAverages i =>
  { leftState := cellAverages (instHSub.hSub i 1), rightState := cellAverages i }
```

### D019: `LocalDef019`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `65e6559cfb9ca07940be04cbe50ab95271f5d1de635854144495cca35ed0c4d9`

Type:

```lean
{State : Type u_1} →
  [inst : NormedAddCommGroup State] →
    [NormedSpace Real State] → LocalDef007 → (Real → State) → Int → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} [NormedAddCommGroup State] [NormedSpace Real State] grid state i =>
  LocalDef027 state (grid.cellLeft i) (grid.cellRight i)
```

### D020: `LocalDef020`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5f0ca989def21ed8e967fb586b47106a111ff6c121a5cdc0b0e980f00a72171b`

Type:

```lean
{Component : Type u_1} →
  LocalDef007 →
    Real → (Int → Component → Real) → (Int → Component → Real) → Int → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Component} grid timeStep cellAverages edgeFlux i =>
  instHSub.hSub (cellAverages i)
    (instHSMul.hSMul (instHDiv.hDiv timeStep (grid.cellVolume i))
      (instHSub.hSub (edgeFlux (instHAdd.hAdd i 1)) (edgeFlux i)))
```

### D021: `LocalDef021`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `4b2df3624ff0c4c9bd75e9adb436566a64b46696205bfe5a53ee001412a62470`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {problem : LocalDef022 law} →
        (solution : Real → Real → Component → Real) →
          LocalDef029 law problem solution →
            LocalDef001 law problem
```

### D022: `LocalDef022`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ef94dbe7341f421784d8b34d4523d9de830fbcdb2525e47718ca5d89eeb6e2fa`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] → LocalDef010 Component → Type u_1
```

### D023: `LocalDef023`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1b11f8006577d74cfa9d8b4175b4078ee6606a698c5053cb84064b8c194a49d3`

Type:

```lean
LocalDef007 → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun grid i => instHSub.hSub (grid.cellRight i) (grid.cellLeft i)
```

### D024: `LocalDef024`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `a5756070c766460340964fdc56e62557e58afc0dc8fd8cce2029d5d3262db199`

Type:

```lean
(cellLeft cellRight : Int → Real) →
  (∀ (i : Int), Real.instLT.lt (cellLeft i) (cellRight i)) →
    (∀ (i : Int), Eq (cellRight (instHSub.hSub i 1)) (cellLeft i)) → LocalDef007
```

### D025: `LocalDef025`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5716f52b65018ff9f19eddfb7cda99a4810b6558b57e23cf0e8bda3ba9150ca4`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (physicalFlux : (Component → Real) → Component → Real) →
      (fluxDerivative :
          (Component → Real) → ContinuousLinearMap (RingHom.id Real) (Component → Real) (Component → Real)) →
        (fluxJacobian : (Component → Real) → Matrix Component Component Real) →
          (∀ (state : Component → Real), HasFDerivAt physicalFlux (fluxDerivative state) state) →
            (∀ (state direction : Component → Real),
                Eq (ContinuousLinearMap.funLike.coe (fluxDerivative state) direction)
                  ((fluxJacobian state).mulVec direction)) →
              (∀ (state : Component → Real), LocalDef028 (fluxJacobian state)) →
                LocalDef010 Component
```

### D026: `LocalDef026`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `2c7f1aade6b5df7a68472f88c59b77adf311acc3d3c673fa4848913812018313`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : LocalDef010 Component} →
      {Information : Type u_2} →
        (domain : LocalDef022 law → Prop) →
          (solve :
              (problem : LocalDef022 law) →
                domain problem → LocalDef001 law problem) →
            (extractInformation :
                {problem : LocalDef022 law} →
                  LocalDef001 law problem → Information) →
              (numericalFluxFromInformation : Information → Component → Real) →
                (constants_in_domain :
                    ∀ (state : Component → Real), domain { leftState := state, rightState := state }) →
                  (∀ (state : Component → Real),
                      Eq
                        (numericalFluxFromInformation
                          (extractInformation (solve { leftState := state, rightState := state } ⋯)))
                        (law.physicalFlux state)) →
                    LocalDef012 law Information
```

### D027: `LocalDef027`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `0c59840079f273e3900b018ab6f6dbe73c00e7370875b883e4413e18c63ddc92`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right =>
  instHSMul.hSMul (Real.instInv.inv (instHSub.hSub right left))
    (intervalIntegral (fun x => field x) left right Real.measureSpace.volume)
```

### D028: `LocalDef028`

- Role: `local`
- Owner module: `LocalImport006`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d47cd84c44b0c456ec06f4b48845c39c02daf4bc4240508afd66168e57eb795c`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → Matrix ι ι Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] coefficient =>
  Exists fun eigenvalues =>
    Exists fun eigenbasis =>
      ∀ (p : ι),
        Eq (coefficient.mulVec (Module.Basis.instFunLike.coe eigenbasis p))
          (instHSMul.hSMul (eigenvalues p) (Module.Basis.instFunLike.coe eigenbasis p))
```

### D029: `LocalDef029`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `469cc5321bdbb587d3252e1629d85b053c4fa0ca53e010634752bc27ba88893d`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : LocalDef010 Component) →
      LocalDef022 law → (Real → Real → Component → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Component} [Fintype Component] law problem solution =>
  And (LocalDef006 (fun x => solution x 0) problem.leftState problem.rightState)
    (LocalDef005 solution law.physicalFlux)
```

### D030: `LocalDef030`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `34f07343b7d88ae80f17bc569a25c144ea62ce8e15e46bc7a6a2bdf9556ea71a`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : LocalDef010 Component} →
      LocalDef022 _law → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] _law self => self.1
```

### D031: `LocalDef031`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5c0b21b126c5177fcabe9b75b65bddbe73bf9436d65b364982678e91820e6803`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : LocalDef010 Component} →
      LocalDef022 _law → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] _law self => self.2
```

### D032: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D033: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D034: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D035: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

### D036: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Type:

```lean
(n : Nat) → Fintype (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n => { elems := { val := Multiset.ofList (List.finRange n), nodup := ⋯ }, complete := ⋯ }
```

### D037: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98025b38d523c0eadea77ba4961a20b2a913b23c079c4bfeba24a7bfaa24a4bc`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSub α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSub α β γ] => self.1
```

### D038: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `683435a8d27d50ec1482d74d23f541d52d05ff0411c60f88d16c32132aca9f3e`

Type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : InnerProductSpace 𝕜 E] → NormedSpace 𝕜 E
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D039: `Int`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `257bf50f640447b541733c8fd9c6bcca584fc9dd85c221eb4f37888655c88e08`

Type:

```lean
Type
```

### D040: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cdec027f4b1a52ca9841248e8efbabc901ed4e9b4220aa4074044d4c9537c68c`

Type:

```lean
Sub Int
```

Definition body (one-level semantic boundary):

```lean
{ sub := Int.sub }
```

### D041: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `438d3df5ccfcf0ec98ba944c6cd9e02b599992e15f8bcb33aaf6cc91c6e2c352`

Type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace ε] → [ENormedAddMonoid ε] → (Real → ε) → MeasureTheory.Measure Real → Real → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ENormedAddMonoid ε] f μ a b =>
  And (MeasureTheory.IntegrableOn f (Set.Ioc a b) μ) (MeasureTheory.IntegrableOn f (Set.Ioc b a) μ)
```

### D042: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D043: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8aa44f6be6ed612f15d809220aa22d43c0715b7383456cd968b96336c71bcb65`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasureTheory.Measure α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.2
```

### D044: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D045: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D046: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing α] → SeminormedAddCommGroup α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NonUnitalSeminormedRing α] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D047: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cdc7999c66248f7b0f68477de30ff4d9ea7a7f0df0bc6f092bc024f699d646fe`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → NormedAddGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯ }
```

### D048: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c2e4373a88aee873807ebe0c84a9ad97e86c59f70ff5cf5af4d6497b3024e91a`

Type:

```lean
{F : Type u_7} → [inst : NormedAddGroup F] → ENormedAddMonoid F
```

Definition body (one-level semantic boundary):

```lean
fun {F} [inst : NormedAddGroup F] =>
  { toContinuousENorm := SeminormedAddGroup.toContinuousENorm, toAddMonoid := inst.toAddMonoid, enorm_zero := ⋯,
    enorm_add_le := ⋯, enorm_eq_zero := ⋯ }
```

### D049: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → SeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toRing := β.toRing, toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D050: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D051: `Pi.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6c82ababc565a0a95c28bec085e8f86c2438699bb486e0ae0b52b3836c28e80e`

Type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedAddCommGroup (G i)] → NormedAddCommGroup ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddCommGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, add_comm := ⋯,
    toPseudoMetricSpace := __src.toPseudoMetricSpace, eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D052: `Pi.normedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e1d8c48f10ab6dcecabe68ad092908fcd0f83c41f7ec434a1553f79491f53fdb`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedAddGroup (G i)] → NormedAddGroup ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D053: `Pi.normedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d355935213de78232f83237164c0ae5a33cf298df9f793729cab1e7594836114`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField 𝕜] →
    {ι : Type u_6} →
      {E : ι → Type u_7} →
        [inst_1 : Fintype ι] →
          [inst_2 : (i : ι) → SeminormedAddCommGroup (E i)] →
            [(i : ι) → NormedSpace 𝕜 (E i)] → NormedSpace 𝕜 ((i : ι) → E i)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] {ι} {E} [Fintype ι] [(i : ι) → SeminormedAddCommGroup (E i)] [(i : ι) → NormedSpace 𝕜 (E i)] =>
  { toModule := Pi.module ι E 𝕜, norm_smul_le := ⋯ }
```

### D054: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Type:

```lean
{ι : Type u_5} → {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace (Y i)] → TopologicalSpace ((i : ι) → Y i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {Y} [t₂ : (i : ι) → TopologicalSpace (Y i)] => iInf fun i => TopologicalSpace.induced (fun f => f i) (t₂ i)
```

### D055: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D056: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D057: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D058: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D059: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
```

Definition body (one-level semantic boundary):

```lean
{ toDenselyNormedField := Real.denselyNormedField, toStarRing := instStarRingReal,
  toNormedAlgebra := NormedAlgebra.id Real, toCompleteSpace := Real.instCompleteSpace, re := AddMonoidHom.id Real,
  im := 0, I := 0, I_re_ax := Real.instRCLike._proof_1, I_mul_I_ax := Real.instRCLike._proof_8, re_add_im_ax := ⋯,
  ofReal_re_ax := Real.instRCLike._proof_11, ofReal_im_ax := Real.instRCLike._proof_12, mul_re_ax := ⋯, mul_im_ax := ⋯,
  conj_re_ax := ⋯, conj_im_ax := ⋯, conj_I_ax := Real.instRCLike._proof_7, norm_sq_eq_def_ax := ⋯, mul_im_I_ax := ⋯,
  toPartialOrder := Real.partialOrder, le_iff_re_im := @Real.instRCLike._proof_13, toDecidableEq := Real.decidableEq }
```

### D060: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D061: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d9de6598dfa4dc9b2cc1dfbccf206b37d159db61f4b35cc745a68902fbc74b22`

Type:

```lean
MeasureTheory.MeasureSpace Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D062: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D063: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Type:

```lean
NormedCommRing Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.commRing;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedCommRing._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedCommRing._proof_2, right_distrib := Real.normedCommRing._proof_3,
  zero_mul := Real.normedCommRing._proof_4, mul_zero := Real.normedCommRing._proof_5,
  mul_assoc := Real.normedCommRing._proof_6, toOne := __src_1.toOne, one_mul := Real.normedCommRing._proof_7,
  mul_one := Real.normedCommRing._proof_8, toNatCast := __src_1.toNatCast, natCast_zero := Real.normedCommRing._proof_9,
  natCast_succ := Real.normedCommRing._proof_10, npow := __src_1.npow, npow_zero := Real.normedCommRing._proof_11,
  npow_succ := Real.normedCommRing._proof_12, toNeg := __src.toNeg, toSub := __src.toSub,
  sub_eq_add_neg := Real.normedCommRing._proof_13, zsmul := __src.zsmul, zsmul_zero' := Real.normedCommRing._proof_14,
  zsmul_succ' := Real.normedCommRing._proof_15, zsmul_neg' := Real.normedCommRing._proof_16,
  neg_add_cancel := Real.normedCommRing._proof_17, toIntCast := __src_1.toIntCast,
  intCast_ofNat := Real.normedCommRing._proof_18, intCast_negSucc := Real.normedCommRing._proof_19,
  toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul_le := Real.normedCommRing._proof_20, mul_comm := ⋯ }
```

### D064: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Type:

```lean
NormedField Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.instField;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedField._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedField._proof_2, right_distrib := Real.normedField._proof_3,
  zero_mul := Real.normedField._proof_4, mul_zero := Real.normedField._proof_5, mul_assoc := Real.normedField._proof_6,
  toOne := __src_1.toOne, one_mul := Real.normedField._proof_7, mul_one := Real.normedField._proof_8,
  toNatCast := __src_1.toNatCast, natCast_zero := Real.normedField._proof_9, natCast_succ := Real.normedField._proof_10,
  npow := __src_1.npow, npow_zero := Real.normedField._proof_11, npow_succ := Real.normedField._proof_12,
  toNeg := __src.toNeg, toSub := __src.toSub, sub_eq_add_neg := Real.normedField._proof_13, zsmul := __src.zsmul,
  zsmul_zero' := Real.normedField._proof_14, zsmul_succ' := Real.normedField._proof_15,
  zsmul_neg' := Real.normedField._proof_16, neg_add_cancel := Real.normedField._proof_17,
  toIntCast := __src_1.toIntCast, intCast_ofNat := Real.normedField._proof_18,
  intCast_negSucc := Real.normedField._proof_19, mul_comm := Real.normedField._proof_20, toInv := __src_1.toInv,
  toDiv := __src_1.toDiv, div_eq_mul_inv := ⋯, zpow := __src_1.zpow, zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯,
  toNontrivial := ⋯, toNNRatCast := __src_1.toNNRatCast, toRatCast := __src_1.toRatCast, mul_inv_cancel := ⋯,
  inv_zero := ⋯, nnratCast_def := ⋯, nnqsmul := __src_1.nnqsmul, nnqsmul_def := ⋯, ratCast_def := ⋯,
  qsmul := __src_1.qsmul, qsmul_def := ⋯, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul := ⋯ }
```

### D065: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D066: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Type:

```lean
{α : Type u_2} → [β : SeminormedCommRing α] → NonUnitalSeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : SeminormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D067: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D068: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D069: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `aa782f2b5af3d068f4c5340de4b32b193fece2c659a45582cc3024a19b550c87`

Type:

```lean
{α : Type u_1} → [Sub α] → HSub α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Sub α] => { hSub := fun a b => inst.sub a b }
```

### D070: `instLTNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4054f2341fdda887b2040c624c0867866ab56eabf3441d6ffc9451c94ae1663c`

Type:

```lean
LT Nat
```

Definition body (one-level semantic boundary):

```lean
{ lt := Nat.lt }
```

### D071: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d01cf83431e28a96433c57a624e20a771e5e0ddc02355969c5044adf1ba168a5`

Type:

```lean
{n : Nat} → OfNat Int n
```

Definition body (one-level semantic boundary):

```lean
fun {n} => { ofNat := Int.ofNat n }
```

### D072: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```

### D073: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D074: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Type:

```lean
(R : Type u) → [inst : CommSemiring R] → Algebra R R
```

Definition body (one-level semantic boundary):

```lean
fun R [CommSemiring R] =>
  let __spread.0 :=
    (have __src := RingHom.id R;
      { toFun := fun x => x, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }).toAlgebra;
  let __SMul := instSMulOfMul;
  { toSMul := __SMul, algebraMap := __spread.0.algebraMap, commutes' := ⋯, smul_def' := ⋯ }
```

### D075: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D076: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
```

### D077: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D078: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

### D079: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul M α] → SMul M (ι → α)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} {α} [SMul M α] => Pi.instSMul
```

### D080: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D081: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D082: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D083: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f3fe827ffb6fc81658773a6ada6451aeb9c1a54d32b216d8dede8eae9142825b`

Type:

```lean
Add Int
```

Definition body (one-level semantic boundary):

```lean
{ add := Int.add }
```

### D084: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

### D085: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D086: `NormedAddGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `06ba17aab699c28aaa8877d0b107536ebd2aefd8bf59143b2357c84bb820d89e`

Type:

```lean
{E : Type u_8} → [self : NormedAddGroup E] → AddGroup E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddGroup E] => self.2
```

### D087: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

### D088: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5deaec32b4deac749a5db5453affea1938386e569380df7daeec26aee3cfd7c2`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub (G i)] → Sub ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [(i : ι) → Sub (G i)] => { sub := fun f g i => instHSub.hSub (f i) (g i) }
```

### D089: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D090: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Type:

```lean
DivInvMonoid Real
```

Definition body (one-level semantic boundary):

```lean
{ toMonoid := Real.instMonoid, toInv := Real.instInv, div := DivInvMonoid.div',
  div_eq_mul_inv := Real.instDivInvMonoid._proof_1, zpow := zpowRec, zpow_zero' := Real.instDivInvMonoid._proof_2,
  zpow_succ' := Real.instDivInvMonoid._proof_3, zpow_neg' := Real.instDivInvMonoid._proof_4 }
```

### D091: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D092: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `3f8499f7dfc2e8115a48b4ac0bec5328dd7223a18dd71fc0061e711fbd543126`

Type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup E] → PseudoMetricSpace E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : SeminormedAddCommGroup E] => self.3
```

### D093: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D094: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D095: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D096: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D097: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e2e08df1f4ea189c5c8b18b5894e96ab72c9a6e408e68c9dbbb6462e003414b2`

Type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → MeasureTheory.Measure Real → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] f a b μ =>
  instHSub.hSub (MeasureTheory.integral (μ.restrict (Set.Ioc a b)) fun x => f x)
    (MeasureTheory.integral (μ.restrict (Set.Ioc b a)) fun x => f x)
```

### D098: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D099: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D100: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D101: `ContinuousLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `0755150640fdc13f3d12ef9d25818b269a296f4838674f17959fc49dd8cab962`

Type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        RingHom R S →
          (M : Type u_3) →
            [TopologicalSpace M] →
              [inst_3 : AddCommMonoid M] →
                (M₂ : Type u_4) →
                  [TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_3 u_4)
```

### D102: `ContinuousLinearMap.funLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `323d1f39018754b45ba5ba40d3379411a46e1a73045c0b02095e694919f7e9a7`

Type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring R₁] →
      [inst_1 : Semiring R₂] →
        {σ₁₂ : RingHom R₁ R₂} →
          {M₁ : Type u_4} →
            [inst_2 : TopologicalSpace M₁] →
              [inst_3 : AddCommMonoid M₁] →
                {M₂ : Type u_6} →
                  [inst_4 : TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] →
                      [inst_6 : Module R₁ M₁] → [inst_7 : Module R₂ M₂] → FunLike (ContinuousLinearMap σ₁₂ M₁ M₂) M₁ M₂
```

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} [Semiring R₁] [Semiring R₂] {σ₁₂} {M₁} [TopologicalSpace M₁] [AddCommMonoid M₁] {M₂} [TopologicalSpace M₂]
    [AddCommMonoid M₂] [Module R₁ M₁] [Module R₂ M₂] =>
  { coe := fun f => LinearMap.instFunLike.coe f.toLinearMap, coe_injective' := ⋯ }
```

### D103: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Type:

```lean
{F : Sort u_1} → {α : outParam (Sort u_2)} → {β : outParam (α → Sort u_3)} → [self : DFunLike F α β] → F → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun F {α} {β} [self : DFunLike F α β] => self.1
```

### D104: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Type:

```lean
{α : Type u_2} → [DenselyNormedField α] → NontriviallyNormedField α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : DenselyNormedField α] => { toNormedField := inst.toNormedField, non_trivial := ⋯ }
```

### D105: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Type:

```lean
{M : Type u_1} → {A : Type u_7} → [inst : Monoid M] → [inst_1 : AddMonoid A] → [DistribMulAction M A] → DistribSMul M A
```

Definition body (one-level semantic boundary):

```lean
fun {M} {A} [Monoid M] [AddMonoid A] [inst_2 : DistribMulAction M A] =>
  let __src := inst_2;
  { toSMul := __src.toSMul, smul_zero := ⋯, smul_add := ⋯ }
```

### D106: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D107: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `7d58c19063063d627291b91068fa4bf2bf5ff88679897376ac465b9f52e93642`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ENormedAddCommMonoid E] → ESeminormedAddCommMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ENormedAddCommMonoid E] => self.1
```

### D108: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `38db724db757c42f8e8affdaa0b60310db98b78e8ba320c452775788f7191220`

Type:

```lean
{E : Type u_8} → [inst : TopologicalSpace E] → [self : ESeminormedAddCommMonoid E] → AddCommMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E [TopologicalSpace E] self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D109: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ad2e3c6c509dab0e1668564037784368e6c01e3dc381545577f451993c8283a4`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddCommMonoid E] → ESeminormedAddMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddCommMonoid E] => self.1
```

### D110: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `bf6ea4b699c55bfcdc7d32c89ca4d866413afa4dc5af86c3f4ff641d96cab901`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddMonoid E] → AddMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddMonoid E] => self.2
```

### D111: `HasFDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `c88b26f5f3fc2e71d02af18ecf4a0d54c0195c980c065fee932526f3a7dc8335`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup E] →
        [inst_2 : Module 𝕜 E] →
          [inst_3 : TopologicalSpace E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup F] →
                [inst_5 : Module 𝕜 F] →
                  [inst_6 : TopologicalSpace F] → (E → F) → ContinuousLinearMap (RingHom.id 𝕜) E F → E → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {E} [AddCommGroup E] [Module 𝕜 E] [TopologicalSpace E] {F} [AddCommGroup F]
    [Module 𝕜 F] [TopologicalSpace F] f f' x =>
  HasFDerivAtFilter f f' (Filter.instSProd.sprod (nhds x) (Filter.instPure.pure x))
```

### D112: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D113: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Type:

```lean
Type u → Type u' → Type v → Type (max u u' v)
```

Definition body (one-level semantic boundary):

```lean
fun m n α => m → n → α
```

### D114: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} → {α : Type v} → [NonUnitalNonAssocSemiring α] → [Fintype n] → Matrix m n α → (n → α) → m → α
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [NonUnitalNonAssocSemiring α] [Fintype n] M v x =>
  have i := x;
  dotProduct (fun j => M i j) v
```

### D115: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Type:

```lean
{R : Type u} →
  {M : Type v} → {inst : Semiring R} → {inst_1 : AddCommMonoid M} → [self : Module R M] → DistribMulAction R M
```

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D116: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D117: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D118: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toAddMonoid := self.toAddMonoid, add_comm := ⋯, toMul := self.toMul, left_distrib := ⋯, right_distrib := ⋯,
    zero_mul := ⋯, mul_zero := ⋯ }
```

### D119: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing α] → NonUnitalCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalRing := self.toNonUnitalRing, mul_comm := ⋯ }
```

### D120: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `eac639a9ae15f19554f668c9811538a135f4f05df04330bd8145b300efe57cfb`

Type:

```lean
{E : Type u_4} → [inst : NormedAddCommGroup E] → ENormedAddCommMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  let __spread.0 := NormedAddGroup.toENormedAddMonoid;
  have __spread.1 := inst;
  { toESeminormedAddMonoid := __spread.0.toESeminormedAddMonoid, add_comm := ⋯, enorm_eq_zero := ⋯ }
```

### D121: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → NonUnitalNormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toMetricSpace := β.toMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D122: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} → {inst : NormedField 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : NormedSpace 𝕜 E] → Module 𝕜 E
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : NormedSpace 𝕜 E] => self.1
```

### D123: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Type:

```lean
(I : Type u) →
  (α : Type u_1) → (β : Type u_2) → [inst : Semiring α] → [inst_1 : AddCommMonoid β] → [Module α β] → Module α (I → β)
```

Definition body (one-level semantic boundary):

```lean
fun I α β [Semiring α] [AddCommMonoid β] [Module α β] => Pi.module I (fun a => β) α
```

### D124: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup (f i)] → AddCommGroup ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommGroup (f i)] =>
  let __src := Pi.addGroup;
  have __src_1 := Pi.addCommMonoid;
  { toAddGroup := __src, add_comm := ⋯ }
```

### D125: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9b57724ac626ed82a5e3b9060068391fe112af839994c2304c9990493e8e9fbc`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid (f i)] → AddCommMonoid ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommMonoid (f i)] =>
  let __src := Pi.addMonoid;
  have __src_1 := Pi.addCommSemigroup;
  { toAddMonoid := __src, add_comm := ⋯ }
```

### D126: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Type:

```lean
DenselyNormedField Real
```

Definition body (one-level semantic boundary):

```lean
{ toNormedField := Real.normedField, lt_norm_lt := Real.denselyNormedField._proof_1 }
```

### D127: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D128: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D129: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D130: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Type:

```lean
Monoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D131: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D132: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a6f90353b229eb95293a3c089ae20ade7711021afe852d8f78a4f79577dab479`

Type:

```lean
(α : Type u_5) → [inst : NonAssocSemiring α] → RingHom α α
```

Definition body (one-level semantic boundary):

```lean
fun α [NonAssocSemiring α] => { toFun := id, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }
```

### D133: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D134: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `33076e5ce1b65d0dacdacdea942f424abbe54f3ff639c158f37c0f533984f227`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNonUnitalNonAssocSemiring := self.toNonUnitalNonAssocSemiring, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯,
    toNatCast := self.toNatCast, natCast_zero := ⋯, natCast_succ := ⋯ }
```

### D135: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1c9ac43c2f2e02a3e345036ace32d209b04abe0516407e31bcb54ee4c7201d0d`

Type:

```lean
{α : Type u} → [s : CommRing α] → NonUnitalCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [s : CommRing α] =>
  { toAddMonoid := s.toAddMonoid, toNeg := s.toNeg, toSub := s.toSub, sub_eq_add_neg := ⋯, zsmul := s.zsmul,
    zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯, toMul := s.toMul,
    left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯, mul_comm := ⋯ }
```

### D136: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `91ccb83aac9752d74388b4b5edfdf55080a7f53ae5fb386c8f8ffab46ed2ceab`

Type:

```lean
Type u_1 →
  (R : Type u_3) →
    (M : Type u_6) → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [Module R M] → Type (max (max u_1 u_3) u_6)
```

### D137: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `09f2e6b4c6d86c2bb88f692b220637928f7ce01a1c3f043a706fedea853492be`

Type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [inst_2 : Module R M] → FunLike (Module.Basis ι R M) ι M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} {M} [Semiring R] [AddCommMonoid M] [Module R M] =>
  { coe := fun b i => EquivLike.toFunLike.coe b.repr.symm (Finsupp.single i 1), coe_injective' := ⋯ }
```

### D138: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `da00a22f1d267a99bad32236c81af717f9f20a554bd227178f282f3393d64a7e`

Type:

```lean
CommRing Real
```

Definition body (one-level semantic boundary):

```lean
{ toAdd := Real.instAdd, add_assoc := ⋯, toZero := Real.instZero, zero_add := ⋯, add_zero := ⋯, nsmul := nsmulRec,
  nsmul_zero := Real.commRing._proof_4, nsmul_succ := Real.commRing._proof_5, add_comm := ⋯, toMul := Real.instMul,
  left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯, toOne := Real.instOne,
  one_mul := ⋯, mul_one := ⋯, natCast := fun n => { cauchy := n.cast }, natCast_zero := Real.commRing._proof_14,
  natCast_succ := ⋯, npow := npowRec, npow_zero := Real.commRing._proof_16, npow_succ := Real.commRing._proof_17,
  toNeg := Real.instNeg, toSub := Real.instSub, sub_eq_add_neg := Real.commRing._proof_18, zsmul := zsmulRec,
  zsmul_zero' := Real.commRing._proof_19, zsmul_succ' := Real.commRing._proof_20, zsmul_neg' := Real.commRing._proof_21,
  neg_add_cancel := ⋯, intCast := fun z => { cauchy := z.cast }, intCast_ofNat := Real.commRing._proof_23,
  intCast_negSucc := ⋯, mul_comm := ⋯ }
```

### D139: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `ff102bae4edee1f1bb819368914caf0ac2ec810b7e80210cd357fd643729a472`

Type:

```lean
{R : Type u_1} → [inst : Semiring R] → Module R R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [Semiring R] =>
  { toMulAction := (MonoidWithZero.toMulActionWithZero R).toMulAction, smul_zero := ⋯, smul_add := ⋯, add_smul := ⋯,
    zero_smul := ⋯ }
```
