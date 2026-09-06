# Faithfulness audit: HDP-02-EXAMPLE-2.5.8B

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The stable wrapper faithfully represents Example 2.5.8(b). Its explicit measure is exactly the symmetric Bernoulli/Rademacher distribution from Definition 2.2.1, its identity function is the canonical random variable with that law, and its PsiTwoGauge definition reproduces Equation (2.13). The asserted value is the exact source value 1/sqrt(ln 2), including equality rather than a weaker bound. Passing from an arbitrary realization to the canonical law-coordinate realization is semantically harmless because the gauge is determined by the pushforward distribution. All dependencies and C01-C12 checks are resolved, both implications hold, and adjudication is unnecessary.

## Implications

- **Lean implies source:** `yes`. Any random variable X with symmetric Bernoulli distribution has pushforward law (1/2)δ₋₁+(1/2)δ₁. The ψ₂ admissibility condition and its infimum depend only on this law, so its gauge equals the target's canonical PsiTwoGauge rademacherPsiTwoLaw id, namely 1/sqrt(ln 2). The finite exact value supplies an admissible scale and hence sub-gaussianity, yielding every conclusion of Example 2.5.8(b).
- **Source implies lean:** `yes`. Apply Example 2.5.8(b) to the canonical probability space (Real,Borel,rademacherPsiTwoLaw) with random variable id. D002 is exactly the symmetric Bernoulli law from Definition 2.2.1, so the source equality gives the target equality after the positive real value is embedded into ENNReal.

## Findings

- **note / canonical-law-representation:** The syntax is specialized to a canonical realization, but no mathematical content is lost because the ψ₂ norm depends only on the distribution.
- **note / implicit-subgaussian-conclusion:** The source conclusion is retained because a finite gauge rules out an empty admissible set and yields a scale satisfying Equation (2.13).
- **note / canonical-realization:** This is a law-equivalent representation, not a consequential restriction, because every quantity in the claim is determined by the distribution.
- **note / implicit-subgaussian-conclusion:** The named sub-gaussian conclusion is logically recoverable: a finite ENNReal infimum cannot arise from an empty admissible set, so property (iv) holds.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `100` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `100` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/agent_outputs/agent_runs.json` (`8115617fed06fb48cf3d31f09f082fc4603afae3e036ebcaab36e07161b3fdea`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/agent_outputs/batch_source_contract.json` (`96eeaf2452f56158f43390ae107c2704186d8907ff70d7e9bf12165c5371c043`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/agent_outputs/blind_translation.json` (`c4ea736e22860ecd01c5a4da6b087de4dce254c25af5af23d22d8d4ec8d9eceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/agent_outputs/direct_judge.json` (`8b5477c14fc84f9a6350903c22ff908155e784917200f4b4fb0cca9e3e339d4e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/agent_outputs/roundtrip_judge.json` (`c81e3bd881f7590a4779c93cf2881439bdfeb0d6964a8c21638570e008d25b80`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/agent_outputs/source_contract.json` (`135642950056bb7346a4c8630f3294cebfee4197ac140138be7adac693c553b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/decision.json` (`0e8f968066175374572b0714ce9209ddfa44cc3e33cd47f6a68c2e8d8215e746`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/agent_outputs/agent_runs.json` (`d54ed32761b1d49502f2f0b94614acd37313096186bc086f6ecf32ef0ddfe307`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/agent_outputs/batch_source_contract.json` (`96eeaf2452f56158f43390ae107c2704186d8907ff70d7e9bf12165c5371c043`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/agent_outputs/blind_translation.json` (`c4ea736e22860ecd01c5a4da6b087de4dce254c25af5af23d22d8d4ec8d9eceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/agent_outputs/direct_judge.json` (`8b5477c14fc84f9a6350903c22ff908155e784917200f4b4fb0cca9e3e339d4e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/agent_outputs/roundtrip_judge.json` (`c81e3bd881f7590a4779c93cf2881439bdfeb0d6964a8c21638570e008d25b80`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/agent_outputs/source_contract.json` (`135642950056bb7346a4c8630f3294cebfee4197ac140138be7adac693c553b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/decision.json` (`6361cd1e6dc7fbda34d00c3b6bc360419b0b69d9151d7dc81ec30261237e2985`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/batch_source_locator.json` (`5293481efbbff8f6d8b3ad24ebedcf01bc9cf08db6b5566fb3e630372f6103f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/blind_dependency_inventory.json` (`099f094f0e88fc5ce6dc615acd29f39f27398b638bb9fc5da66ecf73239521c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/blind_dossier.md` (`6fa6c7d9c7fa0955ae9494df570929692a8079a9f331ea71bccaa22180e94f38`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/blind_review_packet.md` (`6fa6c7d9c7fa0955ae9494df570929692a8079a9f331ea71bccaa22180e94f38`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/declaration_dossier.md` (`2ea0fac8d8d928a3b88add6f778375343159a518f8173ba6bfbd0a4d33ff9fc7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/dependency_inventory.json` (`a1e595235b8171b048a22a50f0d86045f495a862a6b6debd17b133fc4fcc9749`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/direct_review_packet.md` (`26d1f3b41a87c6cd12d0540a0bc0b04ba39047f68cebb3175ae336d8416c7a2c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T085229Z/inputs/source_locator.json` (`034293148d344e6dc85f3d94de1de3386d76085dcf50e1efc2e91961c4dc7ed3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/agent_outputs/agent_runs.json` (`8115617fed06fb48cf3d31f09f082fc4603afae3e036ebcaab36e07161b3fdea`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/agent_outputs/batch_source_contract.json` (`96eeaf2452f56158f43390ae107c2704186d8907ff70d7e9bf12165c5371c043`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/agent_outputs/blind_translation.json` (`c4ea736e22860ecd01c5a4da6b087de4dce254c25af5af23d22d8d4ec8d9eceb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/agent_outputs/direct_judge.json` (`8b5477c14fc84f9a6350903c22ff908155e784917200f4b4fb0cca9e3e339d4e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/agent_outputs/roundtrip_judge.json` (`c81e3bd881f7590a4779c93cf2881439bdfeb0d6964a8c21638570e008d25b80`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/agent_outputs/source_contract.json` (`135642950056bb7346a4c8630f3294cebfee4197ac140138be7adac693c553b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/decision.json` (`175a57ffd81e04cdbacea4feab95f35fb9d68281d495d877df68c7568f45cc2b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/blind_dependency_inventory.json` (`099f094f0e88fc5ce6dc615acd29f39f27398b638bb9fc5da66ecf73239521c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/blind_dossier.md` (`6fa6c7d9c7fa0955ae9494df570929692a8079a9f331ea71bccaa22180e94f38`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/blind_review_packet.md` (`6fa6c7d9c7fa0955ae9494df570929692a8079a9f331ea71bccaa22180e94f38`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/declaration_dossier.md` (`2ea0fac8d8d928a3b88add6f778375343159a518f8173ba6bfbd0a4d33ff9fc7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/dependency_inventory.json` (`a1e595235b8171b048a22a50f0d86045f495a862a6b6debd17b133fc4fcc9749`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/direct_review_packet.md` (`26d1f3b41a87c6cd12d0540a0bc0b04ba39047f68cebb3175ae336d8416c7a2c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/history/20260831T101717Z/inputs/source_locator.json` (`034293148d344e6dc85f3d94de1de3386d76085dcf50e1efc2e91961c4dc7ed3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/blind_dependency_inventory.json` (`099f094f0e88fc5ce6dc615acd29f39f27398b638bb9fc5da66ecf73239521c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/blind_dossier.md` (`6fa6c7d9c7fa0955ae9494df570929692a8079a9f331ea71bccaa22180e94f38`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/blind_review_packet.md` (`6fa6c7d9c7fa0955ae9494df570929692a8079a9f331ea71bccaa22180e94f38`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/declaration_dossier.md` (`7a9d000cadbbba0fc979703a28f46db26e3289ad704172dab6edb47d3325432d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/dependency_inventory.json` (`a1e595235b8171b048a22a50f0d86045f495a862a6b6debd17b133fc4fcc9749`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/direct_review_packet.md` (`26d1f3b41a87c6cd12d0540a0bc0b04ba39047f68cebb3175ae336d8416c7a2c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.5.8B/faithfulness/inputs/source_locator.json` (`034293148d344e6dc85f3d94de1de3386d76085dcf50e1efc2e91961c4dc7ed3`)
