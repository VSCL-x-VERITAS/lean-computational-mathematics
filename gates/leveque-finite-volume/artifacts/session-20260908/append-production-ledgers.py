"""Append observed process and source issues without rewriting prior entries."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
R=S.parents[3]
process=R/"ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"
book=R/"ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"
entries={
process:[
"| BF-LEV-RUN-20260908-008 | 2026-09-08 | canonical placement and prepared-input stability | New directories named ConservationLaw, Hyperbolicity and RiemannData collided with existing declaration-bearing public owner files; concurrent new-task preparation correctly failed when those unpublished paths moved. | Full released layout scan of 5911 modules identified three new declaration-bearing umbrellas, 20 unclassified modules and 34 unreachable leaves; production-rename-receipt.json records 12 new-only moves and 14 import changes with existing owner hashes unchanged. Failed preparations are preserved by released --force archival. | Byte-level input changes require new preparation before any judge result is accepted. | path collisions repaired; tier/aggregate classification and refreshed preparation remain actionable | Root: retain snapshots and failed outputs; introduce tier records referencing the actual production commit, update aggregates, rerun full checks and prepared validators. |",
"| BF-LEV-RUN-20260908-009 | 2026-09-08 | fresh-role runtime capacity | Collaboration spawn returned agent thread limit reached although the fourth retained judge was completed; interrupt did not release the retained thread. | Eq1.1 faithfulness/orchestration contains fresh separate CLI requests, exact runtime IDs, event logs, raw finals and schema validation. Blind UUID 01a08025-5926-7513-b6e5-5c3e1c04dd98 used no tools; later fresh direct, roundtrip and adjudication roles produced a complete accepted decision. | Reusing the completed contaminated judge would violate source blindness. | resolved through the sealed kit's permitted separate-clean-session fallback | Run at most one fresh CLI role alongside root and two coordinators; preserve full inline inputs, actual model/effort and attempted/blocked tool-use evidence. No host cap change, host restart, log deletion or contaminated role reuse. |",
"| BF-LEV-RUN-20260908-010 | 2026-09-08 | new production bytes on Windows | Ten new Huber production files used CRLF while root .gitattributes requires LF; exact staged-byte verification rejected the mismatch. A deeply nested snapshot path also exceeded the native Windows path limit before any production mutation. | Flat content-addressed pre-rename snapshots; shock-production/lf-normalization/receipt.json SHA-256 0f3685805a348ca8915cee4c26ea98c705801f63c04fe653bc0f1de00c2845d5; subsequent staging of all 34 production files reports zero index/worktree byte mismatches. | Normalization without renewed hashes would invalidate proof/audit bindings. | production bytes corrected; fresh LF checks required before freeze | Preserve every prior snapshot under Session's existing * -text override; use short evidence paths and exact POSIX staging verification. Do not normalize frozen audit evidence or change repository-wide attributes. |"
],
book:[
"| LEV-C1-SHOCK-004 | LEV-CH01-NONLINEAR-SHOCK-FORMATION | complete candidate and effective domain | Section 1.1.2 permits spontaneous jumps from smooth data but does not supply a named witness in this chapter | New reusable Huber-flux continuation and leveque01_nonlinear_shock_formation provide a C1 nonaffine flux, C-infinity initial data, spatial continuity before T=1, distinct one-sided traces at T and full oriented rectangle balance | native checked candidate; independent source audit remains OPEN | shock-continuation/final-verification.json and shock-production; production source wrapper's LF SHA-256 ff38f13c8d6dfa9b66558340d588eb92b9d0d02d677b09a1825000d3e3e7a753 | Audit the existential source claim explicitly: witness data -x are unbounded, flux is C1 rather than C2, and no general entropy uniqueness theorem is asserted. |",
"| LEV-C1-DOMAIN-001-PRODUCTION-WITNESS | LEV-CH01-DISCONTINUITY-INTEGRAL-LAW; LEV-CH01-RIEMANN-INTERFACE-FLUX | precise positive-time classical failure | The moving jump has no classical PDE derivative at x=0,t=1 and no classical mass derivative for the unit cell at t=1, for every chosen point value at the jump; its rectangle balance remains valid | leveque01_movingStep_classicalDerivative_witness, leveque01_movingStep_rectangleBalance and their combined witness in the new DiscontinuityWitnesses source module | both failures and corrected rectangle balance checked; no source discrepancy accepted yet | production-postrename-build-exit.json and production-postrename-declarations-output.txt; new immutable discontinuity audit task | Independent source/trace adjudication must decide the printed (1.10) reading. Complete a separate explicit-domain rectangle-certified interface adapter instead of silently changing the existing public classical certificate. |"
]}
records=[]
for path,rows in entries.items():
 before=path.read_bytes()
 backup=S/("ledger-before-production-"+hashlib.sha256(before).hexdigest()+".bin")
 if not backup.exists():backup.write_bytes(before)
 text=before.decode("utf-8").replace("\r\n","\n")
 for row in rows:
  ident=row.split("|")[1].strip()
  assert ident not in text,ident
  text=text.rstrip()+"\n"+row+"\n"
 path.write_text(text,encoding="utf-8",newline="\n")
 records.append({"path":path.relative_to(R).as_posix(),"before_sha256":hashlib.sha256(before).hexdigest(),"added_entries":len(rows),"sha256":hashlib.sha256(path.read_bytes()).hexdigest()})
(S/"production-ledger-update.json").write_text(json.dumps({"schema":1,"files":records},indent=2)+"\n",encoding="utf-8")
print(json.dumps({"process_entries":3,"source_entries":2}))

