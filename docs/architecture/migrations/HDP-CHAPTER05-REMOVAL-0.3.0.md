# Vershynin HDP Chapter 5 removal in 0.3.0

Release 0.3.0 removes the unfinished Vershynin Chapter 5 experiment from the supported product surface. The retained HDP source scope is Chapter 1 and Chapter 2. No Chapter 1 or Chapter 2 import or declaration is removed by this change.

This is a breaking API change because the paths and declarations below were public in 0.2.0. The removal candidate is based on commit `15207b9ce48e59258b6feaeba0b7516dd7c4f6c0`. Its exact local preimage manifest has SHA-256 `d6468c6e965d508cdb7e4c2be906021fd2b8937f99a45cba57a82f63f777e08d`; operational audit files and the manifest remain outside Git.

## Removed imports

- `ComputationalMathematics.HDP.Concentration`
- `ComputationalMathematics.HDP.Concentration.MetricMeasure`
- `ComputationalMathematics.Source.Vershynin.Chapter05`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise13`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise13.Contract`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise13.Signature`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise14`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise14.Contract`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise14.Signature`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section02.Exercise11`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section02.Exercise11.Contract`
- `ComputationalMathematics.Source.Vershynin.Chapter05.Section02.Exercise11.Signature`

## Removed declarations

- `NumStability.HDP.Concentration.MetricMeasure.ConcentrationInterfaceData` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.IsContraction` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.IsMedian` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.LipschitzCertificate` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.LipschitzInterface` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.LipschitzMapData` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.MeanConcentrationBound` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.MedianCertificate` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.MedianConcentrationBound` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.RiemannianManifoldData` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.StronglyLogConcaveData` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.SymmetricGroupData` (structure, public)
- `NumStability.HDP.Concentration.MetricMeasure.absUnitIntervalExample` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.concentrationInterface` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.concentrationMeanScale` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.concentrationMedianScale` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.concentrationPsiTwoScale` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.concentrationTailScale` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.coordinatewiseStandardNormalCdf` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.distance_to_set_le_add` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.distance_to_set_lipschitz` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.exercise512Corrected` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.hdp_05_hex_h5_d1_d14` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.integral_abs_le_two_mul_of_psiTwoAdmissible` (lemma, public)
- `NumStability.HDP.Concentration.MetricMeasure.isMedian_sub_const` (lemma, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipConstants` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipNorm` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipNorm_le` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipschitz_comp` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipschitz_interface_mk` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipschitz_map_data_mk` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipschitz_restrict` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.lipschitz_smul_left` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.medianBoundary` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.medianBoundarySet` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.medianLaw` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.medianLaw_isProbabilityMeasure` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.medianPsiTwoGaugeComparison` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.median_abs_le_of_subGaussianTail` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.median_certificate_exists` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.median_exists` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.median_exists_of_aemeasurable` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.median_interval_of_tail_bounds` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.median_unique_of_crossing` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.metricLipConstants` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.metricLipNorm` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.metricLipNorm_le` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.normalizedHammingDistance` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.psiTwoGauge_le_mul_of_admissible_bound` (lemma, public)
- `NumStability.HDP.Concentration.MetricMeasure.riemannianManifoldData_mk` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.riemannian_distance_self` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.sqrtUnitIntervalExample` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdfProductUniform` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdfProductUniform_consume` (opaque, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdfProductUniform_frontier` (opaque, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_continuous` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_lt_one` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_map_uniform` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_pos` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_preimage_Iic_of_interior` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_preimage_Iic_one` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_preimage_Iic_zero` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_strictMono` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalCdf_surjective_on_unitInterval` (lemma, private)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalLaw` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalLaw_isProbabilityMeasure` (instance, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalLaw_noAtoms` (instance, public)
- `NumStability.HDP.Concentration.MetricMeasure.standardNormalProductLaw` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.stronglyLogConcaveData_mk` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.symmetricGroup` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.symmetricGroupData_mk` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.twoPointLaw` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.twoPointLaw_median_interval` (theorem, public)
- `NumStability.HDP.Concentration.MetricMeasure.uniformUnitCubeLaw` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.uniformUnitIntervalLaw` (def, public)
- `NumStability.HDP.Concentration.MetricMeasure.uniformUnitIntervalLaw_isProbabilityMeasure` (instance, public)
- `NumStability.HDP.Contract.hdp_05_hdef_h5_d1_d1` (def, public)
- `NumStability.HDP.Contract.hdp_05_hdef_h5_d1_hmedian` (def, public)
- `NumStability.HDP.Contract.hdp_05_hdef_h5_d2_hriemannian_hmms` (def, public)
- `NumStability.HDP.Contract.hdp_05_hdef_h5_d2_hstrongly_hlogconcave` (def, public)
- `NumStability.HDP.Contract.hdp_05_hdef_h5_d2_hsymmetric_hgroup` (def, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d13` (theorem, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d13__contract` (theorem, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d13__contract_type` (def, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d14` (theorem, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d14__contract` (theorem, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d14__contract_type` (def, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d1_d2` (theorem, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d2_d11` (theorem, public)
- `NumStability.HDP.Contract.hdp_05_hex_h5_d2_d11__contract_type` (def, public)
- `NumStability.HDP.Contract.hdp_05_hiface_hconcentration` (def, public)
- `NumStability.HDP.Contract.hdp_05_hiface_hlipschitz` (def, public)

## Migration and recovery

Code using these imports or declarations must remain pinned to release `v0.2.0`, or move to independently reviewed replacement mathematics. There is no compatibility alias in 0.3.0 because carrying the Chapter 5 provider would retain the very surface this release retires.

For ordinary source recovery, check out tag `v0.2.0`. For the exact pre-removal tree used by this migration, inspect commit `15207b9ce48e59258b6feaeba0b7516dd7c4f6c0` with `git show <commit>:<path>` or create a detached checkout of that commit. The migration operator also retains a SHA-256-bound, restore-tested all-ref bundle; its path and hash are deliberately recorded only in the external completion handoff, not in this repository.

Do not restore the old campaign gates, ledgers, audits, or topology to the Git tree. Under formalization-workflow v5.1.1 those remain ignored, checkout-local runtime state.
