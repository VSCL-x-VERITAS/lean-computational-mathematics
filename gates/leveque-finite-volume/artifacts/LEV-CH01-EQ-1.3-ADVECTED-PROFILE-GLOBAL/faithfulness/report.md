# Faithfulness audit: LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `cb9ccd90e0eec6fb9872497ebab4c91aa4bbbd78e3e13aeadfb300cfc9b96254`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The target preserves the global R-by-R domain, exact x-speed*t sign, arbitrary signed constant velocity, unchanged-profile identity, and the classical PDE under global differentiability. It does not add the uniqueness claim excluded by the source.

## Implications

- **Lean implies source:** `yes`. travelingWave unfolds to profile(x-speed*t); the global identity and Differentiable-implies-PDE conjunct give the source's unchanged-shape constant-speed solution on all R-by-R.
- **Source implies lean:** `yes`. The source states the same global translation formula and classical PDE consequence for arbitrary signed constant speed, which directly yields both Lean conjuncts.

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
| `N01` | `not-applicable` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `77` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `77` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/agent_outputs/agent_runs.json` (`2f3cc53c7897a4477161375eecc2eed9d512e8201e7aeacc5a415bab3bb1e853`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/agent_outputs/blind_translation.json` (`a56f710d0bc65fa9fd8388ceb6b39b9e12268c3b063757a4ff2972b3ae4784a7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/agent_outputs/direct_judge.json` (`24f44e1b6ec01236f53474ad77abb78e4e2adb2fdd576b4c2b9d6b6a211d5788`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/agent_outputs/roundtrip_judge.json` (`dd37b9f496e6b4c1392d46c0758592129cf302e8bbb09b9682f3bd1f6940c948`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/agent_outputs/source_contract.json` (`79ad0434b335095e61589473a0ea0c9ca533495e330005a033b67cb318ac4206`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/decision.json` (`a6f1ce18048604d195c40825ba17736cdef7d73958b24d4e277a855cb8801f86`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/blind_dependency_inventory.json` (`3d4530bedb1eca9371256dd2eb5569c4fcb38206192c44ac4e6cef0445802b47`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/blind_dossier.md` (`24402ee511e3b1af813547197a449cfbfd9e8189b46c7f199afca6f311f04043`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/blind_review_packet.md` (`24402ee511e3b1af813547197a449cfbfd9e8189b46c7f199afca6f311f04043`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/declaration_dossier.md` (`135a25ef297cc8eb64af84e12ff11744b5f56d689b2df0d9a3244a55bd555cba`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/dependency_inventory.json` (`22547c1de5cc781f8932949f80f59a52e6a18f3a8513c54ea9e8ebb183e93531`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/direct_review_packet.md` (`74447308197e7da8c3997f30ac79aba6a5a9f5ca80a5b32b37edb1b8d830938a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/history/20260831T235844Z/inputs/source_locator.json` (`eaa538615c7ce637ecde5e4ae89e5a21aed6dbbac09d4b5c73732b597a81f3fe`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/blind_dependency_inventory.json` (`14d8bd39eed736ff6aae8716fe9403b21e74e076cbcecb93519f764283c47a39`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/blind_dossier.md` (`16d8849e70f289723a9dbf90e0540c700aebe4b07f42979c5cf5ec2f159a9632`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/blind_review_packet.md` (`16d8849e70f289723a9dbf90e0540c700aebe4b07f42979c5cf5ec2f159a9632`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/declaration_dossier.md` (`4693420aab2d054741f8cfabffd48cbdd4f785e49b511a1b2040310df5066811`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/dependency_inventory.json` (`47c8c7bd7c9383eac12284e995053c559315b0efbf6960698b501b1568aaf2c8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/direct_review_packet.md` (`2ad341ecfe707169cd5c67e99e465f94083c5f2ae8b7aac5d05f62432727aa59`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL/faithfulness/inputs/source_locator.json` (`eaa538615c7ce637ecde5e4ae89e5a21aed6dbbac09d4b5c73732b597a81f3fe`)
