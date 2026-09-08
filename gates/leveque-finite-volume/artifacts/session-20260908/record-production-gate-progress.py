"""Record the production placement increment without claiming pending audits passed."""
from pathlib import Path
import collections,hashlib,json,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
gpath=R/"gates/leveque-finite-volume/chapter-01.json"
data=gpath.read_bytes()
prior=S/("gate-before-production-"+hashlib.sha256(data).hexdigest()+".json")
if prior.exists(): assert prior.read_bytes()==data
else: prior.write_bytes(data)
g=json.loads(data)
row=next(r for r in g["rows"] if r["id"]=="LEV-CH01-EQ-1.3-ADVECTED-PROFILE")
assert row["status"]=="PROVED"
for key in ["lean_declarations","contract_hash","blind_pass","direct_pass","round_trip_pass",
 "lean_implies_source","source_implies_lean","classification","faithfulness_task","faithfulness_decision",
 "source_contract_artifact","source_contract_sha256","blind_artifact","blind_sha256",
 "direct_artifact","direct_sha256","round_trip_artifact","round_trip_sha256"]:
 row.pop(key,None)
row["status"]="READY"
row["next_foundation"]="Complete the fresh canonical GLOBAL equation (1.3) successor audit and bind its unchanged integrated producer to the current tree. The earlier profile-era audit remains preserved in the prior gate; it is not asserted to certify the new tree."
ids=json.loads((S/"new-producer-audit-inputs.json").read_text())["tasks"]
byid={x["id"]:x for x in g["rows"]}
for item in ids:
 r=byid[item["row"]]
 assert r["status"]=="READY"
 r["next_foundation"]="Validate the prepared inputs after the recorded unpublished path/LF corrections, complete independent semantic roles for "+item["task_id"]+", and bind the checked canonical producer only after an accepted decision."
byid["LEV-CH01-DISCONTINUITY-INTEGRAL-LAW"]["next_foundation"]="Independently audit the checked combined moving-step witness against the literal and intended integral-law reading; obtain any triggered source/trace adjudication before declaring a discrepancy. The counterexample and corrected rectangle balance are separate checked declarations."
byid["LEV-CH01-RIEMANN-INTERFACE-FLUX"]["next_foundation"]="Finish the explicit-domain rectangle-certified solver/interface adapter with the checked linear nonempty instance, then independently audit the actual cell-average/flux/update correspondence."
closed=[r for r in g["rows"] if r["status"] in ["PROVED","REUSED","DISCREPANCY"]]
semantic=g["verification_loops"]["semantic_equivalence"]
semantic["rows_requiring_check"]=len(closed)
for key,field in [("blind_recorded","blind_pass"),("direct_recorded","direct_pass"),("round_trip_recorded","round_trip_pass")]:
 semantic[key]=sum(r.get(field)=="PASS" for r in closed)
semantic["unresolved_adjudications"]=0
# Released check_tiers measured all 5,911 staged production modules: 20 unclassified.
# Released full check_layout found 34 leaves unreachable from canonical aggregates.
# The subsequent import-only rename/LF receipts leave these two counts unchanged.
g["verification_loops"]["organization_completeness"]={
 "unclassified_modules":20,"duplicate_wrappers":0,"placeholder_findings":0,"canonical_placement_pending":34}
for name in g["verification_evidence"]:
 g["verification_evidence"][name]={"command":"","artifact":"","artifact_sha256":"","exit_code":None,"count":0}
gpath.write_text(json.dumps(g,ensure_ascii=False,indent=2)+"\n",encoding="utf-8",newline="\n")
print(json.dumps({"prior_gate":prior.name,"counts":dict(collections.Counter(r["status"] for r in g["rows"])),
 "organization":g["verification_loops"]["organization_completeness"],"global_verification":"OPEN",
 "closed_row_rebinding":"required before gate validation"}))

