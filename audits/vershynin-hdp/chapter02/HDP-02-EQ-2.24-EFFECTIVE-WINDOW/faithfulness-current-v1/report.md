# Faithfulness audit: HDP-02-EQ-2.24-EFFECTIVE-WINDOW

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `fcbd4da9570c6dd982c281fd060b0741a3046b86f8669f2fa3637a5265bcf4b8`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Adjudication was confined to the authorized sealed statement-level artifacts and did not inspect Contract.lean, any target proof, the gate, or a prior audit. The source contract deliberately preserves the omission at K = 0 instead of imposing a division convention. The target resolves that omission through the product inequality. This formulation exactly preserves Equation (2.24) for K > 0 and extends it at K = 0 to a genuine, nonvacuous conclusion. Because the extension neither weakens the hypotheses nor loses any source case, it is properly classified and accepted as faithful-stronger. The implication verdicts are therefore Lean-to-source yes and source-to-Lean no.

## Implications

- **Lean implies source:** `yes`. For every source case in which K > 0, |λ|K ≤ c is equivalent to |λ| ≤ c/K, and the target supplies the same componentwise MGF inequality with the same universal constants and individual psi-one scales. The additional K = 0 branch removes no source case.
- **Source implies lean:** `no`. The selected source passage leaves c/K undefined at K = 0 and supplies neither a convention nor a separate degenerate-family conclusion. The target's product window is defined there and requires the integrability and MGF estimate for every real λ, so the full target contains a genuine additional branch.

## Findings

- **minor / zero-maximum extension:** The target adds a valid and satisfiable degenerate-family case, making it stronger than the selected source claim while remaining acceptable.
- **note / positive-domain equivalence:** There is no discrepancy in constants, boundary inclusion, parameter range, or applicability on the source's well-defined effective domain.

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
| `C11` | `fail` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `84` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `84` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The source's intended convention for the zero-maximum quotient remains unstated; it could have intended an infinite-radius convention or tacitly restricted Equation (2.24) to K > 0. This authorial ambiguity does not alter the literal audit classification.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/agent_outputs/adjudicator.json` (`30c800da95697eefb9fceae3c45c46fc47dc1ab72df7fb6f0e591a308acb23a5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/agent_outputs/agent_runs.json` (`9eca736f5a2c73ab336767b8d3c50ff3f738b251b87565d6a4a3cd9f08073133`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/agent_outputs/blind_translation.json` (`6e293d891fd14c7a73f52fd6c76704d00d48e7e3c5a3b7fdbcc6284549500f50`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/agent_outputs/direct_judge.json` (`e4ceefec3db006945c54a11b01bd643505b84dfee978731a089ffecb0e465b02`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`3da5861a79b09d41fbc7241195fb7be83dfb9a0792c7a94db8e1a809269c7eac`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/agent_outputs/source_contract.json` (`21f3c25d6abbe171f619eb487006902ebf7de6a76103102c4543c3fd66f39f87`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/decision.json` (`1a39663318833c7b25c0c996dad74c342ea6f85b0c7be26a9919526bc7d45496`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`09a9e6e9cb1816ad8298b45b1d9899925cf011e828e9930f2142e5e374a7c381`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/blind_dossier.md` (`9577f658aac4532771fbd99a7065068c6fd61524929e775cd905552f7542d314`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/blind_review_packet.md` (`9577f658aac4532771fbd99a7065068c6fd61524929e775cd905552f7542d314`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/declaration_dossier.md` (`3c3b222319699161f3d4ae597fdaaf556082027aec2549b313acf4f44b315dc0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/dependency_inventory.json` (`e37aa8efd29d50ae92dd430b42ee287583b51c2cc9ae4c88652995aa465e7159`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/direct_review_packet.md` (`f197d7e793ce3bab8020a1c9388f36eb0f9172f4f226934bf25d49438b527621`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24-EFFECTIVE-WINDOW/faithfulness-current-v1/inputs/source_locator.json` (`c67ceaefc28e82133ffca7d697e56066ea61e8e871534d9d9daba15abccd3d35`)
