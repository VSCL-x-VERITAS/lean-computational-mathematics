# Faithfulness audit: HDP-02-BODY-2.7-ORLICZ-BANACH

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `d3690510e217706e3aca27d8ca2b8291467e0d0c77b5cf666a82ad02fca75fbc`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target faithfully represents the source's Luxemburg-Orlicz Banach-space assertion. The immutable book context fixes random variables as real-valued and uses 'increasing' in the nondecreasing sense; normhood and Banachness make a.e. identification the intended identity convention. Pinned declarations confirm that AEEqFun is the quotient of a.e. strongly measurable functions by a.e. equality, the Luxemburg gauge is a.e.-invariant, the finite carrier and norm match the displayed formula, and CompleteSpace is instantiated with the uniformity induced by that gauge norm. Both implications hold and no uncertainty remains.

## Implications

- **Lean implies source:** `yes`. The Lean target states compatible real normed-space structure and completeness of the whole finite Luxemburg-gauge space of real random variables modulo a.e. equality, using the uniformity induced by the gauge norm; this is the source's Banach claim.
- **Source implies lean:** `yes`. Under the book's own real-valued, nondecreasing, and norm/Banach conventions, the source gives exactly the a.e.-quotient finite-gauge Banach space represented in Lean; the unused negative extension of ψ is semantically inert.

## Findings

- **note / a.e.-quotient representation:** This is the standard identity convention required for the source claim, not a restriction or strengthening.
- **note / Orlicz-function domain representation:** Negative-input values are unused, so the total-function encoding is equivalent.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `225` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `225` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/agent_outputs/adjudicator.json` (`c5ce0ae0c212ae75c1edaef306c0f29c40c85b48334c107705112758704534fa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/agent_outputs/agent_runs.json` (`2dce4fdb01272fcf6a1ec8852883468db1e3d1e53b508fe486cfdb5f7c136223`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/agent_outputs/blind_translation.json` (`79b7c205e15a4f1c91379b3793a0195511fd34f1baf693520d6084420a6f400e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/agent_outputs/direct_judge.json` (`1b91c7058de99403a5d087936eb40238153eb0930cb4d2e3e90807a76a7652b5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`21046b1cfcdc5ee2995b742c5033129735019ef2fc8282c23b377f2e0188402d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/agent_outputs/source_contract.json` (`e5e84ca7d23a303fcb6dbf4619a1b82248711f393899ba665651f86863d8844b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/decision.json` (`88271dbcd3276cbc38fb2c50a6b5a854a5929780ff2861eb6e4bef6e45dd21d4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`ea9f3eaa65aeec2ec1ceb96051e1c1449ac74d4bad4b231499d51e027b6293f6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/blind_dossier.md` (`24df5b6d0c79d1fad0da3e17d81c7132bb46b30c4c2e15a08269314ede6b1cc4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/blind_review_packet.md` (`24df5b6d0c79d1fad0da3e17d81c7132bb46b30c4c2e15a08269314ede6b1cc4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/declaration_dossier.md` (`72a30274213f9c2bf88e5a281125f1ef9f0f3d1f14c164ec8dae892bad436b85`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/dependency_inventory.json` (`94e76abdd1ac51bdcef7e3ff20aa9448085ab57dbf7410b7b4f01c496fa83c4c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/direct_review_packet.md` (`b8f231f8cce53ed9d69a4bc56df37392f60bdc9aa9c53e6ecddd9fe47a104f0c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-ORLICZ-BANACH/faithfulness-current-v1/inputs/source_locator.json` (`45fe86f08f0aa024978301c65e9dc92c3f0ba372c442201512596081f31c64ff`)
