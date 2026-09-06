# Faithfulness audit: LEV-CH01-EQ-1.11-RIEMANN-DATA

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `4d1c8cd725a0868619ef46473408fe45d3b1abd2ec358e6766226ae0421335d3`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The strict inequalities, constant half-line states, interface location zero, and intentionally free value at the origin exactly match equation (1.11). The target concerns the initial spatial data only and adds no time-dependent or uniqueness assertion.

## Implications

- **Lean implies source:** `yes`. The existential origin value and piecewise riemannData expansion give q_l on x<0, q_r on x>0, and no prescribed x=0 value.
- **Source implies lean:** `yes`. Any source Riemann initial datum determines an arbitrary value at x=0 and therefore equals the Lean piecewise function; conversely the strict branches satisfy IsRiemannData.

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
| `N06` | `pass` | `not-applicable` |

## Dependency coverage

- Blind translator covered `17` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `17` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/agent_outputs/agent_runs.json` (`f3219c77713399a86356cbc19bad63179480fc8c1a9424250c8dae8243b390f0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/agent_outputs/batch_source_contract.json` (`7b946c2a9794a673acc69e1d657a4e46f99d38880d0bf9cd1652eb49ee59a332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/agent_outputs/blind_translation.json` (`7493d8c72d8b7dec90471572c636122111f36cfa19c81232558cd308a2b03223`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/agent_outputs/direct_judge.json` (`b2f41d1d0489e03ccc8af0a77cd17bc17c1e6f503270de527f38dabe438486f0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/agent_outputs/roundtrip_judge.json` (`8686a492e5cee2d9c2db15da489578f7b3138b8a1d450d2dfa71f923ed8239a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/agent_outputs/source_contract.json` (`92fd1883fcbb25152f20a6eb2199d1a6b4f713e49dfd712d3e230ac2c9ed7311`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/decision.json` (`074010cf77f464f81f7cd153e0ca3763ae884d3e77330228aff6d735e0ec2fe6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/batch_source_locator.json` (`0b272037292776c34f1e8ce621cd97c98da8f329dfed4995fa0bb0b41b55aa6f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/blind_dependency_inventory.json` (`214d86e3b800fb5177afcd35b781209d92507c8ab7d9b23cc742c89b4078e783`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/blind_dossier.md` (`35048d4283c0b4a0ba1bea1caa4b28d8c22a9dc82a06ae73521bd74921e344d7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/blind_review_packet.md` (`35048d4283c0b4a0ba1bea1caa4b28d8c22a9dc82a06ae73521bd74921e344d7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/declaration_dossier.md` (`67ec547dee8387f923aef649342e07e51aa1fa282479bbed1d2f32017f848fcb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/dependency_inventory.json` (`f8e18d2feb49b59b863867a8f880492a7dfd8517b2bf1b8ef33593ba74bfe401`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/direct_review_packet.md` (`3901a9a39cf93fc3de5dfec2527faa06cd40461cf77edad6347a8fa078e4e50e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.11-RIEMANN-DATA/faithfulness/inputs/source_locator.json` (`d46e11d7332930fa7b8c8aa14fde03b4b55900ddfdb62679c8bf56e8965a16ab`)
