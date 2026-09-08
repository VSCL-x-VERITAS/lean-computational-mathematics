# Faithfulness audit: LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `fe036a5e4d740495a4c575eb283e1adb1103218ad9f7a49033b862a63f93e370`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the four attached primary-source pages and all supplied dependencies shows that the target preserves the real domain, both acoustic components, their order, constant coefficients, genuine partial derivatives, and the flux (Ku,p/ρ). Nonzero density is the reciprocal's implicit source domain, and the premises admit nonconstant solutions. The differential conservation-form assertion is equivalent to the selected source claim in its classical mathematical context. The only reuse-numbering discrepancy is resolved by the exact inline declaration body; no semantic uncertainty remains.

## Implications

- **Lean implies source:** `yes`. For any classical acoustic solution with constant K and nonzero ρ, instantiate the theorem at each x,t. Expanding the supplied state, matrix, flux, and conservation predicate gives ∂t(p,u) + ∂x(Ku,ρ⁻¹p) = (0,0). These are the pressure and velocity conservation equations obtained from (1.6), (1.8), and f(q) = Aq. This establishes the selected mathematical conservation-form observation. It neither asserts exact physical conservation nor claims an integral identity from a single pointwise hypothesis.
- **Source implies lean:** `yes`. The source's acoustic equations (1.5), matrix (1.6), and constant linear flux explanation identify the same local rewriting. For the derivative witnesses required by D007, ordinary differentiation of constant multiples yields time derivative (pt,ut) of the state and spatial derivative (Kux,ρ⁻¹px) of its flux. Both components of their sum vanish by (1.5), providing exactly D006. The explicit nonzero density premise reflects the ordinary reciprocal domain, and the derivative witnesses make the classical notation precise.

## Findings

- **note / reuse-local-id-reference:** The inline declaration resolves the numbering discrepancy completely. The current target's premise is the acoustic predicate, not the conservation predicate, and the assessment does not treat the implication as a tautological abbreviation.
- **note / scope-of-conservation-form:** Acceptance concerns the selected mathematical conservation-form assertion. The target does not separately formalize endpoint integral identities or the qualitative accuracy of the physical approximation.

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
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `88` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `88` dependencies (`19` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`d0b4cda8ec3ae387ad80e99aa8592770ae14ef85e6358f8a68a2f3dacc3b1bad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`56c2b60aefdcaddba8d03b8fa77c5bd54c90b15df0d472c94eaa5789a24b2267`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`edc3d9cf9d6a037c92c7b22b836e009b45c717ea371e38059bfccd837228f567`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`e061ebb8236cc4b5d0bd82db1a065992da45703e7db88781e75c2059a32f5f0a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`23d29ea8765dd91d71f3e0bac3ffd2e012d1c22040bcf817fb7c9a6d46634274`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/decision.json` (`c02c795c1558de1ed8e5201175ea7767c171e71a7fd01f1554dbd8d47a09a702`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`7bdc1289d5ce9962eb87c9f248b50c9ea59ea1b42d70d7f4d691455ac5c1bac3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`9feafa1fe1b6725caa35d05788282b51e3143461fc2fe35642ec32a0c9a10f78`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`9feafa1fe1b6725caa35d05788282b51e3143461fc2fe35642ec32a0c9a10f78`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`c9a28b0d786172d27dfc49af4f4d89aa2731408cf5b3d979ea4024455cf5cb20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`f9e48a4935cf80b87329c983a7c5f1ff6046a52a5ea1f471b099c355af267841`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`e210bd73710264245f0afb1a5b9b0e7beef90bd85700fc497764d89857e3d885`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`c3733e8f329ed3a66abfdd73ddcd4bb85de1cd8e35780e267f22724a1514b793`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`af3b303450b1549b7fafc3a7242b3d62441c0682ae4b13c9470fd9039f3f111e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`3691602a2e6c85aa1e2dbdc31dd130f9d62b4b1cf4f824fca129f9fbf006780f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`3b6e244e913adb1548846f14729d1a7c5f5b8fe312b32b2a2fbcebd545bc0dd7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`56c2b60aefdcaddba8d03b8fa77c5bd54c90b15df0d472c94eaa5789a24b2267`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`c6a479ff7e7429074b485607097b4d73b4e72716a76acf2abf0339eb5fcac4b4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`6f985e18d9e8c1ed1de93afb674a3f29619a3d4aedc6d7efcffe5cfa8b51573f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`b0e977292746ad3748be79581414c52dd7c4e28c10612264685b37916b9997d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`6f0c1761dc78d653ae65c114ba3bd3ccf73cd2a31a4c31f87c0d512f9d1604c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`47b75c9ca3ca32130e9d16ddec023bf22fde03b33a55156f051c32ac27467113`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`edc3d9cf9d6a037c92c7b22b836e009b45c717ea371e38059bfccd837228f567`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`2bd348f1910e93472358c05608d0e3cd5ccf3420eaa9c0913269f2be3da86ddd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`07e2ccefe5fca97ed7cda62c65cdae322386e042b301e33dd3c3524d8a4dcf3d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`610459b930832bddf37ad7d45f3a6465dcfb04b4cfb67a168ec3e3ad2de67b68`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`2c5b39db26b5fa6f5398490d0368e3318a335b7eaddcc2e47a6cb8caab34d8cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`9a4b27e8430a957527ad2b7a21861f0345a26ed60e8b9f5d2329882e0b95f948`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`e061ebb8236cc4b5d0bd82db1a065992da45703e7db88781e75c2059a32f5f0a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`ffb3db71de277bd432f584ec48c67574a03152288ad9be63b39aca9e08da5f05`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`9a7dd41e319eb662f86ac4de4b342c692eb5c1790e5efbfebcd4b78ff09177bb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`c53c05349e26ca28f418779a9409a66ba3a9f18f83eedba676c4201a732e6ae3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`c4d8e4460b8c95b5f58366b8642ea8eafeac6edce540ba1eb97fafccff2002d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`acf5c5f3d54d4dd82092a747340ae046a6f64a4343257f06d52c82fdc86ccd87`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`23d29ea8765dd91d71f3e0bac3ffd2e012d1c22040bcf817fb7c9a6d46634274`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`4c84667830ee64ca22e22d0c46b571b3040a1804376fdeea03baa08345aa1d68`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`ca2afe498ea883950f04b0e8e4aa7cf8f9d27d4e4676796eb629a12ee9505025`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`24c06feebcd04377bf5884da21382a0745e7053de52738e404cf00f2935f7b92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-CONSERVATION-FORM-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`8d6f0e0ecb0815c4e8d550e56453d9405ba65ec0a5a7bf931fcbdcf842535c02`)
