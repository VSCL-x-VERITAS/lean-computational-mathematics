# Faithfulness audit: HDP-01-THM-JENSEN

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `54d2ea7e1bcb0d8d74654efcdd10691437ca698172ac2b64c6b055481443accb`
- Source SHA-256: `855fdaf6870f664f1e470d47641b6d72758afdb9b87649a6494b027cecc02b17`

The five blind uncertainties are resolved from the pinned Lean environment: the target uses a genuine measurable space, countably additive measure, probability normalization, real numbers, and the Bochner integral; none introduces an additional mismatch. The conclusion, object roles, global convexity, composition order, inequality direction, and probability-space semantics match the source, and the premises are nonvacuous. The decisive discrepancy is domain: hX and hφX restrict the target to finite integrable cases, while the printed result quantifies over any random variable without selecting those restrictions. Applying the protocol's reduced-applicability rule gives Lean⇒source no, source⇒Lean yes, classification not-faithful-weaker, and accepted=false.

## Implications

- **Lean implies source:** `no`. The Lean proposition yields Jensen only for the subclass where X and φ∘X are both integrable. It gives no conclusion for the additional cases included by the source's literal 'any random variable' quantifier, so it does not imply the full printed claim.
- **Source implies lean:** `yes`. Specializing the source's universal claim to X and φ∘X satisfying the target's integrability premises gives the Lean conclusion. D001 and D029 then denote the same finite real Lebesgue expectations, D005 gives global real convexity, and D009 supplies the same probability-space normalization.

## Findings

- **major / reduced-applicability-integrability:** The target omits source-stated cases outside the finite-integral domain; added hypotheses make it less applicable and therefore not-faithful-weaker.
- **note / source-well-definedness:** The source is analytically underspecified. The target makes one valid finite-real choice, but that choice must be recorded as a restriction rather than silently treated as an explicit source hypothesis.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `fail` | `fail` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `not-applicable` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `fail` | `fail` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `33` dependencies (`0` hash-reused); unclear: `D007, D009, D010, D015, D029`.
- Direct judge covered `33` dependencies (`0` hash-reused); failing or unclear: `D008`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/adjudicator.json` (`891a27a73f9990cc19a93ada104e0ceeaec74fbd08fb9b24fd5f9963aeaa534d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/agent_runs.json` (`37423191d3664a21fd8b1166e4006d81d94af2a8cdc08ea1dd767b7de3013c50`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/blind_translation.json` (`7c1709453873f961fda350da69a8de9a6c6d9a37f467f9dfd5f11669b06a3fae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/direct_judge.json` (`06168bb7e44efa188797119d0c7574137f464fc17abfab74a112f350e8bbc5ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/roundtrip_judge.json` (`ae71a5fc9a30b5a9ef450d0971fa83a5c1c6c7abeca45290270b4d751f5b8acf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/source_contract.json` (`03a40db76475306cfedf9b6da9dc946cf7607897d35fb1378a42137fdd251f45`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/decision.json` (`4d827116f81cb626dd465cd4beaf760d0318b3a2af05f2605c7594c8bb961a1c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/blind_dependency_inventory.json` (`5dd511fa4ceb15ddf3627a5acbfa74c7b97d3555e8abbfc8d1223bb697586208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/blind_dossier.md` (`786f6dfe70fa8262098b0f772b3d6bedef57944cd80db889e7f39e3ab833c535`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/blind_review_packet.md` (`786f6dfe70fa8262098b0f772b3d6bedef57944cd80db889e7f39e3ab833c535`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/declaration_dossier.md` (`c924f5d088aa77156292d26aebd850230d9f3b8f01996171f7ef7c10df2b18ea`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/dependency_inventory.json` (`098e002fce24de3a5ba0ab00c4a025b0385c77404429e21d869dfe1749d3859d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/direct_review_packet.md` (`bb2c56d93aa2459cff9eaf63c8f1df2ff47db2a19f46a4b1ffbde02c930c3d27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/source_locator.json` (`3bb5f0e81fff650e811ec3c8e0644cf6222d8e3d7be302fc9fd406e3af956d9c`)
