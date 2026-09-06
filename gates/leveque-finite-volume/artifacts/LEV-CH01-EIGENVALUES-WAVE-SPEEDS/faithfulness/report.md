# Faithfulness audit: LEV-CH01-EIGENVALUES-WAVE-SPEEDS

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `69f5c28e063cfb315e18bd3af4d095db0f650b3a2aabf54445a017664cf8c0c2`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The theorem entails the source case by instantiation at each nonzero eigenbasis vector of a real-hyperbolic matrix and uses the signed eigenvalue as the translation speed. It is genuinely stronger in applicability because it proves the eigenmode fact for any matrix possessing the supplied real eigenpair, without requiring a complete real eigenbasis or global hyperbolicity.

## Implications

- **Lean implies source:** `yes`. For every source eigenbasis pair A*r=lambda*r, instantiate speed=lambda; the target produces profile(x-lambda*t)r satisfying q_t+A*q_x=0, so lambda is the signed component-wave speed.
- **Source implies lean:** `no`. No: the source asserts the correspondence only for a hyperbolic system with a complete real eigenbasis, while Lean proves it for any matrix with the supplied real eigenpair.

## Findings

- **note / genuine-generalization:** The source case is retained, while matrices outside the source's hyperbolic class are also covered; this is faithful-stronger.
- **note / individual-eigenpair-generalization:** It proves the same pure-wave correspondence for individual eigenpairs even when A lacks a complete eigenbasis, a genuine broader domain.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `fail` |

## Dependency coverage

- Blind translator covered `86` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `86` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/agent_outputs/agent_runs.json` (`22aa1926c11241906795a41a4805788d277773a7b15750e2ac03a5a9f52e6258`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/agent_outputs/batch_source_contract.json` (`9e413b94ea29256e073a250007b0a042f7e737213640885c4923d69c980c3d60`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/agent_outputs/blind_translation.json` (`a35fc2d8337ef86ce17cf5af74366ee09af8093c67f9a3912b6a8e086c968a73`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/agent_outputs/direct_judge.json` (`609e09678ed994a66cf0434855c0a798bd0e4d6da2d2665d0fc1357be33ff327`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/agent_outputs/roundtrip_judge.json` (`0d3f8c94ae25f9ed513d65a54033c4d004dcb43d95d3f782408746d2b08c2412`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/agent_outputs/source_contract.json` (`c446777d9d9dc46ef15c8edbd4b4d8c0883a46e42e5d39a59cf36ca59b39788a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/decision.json` (`e33be587c33aed0000239867fdcc7ad271ae4cd696d82fa06eba0857768bb5ac`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/batch_source_locator.json` (`79a737fbd4b0a821455699cb8df35ea628df150c4f6c0df283f0b35bc580a730`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/blind_dependency_inventory.json` (`531958ac361b82361b4e4f8fac2875c8129b4e436a3e9524cea04fcf4c0dbc31`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/blind_dossier.md` (`3a528ab6955ba8af8ef64b05770ec233d9d8a577b28f9738f4548d4ce7b2c3b9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/blind_review_packet.md` (`3a528ab6955ba8af8ef64b05770ec233d9d8a577b28f9738f4548d4ce7b2c3b9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/declaration_dossier.md` (`6c888418e91ef1842e098b20238eaee485d027e1e7623968a06d2405b340b074`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/dependency_inventory.json` (`4d7c2035e7ce1301996b386934dd43522c6b7174c280fbc8734886a62283b996`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/direct_review_packet.md` (`1c73a8feaa5cd9b11c9b7ea3abdf12f350dc3787de0f6352bf9087c944b61930`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENVALUES-WAVE-SPEEDS/faithfulness/inputs/source_locator.json` (`af5b62532b756077b49bd3ab8442c6194466473159eda6cfb7aceefe1dca8055`)
