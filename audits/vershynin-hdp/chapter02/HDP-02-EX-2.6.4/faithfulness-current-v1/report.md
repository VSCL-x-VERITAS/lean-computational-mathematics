# Faithfulness audit: HDP-02-EX-2.6.4

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `a5707e610d1d203a8e205eb11024013afcdd8fa047368da9618ccd1331aa842a`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target is faithful-equivalent to Exercise 2.6.4's requested bounded-variable Hoeffding conclusion. It quantifies one positive exponent constant before all data, uses an arbitrary finite mutually independent measurable real family bounded almost surely in the stated intervals, centers by expectation, requires t>0, measures the inclusive one-sided upper-tail event, divides by the sum of individual squared widths, and has no leading prefactor. Nondegenerate bounded families provide abundant intended models, so the proposition is nonvacuous. The only disputed facet is the source's unstated zero-width division boundary. Lean assigns that quotient the total-real value zero and hence assigns the right side 1, but zero width under the common interval hypotheses makes every centered summand vanish almost surely. Consequently both implication directions hold after the standard mathematical case split, and the totalization is a conservative formal completion rather than a semantic mismatch.

## Implications

- **Lean implies source:** `yes`. For positive total squared width, specialize the arbitrary finite index type to the source's numbered family: the hypotheses, centered upper-tail event, no-prefactor exponential, and squared-width denominator coincide, with c exactly the permitted absolute exponent constant. At zero total width, every closed interval has equal endpoints, so each bounded X_i is almost surely constant and its centered summand is almost surely zero; t>0 makes the event null. Therefore Lean's totalized boundary does not prevent the source's intended bounded-Hoeffding conclusion.
- **Source implies lean:** `yes`. For a nonempty finite type with positive total width, choose an enumeration and apply the source theorem with the same universal absolute constant. If the width sum is zero, Lean's quotient is zero and its right side is 1, so the probability bound follows directly (and the event is in fact null). If the index type is empty, the sum is zero and t>0 again makes the event empty. Thus the target adds only automatically valid completion cases.

## Findings

- **minor / zero-width-totalization:** The displayed boundary value is a formal completion rather than explicit source text, but it causes no theorem-level weakening or strengthening because the shared hypotheses force the t>0 centered event to have probability zero.
- **note / supporting-source-contract-sidedness:** This supporting-artifact error does not affect the audited Exercise 2.6.4 target, which correctly states the one-sided no-prefactor Theorem 2.2.6 conclusion.

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
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `58` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `58` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/adjudicator.json` (`f23f5692121b109703574fb6a138382670922e6c28b41897e1192acc138dbc8d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/agent_runs.json` (`9f03e506156b6b640f7d6e04d00dbea0005a0d7078fd0234fed1d3a782322cf2`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/blind_translation.json` (`8030a233cc44fb52fb8017efeff3f7d22b9eb6a1dd1cb18e7e313188f3dd4108`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/direct_judge.json` (`3bcf345d23f5200c102c997663a170e9449f3eaad61d0f16eea247a814a2311f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`4354106d28ff42bbb1447c809d3fab6bad1e91304856c001d914fbb7e1418df2`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/agent_outputs/source_contract.json` (`e1f03b252cd6b2a7b3278ec0ddbefca76599eec75a9fec3a5b1bf8e91bd0cea5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/decision.json` (`812626ed30262f928ffdd0c4a499c4e1024e51f4bdb415bd09bdccf2a2da8145`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/agent_outputs/agent_runs.json` (`4c536cd457c2bb15f5a5c096948e90fab5f9bf358fd4062c3b40df0692980678`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/agent_outputs/blind_translation.json` (`29a2605fca067a750b4774e1548e446b4b8752947b086c5bd8518b7667bb8ac6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/agent_outputs/source_contract.json` (`86cb78722149692e20ae84fcec0b11c3471d63d3318fbef9d930eacef048d100`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/blind_dependency_inventory.json` (`d72864eb83c7abe5258f1f6b0b0a23edd936fc3fb665ce51c21daa9f05ead096`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/blind_dossier.md` (`083fc488f7992079c6a48f7f558a3d427f545609496508276bcbae6e80c16d32`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/blind_review_packet.md` (`083fc488f7992079c6a48f7f558a3d427f545609496508276bcbae6e80c16d32`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/declaration_dossier.md` (`94a034e00413b33fd50da66dd0f8afa1f5347ca7c7c6ae6355c8cfe437b9579f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/dependency_inventory.json` (`123a8f38bca610c982e09098fcb9b1ddf83e293af6d22f8186948c54692a82ca`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/direct_review_packet.md` (`0fe03e96febb2477b97a8d5d2851c494bedc94181f6f154d29fff15b4444734b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T145139Z/inputs/source_locator.json` (`516759e1550d45ce34f0d0bfd1b0dd7f7e9daec528b95fb904f7cf1d57c16000`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/agent_outputs/adjudicator.json` (`9a7aaf96ed27e218e035dd26db9b3001f117c3d4d18f24b4f82a7f3e71bc9413`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/agent_outputs/agent_runs.json` (`b5d8c3bbdda16b3f215d0a24cbf805bc3fe0f8526bd3e0da461e7c6261ed37a6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/agent_outputs/blind_translation.json` (`e809d5095655a57ed2b2b2ece5c39db4d63ea6f6eeaf95fbedcf8dce13d5a8e9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/agent_outputs/direct_judge.json` (`622713abb08a2fb6064b87247b796edb84f879c47700fdc2e939f54fcef93ffc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/agent_outputs/roundtrip_judge.json` (`de6fd15d8035b5b05979725be91effda15c42a12c7c656234b895577fc44b7d8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/agent_outputs/source_contract.json` (`86d1ac7462e623de238791291a6328034c2347b2b185ab796803d80f5e15dcdc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/decision.json` (`ebaff088a7f40c6bd7b9c36d1ef1a92ef67836ccbe3c2ef1a0b07043dea282f0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/blind_dependency_inventory.json` (`6b22f3ccfdfdbc2d1110eb95718d1de6c2a555ebcc0e61fdde34b3f9ef6c22dc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/blind_dossier.md` (`30127f9b0865ee7918f93723081350cafd92407670a09cde40c78c3c4ea2229b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/blind_review_packet.md` (`30127f9b0865ee7918f93723081350cafd92407670a09cde40c78c3c4ea2229b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/declaration_dossier.md` (`03963c58f124ae6cbbcb46a31a539051bd62995a055956a72e789506234de200`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/dependency_inventory.json` (`746119688db2e89edb76f9c62c5f710d47c67b9b6b200ad1f78ff8f04d923f77`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/direct_review_packet.md` (`25d456f5789363fb98daec18b5275c1f8dc2017718665ea16a80f3906c966403`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/history/20260910T155815Z/inputs/source_locator.json` (`516759e1550d45ce34f0d0bfd1b0dd7f7e9daec528b95fb904f7cf1d57c16000`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`a973f7b3bfacbed76e2045b98618a57d5630f836894ba45e19661d554cdad2f4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/blind_dossier.md` (`d642f6e3fc597bcf28f358d26b9f3ec7aa97ba7ffe1c97ce0a51180721151ae5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/blind_review_packet.md` (`d642f6e3fc597bcf28f358d26b9f3ec7aa97ba7ffe1c97ce0a51180721151ae5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/declaration_dossier.md` (`f54bd1aab60e95260b1df99272675cb2a17527ddc41958ed3d0effec2e4a1949`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/dependency_inventory.json` (`0307c60a6b8bcc8db8482c5b023d6738ce7caf269df454358d8d1971375df8aa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/direct_review_packet.md` (`6eb5160d646f459fbe3df954c6df53cce98997cb6edfd5590b0bca735ea0ca20`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.4/faithfulness-current-v1/inputs/source_locator.json` (`516759e1550d45ce34f0d0bfd1b0dd7f7e9daec528b95fb904f7cf1d57c16000`)
