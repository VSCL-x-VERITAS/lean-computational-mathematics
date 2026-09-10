# Faithfulness audit: HDP-02-DEF-2.7-ORLICZ-FUNCTION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `fba2c68f3eb94c8fac32974a2d400a4839d6c4977a01ff6a801ee57f4a232566`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target faithfully turns the printed definition into a structure-characterization equivalence. Its real-valued ambient-function encoding preserves the source's half-line domain and codomain by restricting all relevant conditions to Set.Ici 0 and requiring nonnegative output there. Convexity, nondecreasingness, ψ(0)=0, and divergence at positive infinity are all represented exactly. No probability-space or random-variable assumptions are introduced, the statement is satisfiable, and both implication directions hold.

## Implications

- **Lean implies source:** `yes`. A witness ψ with ψ.toFun=f carries, by D004, nonnegative values on [0,∞), convexity and nondecreasingness there, f(0)=0, and Tendsto f atTop atTop, which are all source requirements.
- **Source implies lean:** `yes`. Any source Orlicz function can be represented by an arbitrary real extension f; the source properties give the five constructor fields on Set.Ici 0, while negative-input behavior is unconstrained, so D004 produces the existential witness and D003 identifies its function with f.

## Findings

- **note / representation:** This is a semantics-preserving encoding choice: negative inputs are outside the source domain and create neither an extra condition nor a missing condition.
- **note / terminology:** This follows the conventional interpretation recorded in the source contract; no adjudication is required.
- **note / domain-representation:** This is a harmless representation choice because negative-input values are outside the source claim.
- **note / monotonicity-convention:** This conventional non-strict reading is compatible with the source contract and its examples and does not change the classification.

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

- Blind translator covered `27` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `27` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/agent_outputs/agent_runs.json` (`1ba830d7ee37df010f9ff3656d010fcf265828625026eb4804f09279fd637dc8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/agent_outputs/blind_translation.json` (`039a5bfaa6bddb205476ec6189542f9c622041b52fcd55146078280389e9353e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/agent_outputs/direct_judge.json` (`bca63c80a55613c450b77d6aff17a849ce1c351e5486491209a1cb9fe030a431`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`f6dc75c2319db31915aeed109f98862e828b597c117fbb3e0bef95ec3a6a29d4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/agent_outputs/source_contract.json` (`8e748f79732228565ba1991ae2aade070e17d6202798940ec21b923fc0af541f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/decision.json` (`e50fb73964e6bf77e148277c3d19f1b2e5bb6b236f1cf38d8c396dde8e67af47`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`edf73c20c5e0043fdd323fef4955aba06829c25e248366c43c8a2efa3fe5f4f0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/blind_dossier.md` (`69cdaf12a5a53a24908e9a149a4f81457ddab21a937899bb1e331b5cb79f6a91`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/blind_review_packet.md` (`69cdaf12a5a53a24908e9a149a4f81457ddab21a937899bb1e331b5cb79f6a91`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/declaration_dossier.md` (`cbd8bf76d9debba53a3dc56d7652d201e5e9aa4351d27728322e41cd9e28d989`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/dependency_inventory.json` (`234c825a996718d5c69e945262436aa0c59bb1e2e0d2e0fc8b0e295b40fa4c81`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/direct_review_packet.md` (`bf2d8d003afb1b04097c90032f8bdbd8f21dbe84ce0cbc21a3b9b1256fb84a67`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-FUNCTION/faithfulness-current-v1/inputs/source_locator.json` (`247de52f006c596410b19bb468473ff86ac77270277ed07755dc934275a84580`)
