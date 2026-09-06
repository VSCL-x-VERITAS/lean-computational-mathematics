# Faithfulness audit: LEV-CH01-ACOUSTICS-LEFT-MODE

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `7cf0e7f193f7825eaceb8c9b1febc9b45fca8975568e8209f130d43b44e5d91b`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

All signs, coefficients, quantifiers, and object roles agree. Lean makes the source profile sentence precise without claiming that every analytic solution has this form, and it exposes only the technical positivity and differentiability assumptions already implicit in the passage.

## Implications

- **Lean implies source:** `yes`. Expanding the local definitions gives w^2=p-rho*c*u and w^2_t+(-c)w^2_x=0, i.e. w^2_t-c*w^2_x=0. The travelingWave identity reduces to profile(x+ct), and c>0 supplies the left-going interpretation.
- **Source implies lean:** `yes`. The source acoustics equations and c^2=K/rho give the Lean invariant PDE at every point. Its stated profile family, under the explicit local differentiability premise, gives exactly the Lean travelingWave clause and x+ct identity; the added positivity and regularity are the source physical/PDE context made formal.

## Findings

- **note / profile-notation:** The formalization resolves the source notation switch while preserving the substantive profile dependence and direction.
- **note / source-notation:** Sign, coordinate, and direction are preserved, so the switch has no logical effect.

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
| `N01` | `pass` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `109` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `109` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/agent_outputs/agent_runs.json` (`75e138516a91568cd5350e2057802932ca90b3253e39e886435b321e2753fe8d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/agent_outputs/batch_source_contract.json` (`d0fd4bc8d51f4e43a915edd501472b75abc7eb59c4c22ba8049da4ed8c452133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/agent_outputs/blind_translation.json` (`89974b83ae003851bc7825c36c2769d4c95bda0d2f0ace1a0f289a60be91abd6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/agent_outputs/direct_judge.json` (`85333fd5259c25937cbe2881b8d0af4ee094d22e1805ba16fa7b5a9549d356be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/agent_outputs/roundtrip_judge.json` (`4907da9594860bae41ccaccec7e25e751b17c298028f16ff180c762607fcd789`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/agent_outputs/source_contract.json` (`04d3334a57098ae54487de6afc00a0c57e621f58b96ab5eea0fa4a2088d926b5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/decision.json` (`1d35af49a5c2787b83654dc5a29cce8720691e71434012bfc6a5614c6404f4b8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/agent_outputs/agent_runs.json` (`5d11f563a2bf8227a85fcc1c2bd0051c3127e48fbd27c5a72c48fe4cffee42c0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/agent_outputs/batch_source_contract.json` (`d8fdc23104f3a4ce44add59aa66515c36255136ffeac295b5f757fb7be5f1438`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/agent_outputs/blind_translation.json` (`98b4373d8bd398ceefa55a17f03350b4b0d69a224d5ce1beb90e971bf191331c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/agent_outputs/direct_judge.json` (`fea5c3a73ac4d4facf8bb37b2aa8f35b531d0b31b1727505f46c20d4748b38d8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/agent_outputs/source_contract.json` (`daca6bf3148741dba5c2daa2bcd7571c98830efcd76e81b46973c823feab4866`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/blind_dependency_inventory.json` (`5485a9b68ec3acbe8d6e92267fe8223e04d1ff382dd574a05911b7ef35c49e51`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/blind_dossier.md` (`52915b595cb0dcb4accf1b224828475a4c4f1f6e84de2ca22144170dc2103feb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/blind_review_packet.md` (`52915b595cb0dcb4accf1b224828475a4c4f1f6e84de2ca22144170dc2103feb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/declaration_dossier.md` (`aa27683ca4e707dd60d9c7d30b3964ee4c617c88b52994f14b24098ce3b4b029`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/dependency_inventory.json` (`9a7a7b8cfa4488eb9647c7318daae868f3dfc855af7eccd22fa1793b2367876a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/direct_review_packet.md` (`6ea19bf785f19d00e0af21f8096cce9146fa9e9d4ebde5c7ec7bbcaccfeb2275`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/history/20260901T052416Z/inputs/source_locator.json` (`6cf63ae494f4247f20acd10c8761bdef229040aab4c1a9fac9be1b32517b4471`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/blind_dependency_inventory.json` (`640f92d4fc6da181c17170d7bbd35e12fb07ff3fa5d2894c0b791a4b6de1703a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/blind_dossier.md` (`a4dc871a0f68c6f2fc1d8a08322908fb0100fd59a9e923de72637520262924be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/blind_review_packet.md` (`a4dc871a0f68c6f2fc1d8a08322908fb0100fd59a9e923de72637520262924be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/declaration_dossier.md` (`c40914b4e7066e6aba1e62e527578e9767ade0bf25435166a68d5c421d735e0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/dependency_inventory.json` (`d37a99bcd89de84b9c93780bc70c965f7d2ae11c04cc55179e0044755b20306e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/direct_review_packet.md` (`dfb5781a14dffb749b75723d8058826c73c875f57be18f17159995cc6c8b1e87`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-LEFT-MODE/faithfulness/inputs/source_locator.json` (`6cf63ae494f4247f20acd10c8761bdef229040aab4c1a9fac9be1b32517b4471`)
