# Faithfulness audit: LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `630753cfa5ccdf0ee3a0e62a456b07da1193dc195009b7e7ab68bafed5c27152`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The complete proof-free target expresses exactly that every real one-by-one coefficient matrix is hyperbolic in the source's real-eigenvalue and complete-eigenvector sense. The source explicitly defines PDE hyperbolicity through this matrix condition, so a separate solution binder is unnecessary. The scalar matrix encoding preserves every real coefficient, including zero and negative values, and the basis condition is nonvacuous.

## Implications

- **Lean implies source:** `yes`. For any real scalar A in the source's constant-coefficient one-component equation, instantiate speed with A. D001 identifies the resulting coefficient as [A]. D002–D003 provide a real eigenvalue family and a basis satisfying exact matrix eigenvector equations. In dimension one this is precisely one independent real eigenvector, hence the criterion defining hyperbolicity on raw PDF p.25. Thus the selected assertion on raw p.23 follows.
- **Source implies lean:** `yes`. Given any speed : Real, form the source's scalar constant-coefficient system with A = speed. The selected raw p.23 assertion makes it hyperbolic. The raw p.25 definition supplies real eigenvalues and a complete independent eigenvector family; its stated unique-coordinate property supplies the basis representation used by Lean. Identifying the one-dimensional space with Fin 1 → Real and the scalar coefficient with [speed] gives exactly D003 and therefore the target.

## Findings

No findings were recorded.

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

- Blind translator covered `34` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `34` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`1c533ed7aa8e8220784a7e5c3b88cffacf07e54b4f83e27685da69adb6bdc0e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`e7cd3db703e11dfb154f144ab54ef2df7b7fc94e7dfc13ac00eec70f8b1b9d7e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`5ce671ff44511318915277d3f2cddbe96ff45e57469d961fc106eb303d00674d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`081ec883bdaaeb15e158b072464d607f3279cff689feb0eaf61201e297cc8666`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`1d79a3fa8aacc9ad922a0bfb27c12e8f8576c09703a7c1deed227ab4f52bce2f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/decision.json` (`9719d0aeae305ae229a3f366424912f29349bc68d457e982aee268707b1e36c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`13a9810a9a0f6e5d943de01517a9bcc4623f582975c64c61a4f9043d0ab27b43`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`648d7ef2bcebb27800c7b4c179a66be67496850cc6d9f119898515657889d839`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`648d7ef2bcebb27800c7b4c179a66be67496850cc6d9f119898515657889d839`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`4e064a9ba57184e39b81dfc244c3979070a8b7eee9240d9d62f7d9f70b631a03`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`5adf5707a82f628fc391a4754887ae716bbf16307bca60a35dba83b2e15bb8b0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`47cc7eb7661e0cbc315249312e1111eaf9e8a7376512fe79f314fe23f4d86439`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`9d6725256ac79a66d401abd56c994c8e8586b9c0c99455be2696bd8c712b6172`)
