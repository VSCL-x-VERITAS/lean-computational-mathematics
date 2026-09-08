# Eq1.3 baseline producer transport — review draft

This draft compares actual Git blobs at baseline `9e2225705fed906b1120d55105d607baabef57c9` and committed checkpoint `c4bfd6deb756ba46184c9418edc83bda33084719`. It creates no candidate or epoch and supplies no integration, promotion, or protected-ref authority.

The appropriate transport class is **producer**, with **full-reaudit**. Type, policy-domain, canonical producer, and proof fingerprints differ. The immutable source PDF fingerprint is equal. The enlarged source context and interpreted claim are bound inside the policy-domain payload, so equality of the PDF does not imply equality of the selected source claim. `transport-entry.draft.json` has exactly the released transport-entry fields; `draft-provenance.json` defines every hash encoding and the remaining candidate-bound work.

The baseline task selects `NumStability.leveque01_equation03_advectedProfile` through `NumStability/Source/LeVeque/Chapter01/Equation03AdvectedProfile.lean`. That path is a compatibility import, not the declaration owner. The actual old owner is `ComputationalMathematics/Source/LeVeque/Chapter01/Equation03AdvectedProfile.lean`. The new selected declaration is `NumStability.leveque01_equation03_solutionDomains`, owned by `ComputationalMathematics/Source/LeVeque/Chapter01/Equation03SolutionDomains.lean`.

The old selected statement gives unrestricted characteristic translation and a conditional global classical PDE result for differentiable profiles. The new statement additionally gives initial agreement and characteristic constancy, characterizes classical solutionhood by differentiability, and characterizes rectangle conservation by local interval integrability. Its acceptance is explicitly under the separate recorded user interpretation; those exact analytic domains are not attributed to the printed book.

All three baseline declarations and their original proof bodies remain in their original canonical owners, byte-identically at both commits: `profilePropagates`, `scalarAdvection`, and `advectedProfile` (each prefixed `NumStability.leveque01_equation03_`). Their native structural type/proof fingerprints and universe parameters are retained in `declaration-retention.json`. The generic propagation theorem is not discarded on the premise that the new scalar certificate subsumes every generic statement.

The native fingerprints erase metadata and binder display names while preserving de Bruijn indices, universe levels, constants, binder kinds, and expression structure. They are **alpha-canonical structural fingerprints**, not full definitional normal forms. This task did not run a new Lean build; the committed native fingerprint receipts and exact owner bytes are inputs to the draft. The final candidate still needs the released pristine replay.

`full-reaudit-evidence.json` binds the current task, all five independent role records, exact packets, runtime/event receipts, original judgments, adjudication, decision, report, and 113 manifest binding occurrences. The final decision SHA256 is `7592cfc9bc82067b1f89c4fa3c040111ab8e34ee3eb3e6264cfa9d1b0dacf79c`: accepted, adjudicated, faithful-equivalent under the user convention. The original direct verdict is faithful-equivalent; the original round-trip verdict remains undetermined. The adjudicator resolved its measure-instance evidence gap from the exact native supplement. Source-only profile ambiguity and the contextual printed-bound inconsistency remain recorded. The blind packet appears byte-exactly once in its frozen stdin; the user receipt path/digest is absent there. No new semantic role was invoked for this draft.

Historical raw audit artifacts and its task remain byte-identical. Four historical gate projections changed only their binding objects. The exact baseline projection bytes are copied here, and both endpoint blob identities and changed fields are listed. No assertion is made that the whole historical audit directory stayed byte-identical.

The authoritative current book profile is frozen separately at SHA256 `b140898932e6b43e2340459f2d7b4cfee42fddc18ef1ae307ed1c11e55b2d9ea`; current six-file gate policy recomputes to `57f747572806a1e2874d448e60a859c16ec898e003c69c48819ae8d085652f40`. Baseline recorded profile/policy hashes differ. Historical bytes were not recovered or inferred from those hashes. The exact user receipt (`26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b`) remains a distinct input; it neither edits nor narrows the current book profile.

The coordinator must review this explicit composite-hash convention, use it consistently in final assets/transports, bind the actual candidate and affected-book verdict, and execute the required pristine source/import/signature/body/declaration/build checks. A completed audit and this draft do not by themselves authorize epoch acceptance.

Recompute without writes from the Lean repository root:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -B 'gates/leveque-finite-volume/artifacts/session-20260908/baseline-equation03-transport-draft/freeze-transport.py' --check
```

`run-verification.py` performs that read-only recomputation and records its actual stdout, stderr, exit, helper hash, and the scratch artifact hashes. Its only writes are inside this draft directory. `inspect-blobs.py` and `probe-evidence.py` are read-only navigation helpers; their stdout is not an acceptance certificate.
