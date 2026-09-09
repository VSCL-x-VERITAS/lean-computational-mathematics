# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ {m : Nat} (law : LocalDef004 m)
  {Result : LocalDef007 law → Type u_1} {Information : Type u_2}
  (routine : LocalDef015 law Result Information)
  (errorBound : LocalDef007 law → Real),
  routine.HasRiemannAccuracy errorBound →
    ∀ (left center right : Fin m → Real) (hleftState : Set.instMembership.mem law.states left)
      (hcenterState : Set.instMembership.mem law.states center) (hrightState : Set.instMembership.mem law.states right)
      {a b s t : Real},
      Real.instLT.lt a b →
        ∀ (hst : Real.instLT.lt s t)
          (hleftDomain :
            routine.domain
              { left := left, right := center, left_mem := hleftState, right_mem := hcenterState,
                duration := instHSub.hSub t s, duration_pos := ⋯ })
          (hrightDomain :
            routine.domain
              { left := center, right := right, left_mem := hcenterState, right_mem := hrightState,
                duration := instHSub.hSub t s, duration_pos := ⋯ })
          (q : Real → Real → Fin m → Real),
          IntervalIntegrable (fun x => q x s) Real.measureSpace.volume a b →
            IntervalIntegrable (fun x => q x t) Real.measureSpace.volume a b →
              IntervalIntegrable (fun τ => law.flux (q a τ)) Real.measureSpace.volume s t →
                IntervalIntegrable (fun τ => law.flux (q b τ)) Real.measureSpace.volume s t →
                  Eq
                      (instHSub.hSub (intervalIntegral (fun x => (fun x => q x t) x) a b Real.measureSpace.volume)
                        (intervalIntegral (fun x => (fun x => q x s) x) a b Real.measureSpace.volume))
                      (intervalIntegral
                        (fun τ => instHSub.hSub ((fun τ => law.flux (q a τ)) τ) ((fun τ => law.flux (q b τ)) τ)) s t
                        Real.measureSpace.volume) →
                    let leftProblem :=
                      { left := left, right := center, left_mem := hleftState, right_mem := hcenterState,
                        duration := instHSub.hSub t s, duration_pos := ⋯ };
                    let rightProblem :=
                      { left := center, right := right, left_mem := hcenterState, right_mem := hrightState,
                        duration := instHSub.hSub t s, duration_pos := ⋯ };
                    have leftFlux := routine.flux leftProblem hleftDomain;
                    have rightFlux := routine.flux rightProblem hrightDomain;
                    have next :=
                      LocalDef023 (instHSub.hSub t s) (instHSub.hSub b a) center
                        (instHSub.hSub rightFlux leftFlux);
                    And (instLTNat.lt 0 m)
                      (And (LocalDef001 law.flux law.states)
                        (And (Eq leftProblem.left left)
                          (And (Eq leftProblem.right center)
                            (And (Eq rightProblem.left center)
                              (And (Eq rightProblem.right right)
                                (And (Eq leftProblem.duration (instHSub.hSub t s))
                                  (And (Eq rightProblem.duration (instHSub.hSub t s))
                                    (And
                                      (Eq leftFlux
                                        (routine.numericalFlux
                                          (routine.extract (routine.solve leftProblem hleftDomain))))
                                      (And
                                        (Eq rightFlux
                                          (routine.numericalFlux
                                            (routine.extract (routine.solve rightProblem hrightDomain))))
                                        (And
                                          (LocalDef002 (fun x => q x s) a b
                                            (LocalDef024 (fun x => q x s) a b))
                                          (And
                                            (LocalDef002 (fun x => q x t) a b
                                              (LocalDef024 (fun x => q x t) a b))
                                            (And
                                              (LocalDef002 (fun τ => law.flux (q a τ)) s t
                                                (LocalDef024 (fun τ => law.flux (q a τ)) s
                                                  t))
                                              (And
                                                (LocalDef002 (fun τ => law.flux (q b τ)) s
                                                  t
                                                  (LocalDef024 (fun τ => law.flux (q b τ)) s
                                                    t))
                                                (And
                                                  (Eq (LocalDef024 (fun x => q x s) a b)
                                                    (LocalDef022 Real.measureSpace.volume
                                                      (Set.Ioc a b) fun x => q x s))
                                                  (And
                                                    (Eq next
                                                      (instHSub.hSub center
                                                        (instHSMul.hSMul
                                                          (instHDiv.hDiv (instHSub.hSub t s) (instHSub.hSub b a))
                                                          (instHSub.hSub rightFlux leftFlux))))
                                                    (And
                                                      (Eq
                                                        (instHSMul.hSMul (instHSub.hSub b a)
                                                          (instHSub.hSub next
                                                            (LocalDef024 (fun x => q x t) a
                                                              b)))
                                                        (instHAdd.hAdd
                                                          (instHSMul.hSMul (instHSub.hSub b a)
                                                            (instHSub.hSub center
                                                              (LocalDef024 (fun x => q x s) a
                                                                b)))
                                                          (instHSMul.hSMul (instHSub.hSub t s)
                                                            (instHSub.hSub
                                                              (instHSub.hSub leftFlux
                                                                (LocalDef024
                                                                  (fun τ => law.flux (q a τ)) s t))
                                                              (instHSub.hSub rightFlux
                                                                (LocalDef024
                                                                  (fun τ => law.flux (q b τ)) s t))))))
                                                      (And
                                                        (∀ (oldBound leftBound rightBound : Real),
                                                          Real.instLE.le
                                                              (Pi.normedRing.norm
                                                                (instHSub.hSub center
                                                                  (LocalDef024
                                                                    (fun x => q x s) a b)))
                                                              oldBound →
                                                            Real.instLE.le
                                                                (Pi.normedRing.norm (instHSub.hSub leftFlux ⋯))
                                                                leftBound →
                                                              Real.instLE.le (Pi.normedRing.norm ⋯) rightBound →
                                                                Real.instLE.le (Pi.normedRing.norm ⋯)
                                                                  (instHAdd.hAdd oldBound
                                                                    (instHMul.hMul
                                                                      (instHDiv.hDiv (instHSub.hSub t s)
                                                                        (instHSub.hSub b a))
                                                                      (instHAdd.hAdd leftBound rightBound))))
                                                        (Exists fun leftReference =>
                                                          Exists fun rightReference =>
                                                            And
                                                              (LocalDef003
                                                                (fun x => leftReference.field x 0) left center)
                                                              (And
                                                                (LocalDef003
                                                                  (fun x => rightReference.field x 0) center right)
                                                                ⋯)))))))))))))))))))
```

## Fully explicit elaborated target type

```lean
∀ {m : ⋯} (law : LocalDef004 m)
  {Result : @LocalDef007 m law → Type u_1} {Information : Type u_2}
  (routine : @LocalDef015.{u_1, u_2} m law Result Information)
  (errorBound : @LocalDef007 m law → Real)
  (haccuracy :
    @LocalDef016.{u_1, u_2} m law Result Information routine
      errorBound)
  (left center right : Fin m → Real)
  (hleftState :
    @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
      (@LocalDef006 m law) left)
  (hcenterState :
    @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
      (@LocalDef006 m law) center)
  (hrightState :
    @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
      (@LocalDef006 m law) right)
  {a b s t : Real} (hab : @LT.lt.{0} Real Real.instLT a b) (hst : @LT.lt.{0} Real Real.instLT s t)
  (hleftDomain :
    @LocalDef017.{u_1, u_2} m law Result Information routine
      (@LocalDef010 m law left center hleftState hcenterState
        (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
        (@Iff.mpr
          (@LT.lt.{0} Real Real.instLT
            (@OfNat.ofNat.{0} Real (nat_lit 0)
              (@Zero.toOfNat0.{0} Real
                (@NegZeroClass.toZero.{0} Real
                  (@SubNegZeroMonoid.toNegZeroClass.{0} Real
                    (@SubtractionMonoid.toSubNegZeroMonoid.{0} Real
                      (@AddGroup.toSubtractionMonoid.{0} Real Real.instAddGroup))))))
            (@HSub.hSub.{0, 0, 0} Real Real Real
              (@instHSub.{0} Real (@SubNegMonoid.toSub.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup)))
              t s))
          (@LT.lt.{0} Real Real.instLT s t)
          (@sub_pos.{0} Real Real.instAddGroup Real.instLT
            (@IsRightCancelAdd.addRightStrictMono_of_addRightMono.{0} Real
              (@AddZero.toAdd.{0} Real
                (@AddZeroClass.toAddZero.{0} Real
                  (@AddMonoid.toAddZeroClass.{0} Real
                    (@SubNegMonoid.toAddMonoid.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup)))))
              (@AddRightCancelSemigroup.toIsRightCancelAdd.{0} Real Real.instAddRightCancelSemigroup) Real.partialOrder
              (@covariant_swap_add_of_covariant_add.{0} Real
                (fun (x1 x2 : Real) =>
                  @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder)) x1 x2)
                Real.instAddCommSemigroup
                (@IsOrderedAddMonoid.toAddLeftMono.{0} Real Real.instAddCommMonoid Real.instPreorder
                  Real.instIsOrderedAddMonoid)))
            t s)
          hst)))
  (hrightDomain :
    @LocalDef017.{u_1, u_2} m law Result Information routine
      (@LocalDef010 m law center right hcenterState hrightState
        (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
        (@Iff.mpr
          (@LT.lt.{0} Real Real.instLT
            (@OfNat.ofNat.{0} Real (nat_lit 0)
              (@Zero.toOfNat0.{0} Real
                (@NegZeroClass.toZero.{0} Real
                  (@SubNegZeroMonoid.toNegZeroClass.{0} Real
                    (@SubtractionMonoid.toSubNegZeroMonoid.{0} Real
                      (@AddGroup.toSubtractionMonoid.{0} Real Real.instAddGroup))))))
            (@HSub.hSub.{0, 0, 0} Real Real Real
              (@instHSub.{0} Real (@SubNegMonoid.toSub.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup)))
              t s))
          (@LT.lt.{0} Real Real.instLT s t)
          (@sub_pos.{0} Real Real.instAddGroup Real.instLT
            (@IsRightCancelAdd.addRightStrictMono_of_addRightMono.{0} Real
              (@AddZero.toAdd.{0} Real
                (@AddZeroClass.toAddZero.{0} Real
                  (@AddMonoid.toAddZeroClass.{0} Real
                    (@SubNegMonoid.toAddMonoid.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup)))))
              (@AddRightCancelSemigroup.toIsRightCancelAdd.{0} Real Real.instAddRightCancelSemigroup) Real.partialOrder
              (@covariant_swap_add_of_covariant_add.{0} Real
                (fun (x1 x2 : Real) =>
                  @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder)) x1 x2)
                Real.instAddCommSemigroup
                (@IsOrderedAddMonoid.toAddLeftMono.{0} Real Real.instAddCommMonoid Real.instPreorder
                  Real.instIsOrderedAddMonoid)))
            t s)
          hst)))
  (q : Real → Real → Fin m → Real)
  (holdDensity :
    @IntervalIntegrable.{0} (Fin m → Real)
      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@NormedAddGroup.toENormedAddMonoid.{0} (Fin m → Real)
        (@Pi.normedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
          @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
      (fun (x : Real) => q x s) (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
  (hnewDensity :
    @IntervalIntegrable.{0} (Fin m → Real)
      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@NormedAddGroup.toENormedAddMonoid.{0} (Fin m → Real)
        (@Pi.normedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
          @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
      (fun (x : Real) => q x t) (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
  (hleftFlux :
    @IntervalIntegrable.{0} (Fin m → Real)
      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@NormedAddGroup.toENormedAddMonoid.{0} (Fin m → Real)
        (@Pi.normedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
          @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
      (fun (τ : Real) => @LocalDef005 m law (q a τ))
      (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) s t)
  (hrightFlux :
    @IntervalIntegrable.{0} (Fin m → Real)
      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@NormedAddGroup.toENormedAddMonoid.{0} (Fin m → Real)
        (@Pi.normedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
          @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
      (fun (τ : Real) => @LocalDef005 m law (q b τ))
      (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) s t)
  (hphysicalBalance :
    @Eq.{1} (Fin m → Real)
      (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
        (@instHSub.{0} (Fin m → Real)
          (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
        (@intervalIntegral.{0} (Fin m → Real)
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
          (fun (x : Real) => (fun (x : Real) => q x t) x) a b
          (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
        (@intervalIntegral.{0} (Fin m → Real)
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
          (fun (x : Real) => (fun (x : Real) => q x s) x) a b
          (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)))
      (@intervalIntegral.{0} (Fin m → Real)
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
        (fun (τ : Real) =>
          @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
            (@instHSub.{0} (Fin m → Real)
              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
            ((fun (τ : Real) => @LocalDef005 m law (q a τ)) τ)
            ((fun (τ : Real) => @LocalDef005 m law (q b τ)) τ))
        s t (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))),
  let leftProblem : @LocalDef007 m law :=
    @LocalDef010 m law left center hleftState hcenterState
      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
      (@Iff.mpr
        (@LT.lt.{0} Real Real.instLT
          (@OfNat.ofNat.{0} Real (nat_lit 0)
            (@Zero.toOfNat0.{0} Real
              (@NegZeroClass.toZero.{0} Real
                (@SubNegZeroMonoid.toNegZeroClass.{0} Real
                  (@SubtractionMonoid.toSubNegZeroMonoid.{0} Real
                    (@AddGroup.toSubtractionMonoid.{0} Real Real.instAddGroup))))))
          (@HSub.hSub.{0, 0, 0} Real Real Real
            (@instHSub.{0} Real (@SubNegMonoid.toSub.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup))) t
            s))
        (@LT.lt.{0} Real Real.instLT s t)
        (@sub_pos.{0} Real Real.instAddGroup Real.instLT
          (@IsRightCancelAdd.addRightStrictMono_of_addRightMono.{0} Real
            (@AddZero.toAdd.{0} Real
              (@AddZeroClass.toAddZero.{0} Real
                (@AddMonoid.toAddZeroClass.{0} Real
                  (@SubNegMonoid.toAddMonoid.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup)))))
            (@AddRightCancelSemigroup.toIsRightCancelAdd.{0} Real Real.instAddRightCancelSemigroup) Real.partialOrder
            (@covariant_swap_add_of_covariant_add.{0} Real
              (fun (x1 x2 : Real) =>
                @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder)) x1 x2)
              Real.instAddCommSemigroup
              (@IsOrderedAddMonoid.toAddLeftMono.{0} Real Real.instAddCommMonoid Real.instPreorder
                Real.instIsOrderedAddMonoid)))
          t s)
        hst);
  let rightProblem : @LocalDef007 m law :=
    @LocalDef010 m law center right hcenterState hrightState
      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
      (@Iff.mpr
        (@LT.lt.{0} Real Real.instLT
          (@OfNat.ofNat.{0} Real (nat_lit 0)
            (@Zero.toOfNat0.{0} Real
              (@NegZeroClass.toZero.{0} Real
                (@SubNegZeroMonoid.toNegZeroClass.{0} Real
                  (@SubtractionMonoid.toSubNegZeroMonoid.{0} Real
                    (@AddGroup.toSubtractionMonoid.{0} Real Real.instAddGroup))))))
          (@HSub.hSub.{0, 0, 0} Real Real Real
            (@instHSub.{0} Real (@SubNegMonoid.toSub.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup))) t
            s))
        (@LT.lt.{0} Real Real.instLT s t)
        (@sub_pos.{0} Real Real.instAddGroup Real.instLT
          (@IsRightCancelAdd.addRightStrictMono_of_addRightMono.{0} Real
            (@AddZero.toAdd.{0} Real
              (@AddZeroClass.toAddZero.{0} Real
                (@AddMonoid.toAddZeroClass.{0} Real
                  (@SubNegMonoid.toAddMonoid.{0} Real (@AddGroup.toSubNegMonoid.{0} Real Real.instAddGroup)))))
            (@AddRightCancelSemigroup.toIsRightCancelAdd.{0} Real Real.instAddRightCancelSemigroup) Real.partialOrder
            (@covariant_swap_add_of_covariant_add.{0} Real
              (fun (x1 x2 : Real) =>
                @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder)) x1 x2)
              Real.instAddCommSemigroup
              (@IsOrderedAddMonoid.toAddLeftMono.{0} Real Real.instAddCommMonoid Real.instPreorder
                Real.instIsOrderedAddMonoid)))
          t s)
        hst);
  have leftFlux : Fin m → Real :=
    @LocalDef019.{u_1, u_2} m law Result Information routine leftProblem
      hleftDomain;
  have rightFlux : Fin m → Real :=
    @LocalDef019.{u_1, u_2} m law Result Information routine rightProblem
      hrightDomain;
  have next : Fin m → Real :=
    @LocalDef023.{0} (Fin m → Real)
      (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
        (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
          (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
            (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
          (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) b a) center
      (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
        (@instHSub.{0} (Fin m → Real)
          (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
        rightFlux leftFlux);
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (@LocalDef001 m (@LocalDef005 m law)
        (@LocalDef006 m law))
      (And (@Eq.{1} (Fin m → Real) (@LocalDef009 m law leftProblem) left)
        (And (@Eq.{1} (Fin m → Real) (@LocalDef011 m law leftProblem) center)
          (And (@Eq.{1} (Fin m → Real) (@LocalDef009 m law rightProblem) center)
            (And (@Eq.{1} (Fin m → Real) (@LocalDef011 m law rightProblem) right)
              (And
                (@Eq.{1} Real (@LocalDef008 m law leftProblem)
                  (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s))
                (And
                  (@Eq.{1} Real (@LocalDef008 m law rightProblem)
                    (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s))
                  (And
                    (@Eq.{1} (Fin m → Real) leftFlux
                      (@LocalDef020.{u_1, u_2} m law Result Information
                        routine
                        (@LocalDef018.{u_1, u_2} m law Result Information
                          routine leftProblem
                          (@LocalDef021.{u_1, u_2} m law Result Information
                            routine leftProblem hleftDomain))))
                    (And
                      (@Eq.{1} (Fin m → Real) rightFlux
                        (@LocalDef020.{u_1, u_2} m law Result Information
                          routine
                          (@LocalDef018.{u_1, u_2} m law Result Information
                            routine rightProblem
                            (@LocalDef021.{u_1, u_2} m law Result Information
                              routine rightProblem hrightDomain))))
                      (And
                        (@LocalDef002.{0} (Fin m → Real)
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
                          (fun (x : Real) => q x s) a b
                          (@LocalDef024.{0} (Fin m → Real)
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
                            (fun (x : Real) => q x s) a b))
                        (And
                          (@LocalDef002.{0} (Fin m → Real)
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
                            (fun (x : Real) => q x t) a b
                            (@LocalDef024.{0} (Fin m → Real)
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
                              (fun (x : Real) => q x t) a b))
                          (And
                            (@LocalDef002.{0} (Fin m → Real)
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
                              (fun (τ : Real) => @LocalDef005 m law (q a τ)) s t
                              (@LocalDef024.{0} (Fin m → Real)
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
                                (fun (τ : Real) => @LocalDef005 m law (q a τ)) s t))
                            (And
                              (@LocalDef002.{0} (Fin m → Real)
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
                                (fun (τ : Real) => @LocalDef005 m law (q b τ)) s t
                                (@LocalDef024.{0} (Fin m → Real)
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
                                  (fun (τ : Real) => @LocalDef005 m law (q b τ)) s t))
                              (And
                                (@Eq.{1} (Fin m → Real)
                                  (@LocalDef024.{0} (Fin m → Real)
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
                                    (fun (x : Real) => q x s) a b)
                                  (@LocalDef022.{0, 0} Real (Fin m → Real)
                                    (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace)
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
                                    (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)
                                    (@Set.Ioc.{0} Real Real.instPreorder a b) fun (x : Real) => q x s))
                                (And
                                  (@Eq.{1} (Fin m → Real) next
                                    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                      (@instHSub.{0} (Fin m → Real)
                                        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instSub))
                                      center
                                      (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                        (@instHSMul.{0, 0} Real (Fin m → Real)
                                          (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                              (@Algebra.id.{0} Real Real.instCommSemiring))))
                                        (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                          (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                                          (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
                                          (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) b a))
                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                          (@instHSub.{0} (Fin m → Real)
                                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                              Real.instSub))
                                          rightFlux leftFlux))))
                                  (And
                                    (@Eq.{1} (Fin m → Real)
                                      (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                        (@instHSMul.{0, 0} Real (Fin m → Real)
                                          (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                              (@Algebra.id.{0} Real Real.instCommSemiring))))
                                        (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) b a)
                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                          (@instHSub.{0} (Fin m → Real)
                                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                              Real.instSub))
                                          next
                                          (@LocalDef024.{0} (Fin m → Real)
                                            (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                              (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                            (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                              (fun (i : Fin m) =>
                                                @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                        Real.normedCommRing))))
                                              fun (i : Fin m) =>
                                              @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                        Real.normedCommRing))))
                                                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                            (fun (x : Real) => q x t) a b)))
                                      (@HAdd.hAdd.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                        (@instHAdd.{0} (Fin m → Real)
                                          (@Pi.instAdd.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                            Real.instAdd))
                                        (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                          (@instHSMul.{0, 0} Real (Fin m → Real)
                                            (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                (@Algebra.id.{0} Real Real.instCommSemiring))))
                                          (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) b a)
                                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                            (@instHSub.{0} (Fin m → Real)
                                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                Real.instSub))
                                            center
                                            (@LocalDef024.{0} (Fin m → Real)
                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                (fun (i : Fin m) =>
                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                fun (i : Fin m) =>
                                                @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                              (fun (x : Real) => q x s) a b)))
                                        (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                          (@instHSMul.{0, 0} Real (Fin m → Real)
                                            (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                (@Algebra.id.{0} Real Real.instCommSemiring))))
                                          (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
                                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                            (@instHSub.{0} (Fin m → Real)
                                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                Real.instSub))
                                            (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                              (@instHSub.{0} (Fin m → Real)
                                                (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                  Real.instSub))
                                              leftFlux
                                              (@LocalDef024.{0} (Fin m → Real)
                                                (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                  (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                  (fun (a : Fin m) => Real) (Fin.fintype m)
                                                  (fun (i : Fin m) =>
                                                    @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                            Real.normedCommRing))))
                                                  fun (i : Fin m) =>
                                                  @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                            Real.normedCommRing))))
                                                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                (fun (τ : Real) =>
                                                  @LocalDef005 m law (q a τ))
                                                s t))
                                            (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                              (@instHSub.{0} (Fin m → Real)
                                                (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                  Real.instSub))
                                              rightFlux
                                              (@LocalDef024.{0} (Fin m → Real)
                                                (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                  (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                  (fun (a : Fin m) => Real) (Fin.fintype m)
                                                  (fun (i : Fin m) =>
                                                    @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                            Real.normedCommRing))))
                                                  fun (i : Fin m) =>
                                                  @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                            Real.normedCommRing))))
                                                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                (fun (τ : Real) =>
                                                  @LocalDef005 m law (q b τ))
                                                s t))))))
                                    (And
                                      (∀ (oldBound leftBound rightBound : Real),
                                        @LE.le.{0} Real Real.instLE
                                            (@Norm.norm.{0} (Fin m → Real)
                                              (@NormedRing.toNorm.{0} (Fin m → Real)
                                                (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                                  fun (i : Fin m) =>
                                                  @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                (@instHSub.{0} (Fin m → Real)
                                                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                    fun (i : Fin m) => Real.instSub))
                                                center
                                                (@LocalDef024.{0} (Fin m → Real)
                                                  (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                    (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                  (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                    (fun (a : Fin m) => Real) (Fin.fintype m)
                                                    (fun (i : Fin m) =>
                                                      @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                            (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                              Real.normedCommRing))))
                                                    fun (i : Fin m) =>
                                                    @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                            (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                              Real.normedCommRing))))
                                                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                  (fun (x : Real) => q x s) a b)))
                                            oldBound →
                                          @LE.le.{0} Real Real.instLE
                                              (@Norm.norm.{0} (Fin m → Real)
                                                (@NormedRing.toNorm.{0} (Fin m → Real)
                                                  (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                    (Fin.fintype m) fun (i : Fin m) =>
                                                    @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                  (@instHSub.{0} (Fin m → Real)
                                                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                      fun (i : Fin m) => Real.instSub))
                                                  leftFlux
                                                  (@LocalDef024.{0} (Fin m → Real)
                                                    (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                      (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                    (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                      (fun (a : Fin m) => Real) (Fin.fintype m)
                                                      (fun (i : Fin m) =>
                                                        @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                            Real
                                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                              (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                Real.normedCommRing))))
                                                      fun (i : Fin m) =>
                                                      @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                            Real
                                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                              (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                Real.normedCommRing))))
                                                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                    (fun (τ : Real) =>
                                                      @LocalDef005 m law (q a τ))
                                                    s t)))
                                              leftBound →
                                            @LE.le.{0} Real Real.instLE
                                                (@Norm.norm.{0} (Fin m → Real)
                                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                      (Fin.fintype m) fun (i : Fin m) =>
                                                      @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                    (@instHSub.{0} (Fin m → Real)
                                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                        fun (i : Fin m) => Real.instSub))
                                                    rightFlux
                                                    (@LocalDef024.{0} (Fin m → Real)
                                                      (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                        (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                      (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                        (fun (a : Fin m) => Real) (Fin.fintype m)
                                                        (fun (i : Fin m) =>
                                                          @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                              Real
                                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                Real
                                                                (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                  Real.normedCommRing))))
                                                        fun (i : Fin m) =>
                                                        @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                          Real.instRCLike
                                                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                              Real
                                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                Real
                                                                (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                  Real.normedCommRing))))
                                                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                      (fun (τ : Real) =>
                                                        @LocalDef005 m law (q b τ))
                                                      s t)))
                                                rightBound →
                                              @LE.le.{0} Real Real.instLE
                                                (@Norm.norm.{0} (Fin m → Real)
                                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                      (Fin.fintype m) fun (i : Fin m) =>
                                                      @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                    (@instHSub.{0} (Fin m → Real)
                                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                        fun (i : Fin m) => Real.instSub))
                                                    next
                                                    (@LocalDef024.{0} (Fin m → Real)
                                                      (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                        (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                      (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                        (fun (a : Fin m) => Real) (Fin.fintype m)
                                                        (fun (i : Fin m) =>
                                                          @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                              Real
                                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                Real
                                                                (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                  Real.normedCommRing))))
                                                        fun (i : Fin m) =>
                                                        @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                          Real.instRCLike
                                                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                              Real
                                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                Real
                                                                (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                  Real.normedCommRing))))
                                                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                      (fun (x : Real) => q x t) a b)))
                                                (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                                                  oldBound
                                                  (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                                    (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                                      (@instHDiv.{0} Real
                                                        (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                                                      (@HSub.hSub.{0, 0, 0} Real Real Real
                                                        (@instHSub.{0} Real Real.instSub) t s)
                                                      (@HSub.hSub.{0, 0, 0} Real Real Real
                                                        (@instHSub.{0} Real Real.instSub) b a))
                                                    (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                      (@instHAdd.{0} Real Real.instAdd) leftBound rightBound))))
                                      (@Exists.{1} (@LocalDef012 m law leftProblem)
                                        fun
                                          (leftReference :
                                            @LocalDef012 m law leftProblem) =>
                                        @Exists.{1} (@LocalDef012 m law rightProblem)
                                          fun
                                            (rightReference :
                                              @LocalDef012 m law rightProblem) =>
                                          And
                                            (@LocalDef003.{0} (Fin m → Real)
                                              (fun (x : Real) =>
                                                @LocalDef013 m law leftProblem
                                                  leftReference x
                                                  (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                    (@Zero.toOfNat0.{0} Real Real.instZero)))
                                              left center)
                                            (And
                                              (@LocalDef003.{0} (Fin m → Real)
                                                (fun (x : Real) =>
                                                  @LocalDef013 m law
                                                    rightProblem rightReference x
                                                    (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                      (@Zero.toOfNat0.{0} Real Real.instZero)))
                                                center right)
                                              (And
                                                (∀ (x y u v : Real),
                                                  @LE.le.{0} Real Real.instLE
                                                      (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                        (@Zero.toOfNat0.{0} Real Real.instZero))
                                                      u →
                                                    @LE.le.{0} Real Real.instLE u v →
                                                      @LE.le.{0} Real Real.instLE v
                                                          (@HSub.hSub.{0, 0, 0} Real Real Real
                                                            (@instHSub.{0} Real Real.instSub) t s) →
                                                        @Eq.{1} (Fin m → Real)
                                                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                            (Fin m → Real)
                                                            (@instHSub.{0} (Fin m → Real)
                                                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                                fun (i : Fin m) => Real.instSub))
                                                            (@intervalIntegral.{0} (Fin m → Real)
                                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                fun (i : Fin m) => Real.normedAddCommGroup)
                                                              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                (fun (i : Fin m) =>
                                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                    Real
                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                      Real
                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                        Real
                                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                          Real.normedCommRing))))
                                                                fun (i : Fin m) =>
                                                                @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                  Real.instRCLike
                                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                    Real
                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                      Real
                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                        Real
                                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                          Real.normedCommRing))))
                                                                  (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                    Real.instRCLike))
                                                              (fun (z : Real) =>
                                                                @LocalDef013 m
                                                                  law leftProblem leftReference z v)
                                                              x y
                                                              (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                                Real.measureSpace))
                                                            (@intervalIntegral.{0} (Fin m → Real)
                                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                fun (i : Fin m) => Real.normedAddCommGroup)
                                                              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                (fun (i : Fin m) =>
                                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                    Real
                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                      Real
                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                        Real
                                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                          Real.normedCommRing))))
                                                                fun (i : Fin m) =>
                                                                @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                  Real.instRCLike
                                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                    Real
                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                      Real
                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                        Real
                                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                          Real.normedCommRing))))
                                                                  (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                    Real.instRCLike))
                                                              (fun (z : Real) =>
                                                                @LocalDef013 m
                                                                  law leftProblem leftReference z u)
                                                              x y
                                                              (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                                Real.measureSpace)))
                                                          (@intervalIntegral.{0} (Fin m → Real)
                                                            (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              fun (i : Fin m) => Real.normedAddCommGroup)
                                                            (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              (fun (i : Fin m) =>
                                                                @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))
                                                              fun (i : Fin m) =>
                                                              @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                Real.instRCLike
                                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))
                                                                (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                  Real.instRCLike))
                                                            (fun (τ : Real) =>
                                                              @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                                (Fin m → Real)
                                                                (@instHSub.{0} (Fin m → Real)
                                                                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                                    fun (i : Fin m) => Real.instSub))
                                                                (@LocalDef005 m law
                                                                  (@LocalDef013
                                                                    m law leftProblem leftReference x τ))
                                                                (@LocalDef005 m law
                                                                  (@LocalDef013
                                                                    m law leftProblem leftReference y τ)))
                                                            u v
                                                            (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                              Real.measureSpace)))
                                                (And
                                                  (∀ (x y u v : Real),
                                                    @LE.le.{0} Real Real.instLE
                                                        (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                          (@Zero.toOfNat0.{0} Real Real.instZero))
                                                        u →
                                                      @LE.le.{0} Real Real.instLE u v →
                                                        @LE.le.{0} Real Real.instLE v
                                                            (@HSub.hSub.{0, 0, 0} Real Real Real
                                                              (@instHSub.{0} Real Real.instSub) t s) →
                                                          @Eq.{1} (Fin m → Real)
                                                            (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                              (Fin m → Real)
                                                              (@instHSub.{0} (Fin m → Real)
                                                                (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                                  fun (i : Fin m) => Real.instSub))
                                                              (@intervalIntegral.{0} (Fin m → Real)
                                                                (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                  (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                  fun (i : Fin m) => Real.normedAddCommGroup)
                                                                (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                                  (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                  (fun (i : Fin m) =>
                                                                    @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                      Real
                                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                        Real
                                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                          Real
                                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                            Real.normedCommRing))))
                                                                  fun (i : Fin m) =>
                                                                  @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                    Real.instRCLike
                                                                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                      Real
                                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                        Real
                                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                          Real
                                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                            Real.normedCommRing))))
                                                                    (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                      Real.instRCLike))
                                                                (fun (z : Real) =>
                                                                  @LocalDef013
                                                                    m law rightProblem rightReference z v)
                                                                x y
                                                                (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                                  Real.measureSpace))
                                                              (@intervalIntegral.{0} (Fin m → Real)
                                                                (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                  (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                  fun (i : Fin m) => Real.normedAddCommGroup)
                                                                (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                                  (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                  (fun (i : Fin m) =>
                                                                    @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                      Real
                                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                        Real
                                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                          Real
                                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                            Real.normedCommRing))))
                                                                  fun (i : Fin m) =>
                                                                  @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                    Real.instRCLike
                                                                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                      Real
                                                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                        Real
                                                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                          Real
                                                                          (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                            Real.normedCommRing))))
                                                                    (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                      Real.instRCLike))
                                                                (fun (z : Real) =>
                                                                  @LocalDef013
                                                                    m law rightProblem rightReference z u)
                                                                x y
                                                                (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                                  Real.measureSpace)))
                                                            (@intervalIntegral.{0} (Fin m → Real)
                                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                fun (i : Fin m) => Real.normedAddCommGroup)
                                                              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                (fun (i : Fin m) =>
                                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                    Real
                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                      Real
                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                        Real
                                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                          Real.normedCommRing))))
                                                                fun (i : Fin m) =>
                                                                @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                  Real.instRCLike
                                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                    Real
                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                      Real
                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                        Real
                                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                          Real.normedCommRing))))
                                                                  (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                    Real.instRCLike))
                                                              (fun (τ : Real) =>
                                                                @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                                  (Fin m → Real)
                                                                  (@instHSub.{0} (Fin m → Real)
                                                                    (@Pi.instSub.{0, 0} (Fin m)
                                                                      (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                                      Real.instSub))
                                                                  (@LocalDef005 m law
                                                                    (@LocalDef013
                                                                      m law rightProblem rightReference x τ))
                                                                  (@LocalDef005 m law
                                                                    (@LocalDef013
                                                                      m law rightProblem rightReference y τ)))
                                                              u v
                                                              (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                                Real.measureSpace)))
                                                  (And
                                                    (@LocalDef002.{0} (Fin m → Real)
                                                      (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                        (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                      (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                        (fun (a : Fin m) => Real) (Fin.fintype m)
                                                        (fun (i : Fin m) =>
                                                          @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                              Real
                                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                Real
                                                                (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                  Real.normedCommRing))))
                                                        fun (i : Fin m) =>
                                                        @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                          Real.instRCLike
                                                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                              Real
                                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                Real
                                                                (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                  Real.normedCommRing))))
                                                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                      (fun (τ : Real) =>
                                                        @LocalDef005 m law
                                                          (@LocalDef013 m law
                                                            leftProblem leftReference
                                                            (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                              (@Zero.toOfNat0.{0} Real Real.instZero))
                                                            τ))
                                                      (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                        (@Zero.toOfNat0.{0} Real Real.instZero))
                                                      (@HSub.hSub.{0, 0, 0} Real Real Real
                                                        (@instHSub.{0} Real Real.instSub) t s)
                                                      (@LocalDef014 m law
                                                        leftProblem leftReference))
                                                    (And
                                                      (@LocalDef002.{0} (Fin m → Real)
                                                        (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                          (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                                        (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                          (fun (a : Fin m) => Real) (Fin.fintype m)
                                                          (fun (i : Fin m) =>
                                                            @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                Real
                                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                  Real
                                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                    Real.normedCommRing))))
                                                          fun (i : Fin m) =>
                                                          @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                            Real.instRCLike
                                                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                Real
                                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                  Real
                                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                    Real.normedCommRing))))
                                                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                                        (fun (τ : Real) =>
                                                          @LocalDef005 m law
                                                            (@LocalDef013 m law
                                                              rightProblem rightReference
                                                              (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                                (@Zero.toOfNat0.{0} Real Real.instZero))
                                                              τ))
                                                        (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                          (@Zero.toOfNat0.{0} Real Real.instZero))
                                                        (@HSub.hSub.{0, 0, 0} Real Real Real
                                                          (@instHSub.{0} Real Real.instSub) t s)
                                                        (@LocalDef014 m law
                                                          rightProblem rightReference))
                                                      (And
                                                        (@LE.le.{0} Real Real.instLE
                                                          (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                            (@Zero.toOfNat0.{0} Real Real.instZero))
                                                          (errorBound leftProblem))
                                                        (And
                                                          (@LE.le.{0} Real Real.instLE
                                                            (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                              (@Zero.toOfNat0.{0} Real Real.instZero))
                                                            (errorBound rightProblem))
                                                          (And
                                                            (@LE.le.{0} Real Real.instLE
                                                              (@Norm.norm.{0} (Fin m → Real)
                                                                (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                  (@Pi.normedRing.{0, 0} (Fin m)
                                                                    (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                    fun (i : Fin m) =>
                                                                    @NormedCommRing.toNormedRing.{0} Real
                                                                      Real.normedCommRing))
                                                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                                  (Fin m → Real)
                                                                  (@instHSub.{0} (Fin m → Real)
                                                                    (@Pi.instSub.{0, 0} (Fin m)
                                                                      (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                                      Real.instSub))
                                                                  leftFlux
                                                                  (@LocalDef014
                                                                    m law leftProblem leftReference)))
                                                              (errorBound leftProblem))
                                                            (And
                                                              (@LE.le.{0} Real Real.instLE
                                                                (@Norm.norm.{0} (Fin m → Real)
                                                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                    (@Pi.normedRing.{0, 0} (Fin m)
                                                                      (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                      fun (i : Fin m) =>
                                                                      @NormedCommRing.toNormedRing.{0} Real
                                                                        Real.normedCommRing))
                                                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                                    (Fin m → Real)
                                                                    (@instHSub.{0} (Fin m → Real)
                                                                      (@Pi.instSub.{0, 0} (Fin m)
                                                                        (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                                        Real.instSub))
                                                                    rightFlux
                                                                    (@LocalDef014
                                                                      m law rightProblem rightReference)))
                                                                (errorBound rightProblem))
                                                              (∀ (oldBound leftComparison rightComparison : Real),
                                                                @LE.le.{0} Real Real.instLE
                                                                    (@Norm.norm.{0} (Fin m → Real)
                                                                      (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                        (@Pi.normedRing.{0, 0} (Fin m)
                                                                          (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                          fun (i : Fin m) =>
                                                                          @NormedCommRing.toNormedRing.{0} Real
                                                                            Real.normedCommRing))
                                                                      (@HSub.hSub.{0, 0, 0} (Fin m → Real)
                                                                        (Fin m → Real) (Fin m → Real)
                                                                        (@instHSub.{0} (Fin m → Real)
                                                                          (@Pi.instSub.{0, 0} (Fin m)
                                                                            (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                                            Real.instSub))
                                                                        center
                                                                        (@LocalDef024.{0}
                                                                          (Fin m → Real)
                                                                          (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                            (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                            fun (i : Fin m) => Real.normedAddCommGroup)
                                                                          (@Pi.normedSpace.{0, 0, 0} Real
                                                                            Real.normedField (Fin m)
                                                                            (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                            (fun (i : Fin m) =>
                                                                              @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                Real
                                                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                  Real
                                                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                    Real
                                                                                    (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                      Real Real.normedCommRing))))
                                                                            fun (i : Fin m) =>
                                                                            @InnerProductSpace.toNormedSpace.{0, 0} Real
                                                                              Real Real.instRCLike
                                                                              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                Real
                                                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                  Real
                                                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                    Real
                                                                                    (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                      Real Real.normedCommRing))))
                                                                              (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                                Real.instRCLike))
                                                                          (fun (x : Real) => q x s) a b)))
                                                                    oldBound →
                                                                  @LE.le.{0} Real Real.instLE
                                                                      (@Norm.norm.{0} (Fin m → Real)
                                                                        (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                          (@Pi.normedRing.{0, 0} (Fin m)
                                                                            (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                            fun (i : Fin m) =>
                                                                            @NormedCommRing.toNormedRing.{0} Real
                                                                              Real.normedCommRing))
                                                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real)
                                                                          (Fin m → Real) (Fin m → Real)
                                                                          (@instHSub.{0} (Fin m → Real)
                                                                            (@Pi.instSub.{0, 0} (Fin m)
                                                                              (fun (a : Fin m) => Real)
                                                                              fun (i : Fin m) => Real.instSub))
                                                                          (@LocalDef014
                                                                            m law leftProblem leftReference)
                                                                          (@LocalDef024.{0}
                                                                            (Fin m → Real)
                                                                            (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                              fun (i : Fin m) =>
                                                                              Real.normedAddCommGroup)
                                                                            (@Pi.normedSpace.{0, 0, 0} Real
                                                                              Real.normedField (Fin m)
                                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                              (fun (i : Fin m) =>
                                                                                @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                  Real
                                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                    Real
                                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                      Real
                                                                                      (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                        Real Real.normedCommRing))))
                                                                              fun (i : Fin m) =>
                                                                              @InnerProductSpace.toNormedSpace.{0, 0}
                                                                                Real Real Real.instRCLike
                                                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                  Real
                                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                    Real
                                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                      Real
                                                                                      (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                        Real Real.normedCommRing))))
                                                                                (@RCLike.toInnerProductSpaceReal.{0}
                                                                                  Real Real.instRCLike))
                                                                            (fun (τ : Real) =>
                                                                              @LocalDef005
                                                                                m law (q a τ))
                                                                            s t)))
                                                                      leftComparison →
                                                                    @LE.le.{0} Real Real.instLE
                                                                        (@Norm.norm.{0} (Fin m → Real)
                                                                          (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                            (@Pi.normedRing.{0, 0} (Fin m)
                                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                              fun (i : Fin m) =>
                                                                              @NormedCommRing.toNormedRing.{0} Real
                                                                                Real.normedCommRing))
                                                                          (@HSub.hSub.{0, 0, 0} (Fin m → Real)
                                                                            (Fin m → Real) (Fin m → Real)
                                                                            (@instHSub.{0} (Fin m → Real)
                                                                              (@Pi.instSub.{0, 0} (Fin m)
                                                                                (fun (a : Fin m) => Real)
                                                                                fun (i : Fin m) => Real.instSub))
                                                                            (@LocalDef014
                                                                              m law rightProblem rightReference)
                                                                            (@LocalDef024.{0}
                                                                              (Fin m → Real)
                                                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                                (fun (a : Fin m) => Real)
                                                                                (Fin.fintype m) fun (i : Fin m) =>
                                                                                Real.normedAddCommGroup)
                                                                              (@Pi.normedSpace.{0, 0, 0} Real
                                                                                Real.normedField (Fin m)
                                                                                (fun (a : Fin m) => Real)
                                                                                (Fin.fintype m)
                                                                                (fun (i : Fin m) =>
                                                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                    Real
                                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                      Real
                                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                        Real
                                                                                        (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                          Real Real.normedCommRing))))
                                                                                fun (i : Fin m) =>
                                                                                @InnerProductSpace.toNormedSpace.{0, 0}
                                                                                  Real Real Real.instRCLike
                                                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                    Real
                                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                      Real
                                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                        Real
                                                                                        (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                          Real Real.normedCommRing))))
                                                                                  (@RCLike.toInnerProductSpaceReal.{0}
                                                                                    Real Real.instRCLike))
                                                                              (fun (τ : Real) =>
                                                                                @LocalDef005
                                                                                  m law (q b τ))
                                                                              s t)))
                                                                        rightComparison →
                                                                      @LE.le.{0} Real Real.instLE
                                                                        (@Norm.norm.{0} (Fin m → Real)
                                                                          (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                            (@Pi.normedRing.{0, 0} (Fin m)
                                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                              fun (i : Fin m) =>
                                                                              @NormedCommRing.toNormedRing.{0} Real
                                                                                Real.normedCommRing))
                                                                          (@HSub.hSub.{0, 0, 0} (Fin m → Real)
                                                                            (Fin m → Real) (Fin m → Real)
                                                                            (@instHSub.{0} (Fin m → Real)
                                                                              (@Pi.instSub.{0, 0} (Fin m)
                                                                                (fun (a : Fin m) => Real)
                                                                                fun (i : Fin m) => Real.instSub))
                                                                            next
                                                                            (@LocalDef024.{0}
                                                                              (Fin m → Real)
                                                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                                (fun (a : Fin m) => Real)
                                                                                (Fin.fintype m) fun (i : Fin m) =>
                                                                                Real.normedAddCommGroup)
                                                                              (@Pi.normedSpace.{0, 0, 0} Real
                                                                                Real.normedField (Fin m)
                                                                                (fun (a : Fin m) => Real)
                                                                                (Fin.fintype m)
                                                                                (fun (i : Fin m) =>
                                                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                    Real
                                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                      Real
                                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                        Real
                                                                                        (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                          Real Real.normedCommRing))))
                                                                                fun (i : Fin m) =>
                                                                                @InnerProductSpace.toNormedSpace.{0, 0}
                                                                                  Real Real Real.instRCLike
                                                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                                    Real
                                                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                                      Real
                                                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                                        Real
                                                                                        (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                          Real Real.normedCommRing))))
                                                                                  (@RCLike.toInnerProductSpaceReal.{0}
                                                                                    Real Real.instRCLike))
                                                                              (fun (x : Real) => q x t) a b)))
                                                                        (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                                          (@instHAdd.{0} Real Real.instAdd) oldBound
                                                                          (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                            (@instHMul.{0} Real Real.instMul)
                                                                            (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                                                              (@instHDiv.{0} Real
                                                                                (@DivInvMonoid.toDiv.{0} Real
                                                                                  Real.instDivInvMonoid))
                                                                              (@HSub.hSub.{0, 0, 0} Real Real Real
                                                                                (@instHSub.{0} Real Real.instSub) t s)
                                                                              (@HSub.hSub.{0, 0, 0} Real Real Real
                                                                                (@instHSub.{0} Real Real.instSub) b a))
                                                                            (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                                              (@instHAdd.{0} Real Real.instAdd)
                                                                              (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                                                (@instHAdd.{0} Real Real.instAdd)
                                                                                (errorBound leftProblem) leftComparison)
                                                                              (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                                                (@instHAdd.{0} Real Real.instAdd)
                                                                                (errorBound rightProblem)
                                                                                rightComparison))))))))))))))))))))))))))))))))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `94bad8b852444c4d21cfba9a629ee1e790e006684d925ba21373a3f9b6d00a01`

Type:

```lean
{m : Nat} → ((Fin m → Real) → Fin m → Real) → Set (Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} flux states =>
  ∀ (state : Fin m → Real), Set.instMembership.mem states state → LocalDef025 flux state
```

### D002: `LocalDef002`

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
      (Eq average (LocalDef024 field left right)))
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport007`
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

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `20cf15531cbdfb6fb595ac786fdf20381709c58bc5771154e22c3a505ef89f61`

Type:

```lean
Nat → Type
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `76fd82163eb6903313b554b6ec394857a5c9d6ea508eb167d2b99b4789b1a489`

Type:

```lean
{m : Nat} → LocalDef004 m → (Fin m → Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.3
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f1816d4683f7fa4433b3fe8224baa5402742721a6074f632508ee1bdec0b6cf5`

Type:

```lean
{m : Nat} → LocalDef004 m → Set (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.2
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `041e8b7811a8300cfa70dfc89b7b1daec2c0020f1dd7da66e9f968de85a693b2`

Type:

```lean
{m : Nat} → LocalDef004 m → Type
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `83d7e1c923fdf31c0ccc48e27d75a52c049ea3bed58d67baf660af026467b9d1`

Type:

```lean
{m : Nat} → {law : LocalDef004 m} → LocalDef007 law → Real
```

Definition body (one-level semantic boundary):

```lean
fun m law self => self.5
```

### D009: `LocalDef009`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6d615dfdfa1ee8c1bf3b353ca51fa2aa75de9e418b2542433db92b39787d8866`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} → LocalDef007 law → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m law self => self.1
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `98ade23ed6a9898ad7fbb7d2ab950bb0c2e4d700e3b363e354efab5795901651`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    (left right : Fin m → Real) →
      Set.instMembership.mem law.states left →
        Set.instMembership.mem law.states right →
          (duration : Real) → Real.instLT.lt 0 duration → LocalDef007 law
```

### D011: `LocalDef011`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cebb950622ad3f80dc754c62410ef4162cbf18e26aeea0cbd81bb695155239f5`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} → LocalDef007 law → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m law self => self.2
```

### D012: `LocalDef012`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `238d3217392f6cf3db739d7e449507dd7d8594ac7880500c8144c6888dc68cc3`

Type:

```lean
{m : Nat} → {law : LocalDef004 m} → LocalDef007 law → Type
```

### D013: `LocalDef013`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2f259156aba8646f2883391da95359f9b7a3d71dc0cf49b81d37508ddb29c804`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {problem : LocalDef007 law} →
      LocalDef012 problem → Real → Real → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m law problem self => self.1
```

### D014: `LocalDef014`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `08d1372f3875d62bcda7828f1e241423106adcc43c8d37ec11bd4cd338e6b331`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {problem : LocalDef007 law} →
      LocalDef012 problem → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} {law} {problem} reference =>
  LocalDef024 (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration
```

### D015: `LocalDef015`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `23738081b4bb766a122be48a8f778cc47ea5ca022ae6f073f10a060f594db836`

Type:

```lean
{m : Nat} →
  (law : LocalDef004 m) →
    (LocalDef007 law → Type u_1) → Type u_2 → Type (max u_1 u_2)
```

### D016: `LocalDef016`

- Role: `local`
- Owner module: `LocalImport006`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0f53ce3b39be9f83a1a06ab9b84afe3d2e39eb1bd957efe13f59209cb138ed15`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        LocalDef015 law Result Information →
          (LocalDef007 law → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} {law} {Result} {Information} routine errorBound =>
  ∀ (problem : LocalDef007 law) (admitted : routine.domain problem),
    Exists fun reference =>
      Real.instLE.le (Pi.normedRing.norm (instHSub.hSub (routine.flux problem admitted) reference.meanFlux))
        (errorBound problem)
```

### D017: `LocalDef017`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d694f8e3f550719e64c0dd4316f19c7a28fe8a7842de573d549217478abbe861`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        LocalDef015 law Result Information →
          LocalDef007 law → Prop
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.1
```

### D018: `LocalDef018`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8530d3fea27247e114e8f424c6faded7540affc777ef51cdd697f49c07a6671e`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        LocalDef015 law Result Information →
          {problem : LocalDef007 law} → Result problem → Information
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.3
```

### D019: `LocalDef019`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9959ba35e4b5857976904063b84e3f1e36b041a1ee2e51d42d25949524c54679`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        (routine : LocalDef015 law Result Information) →
          (problem : LocalDef007 law) → routine.domain problem → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} {law} {Result} {Information} routine problem admitted =>
  routine.numericalFlux (routine.extract (routine.solve problem admitted))
```

### D020: `LocalDef020`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a65149a1e38755a78038eb57442eb8b13dc0b9487c5f305eed63c64aff9dbebb`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        LocalDef015 law Result Information → Information → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.4
```

### D021: `LocalDef021`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d48023c0b6dfc973d345ffb0e7a3115c4315cdf0023fd4ac6348d480f3691f77`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        (self : LocalDef015 law Result Information) →
          (problem : LocalDef007 law) → self.domain problem → Result problem
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.2
```

### D022: `LocalDef022`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `bc8800385daf12f69f5f7359f6f4ae6dcc02bae04ea06c59c19ad641935524ed`

Type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace Point] →
      [inst_1 : NormedAddCommGroup E] → [NormedSpace Real E] → MeasureTheory.Measure Point → Set Point → (Point → E) → E
```

Definition body (one-level semantic boundary):

```lean
fun {Point} {E} [MeasurableSpace Point] [NormedAddCommGroup E] [NormedSpace Real E] μ region field =>
  instHSMul.hSMul (Real.instInv.inv (MeasureTheory.Measure.instFunLike.coe μ region).toReal)
    (MeasureTheory.integral (μ.restrict region) fun point => field point)
```

### D023: `LocalDef023`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `2c211fbf68ab80aa19f6cbb49d99879941ac27a6722aa66c55bbad97b5f33d56`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → Real → Real → E → E → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] timeStep cellVolume oldAverage netOutwardFlux =>
  instHSub.hSub oldAverage (instHSMul.hSMul (instHDiv.hDiv timeStep cellVolume) netOutwardFlux)
```

### D024: `LocalDef024`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D025: `LocalDef025`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f3c7e9b05681e761c2bdf245f341cbda0480762d7a41c10863afad36b06495ac`

Type:

```lean
{m : Nat} → ((Fin m → Real) → Fin m → Real) → (Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} flux state =>
  Exists fun derivative =>
    And (HasFDerivAt flux derivative state)
      (LocalDef031 (EquivLike.toFunLike.coe LinearMap.toMatrix' derivative.toLinearMap))
```

### D026: `LocalDef026`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `4efb5f41d079874d9b982b8055f3bda7bd58c59e5c65db20d1650988e17e09e2`

Type:

```lean
{m : Nat} →
  instLTNat.lt 0 m →
    (states : Set (Fin m → Real)) →
      (flux : (Fin m → Real) → Fin m → Real) →
        LocalDef001 flux states → LocalDef004 m
```

### D027: `LocalDef027`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `f556ff7cdad63efc72a4ba717860f0c116259674595584a0a1c2af1c90acb54c`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {problem : LocalDef007 law} →
      (field : Real → Real → Fin m → Real) →
        LocalDef003 (fun x => field x 0) problem.left problem.right →
          (∀ (x τ : Real),
              Real.instLT.lt 0 τ → Real.instLE.le τ problem.duration → Set.instMembership.mem law.states (field x τ)) →
            (∀ (a b τ : Real),
                Real.instLE.le 0 τ →
                  Real.instLE.le τ problem.duration →
                    IntervalIntegrable (fun x => field x τ) Real.measureSpace.volume a b) →
              (∀ (x s t : Real),
                  Real.instLE.le 0 s →
                    Real.instLE.le s t →
                      Real.instLE.le t problem.duration →
                        IntervalIntegrable (fun τ => law.flux (field x τ)) Real.measureSpace.volume s t) →
                (∀ (a b s t : Real),
                    Real.instLE.le 0 s →
                      Real.instLE.le s t →
                        Real.instLE.le t problem.duration →
                          Eq
                            (instHSub.hSub (intervalIntegral (fun x => field x t) a b Real.measureSpace.volume)
                              (intervalIntegral (fun x => field x s) a b Real.measureSpace.volume))
                            (intervalIntegral (fun τ => instHSub.hSub (law.flux (field a τ)) (law.flux (field b τ))) s t
                              Real.measureSpace.volume)) →
                  LocalDef012 problem
```

### D028: `LocalDef028`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `3332ff761ada1fa6b174fdb9f15a35a503d8c9126f5dac224eb2c0f862985e97`

Type:

```lean
{m : Nat} →
  {law : LocalDef004 m} →
    {Result : LocalDef007 law → Type u_1} →
      {Information : Type u_2} →
        (domain : LocalDef007 law → Prop) →
          ((problem : LocalDef007 law) → domain problem → Result problem) →
            ({problem : LocalDef007 law} → Result problem → Information) →
              (Information → Fin m → Real) → LocalDef015 law Result Information
```

### D029: `LocalDef029`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `56914ea600c008889cf7a321fb9725518cbcfbc35c6f46b7b5ae2efa1e8016a6`

Type:

```lean
RingHomInvPair (RingHom.id Real) (RingHom.id Real)
```

### D030: `LocalDef030`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `45d3d1103b49ff0e7e5c94c9e228d5836e8f391818c033dff1ce8e9b522d12e0`

Type:

```lean
∀ {m : Nat}, SMulCommClass Real Real (Fin m → Real)
```

### D031: `LocalDef031`

- Role: `local`
- Owner module: `LocalImport008`
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

### D032: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D033: `AddGroup.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `870b92498e084dc8cbc9fc0fe455012b3787dfbb63598e9f8490af543c03c56d`

Type:

```lean
{G : Type u_1} → [AddGroup G] → SubtractionMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun {G} [inst : AddGroup G] =>
  { toSubNegMonoid := inst.toSubNegMonoid, neg_neg := ⋯, neg_add_rev := ⋯, neg_eq_of_add := ⋯ }
```

### D034: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D035: `AddRightCancelSemigroup.toIsRightCancelAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `47873c349b19510930a568c715d639060c3d1b0f77cec298c30894a03bdb0e57`

Type:

```lean
∀ {G : Type u} [self : AddRightCancelSemigroup G], IsRightCancelAdd G
```

### D036: `AddZero.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `aaf8ee0ca0ca4a6b33fb0806d024e8a202ba2d3af3b4f4f8214dfc947d3bf16a`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Add M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.2
```

### D037: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D038: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D039: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D040: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D041: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
```

### D042: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D043: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D044: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D045: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

### D046: `Fin.fintype`

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

### D047: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul M α] → SMul M (ι → α)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} {α} [SMul M α] => Pi.instSMul
```

### D048: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D049: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D050: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D051: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D052: `HSub.hSub`

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

### D053: `Iff.mpr`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `abcae2cc4e99f1dc596c9080dca30ec894770912ebfc2b6ad2910b661baa68ed`

Type:

```lean
∀ {a b : Prop}, Iff a b → b → a
```

### D054: `InnerProductSpace.toNormedSpace`

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

### D055: `IntervalIntegrable`

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

### D056: `IsOrderedAddMonoid.toAddLeftMono`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Defs`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `27d84a030ca846ad17e01cc9d542c712204e56bf12ae554159659bad6da2ff81`

Type:

```lean
∀ {α : Type u_1} [inst : AddCommMonoid α] [inst_1 : Preorder α] [IsOrderedAddMonoid α], AddLeftMono α
```

### D057: `IsRightCancelAdd.addRightStrictMono_of_addRightMono`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Unbundled.Defs`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `5a510fa5f789815d035629b95969fdf7f273f54eebf8847345628baaf560e0e7`

Type:

```lean
∀ (N : Type u_2) [inst : Add N] [IsRightCancelAdd N] [inst_2 : PartialOrder N] [AddRightMono N], AddRightStrictMono N
```

### D058: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D059: `LT.lt`

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

### D060: `MeasureTheory.MeasureSpace.toMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9fcb81af41d67aceded7670716064bc53819a6094bbccd3cb85d7a18952295d3`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasurableSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.1
```

### D061: `MeasureTheory.MeasureSpace.volume`

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

### D062: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `941ea3346e809f919727c21bfcdeea342714a6b83f1cf871d648aa2cb14d6e9e`

Type:

```lean
{α : outParam (Type u)} → {γ : Type v} → [self : Membership α γ] → γ → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} γ [self : Membership α γ] => self.1
```

### D063: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D064: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `881414a459dbdc250afc9bc468e98b17f776dfd31f2aa5eb9acee71a8d1543f7`

Type:

```lean
{G : Type u_2} → [self : NegZeroClass G] → Zero G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : NegZeroClass G] => self.1
```

### D065: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → AddCommMonoid α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocSemiring α] => self.1
```

### D066: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D067: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D068: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Type:

```lean
{α : Type u} → [self : NonUnitalSemiring α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSemiring α] => self.1
```

### D069: `Norm.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `25f5aa97df9bb1faeacd7e5e6446ecbd367452a7105f098063355423713fe15a`

Type:

```lean
{E : Type u_8} → [self : Norm E] → E → Real
```

Definition body (one-level semantic boundary):

```lean
fun E [self : Norm E] => self.1
```

### D070: `NormedAddCommGroup.toNormedAddGroup`

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

### D071: `NormedAddGroup.toENormedAddMonoid`

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

### D072: `NormedCommRing.toNormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ff5852fa6ac00f6a258a1d8fe950a0ed74f219c79c926896eb081436331a480e`

Type:

```lean
{α : Type u_5} → [self : NormedCommRing α] → NormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedCommRing α] => self.1
```

### D073: `NormedCommRing.toSeminormedCommRing`

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

### D074: `NormedRing.toNorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0957abfc66401a60ac36872f31eb54890d14b0b45613e38ba8f235c467f63751`

Type:

```lean
{α : Type u_5} → [self : NormedRing α] → Norm α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedRing α] => self.1
```

### D075: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D076: `OfNat.ofNat`

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

### D077: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `079686fa1ec6d596bcdb475c56a12b7f5a0594bf346c64220c2c992e0f0aae3b`

Type:

```lean
{α : Type u_2} → [self : PartialOrder α] → Preorder α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PartialOrder α] => self.1
```

### D078: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D079: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D080: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Add (M i)] → Add ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [(i : ι) → Add (M i)] => { add := fun f g i => instHAdd.hAdd (f i) (g i) }
```

### D081: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5deaec32b4deac749a5db5453affea1938386e569380df7daeec26aee3cfd7c2`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub (G i)] → Sub ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [(i : ι) → Sub (G i)] => { sub := fun f g i => instHSub.hSub (f i) (g i) }
```

### D082: `Pi.normedAddCommGroup`

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

### D083: `Pi.normedAddGroup`

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

### D084: `Pi.normedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Lemmas`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f9dab15f307cbf227004c74c0bb06dec60fd13239b8d79b0751df5ec0ca2a0d9`

Type:

```lean
{ι : Type u_3} → {R : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedRing (R i)] → NormedRing ((i : ι) → R i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} [Fintype ι] [(i : ι) → NormedRing (R i)] =>
  let __src := Pi.seminormedRing;
  have __src_1 := Pi.normedAddCommGroup;
  { toNorm := __src.toNorm, toRing := __src.toRing, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯, norm_mul_le := ⋯ }
```

### D085: `Pi.normedSpace`

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

### D086: `Pi.topologicalSpace`

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

### D087: `Preorder.toLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a2229e231e0928e24fffee5432201e35fadad80e7f6e4738e0d251c3c01a4676`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LE α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.1
```

### D088: `PseudoMetricSpace.toUniformSpace`

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

### D089: `RCLike.toInnerProductSpaceReal`

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

### D090: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D091: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D092: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D093: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D094: `Real.instAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ee1f6e3dabe7d58e1e670ac49ad636cbe964bc19fdcfa297a61a50e7fedf7570`

Type:

```lean
AddCommSemigroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D095: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f0de8cbc2c873a19be749cd9b2d3cc9a6edb9ebc92020a1877714a50c23d9dc0`

Type:

```lean
AddGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D096: `Real.instAddRightCancelSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `2bf657feb77c4b877a2df40c45d2fe1bc1a758f2d05996f0eefeee52ba0856b0`

Type:

```lean
AddRightCancelSemigroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D097: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D098: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D099: `Real.instIsOrderedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `df4b2b849009b0e354f4a2fb93f470e05bbbf9f4ec38e1e4709e600133be9280`

Type:

```lean
IsOrderedAddMonoid Real
```

### D100: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D101: `Real.instLT`

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

### D102: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D103: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D104: `Real.instRCLike`

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

### D105: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D106: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D107: `Real.instZero`

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

### D108: `Real.measureSpace`

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

### D109: `Real.normedAddCommGroup`

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

### D110: `Real.normedCommRing`

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

### D111: `Real.normedField`

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

### D112: `Real.partialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c230e4cc01baeb2fcfa7d957f7e912e6e79376f736b5b58965ca7da585e8d66a`

Type:

```lean
PartialOrder Real
```

Definition body (one-level semantic boundary):

```lean
{ toLE := Real.instLE, toLT := Real.instLT, le_refl := ⋯, le_trans := ⋯, lt_iff_le_not_ge := ⋯, le_antisymm := ⋯ }
```

### D113: `Real.pseudoMetricSpace`

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

### D114: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D115: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Type:

```lean
{R : Type u} → [self : Ring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Ring R] => self.1
```

### D116: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D117: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonUnitalSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Semiring α] => self.1
```

### D118: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a6e551515032966c16e4f42e4548ff1854c2dce05ffe51e98b66943caecc78ec`

Type:

```lean
Type u → Type u
```

Definition body (one-level semantic boundary):

```lean
fun α => α → Prop
```

### D119: `Set.Ioc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ff05a5eaafe9ff8d3ce7c60e46836b8850e9f73e10712fccf83973114737c089`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → α → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.lt a x) (inst.le x b)
```

### D120: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5858be77d319c5a0e238602f16818ed6fb2e2b52a81ff7edb07bc219d652f201`

Type:

```lean
{α : Type u} → Membership α (Set α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := Set.Mem }
```

### D121: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → AddMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.1
```

### D122: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D123: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0ca9c4737492ec2a9a5ab16ab065d00204507f2caf80997692c360afbf962577`

Type:

```lean
{G : Type u_2} → [self : SubNegZeroMonoid G] → NegZeroClass G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toZero := self.toZero, toNeg := self.toNeg, neg_zero := ⋯ }
```

### D124: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `700a470249543a704f0b5910309b7d1f4c918e3b645f806242c291c98eff4e28`

Type:

```lean
{α : Type u_1} → [SubtractionMonoid α] → SubNegZeroMonoid α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : SubtractionMonoid α] =>
  let __src := inst.toSubNegMonoid;
  { toSubNegMonoid := __src, neg_zero := ⋯ }
```

### D125: `UniformSpace.toTopologicalSpace`

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

### D126: `Zero.toOfNat0`

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

### D127: `covariant_swap_add_of_covariant_add`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Unbundled.Defs`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `31ebefeee19bf7476979074306a9b18488a672fc657ed3273ffedcfb6b42f0c5`

Type:

```lean
∀ (N : Type u_2) (r : N → N → Prop) [inst : AddCommSemigroup N]
  [CovariantClass N N (fun x1 x2 => instHAdd.hAdd x1 x2) r],
  CovariantClass N N (Function.swap fun x1 x2 => instHAdd.hAdd x1 x2) r
```

### D128: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D129: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D130: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D131: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D132: `instHSub`

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

### D133: `instLTNat`

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

### D134: `instOfNatNat`

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

### D135: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D136: `sub_pos`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `4b5acbd66ecbf24b06fe1b009145441ddbe8a5c18f1002051ee2604836d1eba9`

Type:

```lean
∀ {α : Type u} [inst : AddGroup α] [inst_1 : LT α] [AddRightStrictMono α] {a b : α},
  Iff (inst_1.lt 0 (instHSub.hSub a b)) (inst_1.lt b a)
```

### D137: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

### D138: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddCommMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D139: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddGroup G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommGroup G] => self.1
```

### D140: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D141: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Type:

```lean
{F : Sort u_1} → {α : outParam (Sort u_2)} → {β : outParam (α → Sort u_3)} → [self : DFunLike F α β] → F → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun F {α} {β} [self : DFunLike F α β] => self.1
```

### D142: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D143: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D144: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
WithTop NNReal
```

### D145: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D146: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7d58c19063063d627291b91068fa4bf2bf5ff88679897376ac465b9f52e93642`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ENormedAddCommMonoid E] → ESeminormedAddCommMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ENormedAddCommMonoid E] => self.1
```

### D147: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `38db724db757c42f8e8affdaa0b60310db98b78e8ba320c452775788f7191220`

Type:

```lean
{E : Type u_8} → [inst : TopologicalSpace E] → [self : ESeminormedAddCommMonoid E] → AddCommMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E [TopologicalSpace E] self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D148: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `ad2e3c6c509dab0e1668564037784368e6c01e3dc381545577f451993c8283a4`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddCommMonoid E] → ESeminormedAddMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddCommMonoid E] => self.1
```

### D149: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `bf6ea4b699c55bfcdc7d32c89ca4d866413afa4dc5af86c3f4ff641d96cab901`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddMonoid E] → AddMonoid E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddMonoid E] => self.2
```

### D150: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D151: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

### D152: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D153: `MeasureTheory.Measure.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `94b2becf9230ce3d438e9b668f79f08e69dbe28c937b1aaca32d96e94b64a5b2`

Type:

```lean
{α : Type u_1} → [inst : MeasurableSpace α] → FunLike (MeasureTheory.Measure α) (Set α) ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {α} [MeasurableSpace α] =>
  { coe := fun μ => MeasureTheory.OuterMeasure.instFunLikeSetENNReal.coe μ.toOuterMeasure, coe_injective' := ⋯ }
```

### D154: `MeasureTheory.Measure.restrict`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Restrict`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `63c4446a3ae02833cbb1104dcc4f2ea534c0eae36f5642bfa8858a6593aa11e8`

Type:

```lean
{α : Type u_2} → {_m0 : MeasurableSpace α} → MeasureTheory.Measure α → Set α → MeasureTheory.Measure α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {_m0} μ s => LinearMap.instFunLike.coe (MeasureTheory.Measure.restrictₗ s) μ
```

### D155: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup G] →
      [NormedSpace Real G] → {x : MeasurableSpace α} → MeasureTheory.Measure α → (α → G) → G
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D156: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

### D157: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D158: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

### D159: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D160: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D161: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

### D162: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D163: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Type:

```lean
Monoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D164: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D165: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D166: `ContinuousLinearMap`

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

### D167: `ContinuousLinearMap.toLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9f9853b750cccc494240df6aaa291df7574b484c4ef82b93b35f4e8d951fb171`

Type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        {σ : RingHom R S} →
          {M : Type u_3} →
            [inst_2 : TopologicalSpace M] →
              [inst_3 : AddCommMonoid M] →
                {M₂ : Type u_4} →
                  [inst_4 : TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] →
                      [inst_6 : Module R M] → [inst_7 : Module S M₂] → ContinuousLinearMap σ M M₂ → LinearMap σ M M₂
```

Definition body (one-level semantic boundary):

```lean
fun R S [Semiring R] [Semiring S] σ M [TopologicalSpace M] [AddCommMonoid M] M₂ [TopologicalSpace M₂] [AddCommMonoid M₂]
    [Module R M] [Module S M₂] self =>
  self.1
```

### D168: `DFinsupp.instEquivLikeLinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.DFinsupp`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `fe0373c4e4a236db57ec78aa51496bc89dab4fb0097dc18c96c70c6df789463d`

Type:

```lean
{R : Type u_7} →
  {S : Type u_8} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        (σ : RingHom R S) →
          {σ' : RingHom S R} →
            [inst_2 : RingHomInvPair σ σ'] →
              [inst_3 : RingHomInvPair σ' σ] →
                (M : Type u_9) →
                  (M₂ : Type u_10) →
                    [inst_4 : AddCommMonoid M] →
                      [inst_5 : AddCommMonoid M₂] →
                        [inst_6 : Module R M] → [inst_7 : Module S M₂] → EquivLike (LinearEquiv σ M M₂) M M₂
```

Definition body (one-level semantic boundary):

```lean
fun {R} {S} [Semiring R] [Semiring S] σ {σ'} [RingHomInvPair σ σ'] [RingHomInvPair σ' σ] M M₂ [AddCommMonoid M]
    [AddCommMonoid M₂] [Module R M] [Module S M₂] =>
  inferInstance
```

### D169: `DenselyNormedField.toNontriviallyNormedField`

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

### D170: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `0f60978070e976ff8040a5b974a5b08a27d74758a8f4361a6276a17c12a1d96a`

Type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike E α β] → FunLike E α β
```

Definition body (one-level semantic boundary):

```lean
fun {E} {α} {β} [inst : EquivLike E α β] => { coe := inst.coe, coe_injective' := ⋯ }
```

### D171: `HasFDerivAt`

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

### D172: `LinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `6a1e194e5e1f3458fc29174b3ebc7e52b4b228d4e72f70b8b3129d5a513816a3`

Type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        (σ : RingHom R S) →
          {σ' : RingHom S R} →
            [RingHomInvPair σ σ'] →
              [RingHomInvPair σ' σ] →
                (M : Type u_16) →
                  (M₂ : Type u_17) →
                    [inst_4 : AddCommMonoid M] →
                      [inst_5 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_16 u_17)
```

### D173: `LinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `4d6a16b4507b37ff97503f46684751acdb916a859224b68a1c2a8b68af63e31c`

Type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        RingHom R S →
          (M : Type u_16) →
            (M₂ : Type u_17) →
              [inst_2 : AddCommMonoid M] →
                [inst_3 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_16 u_17)
```

### D174: `LinearMap.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ab4e5f87ffe446bf4b1a818669f80f82d003b1d88bffa60d6568767a5b492e76`

Type:

```lean
{R₁ : Type u_2} →
  {R₂ : Type u_3} →
    {M : Type u_8} →
      {M₂ : Type u_10} →
        [inst : Semiring R₁] →
          [inst_1 : Semiring R₂] →
            [inst_2 : AddCommMonoid M] →
              [inst_3 : AddCommMonoid M₂] →
                [inst_4 : Module R₁ M] →
                  [inst_5 : Module R₂ M₂] → {σ₁₂ : RingHom R₁ R₂} → AddCommMonoid (LinearMap σ₁₂ M M₂)
```

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} {M} {M₂} [Semiring R₁] [Semiring R₂] [AddCommMonoid M] [AddCommMonoid M₂] [Module R₁ M] [Module R₂ M₂]
    {σ₁₂} =>
  Function.Injective.addCommMonoid (fun f => LinearMap.instFunLike.coe f) ⋯ ⋯ ⋯ ⋯
```

### D175: `LinearMap.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `017b40e990cc84887be863ba33792de76923fe3ca657329d8c9158a2e880ffee`

Type:

```lean
{R : Type u_1} →
  {R₂ : Type u_3} →
    {S : Type u_5} →
      {M : Type u_8} →
        {M₂ : Type u_10} →
          [inst : Semiring R] →
            [inst_1 : Semiring R₂] →
              [inst_2 : AddCommMonoid M] →
                [inst_3 : AddCommMonoid M₂] →
                  [inst_4 : Module R M] →
                    [inst_5 : Module R₂ M₂] →
                      {σ₁₂ : RingHom R R₂} →
                        [inst_6 : Semiring S] →
                          [inst_7 : Module S M₂] → [SMulCommClass R₂ S M₂] → Module S (LinearMap σ₁₂ M M₂)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {R₂} {S} {M} {M₂} [Semiring R] [Semiring R₂] [AddCommMonoid M] [AddCommMonoid M₂] [Module R M] [Module R₂ M₂]
    {σ₁₂} [Semiring S] [Module S M₂] [SMulCommClass R₂ S M₂] =>
  { toDistribMulAction := LinearMap.instDistribMulAction, add_smul := ⋯, zero_smul := ⋯ }
```

### D176: `LinearMap.toMatrix'`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.ToLin`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e6a54896ef32827c20d64677b2bde29030c3fcd47def618d946669e8a97f5747`

Type:

```lean
{R : Type u_1} →
  [inst : CommSemiring R] →
    {m : Type u_4} →
      {n : Type u_5} →
        [DecidableEq n] →
          [Fintype n] → LinearEquiv (RingHom.id R) (LinearMap (RingHom.id R) (n → R) (m → R)) (Matrix m n R)
```

Definition body (one-level semantic boundary):

```lean
fun {R} [CommSemiring R] {m} {n} [DecidableEq n] [Fintype n] =>
  { toFun := fun f => EquivLike.toFunLike.coe Matrix.of fun i j => LinearMap.instFunLike.coe f (Pi.single j 1) i,
    map_add' := ⋯, map_smul' := ⋯, invFun := Matrix.mulVecLin, left_inv := ⋯, right_inv := ⋯ }
```

### D177: `Matrix`

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

### D178: `Matrix.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `6b893d81bc298230772e16cd0c8ddf7d2638ac0d6127094b06a1290d88f8c3ae`

Type:

```lean
{m : Type u_2} → {n : Type u_3} → {α : Type v} → [AddCommMonoid α] → AddCommMonoid (Matrix m n α)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [AddCommMonoid α] => Pi.addCommMonoid
```

### D179: `Matrix.module`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4fdec58292003fac825b4ffe1900f940d4ef3c8d02e84e23484d4b31f8742856`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {R : Type u_7} →
      {α : Type v} → [inst : Semiring R] → [inst_1 : AddCommMonoid α] → [Module R α] → Module R (Matrix m n α)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {R} {α} [Semiring R] [AddCommMonoid α] [Module R α] => Pi.module m (fun a => n → α) R
```

### D180: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1674e66231d0f66dfe9fae191c7ae33207a78635bcf5490a9cfbb402d16f9bc0`

Type:

```lean
{α : Type u} → [self : NonAssocSemiring α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonAssocSemiring α] => self.1
```

### D181: `Pi.addCommMonoid`

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

### D182: `Real.denselyNormedField`

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

### D183: `RingHom.id`

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

### D184: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D185: `Semiring.toNonAssocSemiring`

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

### D186: `instDecidableEqFin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `7f6d785554f797d18d5ae0b7475c25e8deca421e6ee688f036987ac99c66e1cd`

Type:

```lean
(n : Nat) → DecidableEq (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n i j =>
  instDecidableEqFin.match_1 n i j (fun x => Decidable (Eq i j)) (decEq i.val j.val) (fun h => Decidable.isTrue ⋯)
    fun h => Decidable.isFalse ⋯
```

### D187: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddMonoid M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddCommMonoid M] => self.1
```

### D188: `CommRing.toNonUnitalCommRing`

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

### D189: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Monoid M} → {inst_1 : AddMonoid A} → [self : DistribMulAction M A] → MulAction M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} {inst_1} [self : DistribMulAction M A] => self.1
```

### D190: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

### D191: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D192: `Module.Basis`

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

### D193: `Module.Basis.instFunLike`

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

### D194: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Type:

```lean
{M : Type u} → [self : Monoid M] → Semigroup M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : Monoid M] => self.1
```

### D195: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Type:

```lean
{M₀ : Type u} → [self : MonoidWithZero M₀] → Monoid M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MonoidWithZero M₀] => self.1
```

### D196: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Monoid α} → [self : MulAction α β] → SemigroupAction α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : MulAction α β] => self.1
```

### D197: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D198: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D199: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D200: `Real.commRing`

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

### D201: `RingHomInvPair`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.CompTypeclasses`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `eba5e79959e8652c489365b8e4a0a1562cfc528d141ca51502769b8b6f807ad9`

Type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} → [inst : Semiring R₁] → [inst_1 : Semiring R₂] → RingHom R₁ R₂ → outParam (RingHom R₂ R₁) → Prop
```

### D202: `SMulCommClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `25ca5b6e5618ba5262412f36bda1bf0ec64f56ca37162dc1ff3be3719f8983c5`

Type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul M α] → [SMul N α] → Prop
```

### D203: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Semigroup α} → [self : SemigroupAction α β] → SMul α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : SemigroupAction α β] => self.1
```

### D204: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Type:

```lean
{α : Type u} → [self : Semiring α] → MonoidWithZero α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toMul := self.toMul, mul_assoc := ⋯, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯, npow := self.npow,
    npow_zero := ⋯, npow_succ := ⋯, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```
