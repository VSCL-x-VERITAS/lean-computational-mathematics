# Faithfulness audit: HDP-02-THM-2.1.3

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `false`
- Target SHA-256: `cc16362fc59d5b2da48e42069ba128c348a3254d27fbfcd7f897a463ebbdd86b`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The probability setting, i.i.d. hypotheses, mean, variance, normalized centered sum, upper-tail event, standard-normal law, moment ratio, sample-size domain, and quantifier structure match. The decisive mismatch is the additional coefficient D003 > 1. Thus the source implies the Lean estimate on Lean's explicit effective domain, but the Lean estimate does not recover coefficient one.

## Implications

- **Lean implies source:** `no`. The Lean conclusion only gives C*rho/sqrt(N) with C > 1, so it does not yield coefficient one.
- **Source implies lean:** `yes`. On the explicit effective domain, rho/sqrt(N) is nonnegative and the coefficient-one source bound implies the C > 1 bound.

## Findings

- **major / extra-multiplicative-constant:** The target proves only a strictly looser estimate and does not imply the selected source statement.
- **major / constant-factor mismatch:** The translation states a strictly weaker numerical estimate: the source entails it, but it does not entail the source theorem.
- **note / effective-domain restrictions:** These conditions make the source expressions well-defined and do not create an independent faithfulness defect.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `fail` | `fail` |
| `C06` | `fail` | `pass` |
| `C07` | `fail` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `fail` | `fail` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `114` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `114` dependencies (`0` hash-reused); failing or unclear: `D003, D009`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/agent_outputs/agent_runs.json` (`3e0decbda06e1a8d5d098b2dd411585383b69e124c63a25790a2182727b9d9b7`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/agent_outputs/blind_translation.json` (`4662d35471d934bdf5e90a36837e239066e1ed3361cadcb54147b027cc1b64b6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/agent_outputs/direct_judge.json` (`dcd5a3e9dc4c463acb7fc5b5f93c4bb6c029fb4e9195e3f5f13d5192e00f27ed`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/agent_outputs/roundtrip_judge.json` (`3375f802606482a08665a5f1f0b5d9deb0dd909ad3aaf92f3566bd8e31601676`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/agent_outputs/source_contract.json` (`aa0eb60ff010ef5f052715d2623342afff3ffa5ecfeef26f777bf1244fe6847c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/decision.json` (`5f90ea8732b0657a9d7086db9ab3a851663b309cf59044123ffe3c97a6eb0d3c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/blind_dependency_inventory.json` (`588a7c23375930f4954425497165b1a48f315016604b037718df13e82a33256e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/blind_dossier.md` (`a9da7846ad9a9afb97fe975159b49a92879e8844095d4889827b3c5ef3b103ac`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/blind_review_packet.md` (`a9da7846ad9a9afb97fe975159b49a92879e8844095d4889827b3c5ef3b103ac`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/declaration_dossier.md` (`8d1e492a4a4b774e0f09458342001ff0bee7b897330d233ea40fe89adccca3b3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/dependency_inventory.json` (`6d98acce9280fd483f87d276bf39aa56e9a26dc020cf66382aec1938629fc02d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/direct_review_packet.md` (`105a4a96447c563c4dce85ba0b1897af0ce04713ed493e6f2694e468ba8bf360`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.1.3/faithfulness-current-v5/inputs/source_locator.json` (`ba8bf8c9ace5058a3a0cacb591e3ad630b1e6270ba231dab412d8a7bdf045b35`)
