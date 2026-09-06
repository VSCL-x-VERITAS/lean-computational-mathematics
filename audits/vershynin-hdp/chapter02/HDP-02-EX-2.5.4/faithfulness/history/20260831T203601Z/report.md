# Faithfulness audit: HDP-02-EX-2.5.4

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The Lean statement faithfully expresses Exercise 2.5.4. It fixes a real MGF-bound parameter before universally quantifying lambda, uses the exact Gaussian-type upper bound exp(K^2 lambda^2), and concludes exact zero expectation. Its explicit probability-measure and integrability hypotheses formalize the source's implicit analytic context. Although Lean does not require K > 0 and presents the witness schematically rather than existentially, the square makes all extra K cases equivalent to a positive source witness, so both implication directions hold.

## Implications

- **Lean implies source:** `yes`. Assume source property v with its fixed positive witness K5. Its finite real MGF interpretation supplies the explicit exponential-integrability premises, and it also yields integrability of X (for instance from finite exponential moments at both signs). Instantiating the Lean proposition at K = K5 gives E X = 0, exactly the exercise conclusion.
- **Source implies lean:** `yes`. Given the Lean premises for an arbitrary real K, they imply source property v for some positive constant. If K is nonzero, take K5 = |K|, which has the same square. If K = 0, take K5 = 1: the assumed bound by exp(0)=1 is at most exp(lambda^2) for every real lambda. The source exercise then gives the Lean conclusion E X = 0.

## Findings

- **note / parameter-positivity:** This is a harmless equivalent reformulation: negative K has the same square as |K|, and a K=0 bound implies the bound for any chosen positive constant such as 1.
- **note / explicit-integrability:** These clauses make the real Bochner expectations honest and express conditions implicit in the finite-MGF source statement; they do not reduce intended applicability.
- **note / explicit-integrability:** No semantic loss or restriction results, because those assumptions follow from the all-λ finite MGF bound in the source.
- **note / constant-parameterization:** The forms are equivalent: use the source witness in one direction and enlarge any translated K to a positive constant in the other.

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

- Blind translator covered `38` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `38` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/agent_outputs/agent_runs.json` (`eb7bad296f4d95f2af5fe547af8942a934d3cde5214123da3d4b555b45f240ab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/agent_outputs/blind_translation.json` (`b3956b6a6e3e03e1753c0269b05e3ac5ec7c7a94570fc7aa58fae6873d1e0b6f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/agent_outputs/direct_judge.json` (`274e69836c297d82a1a89106b0cf0df0a985daeb63e10897bb253c3c4972c428`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/agent_outputs/roundtrip_judge.json` (`1c95867f33c9021e5de429e425dbcc2d0954edcc117e10fb5ae55983eaa4eb7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/agent_outputs/source_contract.json` (`b697924751e3aa3e296ad1a8b65a81ca8a9decbc4c86a706f4077d7dfa61daf4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/decision.json` (`ca3ea42fbcc5eb5fc7eec6dedbac507134f231340f18b0fe584c42efc9f56394`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/declaration_dossier.md` (`079a90b6e55d2361c86ef81ce519fdef98bbb7f05ae578fca4abb1e4b582d151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133144Z/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/declaration_dossier.md` (`079a90b6e55d2361c86ef81ce519fdef98bbb7f05ae578fca4abb1e4b582d151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T133220Z/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/agent_outputs/agent_runs.json` (`bf3eb0de4292a5f74b6009793dc22ef3b9ed6f5a248f42c7167582febd7e5ae4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/agent_outputs/blind_translation.json` (`b3956b6a6e3e03e1753c0269b05e3ac5ec7c7a94570fc7aa58fae6873d1e0b6f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/agent_outputs/direct_judge.json` (`274e69836c297d82a1a89106b0cf0df0a985daeb63e10897bb253c3c4972c428`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/agent_outputs/roundtrip_judge.json` (`1c95867f33c9021e5de429e425dbcc2d0954edcc117e10fb5ae55983eaa4eb7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/agent_outputs/source_contract.json` (`b697924751e3aa3e296ad1a8b65a81ca8a9decbc4c86a706f4077d7dfa61daf4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/decision.json` (`bbaa9ffa0eaf4ea4d3a34ec1d3efc9acb605bde702019a138e086efc9edf7b67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/declaration_dossier.md` (`079a90b6e55d2361c86ef81ce519fdef98bbb7f05ae578fca4abb1e4b582d151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T145344Z/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/agent_outputs/agent_runs.json` (`bf3eb0de4292a5f74b6009793dc22ef3b9ed6f5a248f42c7167582febd7e5ae4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/agent_outputs/blind_translation.json` (`b3956b6a6e3e03e1753c0269b05e3ac5ec7c7a94570fc7aa58fae6873d1e0b6f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/agent_outputs/direct_judge.json` (`274e69836c297d82a1a89106b0cf0df0a985daeb63e10897bb253c3c4972c428`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/agent_outputs/roundtrip_judge.json` (`1c95867f33c9021e5de429e425dbcc2d0954edcc117e10fb5ae55983eaa4eb7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/agent_outputs/source_contract.json` (`b697924751e3aa3e296ad1a8b65a81ca8a9decbc4c86a706f4077d7dfa61daf4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/decision.json` (`e51b3422cb20874ac75e4f2898a977bcff97d06726da05acd52c3a28dcfe9723`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/declaration_dossier.md` (`079a90b6e55d2361c86ef81ce519fdef98bbb7f05ae578fca4abb1e4b582d151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260830T153154Z/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/agent_outputs/agent_runs.json` (`bf3eb0de4292a5f74b6009793dc22ef3b9ed6f5a248f42c7167582febd7e5ae4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/agent_outputs/blind_translation.json` (`b3956b6a6e3e03e1753c0269b05e3ac5ec7c7a94570fc7aa58fae6873d1e0b6f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/agent_outputs/direct_judge.json` (`274e69836c297d82a1a89106b0cf0df0a985daeb63e10897bb253c3c4972c428`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/agent_outputs/roundtrip_judge.json` (`1c95867f33c9021e5de429e425dbcc2d0954edcc117e10fb5ae55983eaa4eb7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/agent_outputs/source_contract.json` (`b697924751e3aa3e296ad1a8b65a81ca8a9decbc4c86a706f4077d7dfa61daf4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/decision.json` (`c423fdbe53ced7bc5e1c4556ca7ee16b671c01800c073ba946d97f447ac30f6e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/declaration_dossier.md` (`079a90b6e55d2361c86ef81ce519fdef98bbb7f05ae578fca4abb1e4b582d151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T084351Z/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/agent_outputs/agent_runs.json` (`eb7bad296f4d95f2af5fe547af8942a934d3cde5214123da3d4b555b45f240ab`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/agent_outputs/blind_translation.json` (`b3956b6a6e3e03e1753c0269b05e3ac5ec7c7a94570fc7aa58fae6873d1e0b6f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/agent_outputs/direct_judge.json` (`274e69836c297d82a1a89106b0cf0df0a985daeb63e10897bb253c3c4972c428`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/agent_outputs/roundtrip_judge.json` (`1c95867f33c9021e5de429e425dbcc2d0954edcc117e10fb5ae55983eaa4eb7c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/agent_outputs/source_contract.json` (`b697924751e3aa3e296ad1a8b65a81ca8a9decbc4c86a706f4077d7dfa61daf4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/decision.json` (`b826e93bc17887e121e7f3e817f4e8fd9734437964da403d1167f5ffd7396c8f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/declaration_dossier.md` (`079a90b6e55d2361c86ef81ce519fdef98bbb7f05ae578fca4abb1e4b582d151`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/history/20260831T101520Z/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/blind_dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/blind_dossier.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/blind_review_packet.md` (`72ec6f31419506722e5dfd26d309d123309437ac61e695ee01a1a63de630faf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/declaration_dossier.md` (`c04247a310fd3d8550c67c257ad22eeea78ddd3a0be24ce5806cfd9d93e5cc86`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/dependency_inventory.json` (`cb8801c2525c4bf924213df1da9880c032d8e6d40b2210b1d4ca12a267cd73ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/direct_review_packet.md` (`19dcd2875e6758cff2c9c3a98c4ff4a8b85f18835e29310feec07d7775558700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.4/faithfulness/inputs/source_locator.json` (`38fa9aaeaf1c7ee458e26436833e6c412dbbba73e9ea46729e89b81a4dabeea4`)
