/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Finset.Update
/-!
# Coordinate influence

Defines single-coordinate functional influence for arbitrary input and output
types, its exact influence set, and a finite-dependence extensionality result.
The definitions concern unrestricted fixed-method inputs; they do not impose an
admissibility class or assert a PDE support or stability result.
-/


namespace NumStability

universe uSite uData uOutput

def SingleCoordinateInfluences
    {ι : Type uSite} {E : Type uData} {V : Type uOutput}
    (f : (ι → E) → V) (site : ι) : Prop :=
  ∃ left right : ι → E,
    (∀ j : ι, j ≠ site → left j = right j) ∧ f left ≠ f right

def singleCoordinateInfluenceSet
    {ι : Type uSite} {E : Type uData} {V : Type uOutput}
    (f : (ι → E) → V) : Set ι :=
  {site | SingleCoordinateInfluences f site}

theorem eq_of_eq_on_singleCoordinateInfluenceSet_of_dependsOn_finset
    {ι : Type uSite} {E : Type uData} {V : Type uOutput}
    (f : (ι → E) → V) (s : Finset ι)
    (hfinite : DependsOn f (s : Set ι)) (left right : ι → E)
    (heq : ∀ site ∈ singleCoordinateInfluenceSet f, left site = right site) :
    f left = f right := by
  classical
  let t : Finset ι := s.filter fun i => left i ≠ right i
  let x : ι → E := Function.updateFinset right s fun i => left i
  have hnot : ∀ i ∈ t, ¬ i ∈ singleCoordinateInfluenceSet f := by
    intro i hi hinf
    have hdiff : left i ≠ right i := (Finset.mem_filter.mp hi).2
    exact hdiff (heq i hinf)
  have hstep (z : ι → E) (i : ι)
      (hi : ¬ i ∈ singleCoordinateInfluenceSet f) :
      f z = f (Function.update z i (right i)) := by
    by_contra hne
    apply hi
    change SingleCoordinateInfluences f i
    exact ⟨z, Function.update z i (right i),
      (by
        intro j hji
        simp [Function.update, hji]), hne⟩
  have hchange : ∀ q : Finset ι,
      (∀ i ∈ q, ¬ i ∈ singleCoordinateInfluenceSet f) →
      f x = f (Function.updateFinset x q fun i => right i) := by
    intro q
    induction q using Finset.induction_on with
    | empty =>
        intro _
        simp
    | @insert a q ha ih =>
        intro hq
        have hq' : ∀ i ∈ q, ¬ i ∈ singleCoordinateInfluenceSet f := by
          intro i hi
          exact hq i (Finset.mem_insert_of_mem hi)
        have hinsert :
            Function.updateFinset x (insert a q) (fun i => right i) =
              Function.update (Function.updateFinset x q (fun i => right i))
                a (right a) := by
          funext j
          by_cases hja : j = a
          · subst j
            simp [Function.updateFinset]
          · by_cases hjq : j ∈ q
            · simp [Function.updateFinset, hja, hjq]
            · simp [Function.updateFinset, hja, hjq]
        rw [hinsert]
        calc
          f x = f (Function.updateFinset x q fun i => right i) := ih hq'
          _ = f (Function.update (Function.updateFinset x q fun i => right i)
              a (right a)) := hstep _ _ (hq a (Finset.mem_insert_self a q))
  have hx : ∀ i ∈ s, x i = left i := by
    intro i hi
    simp [x, Function.updateFinset, hi]
  have hleftx : f left = f x := hfinite (fun i hi => (hx i hi).symm)
  let y : ι → E := Function.updateFinset x t fun i => right i
  have hy : y = right := by
    funext i
    by_cases his : i ∈ s
    · by_cases hdiff : left i ≠ right i
      · have hit : i ∈ t := Finset.mem_filter.mpr ⟨his, hdiff⟩
        simp [y, t, Function.updateFinset, hit]
      · have heq' : left i = right i := not_not.mp hdiff
        have hit : i ∉ t := by
          intro hit
          exact hdiff (Finset.mem_filter.mp hit).2
        simp [y, t, Function.updateFinset, hit, x, Function.updateFinset, his, heq']
    · have hit : i ∉ t := by
        intro hit
        exact his (Finset.mem_filter.mp hit).1
      simp [y, t, Function.updateFinset, hit, x, Function.updateFinset, his]
  have hxy : f x = f y := by
    simpa [y] using hchange t hnot
  have hyright : ∀ i ∈ s, y i = right i := by
    intro i _
    rw [hy]
  have hrighty : f y = f right := hfinite (fun i hi => hyright i hi)
  exact hleftx.trans (hxy.trans hrighty)


end NumStability
