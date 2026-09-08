"""Introduce exact tier records for newly committed Chapter 1 production modules."""
from pathlib import Path
import collections,datetime,hashlib,json,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
receipt=json.loads((S/"interpreted-transport-production-verification.json").read_text())
files=[f["path"] for f in receipt["files"] if not f["path"].startswith("ComputationalMathematics/Source/")]
manifest_path=R/"docs/architecture/tiers.json"
manifest=json.loads(manifest_path.read_text())
heads={subprocess.check_output(["git","log","--diff-filter=A","-1","--format=%H","--",f],cwd=R,text=True).strip() for f in files}
assert len(heads)==1 and all(heads),"All files must first have one actual introduction commit."
intro=heads.pop()
date=subprocess.check_output(["git","show","-s","--format=%cI",intro],cwd=R,text=True).strip()
review_date=datetime.datetime.now(datetime.timezone.utc).isoformat()
review={"reviewer":"Codex root executing the authorized Chapter 1 organization loop",
 "status":"accepted","review_date":review_date,
 "evidence":"gates/leveque-finite-volume/artifacts/session-20260908/interpreted-transport-organization-review.md"}
prefixes={r["prefix"].rstrip("."):r["tier"] for r in manifest["prefixes"]}
new_modules=[]
for file in files:
 module=file[:-5].replace("/",".")
 assert module not in manifest["exact"],module
 role="source" if module.startswith("ComputationalMathematics.Source.") else "reusable"
 rationale=("Thin source-local Chapter 1 correspondence; mathematical producers remain in reusable modules."
            if role=="source" else
            "Reusable mathematical definition, theorem or explicit PDE example; source-independent statement and imports.")
 rule={"rule_id":"exact:"+module,"match_kind":"exact","module":module,"role":role,
  "rationale":rationale,"introduction":{"commit":intro,"date":date,"determined_by":"diff_filter_add"},
  "review":review.copy(),"exception":None,"file_present":True}
 hits=sorted([p for p in prefixes if module==p or module.startswith(p+".")],key=len,reverse=True)
 if hits:
  assert prefixes[hits[0]]==role,(module,hits[0])
  rule["extends"]="prefix:"+hits[0]
 manifest["exact"][module]=role
 manifest["exact_rules"].append(rule)
 new_modules.append(module)
manifest["exact"]=dict(sorted(manifest["exact"].items()))
manifest["exact_rules"]=sorted(manifest["exact_rules"],key=lambda x:x["module"])
paths=subprocess.check_output(["git","-c","core.longpaths=true","ls-files","-z"],cwd=R).decode().split("\0")
modules=[f[:-5].replace("/",".") for f in paths if f.endswith(".lean") and
 (f.startswith("ComputationalMathematics/") or f.startswith("NumStability/") or f in ("ComputationalMathematics.lean","NumStability.lean"))]
roles=collections.Counter();decisions=collections.Counter()
for m in modules:
 if m in manifest["exact"]:
  role=manifest["exact"][m];rid="exact:"+m
 else:
  hits=sorted([p for p in prefixes if m==p or m.startswith(p+".")],key=len,reverse=True)
  assert hits,m
  role=prefixes[hits[0]];rid="prefix:"+hits[0]
 roles[role]+=1;decisions[rid]+=1
for rule in manifest["prefix_rules"]:
 rule["modules_decided"]=decisions[rule["rule_id"]]
manifest["counts"]={"by_role":dict(sorted(roles.items())),"exact_rules":len(manifest["exact"]),
 "exact_rules_with_absent_file":0,"prefix_rules":len(prefixes),
 "prefix_rules_deciding_nothing":sum(decisions["prefix:"+p]==0 for p in prefixes),
 "production_modules":len(modules)}
before=manifest_path.read_bytes()
(S/("tiers-before-interpreted-"+hashlib.sha256(before).hexdigest()+".json")).write_bytes(before)
manifest_path.write_text(json.dumps(manifest,indent=1,ensure_ascii=False)+"\n",encoding="utf-8",newline="\n")
record={"schema":1,"introduction_commit":intro,"new_exact_rules":len(new_modules),
 "counts":manifest["counts"],
 "verification":"Exact records cite the actual four-file addition commit, classifying only the two new reusable owners. Aggregates were already connected and checked; run current unchanged tier/layout/compatibility validators."}
(S/"interpreted-tier-update.json").write_text(json.dumps(record,indent=2)+"\n",encoding="utf-8")
print(json.dumps(record,indent=2))
