"""Verify the complete batch10 integration checkpoint without claiming source closure."""
from pathlib import Path
from collections import Counter
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
bind=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
head='24b3a281d19aac39ee745a4168a877bd82f78208'
assert git('rev-parse','HEAD').decode().strip()==head
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics','NumStability').strip()
pins={
'root-batch10-production-placement-verification.json':'8a787a175719f797fe928c580048d2e349d88a7816848b77b98ea37fd7a0e37b',
'root-information-interface-capstone-verification.json':'e79470bf889dc1b0e3382c9fbef278b997eee463ffc943664677621ab2654dcb',
'root-information-coordinate-sweep-verification.json':'19755c0bac4ac2ffa0d5b81ed02023ad1239a8a1ba63a5eea6e802f438e5fb8f',
'root-eigen-fv-qualification-verification.json':'134c763a80150fb97111d1dc770564ee1ceb6406af777625f5871eb847f5ba4f',
'root-nine-row-evidence-verification.json':'9e74e66936f0363fe2a285a553542841e2a3a3a9ca8923c97ec815f80b8ad36d',
'root-nine-row-production-supplement-review.json':'7910821d5476039b5a582f526657c70f084a79a191174958f798d7226666bcf2',
'root-generated-capstone-cache-review.json':'70bd559d57b8f4b641bf0600caec3f1bb95196252945ab076be51260d9926642',
'generated-capstone-cache-preservation/preservation.json':'3bd9a4893d9713259398d5ead7e9cadc4fd7b4792a51c2c5253f125e76837b4c',
'batch7-rebind-preparation/batch10-closed-rows-current/summary.json':'a214864e572faa1cfc04450ed4576b9337cac95455a77914ade9693342588337',
'prospective-source-choice-boundaries-batch10-v2.json':'99fb785787ccfe7906b95ff0dc1d4d774bcd664673cc3c7c9323e9d29ae2c0c3',
'current-thread-question-provenance-v2-batch10/projection.json':'15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc',
'root-blocked-binder-v2-review.json':'fd690bd3ef2a3c33a64741a4c9b2c860c0bdd24be6259356941e7d9920078c85',
'root-blocked-gate-installer-v3-review.json':'30cac253f64b157fc7ea5069b86fcf33ef74d1d5f1c01b31ea8ba9de91d64b2e',
'root-blocked-route-input-constructor-review.json':'9b3174080ae8971840bd0c420140e31eb0bc2beb7ab13a8425ce1d1fe778493d'}
for p,h in pins.items():assert sha(S/p)==h,p
labels=['batch10-foundations-full-build','batch10-tiers','batch10-layout-retry','batch10-compatibility',
'batch10-placeholders','batch10-source-inventory','batch10-graph-capture','batch10-graph-check',
'batch10-expression-export','batch10-closed-audits','batch10-organization-preflight','batch10-gate',
'batch10-trackers-final','root-batch10-campaign-before-checkpoint','root-generated-cache-existing-verification']
checks=[]
for label in labels:
 p=S/(label+'-exit.json');out=S/(label+'-output.txt');n=read(p)
 assert type(n['exit_code']) is int and n['exit_code']==0,label
 assert n.get('raw_output_sha256',n.get('output_sha256'))==sha(out),label
 checks.append(dict(label=label,receipt=bind(p),output=bind(out)))
audits=read(S/'batch10-closed-audits-output.txt')
assert audits['mode']=='released-complete-validation' and audits['closed_rows']==len(audits['records'])==32
assert all(type(x['exit_code']) is int and x['exit_code']==0 for x in audits['records'])
G=R/'gates/leveque-finite-volume/chapter-01.json';g=read(G)
assert sha(G)=='b5538b8881e3a3e58e6cc43aa03344072f4bb9d692516599144820f049599d2e'
counts=Counter(r['status'] for r in g['rows']);assert counts==dict(PROVED=15,REUSED=17,READY=9,SKIPPED=16)
classes=Counter(r['classification'] for r in g['rows'] if r['status'] in ['PROVED','REUSED'])
assert classes=={'faithful-equivalent':28,'faithful-stronger':4}
assert all(x['exit_code'] is None for x in g['verification_evidence'].values())
fp=S/'chapter01-current-expression-fingerprints-24b3.json';f=read(fp)
assert sha(fp)=='c27b9c4b5b0bf1c6fa6f26300045423512118a24c0b24eff2b57f65d77f09400'
assert f['input_commit']==head and len(f['selected_modules'])==111 and f['declaration_count']==556
assert f['new_module_declaration_constants']==493
for x in f['files']:assert sha(R/x['path'])==x['sha256']
graph=S/'architecture-graphs/checkpoint-24b3a281-foundations.json'
assert f['compiled_graph_sha256']==sha(graph) and f['source_tree_sha256']==read(graph)['source']['source_tree_sha256']
assert sha(R/'docs/architecture/tiers.json')=='b300e592159490343408ff78b03ec4f81dfac7efaccd395d3fc5ffa8431cedf1'
cache=read(S/'generated-capstone-cache-preservation/preservation.json')
for x in cache['files']:
 assert sha(R/x['original_path'])==sha(R/x['snapshot_path'])==x['original_sha256']
 assert not git('ls-files','--',x['original_path']).strip()
 assert git('cat-file','blob','HEAD:'+x['original_path'])==(R/x['snapshot_path']).read_bytes()
assert set(git('diff','--cached','--name-only').decode().splitlines())=={x['original_path'] for x in cache['files']}
out=S/'root-batch10-checkpoint-verification.json'
v=dict(schema=1,input_commit=head,gate=bind(G),status_counts=dict(counts),classifications=dict(classes),
formalized_objects=32,remaining_objects=9,denominator=41,percentage=78.05,skipped=16,deferred=0,
verification_artifacts=[bind(S/p) for p in pins]+[bind(fp)],checks=checks,graph=bind(graph),
tiers=bind(R/'docs/architecture/tiers.json'),cache_representation=cache['files'],
scope='Nine new reusable owners exposed, native checked and fingerprinted; unchanged 32 accepted rows rebind and full audit validation pass. Current source/layout/tier/compatibility/hygiene/graph checks pass. Two accidentally tracked historical compiled outputs are preserved as exact snapshots with a reviewed replay map. No pending source choice is adopted. Final per-row route conclusion, native final-context receipts, global evidence and terminal checker/reconciliation remain to be completed.')
with out.open('x',encoding='utf-8') as h:json.dump(v,h,indent=2);h.write('\n')
print(json.dumps(dict(status='PASS',verification=bind(out),counts=dict(counts),classes=dict(classes))))

