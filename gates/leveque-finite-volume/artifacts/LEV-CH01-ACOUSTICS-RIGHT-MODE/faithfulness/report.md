# Faithfulness audit: LEV-CH01-ACOUSTICS-RIGHT-MODE

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `7cf0e7f193f7825eaceb8c9b1febc9b45fca8975568e8209f130d43b44e5d91b`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The formal proposition preserves the right-mode combination, transport sign, sound-speed formula, domain, and pointwise scope exactly. Neither direction introduces or omits a substantive source claim.

## Implications

- **Lean implies source:** `yes`. By the supplied definitions, Lean states exactly w^1=p+rho*c*u and w^1_t+c*w^1_x=0 for c=sqrt(K/rho), while the explicit c>0 conjunct gives the source right-going speed interpretation.
- **Source implies lean:** `yes`. The source equations (1.5), the definition w^1=p+rho*c*u, and c^2=K/rho yield the pointwise Lean advection identity. The Lean positivity and regularity packaging merely formalizes the source physical and PDE context.

## Findings

- **note / explicit-physical-context:** These are faithful technical side conditions and do not narrow the intended physical setting.

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

- Blind translator covered `94` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `94` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/agent_outputs/agent_runs.json` (`cd6d489060b880831a2291b29b652986fbfe0fe9c1af9e3e3dcdb8a549b8043f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/agent_outputs/batch_source_contract.json` (`d0fd4bc8d51f4e43a915edd501472b75abc7eb59c4c22ba8049da4ed8c452133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/agent_outputs/blind_translation.json` (`56eaf5c3e6ba4f8deaacfaaa1251efc9bafcf7ca7ce4db3934b46eb0bdb15e3c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/agent_outputs/direct_judge.json` (`e79370c54d7612b62737c3b797223fd3220024e73983f553f8746c6cafacc670`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/agent_outputs/roundtrip_judge.json` (`08867cb2951f8a71559a808a15fcc7429ed70aaa5d5d8c840e3b64c2d6b6a626`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/agent_outputs/source_contract.json` (`e6a8d298ad64a4dd7782db81d324913892a79cd22b4ddd2dbcc6d2a44b54ca0a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/decision.json` (`2d4f43b540fbc3d767feace9beff0e961758aede25de97a918c99c4e83611150`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/agent_outputs/agent_runs.json` (`35772c094b563b7fd2df9cf997926ad136afe302fe3ff522da16b0cd5d89e0ae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/agent_outputs/batch_source_contract.json` (`d8fdc23104f3a4ce44add59aa66515c36255136ffeac295b5f757fb7be5f1438`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/agent_outputs/blind_translation.json` (`f39073a995d151ac76f949e28ed7f4015badfbdfe22de521c91cd0de49056bef`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/agent_outputs/direct_judge.json` (`5fffe91aae2a0811dea85b4138ebc90b9c55f5f0fc62aa1c643e5a0d1038bc4b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/agent_outputs/source_contract.json` (`56d43903da2b15229d59c29e887124bd5f13010c933b75b5083eb26976304ccd`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/blind_dependency_inventory.json` (`c580571a1800e551ec2dce1100a4a5bccc2c5d7634b3b7b2f80c506ffed6eadf`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/blind_dossier.md` (`cc39d48ed5cb46cc621960bce13951d949ce83fed1a9428675b3699cf04c3db2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/blind_review_packet.md` (`cc39d48ed5cb46cc621960bce13951d949ce83fed1a9428675b3699cf04c3db2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/declaration_dossier.md` (`9917338df0094b8687e30c744b0efec16f542f59282300d8ca7a568897d3aea3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/dependency_inventory.json` (`ae89dbf9bd67314b54590478687b2b2d5412a6206dd16318b9079ae06f443c8e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/direct_review_packet.md` (`90653618de6424a164108dd913fa99964de9008681be1eba5bec6d709f0769ed`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/history/20260901T052402Z/inputs/source_locator.json` (`002c42d94438a265a5ea6b6be5520236e57ff221e57c171e18ecb7ca12fabdd8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/blind_dependency_inventory.json` (`c580571a1800e551ec2dce1100a4a5bccc2c5d7634b3b7b2f80c506ffed6eadf`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/blind_dossier.md` (`cc39d48ed5cb46cc621960bce13951d949ce83fed1a9428675b3699cf04c3db2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/blind_review_packet.md` (`cc39d48ed5cb46cc621960bce13951d949ce83fed1a9428675b3699cf04c3db2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/declaration_dossier.md` (`9917338df0094b8687e30c744b0efec16f542f59282300d8ca7a568897d3aea3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/dependency_inventory.json` (`ae89dbf9bd67314b54590478687b2b2d5412a6206dd16318b9079ae06f443c8e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/direct_review_packet.md` (`90653618de6424a164108dd913fa99964de9008681be1eba5bec6d709f0769ed`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-RIGHT-MODE/faithfulness/inputs/source_locator.json` (`002c42d94438a265a5ea6b6be5520236e57ff221e57c171e18ecb7ca12fabdd8`)
