# Faithfulness audit: HDP-02-EXAMPLE-2.7.8

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `17735febbcef365ed271869eab6cf012fb916ff04da25dbd8463534bb3f800d5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target is a faithful strengthening of the selected example and its stated gauge context. The critical round-trip uncertainty is resolved by the pinned Mathlib definitions: expMeasure is gammaMeasure of shape 1, hence an atomless with-density probability measure supported on the nonnegative reals, and its proved CDF yields exactly the source tail. The threshold-2 psi-one definition then gives the exact coefficient 2. The normal-square phrase is illustrative and is subsumed by the universal square claim; the displayed variance entails the prose's standard-deviation scale; and rate-zero Poisson is a valid degenerate extension. The source nevertheless does not imply the target's arbitrary-measure square theorem, so the correct implication pair is yes/no and the classification is faithful-stronger, accepted.

## Implications

- **Lean implies source:** `yes`. Every family and quantitative claim in Example 2.7.8 is covered. Primary Mathlib semantics show that expMeasure lambda for lambda>0 is the standard nonnegative exponential probability law with tail P{X>=t}=exp(-lambda*t). The target's psi-one value 2/lambda therefore supplies the displayed C/lambda scale, its variance formula supplies both the displayed variance and the prose's standard-deviation scale, its universal square claim subsumes the normal illustration, and its Poisson statement covers positive rates.
- **Source implies lean:** `no`. The source does not assert the target's square-gauge equivalence and equality for arbitrary, possibly non-probability measures. That enlarged domain is satisfiable and nonvacuous, so it is genuine strength. Fixing the calculable coefficient C=2 and including the degenerate zero-rate Poisson law are further explicit refinements or boundary extensions, but the arbitrary-measure conjunct already makes this implication fail.

## Findings

- **major / genuine-domain-strengthening:** The source does not imply the full Lean proposition; Lean is a nonvacuous generalization and is classified faithful-stronger.
- **note / exact-constant-refinement:** The target resolves the source-local unbound constant correctly and does not lose the stated 1/lambda scale.
- **note / poisson-boundary-extension:** The target includes a valid finite-gauge boundary case in addition to all positive-rate Poisson distributions.
- **note / source-presentation-reconciled:** The variance identity entails the standard-deviation scale for positive lambda, and the universal square result subsumes the normal illustration; neither presentation difference blocks faithfulness.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `unclear` |
| `C08` | `pass` | `unclear` |
| `C09` | `fail` | `unclear` |
| `C10` | `pass` | `fail` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `140` dependencies (`80` hash-reused); unclear: `none`.
- Direct judge covered `140` dependencies (`80` hash-reused); failing or unclear: `D001`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/agent_outputs/adjudicator.json` (`2fda7df3f2ac946b38d8084b327ebd496b9459e6191241786de2d5c3954059c1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/agent_outputs/agent_runs.json` (`bc820238c30c4a499c812c9b82d284502ed7b89e88101e587110cc20db01cbb3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/agent_outputs/blind_translation.json` (`b03ceeef99289c5c53715e51dde6bff9bcdb5dbae918de787a8fe99a750f9a5b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/agent_outputs/direct_judge.json` (`16c93322e3530603aef335afbffd9f9b86cef54ab3b48de4f9d5b375af0db221`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`1f76b08f296fe7b52c0170098abae08e24af5b1d87105b7dc082266feab0a8ae`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/agent_outputs/source_contract.json` (`f2a48ddada772c222492df2506849cc6dc191a7c5846b7d22c755890121c92ea`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/decision.json` (`7cd41bc295841662c4a090ca15e6b150f4732172d549e8eda67969e29b130ac3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`61e2954474ec2adcb52bf537eb704400fbd1a118de058a12f388c362ced69e5f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/blind_dossier.md` (`3809d7727fc4e2588e4ef2444f233d4a166dddf553bc8870904af4bac65874e8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/blind_review_packet.md` (`dfd09255a6b190bd3fcedd7cadbe9af4af14fb5f3bf77367a6830ec1adfe8e01`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/declaration_dossier.md` (`155c1bbbb360b0057929803f57a659de2194f1775e7666d32f2fbe6ea9078dbb`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/dependency_inventory.json` (`aea8122d333d7f7007a0b0acf74d2c3dcdb7c2461666733fa50df7a54378ccc0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/dependency_reuse_blind.json` (`d484eeecd36062c9f68e6ee4e5f3a1a9cde922afa5749cc9fc45669d145fbdee`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/dependency_reuse_direct.json` (`c1698722916020da7ee9f2025186685d3dc5ec25a13a031a712cd325ad3d92dc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/direct_review_packet.md` (`25ac92d8f95060cd732a44579497ead3d5f456c6847de6ecd5ab75b03ce7552d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.8/faithfulness-current-v1/inputs/source_locator.json` (`64d7ad44fa13baa00f5fe85ba6aa1e9249e9fee7c2020533fe2bfe6cdaaca723`)
