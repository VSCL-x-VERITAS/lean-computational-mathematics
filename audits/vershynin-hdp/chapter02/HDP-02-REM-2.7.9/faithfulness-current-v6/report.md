# Faithfulness audit: HDP-02-REM-2.7.9-current-v6

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `ea808bca200c29793c409c86967106c487ff9eb1fbbff75106d63a21a6a6366a`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The sealed dossiers show complete agreement with the source on binders, probability-space assumptions, bounded centered unit-variance normalization, exact N(0,1) identity, the global versus local MGF domains, absolute-factor property conversions, and the uncentered Exp(1) boundary case. The sole consequential difference is that Lean turns the source's informal near-zero approximation into two exact little-o assertions. Those assertions imply the source-facing heuristic and are satisfied in intended bounded examples, but the source's undefined notation does not entail their precise filter-level formulation. The coherent correction of the source's property-e/property-v cross-reference is also encoded correctly. Therefore the proposition is accepted as faithful-stronger, with no remaining uncertainty.

## Implications

- **Lean implies source:** `yes`. The two exact little-o statements yield the source's intended second-order near-zero approximations for every bounded measurable centered unit-second-moment random variable. The remaining conjuncts directly supply the exact all-real N(0,1) MGF formula, the global centered sub-gaussian and local centered sub-exponential characterization contracts with absolute-factor parameter control, and Exp(1) nonintegrability for every lambda >= 1.
- **Source implies lean:** `no`. The source's exact Gaussian identity, characterization results, and Exp(1) boundary claim support their matching target conjuncts. However, the general Taylor display uses undefined approximation signs and an unspecified little-o term inside expectation; those words alone do not entail the target's two fully quantified IsLittleO relations at nhds 0.

## Findings

- **note / rigorous-asymptotic-strengthening:** This is genuine nonvacuous added precision. It makes the target stronger than the literal source wording while preserving the intended claim and its domain.
- **note / source-cross-reference-typography:** The surrounding text determines the intended v/e pair uniquely, and D002/D003 encode that pair; the typo causes no target mismatch.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `122` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `122` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/agent_outputs/adjudicator.json` (`41ae7b4694332b24a7cde1072d6e1ffa8d80e173209ff4eb5def523e32d49735`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/agent_outputs/agent_runs.json` (`550f857e32475ff83ffdaa741f25c50d8374fea03e4b54d99c37625051986c27`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/agent_outputs/blind_translation.json` (`d25f1c03e49e981c226c9546f9d03f7600cf298f1050b01b938265f29fe75095`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/agent_outputs/direct_judge.json` (`ff7885afdaa646da4c8f9baca810bfc779aecb1e4d5424acb6ef79a903c2f203`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/agent_outputs/roundtrip_judge.json` (`f75cc8a6abeb2bd56b1047c752d2b7173e714a514e5a884168423099d0084ed1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/agent_outputs/source_contract.json` (`de1c2f3ebdd1c1838075913edfb570a123dd94af729d2a7f71699d225abc51aa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/decision.json` (`130cf9e16ac1f925c176c459adffe80476083bcba2ef527d6e875e6894edbe6e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/agent_outputs/adjudicator.json` (`41ae7b4694332b24a7cde1072d6e1ffa8d80e173209ff4eb5def523e32d49735`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/agent_outputs/agent_runs.json` (`550f857e32475ff83ffdaa741f25c50d8374fea03e4b54d99c37625051986c27`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/agent_outputs/blind_translation.json` (`d25f1c03e49e981c226c9546f9d03f7600cf298f1050b01b938265f29fe75095`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/agent_outputs/direct_judge.json` (`ff7885afdaa646da4c8f9baca810bfc779aecb1e4d5424acb6ef79a903c2f203`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/agent_outputs/roundtrip_judge.json` (`f75cc8a6abeb2bd56b1047c752d2b7173e714a514e5a884168423099d0084ed1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/agent_outputs/source_contract.json` (`de1c2f3ebdd1c1838075913edfb570a123dd94af729d2a7f71699d225abc51aa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/blind_dependency_inventory.json` (`754efe7c09a70772fb45eaf72cf255a619ced043eb18bd802f745d04fbdfef1b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/blind_dossier.md` (`dd8a394838a9d21babfc9aa682ad6fd1f37f79d6d24738ab7a2320044171c819`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/blind_review_packet.md` (`dd8a394838a9d21babfc9aa682ad6fd1f37f79d6d24738ab7a2320044171c819`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/declaration_dossier.md` (`6f28e249ebc667898437af2b2ab21a26b856c6b6fd36e7fe3fec1082f7a9d3c1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/dependency_inventory.json` (`e53f019e8b8afb70eea3f969c731d58eef6d20b549f36e2d0c01d740c676e94a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/direct_review_packet.md` (`b40f205fde75f613ca4c7092420aa6094a60d717cd31c181201a37a247b5bbc9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/history/20260910T184018Z/inputs/source_locator.json` (`658076eae278767b6bd50278106507a823442f36924ac0fce36b35948a829263`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/blind_dependency_inventory.json` (`754efe7c09a70772fb45eaf72cf255a619ced043eb18bd802f745d04fbdfef1b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/blind_dossier.md` (`dd8a394838a9d21babfc9aa682ad6fd1f37f79d6d24738ab7a2320044171c819`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/blind_review_packet.md` (`dd8a394838a9d21babfc9aa682ad6fd1f37f79d6d24738ab7a2320044171c819`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/declaration_dossier.md` (`6f28e249ebc667898437af2b2ab21a26b856c6b6fd36e7fe3fec1082f7a9d3c1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/dependency_inventory.json` (`e53f019e8b8afb70eea3f969c731d58eef6d20b549f36e2d0c01d740c676e94a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/direct_review_packet.md` (`b40f205fde75f613ca4c7092420aa6094a60d717cd31c181201a37a247b5bbc9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-REM-2.7.9/faithfulness-current-v6/inputs/source_locator.json` (`658076eae278767b6bd50278106507a823442f36924ac0fce36b35948a829263`)
