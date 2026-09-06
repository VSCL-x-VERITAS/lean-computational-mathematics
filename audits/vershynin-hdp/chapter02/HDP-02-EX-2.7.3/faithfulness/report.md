# Faithfulness audit: HDP-02-EX-2.7.3

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `b9b6197d46c0d9ee992da6aea098467a848bd2e2908da060671f97f0920cf706`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The primary source is deliberately not a single fully quantified theorem: it delegates to the reader the task of stating and proving a version of Proposition 2.7.1 for exp(-c t^alpha) tails. The exact Lean statement makes one transparent, mathematically canonical selection by setting Y = |X|^alpha for alpha > 0 and applying the four principal sub-exponential properties to Y. This produces the requested tail shape, companion moment and exponential-integrability characterizations, and a quantitative transfer theorem with the absolute constant already supplied by Proposition 2.7.1. For bidirectional auditing of such a construction exercise, the source-to-Lean direction asks whether the referenced source mathematics establishes the selected permissible version, not whether the open command uniquely dictates every binder and normalization. It does. At the same time, the K normalization is not identified with every conventional X-scale: converting K = L^alpha changes C to C^(1/alpha), and that genuine distinction is retained as a finding. With that qualification, both implications are yes, the target is faithful-equivalent, and no uncertainty remains.

## Implications

- **Lean implies source:** `yes`. The Lean theorem is a substantive answer to the source exercise: for every alpha > 0 it quantitatively transfers among four Proposition 2.7.1 properties for Y = |X|^alpha. The tail branch becomes P{|X| >= t} <= 2 exp(-t^alpha/K), hence has the required exp(-c t^alpha) decay, and alpha = 1 and alpha = 2 give the named regimes after scale reparameterization. The omitted centered clause is not required by the open-ended request for a version.
- **Source implies lean:** `yes`. For this expressly solver-selected version, the source context proves the Lean proposition by applying Proposition 2.7.1(a)-(d) to Y = |X|^alpha. Its absolute comparison constant is uniform in Y and therefore in X and alpha in the powered K-coordinate. The source's latitude over exact range and normalization licenses this declared choice; it does not purport to make all possible normalizations literally identical.

## Findings

- **note / open-ended-source-specification:** These choices must be described as the selected answer, not quoted as uniquely prescribed source wording; within that policy they do not prevent bidirectional faithfulness.
- **minor / scale-normalization:** The comparison is alpha-uniform only in the powered K-coordinate. The theorem does not establish an alpha-uniform factor C in the L-coordinate, and the classification does not erase that genuine normalization difference.
- **note / centered-mgf-clause:** Omission of an unspecified generalized clause (e) is a legitimate scope choice for 'a version,' not a missing conclusion.
- **note / magnitude-measurability-encoding:** All source random variables are covered. Extra functions with the same measurable magnitude add no new observable tail, moment, or exponential-integrability content beyond the measurable nonnegative variable |X|^alpha.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `unclear` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `84` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `84` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/adjudicator.json` (`a77942b19075225441a6daaf6884440e72030d67d351320991c09b6e03f15ef9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/agent_runs.json` (`16dce2818db95afa335b22b4ad699c54dcea749d99d0b59f88b940f467d3d356`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/batch_source_contract.json` (`b943e60669562e43cdb440f515c87130d55317aaf52aa86c85e3536eaed91156`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/blind_translation.json` (`c0f8b1ce9157dd523553ae0203486a5ce545c92da558a58f71252e44049d46bf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/direct_judge.json` (`0a741db0b10ca2afe10fa7c0950b149d02821c1af0df793950cd6fa68fd20785`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/roundtrip_judge.json` (`bf2e33ed29a5ea23c8d9bcfb27edfa19c06cdeada4d96448060d1997f753fcff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/agent_outputs/source_contract.json` (`9d84352983cfc5ce9ec92f516efc5e3642c81f49dd24b95c84f65b307fef9fad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/decision.json` (`56f4121aac726244a922efa1b470e127bed3ac98c9d18b4861f2188d76d12241`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/adjudicator.json` (`a77942b19075225441a6daaf6884440e72030d67d351320991c09b6e03f15ef9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/agent_runs.json` (`b25df1c4c854c5840cba309eea12a1e5cd5e69a54d490469760e6bb54fbdbd3f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/batch_source_contract.json` (`b943e60669562e43cdb440f515c87130d55317aaf52aa86c85e3536eaed91156`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/blind_translation.json` (`c0f8b1ce9157dd523553ae0203486a5ce545c92da558a58f71252e44049d46bf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/direct_judge.json` (`0a741db0b10ca2afe10fa7c0950b149d02821c1af0df793950cd6fa68fd20785`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/roundtrip_judge.json` (`bf2e33ed29a5ea23c8d9bcfb27edfa19c06cdeada4d96448060d1997f753fcff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/agent_outputs/source_contract.json` (`9d84352983cfc5ce9ec92f516efc5e3642c81f49dd24b95c84f65b307fef9fad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/decision.json` (`0ceba379f16eaee8199f534c2d2cbe2c6ff7412ef794c2621f77adc9dce7ac5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/batch_source_locator.json` (`626250564a35ff503ae643cdec32b1490a802048e09ba2f4108a0d95124f67ca`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/blind_dependency_inventory.json` (`408706f264d8acfe547ddd85214aafc2b5c1af9443f01b3097413dc701323c25`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/blind_dossier.md` (`8924c3c0971b0aceea54394461a5e08e7ab4b960399a70b7df9fc57a354edbcd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/blind_review_packet.md` (`8924c3c0971b0aceea54394461a5e08e7ab4b960399a70b7df9fc57a354edbcd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/declaration_dossier.md` (`6f0c83c44e9fc49df95589f327739597611e959d538ebb5600778f4aba728dcc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/dependency_inventory.json` (`035c654b676f2bd021f6f6759cd18ac2ca93b4bba01528c273f477bff6619f5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/direct_review_packet.md` (`01e1801eb64892cb5c883a422da9524526563ac1fd0002009078659f1de218e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/history/20260831T204355Z/inputs/source_locator.json` (`7e8dea43c6c3362f514c9d994b4ce4b09e1488682bf090c9935b746c0f823901`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/blind_dependency_inventory.json` (`408706f264d8acfe547ddd85214aafc2b5c1af9443f01b3097413dc701323c25`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/blind_dossier.md` (`8924c3c0971b0aceea54394461a5e08e7ab4b960399a70b7df9fc57a354edbcd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/blind_review_packet.md` (`8924c3c0971b0aceea54394461a5e08e7ab4b960399a70b7df9fc57a354edbcd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/declaration_dossier.md` (`17dc4144937f34e74dec89c57269b589815fd68e04a36220fe67e66aaec20ed7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/dependency_inventory.json` (`035c654b676f2bd021f6f6759cd18ac2ca93b4bba01528c273f477bff6619f5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/direct_review_packet.md` (`01e1801eb64892cb5c883a422da9524526563ac1fd0002009078659f1de218e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.3/faithfulness/inputs/source_locator.json` (`7e8dea43c6c3362f514c9d994b4ce4b09e1488682bf090c9935b746c0f823901`)
