/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonEnergy

import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.Data.ZMod.Basic

/-!
# LeVeque Chapter 4: weighted diffusion energy

A finite symmetric collection of nonnegative conductances defines a
dissipative diffusion operator. This covers variable edge diffusivities
once the grid's interface weights and boundary conditions are supplied.
The Crank–Nicolson step for this operator contracts the discrete
squared-energy at every nonnegative time step.
-/

namespace NumStability

open scoped BigOperators

/-- Diffusion through finite symmetric weighted edges. -/
noncomputable def leveque04_weightedDiffusion
    {V : Type*} [Fintype V]
    (conductance : V → V → ℝ) (u : V → ℝ) (i : V) : ℝ :=
  ∑ j, conductance i j * (u j - u i)

/-- The weighted diffusion operator is linear under subtraction. -/
theorem leveque04_weightedDiffusion_sub
    {V : Type*} [Fintype V] (conductance : V → V → ℝ)
    (u v : V → ℝ) (i : V) :
    leveque04_weightedDiffusion conductance (u - v) i =
      leveque04_weightedDiffusion conductance u i -
        leveque04_weightedDiffusion conductance v i := by
  simp only [leveque04_weightedDiffusion, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j _
  simp only [Pi.sub_apply]
  ring

/-- The finite weighted diffusion operator as a real linear map. -/
noncomputable def leveque04_weightedDiffusionLinear
    {V : Type*} [Fintype V] (conductance : V → V → ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) where
  toFun u := leveque04_weightedDiffusion conductance u
  map_add' u v := by
    ext i
    simp only [leveque04_weightedDiffusion, Pi.add_apply,
      ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro j _
    ring
  map_smul' a u := by
    ext i
    simp only [leveque04_weightedDiffusion, Pi.smul_apply, smul_eq_mul,
      Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    simp only [RingHom.id_apply]
    ring

/-- Symmetric nonnegative edge conductances give a nonpositive
spatial energy pairing. -/
theorem leveque04_weightedDiffusion_dissipative
    {V : Type*} [Fintype V]
    (conductance : V → V → ℝ)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (u : V → ℝ) :
    (∑ i, leveque04_weightedDiffusion conductance u i * u i) ≤ 0 := by
  let energy := ∑ i, ∑ j, conductance i j * (u j - u i) * u i
  let edgeSquares := ∑ i, ∑ j,
    conductance i j * (u j - u i) ^ 2
  have hswap : energy =
      ∑ i, ∑ j, conductance i j * (u i - u j) * u j := by
    calc
      energy = ∑ j, ∑ i,
          conductance i j * (u j - u i) * u i := by
            dsimp [energy]
            exact Finset.sum_comm
      _ = ∑ i, ∑ j,
          conductance j i * (u i - u j) * u j := rfl
      _ = _ := by
        apply Finset.sum_congr rfl
        intro i _
        apply Finset.sum_congr rfl
        intro j _
        rw [hsym j i]
  have hsquares : 0 ≤ edgeSquares := by
    dsimp [edgeSquares]
    apply Finset.sum_nonneg
    intro i _
    apply Finset.sum_nonneg
    intro j _
    exact mul_nonneg (hnonneg i j) (sq_nonneg _)
  have hidentity : 2 * energy = -edgeSquares := by
    calc
      2 * energy = energy + energy := by ring
      _ = energy + ∑ i, ∑ j,
          conductance i j * (u i - u j) * u j := by rw [← hswap]
      _ = ∑ i, ∑ j,
          (conductance i j * (u j - u i) * u i +
            conductance i j * (u i - u j) * u j) := by
            dsimp [energy]
            simp only [← Finset.sum_add_distrib]
      _ = -edgeSquares := by
        dsimp [edgeSquares]
        rw [← Finset.sum_neg_distrib]
        apply Finset.sum_congr rfl
        intro i _
        rw [← Finset.sum_neg_distrib]
        apply Finset.sum_congr rfl
        intro j _
        ring
  simp only [leveque04_weightedDiffusion, Finset.sum_mul]
  change energy ≤ 0
  linarith

/-- A weighted Crank–Nicolson step contracts the sum of squared cell
values for every nonnegative time step, without a CFL restriction. -/
theorem leveque04_weightedCrankNicolson_energy
    {V : Type*} [Fintype V]
    (conductance : V → V → ℝ)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (before after : V → ℝ) (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (hstep : ∀ i, after i - before i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after + before) i) :
    (∑ i, after i ^ 2) ≤ ∑ i, before i ^ 2 := by
  have hdissipative := leveque04_weightedDiffusion_dissipative
    conductance hsym hnonneg (after + before)
  have hpoint (i : V) : after i ^ 2 - before i ^ 2 =
      (timeStep / 2) *
        (leveque04_weightedDiffusion conductance (after + before) i *
          (after i + before i)) := by
    calc
      after i ^ 2 - before i ^ 2 =
          (after i - before i) * (after i + before i) := by ring
      _ = _ := by rw [hstep i]; ring
  have henergy : (∑ i, after i ^ 2) - (∑ i, before i ^ 2) =
      (timeStep / 2) *
        (∑ i, leveque04_weightedDiffusion conductance
          (after + before) i * (after i + before i)) := by
    rw [← Finset.sum_sub_distrib]
    simp_rw [hpoint]
    rw [← Finset.mul_sum]
  have hnonpos : (timeStep / 2) *
      (∑ i, leveque04_weightedDiffusion conductance
        (after + before) i * (after i + before i)) ≤ 0 :=
    mul_nonpos_of_nonneg_of_nonpos (by linarith) (by simpa using hdissipative)
  linarith

/-- For a fixed before-state, a nonnegative-time-step weighted
Crank–Nicolson equation has at most one after-state. -/
theorem leveque04_weightedCrankNicolson_unique
    {V : Type*} [Fintype V]
    (conductance : V → V → ℝ)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (before after₁ after₂ : V → ℝ) (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (hstep₁ : ∀ i, after₁ i - before i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after₁ + before) i)
    (hstep₂ : ∀ i, after₂ i - before i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after₂ + before) i) :
    after₁ = after₂ := by
  let δ := after₁ - after₂
  have harg : (after₁ + before) - (after₂ + before) = δ := by
    ext i
    simp only [δ, Pi.sub_apply, Pi.add_apply]
    ring
  have hdelta (i : V) : δ i =
      (timeStep / 2) * leveque04_weightedDiffusion conductance δ i := by
    have h₁ := hstep₁ i
    have h₂ := hstep₂ i
    have hsub := leveque04_weightedDiffusion_sub conductance
      (after₁ + before) (after₂ + before) i
    rw [harg] at hsub
    dsimp [δ]
    rw [hsub]
    linarith
  have henergy := leveque04_weightedCrankNicolson_energy conductance
    hsym hnonneg (fun _ => 0) δ timeStep htime (by
      intro i
      simpa [leveque04_weightedDiffusion] using hdelta i)
  have hsum : (∑ i, δ i ^ 2) ≤ 0 := by simpa using henergy
  funext i
  have hi : δ i ^ 2 ≤ ∑ j, δ j ^ 2 :=
    Finset.single_le_sum (fun j _ => sq_nonneg (δ j)) (Finset.mem_univ i)
  have hzero : δ i = 0 := by nlinarith [sq_nonneg (δ i)]
  exact sub_eq_zero.mp hzero

/-- On any finite symmetric nonnegative conductance network, the
Crank–Nicolson implicit equation has exactly one after-state for each
before-state and nonnegative time step. -/
theorem leveque04_weightedCrankNicolson_existsUnique
    {V : Type*} [Fintype V]
    (conductance : V → V → ℝ)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (before : V → ℝ) (timeStep : ℝ) (htime : 0 ≤ timeStep) :
    ∃! after : V → ℝ, ∀ i, after i - before i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after + before) i := by
  let L := leveque04_weightedDiffusionLinear conductance
  let A : (V → ℝ) →ₗ[ℝ] (V → ℝ) := LinearMap.id - (timeStep / 2) • L
  have hker (u : V → ℝ) (hu : A u = 0) : u = 0 := by
    have hstep (i : V) : u i - (0 : V → ℝ) i =
        (timeStep / 2) *
          leveque04_weightedDiffusion conductance (u + 0) i := by
      have hi := congrFun hu i
      simp only [A, L, LinearMap.sub_apply, LinearMap.id_apply,
        LinearMap.smul_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul,
        leveque04_weightedDiffusionLinear, Pi.zero_apply] at hi
      simpa [leveque04_weightedDiffusion] using sub_eq_zero.mp hi
    have hzero (i : V) : (0 : V → ℝ) i - (0 : V → ℝ) i =
        (timeStep / 2) *
          leveque04_weightedDiffusion conductance (0 + 0) i := by
      simp [leveque04_weightedDiffusion]
    exact leveque04_weightedCrankNicolson_unique conductance hsym hnonneg
      0 u 0 timeStep htime hstep hzero
  have hinj : Function.Injective A := by
    intro u v huv
    have hzero : A (u - v) = 0 := by rw [map_sub, huv, sub_self]
    exact sub_eq_zero.mp (hker (u - v) hzero)
  have hsurj : Function.Surjective A := LinearMap.surjective_of_injective hinj
  let rhs : V → ℝ := fun i => before i +
    (timeStep / 2) * leveque04_weightedDiffusion conductance before i
  obtain ⟨after, hafter⟩ := hsurj rhs
  have hstepAfter (i : V) : after i - before i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after + before) i := by
    have hi := congrFun hafter i
    change after i - (timeStep / 2) *
        leveque04_weightedDiffusion conductance after i =
      before i + (timeStep / 2) *
        leveque04_weightedDiffusion conductance before i at hi
    have hadd : leveque04_weightedDiffusion conductance (after + before) i =
        leveque04_weightedDiffusion conductance after i +
          leveque04_weightedDiffusion conductance before i := by
      exact congrFun (L.map_add after before) i
    rw [hadd]
    nlinarith
  refine ⟨after, hstepAfter, ?_⟩
  intro other hother
  exact leveque04_weightedCrankNicolson_unique conductance hsym hnonneg
    before other after timeStep htime hother hstepAfter

/-- A conductance row supported on two selected neighbors is exactly
the corresponding two-sided discrete diffusion stencil. -/
theorem leveque04_weightedDiffusion_twoNeighbor
    {V : Type*} [Fintype V] [DecidableEq V] (conductance : V → V → ℝ)
    (u : V → ℝ) (i left right : V) (leftWeight rightWeight : ℝ)
    (hrow : ∀ j, conductance i j =
      (if j = left then leftWeight else 0) +
        (if j = right then rightWeight else 0)) :
    leveque04_weightedDiffusion conductance u i =
      leftWeight * (u left - u i) +
        rightWeight * (u right - u i) := by
  classical
  simp only [leveque04_weightedDiffusion]
  simp_rw [hrow, add_mul, Finset.sum_add_distrib]
  simp only [ite_mul, zero_mul, Finset.sum_ite_eq', Finset.mem_univ, ↓reduceIte]

/-- On a finite grid whose conductance rows are the two adjacent
interface diffusivities divided by `width²`, the weighted CN equation
is the indexed two-sided stencil of equation (4.13). -/
theorem leveque04_weightedCrankNicolson_twoNeighbor_iff
    {V : Type*} [Fintype V] [DecidableEq V]
    (conductance : V → V → ℝ) (left right : V → V)
    (leftDiffusivity rightDiffusivity : V → ℝ)
    (width timeStep : ℝ) (hwidth : width ≠ 0)
    (before after : V → ℝ)
    (hrow : ∀ i j, conductance i j =
      (if j = left i then leftDiffusivity i / width ^ 2 else 0) +
        (if j = right i then rightDiffusivity i / width ^ 2 else 0)) :
    (∀ i, after i - before i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after + before) i) ↔
    (∀ i, after i = before i + timeStep / (2 * width ^ 2) *
      (rightDiffusivity i * (before (right i) - before i) -
        leftDiffusivity i * (before i - before (left i)) +
        rightDiffusivity i * (after (right i) - after i) -
        leftDiffusivity i * (after i - after (left i)))) := by
  have hformula (i : V) :
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after + before) i =
      timeStep / (2 * width ^ 2) *
        (rightDiffusivity i * (before (right i) - before i) -
          leftDiffusivity i * (before i - before (left i)) +
          rightDiffusivity i * (after (right i) - after i) -
          leftDiffusivity i * (after i - after (left i))) := by
    rw [leveque04_weightedDiffusion_twoNeighbor conductance (after + before)
      i (left i) (right i)
      (leftDiffusivity i / width ^ 2) (rightDiffusivity i / width ^ 2)
      (hrow i)]
    simp only [Pi.add_apply]
    field_simp
    ring
  constructor
  · intro h i
    have hi := h i
    rw [hformula i] at hi
    linarith
  · intro h i
    rw [hformula i]
    linarith [h i]

/-- A finite symmetric nonnegative two-neighbor grid has a unique
solution of the indexed Crank–Nicolson diffusion stencil for every
nonnegative time step. -/
theorem leveque04_twoNeighborCrankNicolson_existsUnique
    {V : Type*} [Fintype V] [DecidableEq V]
    (conductance : V → V → ℝ) (left right : V → V)
    (leftDiffusivity rightDiffusivity : V → ℝ)
    (width timeStep : ℝ) (hwidth : width ≠ 0) (htime : 0 ≤ timeStep)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (hrow : ∀ i j, conductance i j =
      (if j = left i then leftDiffusivity i / width ^ 2 else 0) +
        (if j = right i then rightDiffusivity i / width ^ 2 else 0))
    (before : V → ℝ) :
    ∃! after : V → ℝ, ∀ i, after i =
      before i + timeStep / (2 * width ^ 2) *
        (rightDiffusivity i * (before (right i) - before i) -
          leftDiffusivity i * (before i - before (left i)) +
          rightDiffusivity i * (after (right i) - after i) -
          leftDiffusivity i * (after i - after (left i))) := by
  obtain ⟨after, hstep, hunique⟩ :=
    leveque04_weightedCrankNicolson_existsUnique conductance
      hsym hnonneg before timeStep htime
  refine ⟨after, ?_, ?_⟩
  · exact (leveque04_weightedCrankNicolson_twoNeighbor_iff conductance
      left right leftDiffusivity rightDiffusivity width timeStep
      hwidth before after hrow).mp hstep
  · intro other hother
    apply hunique
    exact (leveque04_weightedCrankNicolson_twoNeighbor_iff conductance
      left right leftDiffusivity rightDiffusivity width timeStep
      hwidth before other hrow).mpr hother

/-- Every solution of that finite indexed stencil contracts the
sum of squared cell values without a time-step restriction. -/
theorem leveque04_twoNeighborCrankNicolson_energy
    {V : Type*} [Fintype V] [DecidableEq V]
    (conductance : V → V → ℝ) (left right : V → V)
    (leftDiffusivity rightDiffusivity : V → ℝ)
    (width timeStep : ℝ) (hwidth : width ≠ 0) (htime : 0 ≤ timeStep)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (hrow : ∀ i j, conductance i j =
      (if j = left i then leftDiffusivity i / width ^ 2 else 0) +
        (if j = right i then rightDiffusivity i / width ^ 2 else 0))
    (before after : V → ℝ)
    (hstep : ∀ i, after i =
      before i + timeStep / (2 * width ^ 2) *
        (rightDiffusivity i * (before (right i) - before i) -
          leftDiffusivity i * (before i - before (left i)) +
          rightDiffusivity i * (after (right i) - after i) -
          leftDiffusivity i * (after i - after (left i)))) :
    (∑ i, after i ^ 2) ≤ ∑ i, before i ^ 2 := by
  apply leveque04_weightedCrankNicolson_energy conductance hsym hnonneg
    before after timeStep htime
  exact (leveque04_weightedCrankNicolson_twoNeighbor_iff conductance
    left right leftDiffusivity rightDiffusivity width timeStep
    hwidth before after hrow).mpr hstep

/-- The weighted CN update is a contraction between any two solutions,
so perturbations in the before-state cannot grow in finite-grid
squared energy at any nonnegative time step. -/
theorem leveque04_weightedCrankNicolson_differenceEnergy
    {V : Type*} [Fintype V]
    (conductance : V → V → ℝ)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (before₁ after₁ before₂ after₂ : V → ℝ)
    (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (hstep₁ : ∀ i, after₁ i - before₁ i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after₁ + before₁) i)
    (hstep₂ : ∀ i, after₂ i - before₂ i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (after₂ + before₂) i) :
    (∑ i, (after₁ i - after₂ i) ^ 2) ≤
      ∑ i, (before₁ i - before₂ i) ^ 2 := by
  let δbefore := before₁ - before₂
  let δafter := after₁ - after₂
  have harg : (after₁ + before₁) - (after₂ + before₂) =
      δafter + δbefore := by
    ext i
    simp only [δafter, δbefore, Pi.add_apply, Pi.sub_apply]
    ring
  have hdelta (i : V) : δafter i - δbefore i =
      (timeStep / 2) *
        leveque04_weightedDiffusion conductance (δafter + δbefore) i := by
    have h₁ := hstep₁ i
    have h₂ := hstep₂ i
    have hsub := leveque04_weightedDiffusion_sub conductance
      (after₁ + before₁) (after₂ + before₂) i
    rw [harg] at hsub
    rw [hsub]
    dsimp [δafter, δbefore]
    linarith
  exact leveque04_weightedCrankNicolson_energy conductance hsym hnonneg
    δbefore δafter timeStep htime hdelta

/-- Perturbations also contract for the displayed finite two-neighbor
Crank–Nicolson stencil. -/
theorem leveque04_twoNeighborCrankNicolson_differenceEnergy
    {V : Type*} [Fintype V] [DecidableEq V]
    (conductance : V → V → ℝ) (left right : V → V)
    (leftDiffusivity rightDiffusivity : V → ℝ)
    (width timeStep : ℝ) (hwidth : width ≠ 0) (htime : 0 ≤ timeStep)
    (hsym : ∀ i j, conductance i j = conductance j i)
    (hnonneg : ∀ i j, 0 ≤ conductance i j)
    (hrow : ∀ i j, conductance i j =
      (if j = left i then leftDiffusivity i / width ^ 2 else 0) +
        (if j = right i then rightDiffusivity i / width ^ 2 else 0))
    (before₁ after₁ before₂ after₂ : V → ℝ)
    (hstep₁ : ∀ i, after₁ i =
      before₁ i + timeStep / (2 * width ^ 2) *
        (rightDiffusivity i * (before₁ (right i) - before₁ i) -
          leftDiffusivity i * (before₁ i - before₁ (left i)) +
          rightDiffusivity i * (after₁ (right i) - after₁ i) -
          leftDiffusivity i * (after₁ i - after₁ (left i))))
    (hstep₂ : ∀ i, after₂ i =
      before₂ i + timeStep / (2 * width ^ 2) *
        (rightDiffusivity i * (before₂ (right i) - before₂ i) -
          leftDiffusivity i * (before₂ i - before₂ (left i)) +
          rightDiffusivity i * (after₂ (right i) - after₂ i) -
          leftDiffusivity i * (after₂ i - after₂ (left i)))) :
    (∑ i, (after₁ i - after₂ i) ^ 2) ≤
      ∑ i, (before₁ i - before₂ i) ^ 2 := by
  apply leveque04_weightedCrankNicolson_differenceEnergy conductance
    hsym hnonneg before₁ after₁ before₂ after₂ timeStep htime
  · exact (leveque04_weightedCrankNicolson_twoNeighbor_iff conductance
      left right leftDiffusivity rightDiffusivity width timeStep
      hwidth before₁ after₁ hrow).mpr hstep₁
  · exact (leveque04_weightedCrankNicolson_twoNeighbor_iff conductance
      left right leftDiffusivity rightDiffusivity width timeStep
      hwidth before₂ after₂ hrow).mpr hstep₂

/-- Periodic conductances with one shared variable diffusivity on
each interface; the edge from `i - 1` to `i` has coefficient `D i`. -/
noncomputable def leveque04_periodicVariableDiffusionConductance
    (n : ℕ) (interfaceDiffusivity : ZMod n → ℝ) (width : ℝ)
    (i j : ZMod n) : ℝ :=
  (if j = i - 1 then interfaceDiffusivity i / width ^ 2 else 0) +
    (if j = i + 1 then interfaceDiffusivity (i + 1) / width ^ 2 else 0)

theorem leveque04_periodicVariableDiffusionConductance_symm
    (n : ℕ) (interfaceDiffusivity : ZMod n → ℝ) (width : ℝ)
    (i j : ZMod n) :
    leveque04_periodicVariableDiffusionConductance n interfaceDiffusivity width i j =
      leveque04_periodicVariableDiffusionConductance n interfaceDiffusivity width j i := by
  have hleft : (j = i - 1) ↔ (i = j + 1) := by
    constructor <;> intro h <;> rw [h] <;> abel
  have hright : (j = i + 1) ↔ (i = j - 1) := by
    constructor <;> intro h <;> rw [h] <;> abel
  simp only [leveque04_periodicVariableDiffusionConductance, hleft, hright]
  have hfirst :
      (if i = j + 1 then interfaceDiffusivity i / width ^ 2 else 0) =
        (if i = j + 1 then interfaceDiffusivity (j + 1) / width ^ 2 else 0) := by
    split_ifs with h
    · rw [h]
    · rfl
  have hsecond :
      (if i = j - 1 then interfaceDiffusivity (i + 1) / width ^ 2 else 0) =
        (if i = j - 1 then interfaceDiffusivity j / width ^ 2 else 0) := by
    split_ifs with h
    · congr 1
      congr 1
      rw [h]
      abel
    · rfl
  rw [hfirst, hsecond]
  ac_rfl

theorem leveque04_periodicVariableDiffusionConductance_nonneg
    (n : ℕ) (interfaceDiffusivity : ZMod n → ℝ) (width : ℝ)
    (hdiffusivity : ∀ i, 0 ≤ interfaceDiffusivity i)
    (i j : ZMod n) :
    0 ≤ leveque04_periodicVariableDiffusionConductance n
      interfaceDiffusivity width i j := by
  unfold leveque04_periodicVariableDiffusionConductance
  have hleft : 0 ≤ interfaceDiffusivity i / width ^ 2 :=
    div_nonneg (hdiffusivity i) (sq_nonneg width)
  have hright : 0 ≤ interfaceDiffusivity (i + 1) / width ^ 2 :=
    div_nonneg (hdiffusivity (i + 1)) (sq_nonneg width)
  split_ifs <;> positivity

/-- Equation (4.13) on a finite periodic grid with variable
nonnegative interface diffusivity has a unique after-state at every
nonnegative time step. -/
theorem leveque04_periodicVariableCrankNicolson_existsUnique
    (n : ℕ) [NeZero n] (interfaceDiffusivity : ZMod n → ℝ)
    (width timeStep : ℝ)
    (hdiffusivity : ∀ i, 0 ≤ interfaceDiffusivity i)
    (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before : ZMod n → ℝ) :
    ∃! after : ZMod n → ℝ, ∀ i, after i =
      before i + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
          interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
          interfaceDiffusivity i * (after i - after (i - 1))) := by
  exact leveque04_twoNeighborCrankNicolson_existsUnique
    (leveque04_periodicVariableDiffusionConductance n interfaceDiffusivity width)
    (fun i => i - 1) (fun i => i + 1) interfaceDiffusivity
    (fun i => interfaceDiffusivity (i + 1)) width timeStep
    (ne_of_gt hwidth) htime
    (leveque04_periodicVariableDiffusionConductance_symm n
      interfaceDiffusivity width)
    (leveque04_periodicVariableDiffusionConductance_nonneg n
      interfaceDiffusivity width hdiffusivity) (by intro i j; rfl) before

/-- The periodic variable-diffusivity equation (4.13) is
unconditionally contractive for perturbations in squared cell energy. -/
theorem leveque04_periodicVariableCrankNicolson_differenceEnergy
    (n : ℕ) [NeZero n] (interfaceDiffusivity : ZMod n → ℝ)
    (width timeStep : ℝ)
    (hdiffusivity : ∀ i, 0 ≤ interfaceDiffusivity i)
    (hwidth : 0 < width) (htime : 0 ≤ timeStep)
    (before₁ after₁ before₂ after₂ : ZMod n → ℝ)
    (hstep₁ : ∀ i, after₁ i =
      before₁ i + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity (i + 1) * (before₁ (i + 1) - before₁ i) -
          interfaceDiffusivity i * (before₁ i - before₁ (i - 1)) +
          interfaceDiffusivity (i + 1) * (after₁ (i + 1) - after₁ i) -
          interfaceDiffusivity i * (after₁ i - after₁ (i - 1))))
    (hstep₂ : ∀ i, after₂ i =
      before₂ i + timeStep / (2 * width ^ 2) *
        (interfaceDiffusivity (i + 1) * (before₂ (i + 1) - before₂ i) -
          interfaceDiffusivity i * (before₂ i - before₂ (i - 1)) +
          interfaceDiffusivity (i + 1) * (after₂ (i + 1) - after₂ i) -
          interfaceDiffusivity i * (after₂ i - after₂ (i - 1)))) :
    (∑ i, (after₁ i - after₂ i) ^ 2) ≤
      ∑ i, (before₁ i - before₂ i) ^ 2 := by
  exact leveque04_twoNeighborCrankNicolson_differenceEnergy
    (leveque04_periodicVariableDiffusionConductance n interfaceDiffusivity width)
    (fun i => i - 1) (fun i => i + 1) interfaceDiffusivity
    (fun i => interfaceDiffusivity (i + 1)) width timeStep
    (ne_of_gt hwidth) htime
    (leveque04_periodicVariableDiffusionConductance_symm n
      interfaceDiffusivity width)
    (leveque04_periodicVariableDiffusionConductance_nonneg n
      interfaceDiffusivity width hdiffusivity) (by intro i j; rfl)
    before₁ after₁ before₂ after₂ hstep₁ hstep₂

end NumStability
