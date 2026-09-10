# Faithfulness audit: HDP-02-EX-2.4.4

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `e74ddb8d38eda060d6b675bcb2af20e37d2bfe4f54929cbb5b5aa19c5f8fc425`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The proof-free target faithfully formalizes the selected exercise. It quantifies an n-dependent edge-probability sequence in [0,1], uses the correct Erdős–Rényi graph law and ordinary degree, ties the integral natural threshold exactly to 10(n-1)p, expresses d=o(log n) equivalently through k/log n tending to zero, and asserts eventual probability at least 9/10 for existence of a vertex of exactly that degree. The finite-index behavior of natural subtraction and Real.log is immaterial under atTop, and the source's proof hint is not promoted to a hypothesis.

## Implications

- **Lean implies source:** `yes`. The model definitions give G(n,p(n)) and ordinary degree; hrel makes the natural threshold exactly 10d with d=(n-1)p; hsmall is equivalent under hrel to d=o(log n); and the conclusion gives, for all sufficiently large n, probability at least 0.9 of an exactly degree-10d vertex.
- **Source implies lean:** `yes`. For any source parameter family satisfying d=o(log n) and integral 10d, take k(n)=10d(n). Then k is Nat-valued, hrel holds, k/log n tends to zero, and the source's explicit eventual probability-0.9 conclusion is exactly the Lean event. Finite initial-index conventions do not affect the atTop proposition.

## Findings

- **note / with-high-probability wording:** The parenthetical expressly authorizes 0.9, so the translation faithfully captures the selected concrete claim. It does not separately assert the conventionally stronger convergence-to-one formulation.

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

## Dependency coverage

- Blind translator covered `61` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `61` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/agent_outputs/agent_runs.json` (`1782bcf72a1b84556525180af50825d0717e4d4ab98c6e4559425b9630673ca5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/agent_outputs/blind_translation.json` (`f8e5774079e985d890c3481765baa3d473cfb6d168f7f0b277fa8872cff029f5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/agent_outputs/direct_judge.json` (`80baf4e5fac8e2a461490de3f764c17de4e3245ef1339971556f9ed4b20b0d97`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/agent_outputs/roundtrip_judge.json` (`f0d0f3194d36a3fc84019b0e8450fb01498e5eea48f47fbd601973d6e3590aea`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/agent_outputs/source_contract.json` (`78d644de63b2e51e9fbd27ddcb6f09278f0e90c9fda5b9dd8e6f3d30690b0059`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/decision.json` (`0d74d170a8c014a6dad4cdbd7e31bde00a639f75ead1d5e5ecca6be841383edc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/blind_dependency_inventory.json` (`dc54e7e5df8d7bd3772d86560eafc7e92314083bfa039de2b2211b711f346753`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/blind_dossier.md` (`ec18c90d2d66867eb912e62be0755d1c1371c37751c496bd226d14f4cc9efd77`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/blind_review_packet.md` (`ec18c90d2d66867eb912e62be0755d1c1371c37751c496bd226d14f4cc9efd77`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/declaration_dossier.md` (`7b4c58292b9c178a4762d4072d425f2de7dffadc7f5f0fb09ed6b1a5fe3ee885`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/dependency_inventory.json` (`2f3c3d0238a6ad4d4ffe71eb7971122f88b6a32ef81197f5d847c79652818132`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/direct_review_packet.md` (`137e905bfbd1cbe6bcb198aba445553de4e086fdd2dfe53da98733e36ebc8863`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/history/20260910T052733Z/inputs/source_locator.json` (`2721fa294b39cdcf6194778f4d60046ae3b69e76903692675774a2bacc0b6d44`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/blind_dependency_inventory.json` (`80c9110fa5ace35dc3ff90a6007a6b3628234c8ee9be3743230255681bfcc5af`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/blind_dossier.md` (`eb5b8a0c95487d95753d5d58992ea329ecdb4341ff7c02f276772059fb6b6457`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/blind_review_packet.md` (`eb5b8a0c95487d95753d5d58992ea329ecdb4341ff7c02f276772059fb6b6457`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/declaration_dossier.md` (`b7f18c7f0e7d00c61a50a4aef73b44c6910dd6e7528094d648e2c949836c0b70`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/dependency_inventory.json` (`d0477908ae12bb9a121ab0346a13239cdb51bb7b1a82ed484a836a8cfc5cbb7f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/direct_review_packet.md` (`7c3d4e74c1fc7b7b1d4ecfd5837e68f21527de7533d75786a51cacde98975c73`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.4.4/faithfulness-current-v5/inputs/source_locator.json` (`2721fa294b39cdcf6194778f4d60046ae3b69e76903692675774a2bacc0b6d44`)
