# Vershynin Chapter 4 coverage

The selected source is the pinned 2018 first edition, Chapter 4, *Random matrices*. As of October 30, 2026, **124 of 124 source obligations are accepted (100.00%)**, with **none open**, **three skipped** and **17 deferred**. The Chapter 4 gate is **PASS**, including the actual whole-unit organization check. Protected publication is tracked separately. The complete independently reviewed inventory covers all 29 chapter-PDF pages; witness and correction children do not enlarge its denominator.

Lean `v4.29.0-rc3` and Mathlib `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b` remain pinned. Continuation uses workflow `8.1.65`; previously accepted results retain their original proof and review receipts.

Source SHA-256: `b7448935fe23081eefa4d1589a07550c384d986f6ae499fb06547d10c2f993f9`. Sealed inventory SHA-256: `4f78d8aa158dc0dc2e08bb489fa5b488e7a809d8dbf549501c0eea632b8d9908`. Gate snapshot SHA-256: `e4bcd3129392a5d1fc1ed18f509b676117d80c6c707db9e9d1cc97b61c21d851`.

## Acceptance and remaining work

| Status | Source rows |
|---|---:|
| `PROVED` | 87 |
| `REUSED` | 26 |
| `DISCREPANCY` | 11 |
| `IN_PROGRESS` | 0 |
| `SKIPPED` | 3 |
| `DEFERRED` | 17 |

`PROVED` and `REUSED` consume accepted source correspondences and canonical Lean proof receipts. `DISCREPANCY` closes a false printed assertion through its formal witness, distinct corrected result and required complete parent correspondence. It does not prove the false printed assertion. Open candidates, generic builds, source opinions and favorable partial reviews grant no source-row credit.

No selected source obligation remains open. The spectral-gap parent and Exercise 4.7.6 now have accepted complete parent correspondences, canonical proofs and actual source-parent consumption. Their original adverse judgments remain preserved; the discrepancy closures do not prove the false printed assertions. The signal-norm, Equation 4.17 and Theorem 4.7.5 parent closures remain accepted. Equation 4.15 retains its accepted complete statement review and exact-target canonical proof.

Remark 4.7.2 is excluded for unresolved dependence of the printed comparison constants on the inherited subgaussian parameter. Its existing conditional sufficient bound remains useful mathematics and grants no source-row credit. All saved source uncertainty and the earlier formal target remain preserved. See [the sample-complexity analysis](remark-4-7-2-analysis.md).

The actual Chapter 4 terminal gate and whole-unit organization check both pass. The native organization receipt covers 666 modules, with all five finding counters zero and complete semantic coverage. It retains 665 unchanged assessments and the final two-parent aggregate assessment; the affected aggregate build passes 4105 jobs. Protected publication is tracked separately.

## Module structure

Reusable mathematics lives below `Analysis`, `Algorithms` and `HDP`; source correspondences, witnesses and corrected counterparts live below `Source/Vershynin/Chapter04`. The [public chapter aggregate](../../../ComputationalMathematics/Source/Vershynin/Chapter04.lean) exposes accepted source proofs. [The organization record](../../architecture/ch04-organization-20261029.md) describes the preserved module/API assessments and pseudoinverse extraction.

The principal dependency chains are matrix spectral theory → norm and singular-value contracts; nets and packing → matrix norm approximation → concentration; covariance estimation → spectral perturbation → clustering. Generic Moore–Penrose and symmetric partial-inverse algebra also supports singular covariance and whitening constructions.

## Every inventoried row

The table accounts for all **144 inventory rows**: 124 formalization obligations, three skips and 17 deferrals. The declaration column is the selected gate's public alias index for accepted rows. Original canonical proof receipts and parent correspondence receipts remain acceptance authority; declaration names alone do not establish acceptance. Skips and deferrals state their disposition. Private PDFs and campaign artifacts remain outside product Git history.

| Source row | Status | Accepted declaration index or disposition |
|---|---|---|
| `HDP-04-SVD-DEFINITION` | `PROVED` | `NumStability.HDP.Chapter04.SVDDefinitionGramSpectra.target_proved` |
| `HDP-04-EQ-4.1` | `REUSED` | `NumStability.HDP.Contract.hdp_04_heq_h4_d1` |
| `HDP-04-SINGULAR-EIGENVALUE-RELATIONS` | `PROVED` | `NumStability.HDP.Contract.hdp_04_singular_eigenvalue_relations` |
| `HDP-04-SYMMETRIC-SINGULAR-VALUES` | `PROVED` | `NumStability.HDP.Contract.hdp_04_symmetric_singular_values` |
| `HDP-04-EQ-4.2` | `PROVED` | `NumStability.HDP.Contract.hdp_04_heq_h4_d2` |
| `HDP-04-SINGULAR-VALUE-MINMAX` | `PROVED` | `NumStability.HDP.Contract.hdp_04_singular_value_minmax` |
| `HDP-04-EXERCISE-4.1.1` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_1_1` |
| `HDP-04-OPERATOR-NORM-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_operator_norm_definition` |
| `HDP-04-OPERATOR-NORM-BILINEAR` | `PROVED` | `NumStability.HDP.Contract.hdp_04_operator_norm_bilinear` |
| `HDP-04-OPERATOR-NORM-LARGEST-SINGULAR-CHECK` | `PROVED` | `NumStability.HDP.Contract.hdp_04_operator_norm_eq_largest_singular_value_coordinate_max` |
| `HDP-04-SMALLEST-SINGULAR-PSEUDOINVERSE` | `REUSED` | `NumStability.HDP.Contract.hdp_04_smallest_singular_value_kernel_and_penrose_equations` |
| `HDP-04-FROBENIUS-NORM-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_frobenius_norm_definition` |
| `HDP-04-FROBENIUS-SINGULAR-VALUES` | `PROVED` | `NumStability.HDP.Contract.hdp_04_frobenius_norm_eq_sqrt_sum_singular_values_sq` |
| `HDP-04-EQ-4.3` | `PROVED` | `NumStability.HDP.Contract.hdp_04_eq_4_3` |
| `HDP-04-FROBENIUS-INNER-PRODUCT-NORM` | `PROVED` | `NumStability.HDP.Contract.hdp_04_frobenius_norm_sq_eq_inner_self` |
| `HDP-04-SINGULAR-VECTOR-NORM-COMPARISON-CHECK` | `PROVED` | `NumStability.HDP.Contract.hdp_04_singular_vector_norm_comparison_check` |
| `HDP-04-EQ-4.4` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_4` |
| `HDP-04-EXERCISE-4.1.2` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_1_2` |
| `HDP-04-ECKART-YOUNG-MIRSKY` | `PROVED` | `NumStability.HDP.Contract.hdp_04_eckart_young_mirsky` |
| `HDP-04-EXERCISE-4.1.3` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_1_3` |
| `HDP-04-EQ-4.5` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_5`; `NumStability.HDP.Contract.hdp_04_equation_4_5_explicit_svd` |
| `HDP-04-DISTANCE-DISTORTION-CHECK` | `PROVED` | `NumStability.HDP.Contract.hdp_04_distance_distortion_check`; `NumStability.HDP.Contract.hdp_04_distance_distortion_explicit_svd` |
| `HDP-04-EXERCISE-4.1.4` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_1_4` |
| `HDP-04-ORTHOGONAL-PROJECTION-DEFINITION` | `REUSED` | `NumStability.HDP.Contract.hdp_04_orthogonal_projection_definition` |
| `HDP-04-LEMMA-4.1.5` | `PROVED` | `NumStability.HDP.Contract.hdp_04_lemma_4_1_5` |
| `HDP-04-EQ-4.6` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_6` |
| `HDP-04-EQ-4.7` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_7` |
| `HDP-04-EQ-4.8` | `REUSED` | `NumStability.HDP.Contract.hdp_04_heq_h4_d8` |
| `HDP-04-EXERCISE-4.1.6` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_1_6` |
| `HDP-04-REMARK-4.1.7` | `PROVED` | `NumStability.HDP.Contract.hdp_04_remark_4_1_7` |
| `HDP-04-EXERCISE-4.1.8` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_1_8` |
| `HDP-04-DEFINITION-4.2.1` | `REUSED` | `NumStability.HDP.Contract.hdp_04_hdef_h4_d2_d1` |
| `HDP-04-EQ-4.9` | `REUSED` | `NumStability.HDP.Contract.hdp_04_heq_h4_d9` |
| `HDP-04-XREF-COROLLARY-0.0.4` | `DEFERRED` | The polytope covering result belongs to the Appetizer and serves as an imported example for the epsilon-net definition. |
| `HDP-04-DEFINITION-4.2.2` | `PROVED` | `NumStability.HDP.Contract.hdp_04_hdef_h4_d2_d2` |
| `HDP-04-REMARK-4.2.3` | `REUSED` | `NumStability.HDP.Contract.hdp_04_hremark_h4_d2_d3` |
| `HDP-04-DEFINITION-4.2.4` | `PROVED` | `NumStability.HDP.Contract.definition424OwnerQualifiedPositiveTarget_proved` |
| `HDP-04-EXERCISE-4.2.5` | `PROVED` | `NumStability.HDP.Contract.exercise425_numerical_packing_proved` |
| `HDP-04-MAXIMAL-SEPARATED-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_maximal_separated_positive_definition` |
| `HDP-04-LEMMA-4.2.6` | `REUSED` | `NumStability.HDP.Contract.hdp_04_maximal_separated_positive_is_net` |
| `HDP-04-REMARK-4.2.7` | `REUSED` | `NumStability.HDP.Contract.hdp_04_hremark_h4_d2_d7` |
| `HDP-04-LEMMA-4.2.8` | `PROVED` | `NumStability.HDP.Contract.hdp_04_lemma_4_2_8_owner_qualified_numerical_proved` |
| `HDP-04-EXERCISE-4.2.9` | `PROVED` | `NumStability.HDP.Contract.exercise429NumericalTarget_proved` |
| `HDP-04-EXERCISE-4.2.10` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_2_10` |
| `HDP-04-EUCLIDEAN-COVERING-NOTATION` | `REUSED` | `NumStability.HDP.Contract.hdp_04_euclidean_positive_covering_value` |
| `HDP-04-DEFINITION-4.2.11` | `REUSED` | `NumStability.HDP.Contract.hdp_04_hdef_h4_d2_d11` |
| `HDP-04-EUCLIDEAN-UNIT-BALL-DEFINITION` | `REUSED` | `NumStability.HDP.Contract.hdp_04_euclidean_unit_ball_definition` |
| `HDP-04-PROPOSITION-4.2.12` | `PROVED` | `NumStability.HDP.Contract.hdp_04_proposition_4_2_12` |
| `HDP-04-COROLLARY-4.2.13` | `PROVED` | `NumStability.HDP.Contract.hdp_04_corollary_4_2_13` |
| `HDP-04-EQ-4.10` | `REUSED` | `NumStability.HDP.Contract.hdp_04_equation_4_10` |
| `HDP-04-EUCLIDEAN-BALL-TRIVIAL-COVER` | `PROVED` | `NumStability.HDP.Contract.hdp_04_euclidean_ball_trivial_cover` |
| `HDP-04-DEFINITION-4.2.14` | `PROVED` | `NumStability.HDP.Contract.hdp_04_hdef_h4_d2_d14` |
| `HDP-04-EXERCISE-4.2.15` | `REUSED` | `NumStability.HDP.Contract.hdp_04_hexercise_h4_d2_d15` |
| `HDP-04-EXERCISE-4.2.16` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_2_16` |
| `HDP-04-XREF-EXERCISE-0.0.5` | `DEFERRED` | The result belongs to the Appetizer inventory and is an imported dependency for Chapter 4. |
| `HDP-04-METRIC-ENTROPY-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_metric_entropy_definition` |
| `HDP-04-CODING-COMPLEXITY-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_coding_complexity_definition` |
| `HDP-04-DIAMETER-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_diameter_definition` |
| `HDP-04-PROPOSITION-4.3.1` | `PROVED` | `NumStability.HDP.Contract.hdp_04_proposition_4_3_1` |
| `HDP-04-ERROR-CORRUPTION-STRING-EXAMPLE` | `PROVED` | `NumStability.HDP.StringCorruption.errorCorruptionStringAtMostTwoExample`; `NumStability.HDP.Verification.errorCorruptionStringAtMostTwoExample` |
| `HDP-04-EXAMPLE-4.3.2` | `PROVED` | `NumStability.HDP.Contract.hdp_04_example_4_3_2` |
| `HDP-04-EQ-4.11` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_11` |
| `HDP-04-DEFINITION-4.3.3` | `PROVED` | `NumStability.HDP.Contract.hdp_04_definition_4_3_3` |
| `HDP-04-LEMMA-4.3.4` | `REUSED` | `NumStability.HDP.Contract.hdp_04_lemma_4_3_4` |
| `HDP-04-THEOREM-4.3.5` | `DISCREPANCY` | `NumStability.HDP.Contract.hdp_04_theorem_4_3_5_printed_statement_counterexample`; `NumStability.HDP.Contract.hdp_04_theorem_4_3_5_corrected` |
| `HDP-04-THIRTY-LETTER-CODE-EXAMPLE` | `PROVED` | `NumStability.HDP.SourceTargets.thirtyLetterQualifiedProof` |
| `HDP-04-REMARK-4.3.6` | `DISCREPANCY` | `NumStability.HDP.Contract.hdp_04_remark_4_3_6_printed_statement_counterexample`; `NumStability.HDP.Contract.hdp_04_remark_4_3_6_integer_rounded_correction` |
| `HDP-04-EXERCISE-4.3.7` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_3_7_converse` |
| `HDP-04-XREF-SECTION-6.5` | `DEFERRED` | The referenced extension belongs to Chapter 6 and is a future-unit dependency rather than a Chapter 4 proof target. |
| `HDP-04-LEMMA-4.4.1` | `PROVED` | `NumStability.HDP.Contract.hdp_04_lemma_4_4_1` |
| `HDP-04-EXERCISE-4.4.2` | `REUSED` | `NumStability.HDP.Contract.hdp_04_exercise_4_4_2` |
| `HDP-04-SYMMETRIC-OPERATOR-NORM-QUADRATIC` | `PROVED` | `NumStability.HDP.Contract.hdp_04_symmetric_operator_norm_quadratic` |
| `HDP-04-EXERCISE-4.4.3` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_4_3` |
| `HDP-04-EXERCISE-4.4.4` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_4_4` |
| `HDP-04-THEOREM-4.4.5` | `PROVED` | `NumStability.HDP.Contract.hdp_04_theorem_4_4_5` |
| `HDP-04-EQ-4.12` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_12` |
| `HDP-04-XREF-PROPOSITION-2.6.1` | `DEFERRED` | The proposition belongs to Chapter 2 and is an imported concentration dependency for Theorem 4.4.5. |
| `HDP-04-XREF-EQ-2.14` | `DEFERRED` | The tail equivalence is sourced in Chapter 2 and is an imported dependency for Theorem 4.4.5. |
| `HDP-04-EQ-4.13` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_13` |
| `HDP-04-EQ-4.14` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_14` |
| `HDP-04-EQ-4.15` | `PROVED` | `NumStability.HDP.Contract.Equation415OwnerQualified.equation415_owner_qualified_proved` |
| `HDP-04-EQ-4.16` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_16` |
| `HDP-04-EXERCISE-4.4.6` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_4_6` |
| `HDP-04-EXERCISE-4.4.7` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_4_7` |
| `HDP-04-XREF-EXERCISE-3.1.4` | `DEFERRED` | The concentration result belongs to Chapter 3 and is an imported dependency for Exercise 4.4.7. |
| `HDP-04-COROLLARY-4.4.8` | `PROVED` | `NumStability.HDP.Contract.hdp_04_corollary_4_4_8` |
| `HDP-04-XREF-SECTION-2.4` | `DEFERRED` | The Erdos-Renyi model belongs to Chapter 2 and is imported as background for Definition 4.5.1. |
| `HDP-04-DEFINITION-4.5.1` | `PROVED` | `NumStability.HDP.Contract.hdp_04_definition_4_5_1` |
| `HDP-04-XREF-DEFINITION-3.6.2` | `DEFERRED` | The adjacency-matrix definition belongs to Chapter 3 and is imported by the stochastic-block-model application. |
| `HDP-04-EXPECTED-ADJACENCY-DECOMPOSITION` | `DISCREPANCY` | `NumStability.HDP.Contract.hdp_04_expected_adjacency_literal_identification_obstruction`; `NumStability.HDP.Contract.hdp_04_expected_adjacency_decomposition_corrected` |
| `HDP-04-EXPECTED-ADJACENCY-N4-EXAMPLE` | `DISCREPANCY` | `NumStability.HDP.Contract.hdp_04_expected_adjacency_n4_concrete_literal_obstruction`; `NumStability.HDP.Contract.hdp_04_expected_adjacency_n4_corrected` |
| `HDP-04-EXERCISE-4.5.2` | `DISCREPANCY` | `NumStability.HDP.Contract.hdp_04_exercise_4_5_2_actual_expectation_rank_obstruction`; `NumStability.HDP.Contract.hdp_04_exercise_4_5_2_loopless_rank_classification`; `NumStability.HDP.Contract.hdp_04_equation_4_17_loopless_full_corrected` |
| `HDP-04-EQ-4.17` | `DISCREPANCY` | `NumStability.HDP.Contract.DiscrepancyChildren.equation417_witness_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.equation417_correction_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.signal_norm_correction_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.spectral_gap_correction_child_proved` |
| `HDP-04-SBM-SIGNAL-NORM` | `DISCREPANCY` | `NumStability.HDP.Contract.DiscrepancyChildren.signal_norm_witness_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.equation417_correction_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.signal_norm_correction_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.spectral_gap_correction_child_proved` |
| `HDP-04-SBM-EIGENVECTOR-COEFFICIENT-SIZES` | `DISCREPANCY` | `NumStability.HDP.Contract.hdp_04_sbm_eigenvector_coefficient_sizes_counterexample`; `NumStability.HDP.Contract.hdp_04_sbm_eigenvector_sign_correction` |
| `HDP-04-EQ-4.18` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_18` |
| `HDP-04-THEOREM-4.5.3` | `REUSED` | `NumStability.HDP.Contract.hdp_04_theorem_4_5_3` |
| `HDP-04-EXERCISE-4.5.4` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_5_4` |
| `HDP-04-THEOREM-4.5.5` | `PROVED` | `NumStability.HDP.Contract.hdp_04_theorem_4_5_5` |
| `HDP-04-EQ-4.19` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_19` |
| `HDP-04-SBM-SPECTRAL-GAP` | `DISCREPANCY` | `NumStability.HDP.Contract.DiscrepancyChildren.spectral_gap_witness_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.equation417_correction_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.signal_norm_correction_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.spectral_gap_correction_child_proved` |
| `HDP-04-SBM-EIGENVECTOR-PERTURBATION` | `REUSED` | `NumStability.HDP.Contract.hdp_04_sbm_eigenvector_perturbation` |
| `HDP-04-EQ-4.20` | `REUSED` | `NumStability.HDP.Contract.hdp_04_equation_4_20` |
| `HDP-04-SBM-SIGN-DISAGREEMENT-BOUND` | `PROVED` | `NumStability.HDP.Contract.sbm_sign_disagreement_full_body_proved` |
| `HDP-04-SBM-EIGENVECTOR-SIGN-CORRECTION` | `PROVED` | `NumStability.HDP.Contract.sbm_eigenvector_sign_correction_full_body_proved` |
| `HDP-04-ALGORITHM-4.5-SPECTRAL-CLUSTERING` | `PROVED` | `NumStability.HDP.Contract.hdp_04_algorithm_4_5_spectral_clustering` |
| `HDP-04-THEOREM-4.5.6` | `PROVED` | `NumStability.HDP.Contract.theorem456_owner_qualified_all_unit_proved` |
| `HDP-04-SBM-DENSE-REGIME-CONSTANT-ERROR` | `PROVED` | `NumStability.HDP.Contract.hdp_04_sbm_dense_regime_constant_error_explicit` |
| `HDP-04-XREF-SECTION-3.4` | `DEFERRED` | These definitions and foundational results belong to Chapter 3 and are imported by the row-independent random-matrix theorem. |
| `HDP-04-THEOREM-4.6.1` | `PROVED` | `NumStability.HDP.Contract.hdp_04_theorem_4_6_1_explicit_svd` |
| `HDP-04-EQ-4.21` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_21_explicit_svd` |
| `HDP-04-EQ-4.22` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_22` |
| `HDP-04-EQ-4.23` | `PROVED` | `NumStability.HDP.Contract.hdp_04_equation_4_23` |
| `HDP-04-SQUARED-SUBGAUSSIAN-CHECK` | `REUSED` | `NumStability.HDP.Contract.hdp_04_squared_subgaussian_check` |
| `HDP-04-XREF-COROLLARY-2.8.3` | `DEFERRED` | Bernstein's inequality belongs to Chapter 2 and is an imported concentration dependency. |
| `HDP-04-EXERCISE-4.6.2` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_6_2` |
| `HDP-04-XREF-LEMMA-1.2.1` | `DEFERRED` | The integral identity belongs to Chapter 1 and is an imported dependency for Exercise 4.6.2. |
| `HDP-04-EXERCISE-4.6.3` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_6_3_explicit_svd` |
| `HDP-04-EXERCISE-4.6.4` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_6_4`; `NumStability.HDP.Contract.hdp_04_exercise_4_6_4_explicit_svd` |
| `HDP-04-XREF-THEOREM-3.1.1` | `DEFERRED` | The concentration theorem belongs to Chapter 3 and is an imported dependency for Exercise 4.6.4. |
| `HDP-04-COVARIANCE-MATRIX-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_covariance_matrix_definition` |
| `HDP-04-XREF-SECTION-3.2` | `DEFERRED` | The non-centered covariance/second-moment convention is sourced in Chapter 3 and imported as context for Section 4.7. |
| `HDP-04-XREF-SECTION-3.2.1` | `DEFERRED` | The PCA setup belongs to Chapter 3 and is imported background for covariance estimation. |
| `HDP-04-SAMPLE-COVARIANCE-DEFINITION` | `PROVED` | `NumStability.HDP.Contract.hdp_04_sample_covariance_definition` |
| `HDP-04-SAMPLE-COVARIANCE-UNBIASED` | `PROVED` | `NumStability.HDP.Contract.hdp_04_sample_covariance_unbiased` |
| `HDP-04-SAMPLE-COVARIANCE-ALMOST-SURE` | `PROVED` | `NumStability.HDP.Contract.hdp_04_sample_covariance_almost_sure` |
| `HDP-04-XREF-THEOREM-1.3.1` | `DEFERRED` | The law of large numbers belongs to Chapter 1; its entrywise matrix consequence is imported as asymptotic context here. |
| `HDP-04-COVARIANCE-DIMENSION-HEURISTIC-WHY` | `SKIPPED` | The source does not define the approximation accuracy or constants in approximately/gtrsim, and it does not state a nondegeneracy condition on Sigma; no full-rank hypothesis is silently added. |
| `HDP-04-XREF-SECTION-1.1-L2-NORM` | `DEFERRED` | The L^2 random-variable norm is defined in Chapter 1 and is imported by the covariance-estimation hypothesis. |
| `HDP-04-THEOREM-4.7.1` | `REUSED` | `NumStability.HDP.Contract.hdp_04_theorem_4_7_1_explicit_probability` |
| `HDP-04-EQ-4.24` | `REUSED` | `NumStability.HDP.Contract.hdp_04_equation_4_24_probability_ordinary` |
| `HDP-04-XREF-EXERCISE-3.2.2` | `DEFERRED` | The whitening result belongs to Chapter 3 and is an imported dependency for Theorem 4.7.1. |
| `HDP-04-SINGULAR-COVARIANCE-WHITENING` | `REUSED` | `NumStability.HDP.Contract.hdp_04_singular_covariance_whitening_explicit_probability` |
| `HDP-04-WHITENED-PSI2-CHECK` | `REUSED` | `NumStability.HDP.Contract.hdp_04_whitened_supplied_norms_chapter01_context` |
| `HDP-04-EQ-4.25` | `PROVED` | `NumStability.HDP.Contract.equation425_constructed_pointwise_proved` |
| `HDP-04-REMARK-4.7.2` | `SKIPPED` | Researched source-specification exclusion of the unqualified printed sample-complexity comparison only. The pinned Remark 4.7.2 prints m ≍ ε^-2 n and leaves the comparison-constant dependence on the inherited K unspecified. Complete selected Chapter 2/3/4/9 context, saved independent source opinion and inspected current author-hosted first/second editions do not supply an explicit convention resolving that scope. The K-dependent sufficient consequence is supported separate mathematics; it does not settle the unqualified row. Preserve hidden-K AMBIGUOUS, all four saved selected_value=null, all 11+11 current source-opinion warnings, seven earlier ambiguity objects, the original undetermined audit, and the existing conditional theorem. No target, proof or formalization credit is claimed. |
| `HDP-04-EXERCISE-4.7.3` | `PROVED` | `NumStability.HDP.Contract.hdp_04_exercise_4_7_3` |
| `HDP-04-DEFINITION-4.7.4` | `PROVED` | `NumStability.HDP.Contract.hdp_04_definition_4_7_4` |
| `HDP-04-ALGORITHM-4.7-SPECTRAL-CLUSTERING` | `PROVED` | `NumStability.HDP.Contract.hdp_04_algorithm_4_7_spectral_clustering` |
| `HDP-04-THEOREM-4.7.5` | `DISCREPANCY` | `NumStability.HDP.Contract.DiscrepancyChildren.theorem475_witness_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit.theorem475_allUnitCorrection_child_proved` |
| `HDP-04-EXERCISE-4.7.6` | `DISCREPANCY` | `NumStability.HDP.Contract.DiscrepancyChildren.exercise476_witness_child_proved`; `NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit.exercise476_allUnitCorrection_child_proved` |
| `HDP-04-NOTES-BINARY-ENTROPY-PRINTED-DEFINITION` | `REUSED` | `NumStability.HDP.Contract.hdp_04_notes_binary_entropy_ordinary_domain` |
| `HDP-04-NOTES-GILBERT-VARSHAMOV` | `SKIPPED` | The literal plus-sign formula conflicts with the standard binary-entropy formula, and the asymptotic variable/regime for o(1) is unspecified; retain the source claim for discrepancy/underspecification tracking rather than silently correcting it. |
| `HDP-04-NOTES-HAMMING-BOUND` | `REUSED` | `NumStability.HDP.Contract.hdp_04_notes_hamming_bound_ordinary_domain` |

## Source conventions and exercise scope

Every precise mathematical exercise in the selected inventory remains a proof obligation. Exercise 4.7.6 is still open. Quantified constants, probability bounds, dimensions, laws and independence assumptions follow each admitted source contract. Equation 4.15 separately treats positive scale/dimensions, zero scale and empty dimensions, following the recorded owner qualification. Its complete current statement review and canonical proof are accepted.

Ordinary real expectations use the module's finite-integral definability convention. The stochastic-block-model correspondence preserves loopless adjacency and explicitly handles the conflicting displayed diagonal formula through separate witness and correction claims. Gaussian corrections preserve their explicitly admitted all-unit-vector scope and distinguish analyst counterparts from claims about author intent. All original adverse reviews and source-variance records remain preserved.

See [coverage evidence](coverage-evidence.md) and [source variance](source-variance.md) for detailed historical records. Their dated statements retain their recorded scope; this page supplies the current source-row snapshot.
