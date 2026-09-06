# Faithfulness audit: HDP-01-THM-JENSEN

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `e449755e3d1f30dbd32e7827d164e4af191c17fd6fa268932bb830926d210aeb`
- Source SHA-256: `855fdaf6870f664f1e470d47641b6d72758afdb9b87649a6494b027cecc02b17`

Direct comparison of the first-edition Jensen passage (PDF page 2 / printed page 6, Section 1.2) with `hdp_01_hthm_hjensen`. Reading the printed sentence together with its three inherited footnotes, the source claim is: on a probability space (Ω, Σ, P), for any real random variable X and any convex φ : R → R, φ(E X) ≤ E[φ ∘ X], where E is the Lebesgue integral (footnote 1), the right-hand side is the expectation of the composite (footnote 2's binding convention), and 'convex' is the non-strict combination inequality over the whole domain of φ, here all of R (footnote 3). I applied this module's authoritative definability convention: because the first edition defines E as a Lebesgue integral without any exceptional-value convention for non-integrable real random variables, each ordinary real-valued E X is read on its finite-integral domain, so `Integrable X μ` and `Integrable (fun ω => φ (X ω)) μ` are part of the configured source contract and are NOT scored as reduced applicability; I also verified that the Lean statement adds no restriction beyond those declared definability conditions, which would have been `not-faithful-weaker`. Following the module's second instruction, I judged `ConvexOn ℝ Set.univ φ` against the printed 'φ : R → R' typing (which it matches exactly) rather than against a sharper interval-domain reading, noting only that the book's own use at (1.3) with x^{q/p} is internally looser than its own typing. All 33 dependencies were interpreted from their supplied declarations rather than their names: the single local definition `expectation` unfolds to the Bochner integral against μ, i.e. footnote 1's Lebesgue integral (and not the L2 inner product of (1.1) or a conditional expectation); `ConvexOn` unfolds to footnote 3's inequality; `Integrable` unfolds to a.e. strong measurability plus finite integral; `Set.univ` to all of R; `IsProbabilityMeasure` to μ univ = 1, i.e. P(Ω) = 1; and the remaining 27 entries are order, algebra, norm, topology, and integral instance plumbing on R that deliver only the standard structures. All twelve semantic checks pass except C09, marked not-applicable with a concrete reason (the selected result contains no constants, coefficients, exponents, or indices to compare). Both implications hold: the Lean theorem yields the contract-read source claim on its full domain, and every Lean instance is an instance of that claim, the only slack being `Integrable`'s a.e.-measurability versus the source's 'random variable', which is an a.e.-modification equivalence with no effect on either integral. Nonvacuity was tested concretely (standard Gaussian X with φ = t ↦ t², giving the strict instance 0 ≤ 1), and both `ConvexOn` and `IsProbabilityMeasure` were checked to be load-bearing by exhibiting counterexamples when each is dropped. Classification: faithful-equivalent. Nothing was left unresolved, so no adjudication is required; the five findings are all note-level records of the policy-bound premises, the measurability slack, the convexity-domain typing, the unreachable Bochner junk value, and the equivalent convex-combination parameterization.

## Implications

- **Lean implies source:** `yes`. Take the printed statement as fixed by the module definability convention: for any probability space (Ω, Σ, P), any real random variable X whose expectation and whose transformed expectation are defined as finite Lebesgue integrals, and any convex φ : R → R, φ(E X) ≤ E φ(X). Every ingredient of that reading is discharged by the Lean statement under a literal translation: (Ω, Σ, P) ↦ `{Ω} [MeasurableSpace Ω] {μ} [IsProbabilityMeasure μ]`; 'X a random variable with E X and E φ(X) finite Lebesgue integrals' ↦ `Integrable X μ` and `Integrable (fun ω => φ (X ω)) μ`, which is (slightly more than) enough since a.e. strong measurability is implied by measurability; 'φ : R → R convex' ↦ `ConvexOn ℝ Set.univ φ` (D005 unfolded against footnote 3); 'E' ↦ `expectation` = Bochner integral, which coincides with the Lebesgue integral for integrable real functions; '≤' ↦ the ordinary real order. The Lean conclusion is then literally the printed display, so the Lean theorem yields the source claim on its entire contract domain, with no residual case left uncovered.
- **Source implies lean:** `yes`. Conversely, every instance of the Lean statement is an instance of the contract-read source claim. Given Lean data Ω, μ (a probability measure), X, φ satisfying the three hypotheses, (Ω, MeasurableSpace Ω, μ) is a probability space in the book's sense; φ is convex on all of R in footnote 3's sense (unfolding `ConvexOn ℝ Set.univ φ` and setting λ = a, 1 − λ = b); and `expectation μ X`, `expectation μ (φ ∘ X)` are the finite Lebesgue integrals E X and E φ(X) precisely because of `hX` and `hφX`. The single point where the Lean hypotheses are a hair weaker than the source's wording is that `Integrable` requires only a.e. strong measurability, whereas 'random variable' means measurable; this is not a genuine gap, since an a.e. strongly measurable real function agrees a.e. with a measurable one and both integrals are unchanged by such modification, so the source claim transfers verbatim. Hence the source result (on the module's declared definability domain) entails the Lean proposition.

## Findings

- **note / policy-bound definability premises:** Recorded for transparency only. Under this module's authoritative definability convention, each ordinary real-valued E X is read on its finite-integral domain, so both premises are part of the configured source contract rather than optional proof conveniences, and their presence is explicitly not scored as reduced applicability or as `not-faithful-weaker`. No hypothesis beyond these declared conditions appears in the Lean statement. Anyone reading the printed sentence in isolation should nonetheless be aware that neither premise is in the text.
- **note / measurability strength:** The Lean hypothesis is marginally weaker than 'random variable' (a.e. measurability rather than measurability), so the Lean statement covers slightly more functions than the printed sentence literally speaks about. This is a standard measure-theoretic equivalence — an a.e. strongly measurable real function coincides a.e. with a measurable one and has the same integral — so it does not alter the mathematical content or the classification, and it is a generalisation rather than a restriction.
- **note / convexity domain:** The Lean hypothesis matches the printed typing exactly, which is the standard this module directs the judge to apply. It does mean the Lean theorem does not directly cover the book's own downstream use at (1.3) with φ(x) = x^{q/p}; that looseness is internal to the source, not a defect of the formalization, and no narrower-domain version was stated by the source to be matched.
- **note / junk-value semantics:** No effect on faithfulness: the `Integrable` premises make the junk-value branch unreachable, so the Lean statement asserts nothing about cases on which the source is silent. Worth recording because a reader who did not unfold `expectation` might wrongly suspect a junk-value reading was being asserted as source content.
- **note / convexity parameterization:** The two-scalar (a, b) parameterization is equivalent to the (λ, 1 − λ) parameterization with λ ∈ [0, 1], so the Lean hypothesis is neither stronger nor weaker than footnote 3 under the forced reading of the λ/t slip. No adjudication needed.
- **note / interpretation-policy applied (definability premises):** None on the verdict. Per the authoritative module definability convention recorded in my instructions, these two premises are part of the configured source contract, not optional proof conveniences, and their presence must not by itself be scored as reduced applicability. I applied that policy here. The blind translator, working without the source, characterized hφX as an added hypothesis that "weakens the conclusion's scope (the +∞ case is excluded rather than proven)" — but the source neither asserts nor denies the +∞ case (contract ambiguity 2), so no such claim is dropped, and no restriction beyond the declared definability conditions is present.
- **note / convexity domain — apparent strengthening resolved against printed form:** None on the verdict. Convexity on all of ℝ is exactly the printed hypothesis, so this is faithful, not a strengthening of the hypothesis relative to the source. The blind translator's comparison was against the sharpest possible Jensen rather than against Vershynin's sentence. Worth recording that the contract itself notes an internal looseness in the book — the very next sentence instantiates φ(x) = x^{q/p}, convex on [0, ∞) rather than on all of R — but the contract directs that the selected passage be judged against its printed R → R typing, which the translation matches.
- **note / measurability strength (a.e. strong vs. strict):** None on the verdict. This makes the translation cover every source instance and marginally more (a.e.-modifications), which is widened applicability rather than a gap; since a.e.-equal functions have equal integrals, the mathematical content is unchanged. Both implications survive.
- **note / explicit ambient probability space:** None. Making inherited ambient context into explicit binders is required for a self-contained statement and preserves quantifier order and scope; the probability normalization μ(univ) = 1 matches footnote 1's setting and is essential (the inequality fails for non-probability measures), so it is neither an added restriction nor an omission.
- **note / no equality/strictness content added:** None; recorded as confirmation that the translation adds no conclusion the source does not state, keeping the result single-part as the contract's undebatable constraints require.

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
| `C09` | `not-applicable` | `not-applicable` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `33` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `33` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/agent_runs.json` (`52970ef6f839f22c3a532deedc49dac09c2a08cfa643f188dd84673e966ad397`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/blind_translation.json` (`ddabaa7d16e60d8773ee59a23dfb9506446dfb56b846c342b75b0f22fab23e12`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/direct_judge.json` (`dcbd9a9fe83f7a3fc0f4f8551433e998ca7b3fc687a164f141544493f52b7d05`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/roundtrip_judge.json` (`7bbc47ee4270e673aeb57bdfbc83b0a75fd0e5f62ba4b58e7f2dd008d2c76fc1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/agent_outputs/source_contract.json` (`bbca7f9b6174ee052774d10cd6e83a13bce08b134010406483401c16856b1e8d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/decision.json` (`d73254966b212ad4da5863ed6804cf28b011a023a79e77296d5b933c61f423a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/agent_outputs/adjudicator.json` (`891a27a73f9990cc19a93ada104e0ceeaec74fbd08fb9b24fd5f9963aeaa534d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/agent_outputs/agent_runs.json` (`37423191d3664a21fd8b1166e4006d81d94af2a8cdc08ea1dd767b7de3013c50`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/agent_outputs/blind_translation.json` (`7c1709453873f961fda350da69a8de9a6c6d9a37f467f9dfd5f11669b06a3fae`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/agent_outputs/direct_judge.json` (`06168bb7e44efa188797119d0c7574137f464fc17abfab74a112f350e8bbc5ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/agent_outputs/roundtrip_judge.json` (`ae71a5fc9a30b5a9ef450d0971fa83a5c1c6c7abeca45290270b4d751f5b8acf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/agent_outputs/source_contract.json` (`03a40db76475306cfedf9b6da9dc946cf7607897d35fb1378a42137fdd251f45`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/decision.json` (`4d827116f81cb626dd465cd4beaf760d0318b3a2af05f2605c7594c8bb961a1c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/blind_dependency_inventory.json` (`5dd511fa4ceb15ddf3627a5acbfa74c7b97d3555e8abbfc8d1223bb697586208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/blind_dossier.md` (`786f6dfe70fa8262098b0f772b3d6bedef57944cd80db889e7f39e3ab833c535`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/blind_review_packet.md` (`786f6dfe70fa8262098b0f772b3d6bedef57944cd80db889e7f39e3ab833c535`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/declaration_dossier.md` (`c924f5d088aa77156292d26aebd850230d9f3b8f01996171f7ef7c10df2b18ea`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/dependency_inventory.json` (`098e002fce24de3a5ba0ab00c4a025b0385c77404429e21d869dfe1749d3859d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/direct_review_packet.md` (`bb2c56d93aa2459cff9eaf63c8f1df2ff47db2a19f46a4b1ffbde02c930c3d27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/history/20260828T221528Z/inputs/source_locator.json` (`3bb5f0e81fff650e811ec3c8e0644cf6222d8e3d7be302fc9fd406e3af956d9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/blind_dependency_inventory.json` (`5dd511fa4ceb15ddf3627a5acbfa74c7b97d3555e8abbfc8d1223bb697586208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/blind_dossier.md` (`786f6dfe70fa8262098b0f772b3d6bedef57944cd80db889e7f39e3ab833c535`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/blind_review_packet.md` (`786f6dfe70fa8262098b0f772b3d6bedef57944cd80db889e7f39e3ab833c535`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/declaration_dossier.md` (`51a605d0db66986f6a67f9048b14718b30c5a235d57aa2727d384c8f58dea97b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/dependency_inventory.json` (`098e002fce24de3a5ba0ab00c4a025b0385c77404429e21d869dfe1749d3859d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/direct_review_packet.md` (`23ad78ba71c1141dae486998a04d1f59f97df400944af935d3d6b924b5dd0e48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-THM-JENSEN/faithfulness/inputs/source_locator.json` (`3bb5f0e81fff650e811ec3c8e0644cf6222d8e3d7be302fc9fd406e3af956d9c`)
