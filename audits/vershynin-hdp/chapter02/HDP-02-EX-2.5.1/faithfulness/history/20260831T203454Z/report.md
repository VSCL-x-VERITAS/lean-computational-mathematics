# Faithfulness audit: HDP-02-EX-2.5.1

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary-source inspection confirms that the selected exercise includes both the exact formula and the separate O(sqrt(p)) deduction. The Lean target explicitly states only the exact formula, but it states it uniformly for every real p >= 1, and that exact Gamma identity mathematically entails the big-O conclusion. The converse uses the exact part of the source, the canonical N(0,1) coordinate, finiteness of Gaussian moments, and equivalent positive real-power algebra. The two unresolved dependencies and all four unclear semantic checks therefore pass, both implications are yes, and the faithful-equivalent classification is accepted.

## Implications

- **Lean implies source:** `yes`. For every real p >= 1, the Lean target gives the standard-normal Lp norm by the exact Gamma formula. Positivity and real-power laws identify its placement of 2^(p/2) inside the outer 1/p power with the source's external sqrt(2) factor. The source's separately requested O(sqrt(p)) statement follows from this uniform exact formula by the standard Gamma/Stirling estimate, as the source's words 'Deduce that' indicate.
- **Source implies lean:** `yes`. The source exact identity, applied to the canonical identity random variable under gaussianReal 0 1, equals the toReal conversion of eLpNorm' because all standard-Gaussian moments at finite p >= 1 are finite. Regrouping the positive factors under Real.rpow gives exactly the Lean right-hand side.

## Findings

- **note / derived-asymptotic-not-explicit:** There is a syntactic omission but no semantic weakening: the exact formula entails the requested big-O deduction, so both implication directions still hold.
- **note / equivalent-canonical-and-algebraic-presentation:** The canonical measure has the same law, and positivity on p >= 1 makes the two real-power expressions equal; neither difference changes applicability or strength.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `46` dependencies (`0` hash-reused); unclear: `D003, D020`.
- Direct judge covered `46` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/agent_outputs/adjudicator.json` (`31bd3c1610a2d4328d51997c4b44899a8f85041146396c1434363f36e23fa03b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/agent_outputs/agent_runs.json` (`a20751b2f122d231ee7371e6323661fa4fa2dcb12a07eaf48c61afa67780b43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/agent_outputs/blind_translation.json` (`15ccf3e7fd0dccfee301f8fee5c2318df984244ca04a05b7e51b3ec494fcd765`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/agent_outputs/direct_judge.json` (`fd25f323abac206fcdec457880d9ece4e95bbcfefe5233144e4069d7921082f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/agent_outputs/roundtrip_judge.json` (`8586bdba7a18ce258a073985e01773c602ecbf33632c9c399da964f89a09a43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/agent_outputs/source_contract.json` (`ac84202436bf766c030d731736da3e20a2d9fc0576f18d5055af48a7023da1cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/decision.json` (`628ebc96c2af4083aaa999276a13793b16f7830cdd51097d1d6e2914b1a0a5fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/agent_outputs/adjudicator.json` (`31bd3c1610a2d4328d51997c4b44899a8f85041146396c1434363f36e23fa03b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/agent_outputs/agent_runs.json` (`c8bc9385e955e46f78e6cfb4ddc9adf116592e1b147191b1735545c0be676f5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/agent_outputs/blind_translation.json` (`15ccf3e7fd0dccfee301f8fee5c2318df984244ca04a05b7e51b3ec494fcd765`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/agent_outputs/direct_judge.json` (`fd25f323abac206fcdec457880d9ece4e95bbcfefe5233144e4069d7921082f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/agent_outputs/roundtrip_judge.json` (`8586bdba7a18ce258a073985e01773c602ecbf33632c9c399da964f89a09a43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/agent_outputs/source_contract.json` (`ac84202436bf766c030d731736da3e20a2d9fc0576f18d5055af48a7023da1cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/decision.json` (`223302d402856cada80ed239305a3ce2095558b360e0c90329c6a468d5b98962`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/blind_dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/blind_dossier.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/blind_review_packet.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/declaration_dossier.md` (`ffddd344766cfd4e243df5964dc8a8beb015fd796dd879f93dbe9b85a324662d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/direct_review_packet.md` (`a976e64f481021b6c8d00c7a0d2e2dc81dc98c7b8d23ca7802ab1d4155e463cc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T131914Z/inputs/source_locator.json` (`7b181e3281f3ddc6377c755ea5d109f1280b5740d99a02fdf170998cc07d81f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/agent_outputs/adjudicator.json` (`31bd3c1610a2d4328d51997c4b44899a8f85041146396c1434363f36e23fa03b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/agent_outputs/agent_runs.json` (`c8bc9385e955e46f78e6cfb4ddc9adf116592e1b147191b1735545c0be676f5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/agent_outputs/blind_translation.json` (`15ccf3e7fd0dccfee301f8fee5c2318df984244ca04a05b7e51b3ec494fcd765`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/agent_outputs/direct_judge.json` (`fd25f323abac206fcdec457880d9ece4e95bbcfefe5233144e4069d7921082f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/agent_outputs/roundtrip_judge.json` (`8586bdba7a18ce258a073985e01773c602ecbf33632c9c399da964f89a09a43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/agent_outputs/source_contract.json` (`ac84202436bf766c030d731736da3e20a2d9fc0576f18d5055af48a7023da1cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/decision.json` (`0c4b17b9c612da5bb10f08a0c096f465da3f593bc8f8fbaff6d673dbba315f6d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/blind_dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/blind_dossier.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/blind_review_packet.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/declaration_dossier.md` (`ffddd344766cfd4e243df5964dc8a8beb015fd796dd879f93dbe9b85a324662d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/direct_review_packet.md` (`a976e64f481021b6c8d00c7a0d2e2dc81dc98c7b8d23ca7802ab1d4155e463cc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T145344Z/inputs/source_locator.json` (`7b181e3281f3ddc6377c755ea5d109f1280b5740d99a02fdf170998cc07d81f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/agent_outputs/adjudicator.json` (`31bd3c1610a2d4328d51997c4b44899a8f85041146396c1434363f36e23fa03b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/agent_outputs/agent_runs.json` (`c8bc9385e955e46f78e6cfb4ddc9adf116592e1b147191b1735545c0be676f5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/agent_outputs/blind_translation.json` (`15ccf3e7fd0dccfee301f8fee5c2318df984244ca04a05b7e51b3ec494fcd765`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/agent_outputs/direct_judge.json` (`fd25f323abac206fcdec457880d9ece4e95bbcfefe5233144e4069d7921082f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/agent_outputs/roundtrip_judge.json` (`8586bdba7a18ce258a073985e01773c602ecbf33632c9c399da964f89a09a43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/agent_outputs/source_contract.json` (`ac84202436bf766c030d731736da3e20a2d9fc0576f18d5055af48a7023da1cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/decision.json` (`f3893aab8604b39b3bb964bc37b8329fde5206109d61fa14bd48418f6c205ba2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/blind_dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/blind_dossier.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/blind_review_packet.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/declaration_dossier.md` (`ffddd344766cfd4e243df5964dc8a8beb015fd796dd879f93dbe9b85a324662d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/direct_review_packet.md` (`a976e64f481021b6c8d00c7a0d2e2dc81dc98c7b8d23ca7802ab1d4155e463cc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260830T153119Z/inputs/source_locator.json` (`7b181e3281f3ddc6377c755ea5d109f1280b5740d99a02fdf170998cc07d81f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/agent_outputs/adjudicator.json` (`31bd3c1610a2d4328d51997c4b44899a8f85041146396c1434363f36e23fa03b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/agent_outputs/agent_runs.json` (`c8bc9385e955e46f78e6cfb4ddc9adf116592e1b147191b1735545c0be676f5e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/agent_outputs/blind_translation.json` (`15ccf3e7fd0dccfee301f8fee5c2318df984244ca04a05b7e51b3ec494fcd765`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/agent_outputs/direct_judge.json` (`fd25f323abac206fcdec457880d9ece4e95bbcfefe5233144e4069d7921082f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/agent_outputs/roundtrip_judge.json` (`8586bdba7a18ce258a073985e01773c602ecbf33632c9c399da964f89a09a43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/agent_outputs/source_contract.json` (`ac84202436bf766c030d731736da3e20a2d9fc0576f18d5055af48a7023da1cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/decision.json` (`3ede98a7bab13c3112f348d90291aaab83c18c8fe0a9d981748ea82033b7800d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/blind_dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/blind_dossier.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/blind_review_packet.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/declaration_dossier.md` (`ffddd344766cfd4e243df5964dc8a8beb015fd796dd879f93dbe9b85a324662d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/direct_review_packet.md` (`a976e64f481021b6c8d00c7a0d2e2dc81dc98c7b8d23ca7802ab1d4155e463cc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T084130Z/inputs/source_locator.json` (`7b181e3281f3ddc6377c755ea5d109f1280b5740d99a02fdf170998cc07d81f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/agent_outputs/adjudicator.json` (`31bd3c1610a2d4328d51997c4b44899a8f85041146396c1434363f36e23fa03b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/agent_outputs/agent_runs.json` (`a20751b2f122d231ee7371e6323661fa4fa2dcb12a07eaf48c61afa67780b43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/agent_outputs/blind_translation.json` (`15ccf3e7fd0dccfee301f8fee5c2318df984244ca04a05b7e51b3ec494fcd765`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/agent_outputs/direct_judge.json` (`fd25f323abac206fcdec457880d9ece4e95bbcfefe5233144e4069d7921082f5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/agent_outputs/roundtrip_judge.json` (`8586bdba7a18ce258a073985e01773c602ecbf33632c9c399da964f89a09a43d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/agent_outputs/source_contract.json` (`ac84202436bf766c030d731736da3e20a2d9fc0576f18d5055af48a7023da1cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/decision.json` (`54b548dc6def9e381b3991a009b080ea3de7b1bb8302ac5f08ff2dbcf520260f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/blind_dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/blind_dossier.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/blind_review_packet.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/declaration_dossier.md` (`ffddd344766cfd4e243df5964dc8a8beb015fd796dd879f93dbe9b85a324662d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/direct_review_packet.md` (`a976e64f481021b6c8d00c7a0d2e2dc81dc98c7b8d23ca7802ab1d4155e463cc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/history/20260831T101426Z/inputs/source_locator.json` (`7b181e3281f3ddc6377c755ea5d109f1280b5740d99a02fdf170998cc07d81f0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/blind_dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/blind_dossier.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/blind_review_packet.md` (`abe478d497d3eb99e1f65d276f031cc924817eb3f0601a983347b502dca49fd1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/declaration_dossier.md` (`85cb949f8a4722880be1248df464d09b563e13f802d4ddc96fe9d9d692bd2116`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/dependency_inventory.json` (`0c93f42dad39814c3122cad3169d0cb90c78ca7adbcda100c88b81cdef5fd16a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/direct_review_packet.md` (`a976e64f481021b6c8d00c7a0d2e2dc81dc98c7b8d23ca7802ab1d4155e463cc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.1/faithfulness/inputs/source_locator.json` (`7b181e3281f3ddc6377c755ea5d109f1280b5740d99a02fdf170998cc07d81f0`)
