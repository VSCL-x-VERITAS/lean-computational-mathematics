"""Create a count-configured analysis successor; never construct origin assets or payloads."""
from pathlib import Path
import ast, hashlib, json
P=Path(__file__).resolve().parent
D=P.parent; R=D.parents[4]
assert R.name=='lean-computational-mathematics'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(name,v):
    with (P/name).open('xb') as f:f.write((json.dumps(v,indent=2)+'\n').encode())
old=D/'final-reconciliation-mapping-inputs/capture_current_mapping.py'
raw=old.read_text(encoding='utf-8')
text=raw
changes=[]
def replace(a,b):
    global text
    assert text.count(a)==1,a[:100]
    text=text.replace(a,b);changes.append({'old':a,'new':b})
replace("    topology=bound(config['topology']); records={}; owners={}; fps=[]; origins={}",
"    topology=bound(config['topology']); policy=bound(config['preparation_policy'])\n    require([e['inventory'] for e in config['fingerprints']]==policy['current_work_fingerprint_refs'],'policy exact current refs')\n    records={}; owners={}; fps=[]; origins={}")
replace("    require(len(records)==1426 and len(owners)==171 and len(fps)==7,'expected exact seven inventories / 1426 / 171')",
"    require((len(records),len(owners),len(fps))==(config['expected_records'],config['expected_owners'],len(policy['current_work_fingerprint_refs'])),'explicit current census')")
replace("    future=read(d/'final-certified-complete-declarations/manifest.json')", "    future=bound(config['complete_declaration_manifest'])")
start=text.index('    def git(*args):')
end=text.index('    variants=[]',start)
removed=text[start:end]
replacement="""    manual=bound(config['manual_review'])
    head=manual['input_commit']; require(head==config['expected_head'],'manual recorded HEAD')
    require(manual['anchor']==config['anchor'],'manual anchor')
    paths=manual['reviewed_changed_source_paths']; require(len(paths)==config['expected_changed_paths'],'manual changed scope')
    require(len(manual['source_files'])==config['expected_semantic_paths'],'manual semantic scope')
    for item in manual['source_files']:
        require(digest((root/item['path']).read_bytes())==item['sha256'],'manual source drift '+item['path'])
    staged=None
    protected={}
    for item in bs['lanes'][1]['fingerprints']:
        for r in bound(item)['records']:
            require(r['name'] not in protected,'duplicate inspection record')
            protected[r['name']]=r
    require(set(protected)==set(old),'inspection catalogue/record names')
    protected_differences=[{'name':n,'fields':[k for k in sorted(set(v)|set(records[n])) if v.get(k)!=records[n].get(k)]}
                          for n,v in sorted(protected.items()) if n not in records or v!=records[n]]
    require(not protected_differences,'protected inspection record changed')
"""
text=text[:start]+replacement+text[end:];changes.append({'old':removed,'new':replacement})
replace("             'changed_lean_paths_from_anchor':len(paths),'current_staged_lean_paths':len(staged),",
"             'changed_lean_paths_from_anchor':len(paths),'semantic_review_paths':len(manual['source_files']),\n             'scope_provenance':config['manual_review'],'scope_collection':'Frozen manual review; no new Git invocation',\n             'all_protected_records_byte_equal_as_json_values':not protected_differences,'current_staged_lean_paths':None,")
replace("    require(git('rev-parse','HEAD').decode().strip()==head,'HEAD changed')", "    require(bound(config['manual_review'])==manual,'manual changed')")
replace("             'new-policy-proposals.json':newpolicies,'source-row-assessment.json':rowdata,'nondeclaration-variants.json':variants,",
"             'source-row-assessment.json':[{k:v for k,v in row.items() if k not in ('old_context','current_context')} for row in rowdata],\n             'nondeclaration-variants.json':variants,")
# No producer/policy object is written. The old canonical hash calculations are retained.
replace("import argparse, collections, hashlib, importlib.util, json, re, subprocess", "import argparse, collections, hashlib, json, re")
ast.parse(text)
assert 'subprocess' not in text and "'new-policy-proposals.json'" not in text and 'def git(' not in text
with (P/'assess.py').open('xb') as f:f.write(text.encode())
policy_path=D/'physical-reconciliation-policy-preparation/preparation-policy.json'
assert sha(policy_path)=='f23e21fc22aff140885cc9d3de880c7ea736b1df55aea9f97ba8cf7c84d5ae83'
policy=json.loads(policy_path.read_bytes())
manual_path=D/'physical-final-organization-preparation/manual-current-01/review-data.json'
manual=json.loads(manual_path.read_bytes())
fp=policy['current_work_fingerprint_refs'][0]
f=json.loads((R/fp['path']).read_bytes());assert sha(R/fp['path'])==fp['sha256']
config={'schema':1,'status':'ROOT_REVIEW_REQUIRED','source_acceptance':False,
    'preparation_policy':ref(policy_path),'expected_head':policy['inspection_head'],'anchor':policy['anchor'],
    'topology':ref(R/'.formalization/library-topology.json'),'fingerprints':[{'inventory':fp,'expected_records':len(f['records'])}],
    'expected_records':1688,'expected_owners':183,'expected_changed_paths':149,'expected_semantic_paths':221,
    'manual_review':ref(manual_path),'complete_declaration_manifest':ref(D/'physical-current-complete-declarations/manifest.json')}
put('assessment-config.json',config)
put('derivation.json',{'original':ref(old),'successor':ref(P/'assess.py'),'changes':changes,
    'scope':'Analysis only. Canonical producer/policy hashing and exact overrides retained in memory; payload output and all Git execution removed. Frozen scope and explicit count config replace historical hardcodes.'})
gate=R/'gates/leveque-finite-volume/chapter-01.json'
put('run-inputs.json',{'root':str(R),'config':ref(P/'assessment-config.json'),'gate':ref(gate),
    'output':str(P/'observed-01'),'status':'ANALYSIS_ONLY'})
print(json.dumps({'config':ref(P/'assessment-config.json'),'gate':ref(gate),'script':ref(P/'assess.py')}))
