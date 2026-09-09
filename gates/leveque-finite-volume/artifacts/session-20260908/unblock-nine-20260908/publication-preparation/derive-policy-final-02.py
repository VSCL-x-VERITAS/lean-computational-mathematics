"""Add root-declared graph paths and exact newly observed session receipts."""
from pathlib import Path
import copy
import hashlib
import importlib.util
import json

P=Path(__file__).resolve().parent
R=P.parents[5]
S='gates/leveque-finite-volume/artifacts/session-20260908/'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
base=P/'policy-final-01.json'
assert sha(base)=='4eede0249662e96ac45fb5abdb425380a4b5f7e07bd691600fab0c3c9f65b353'
old=json.loads(base.read_bytes()); new=copy.deepcopy(old)
graphs=[S+'architecture-graphs/'+name+ext for name in
    ('unblock-nine-certified-high-resolution-final-source','unblock-nine-certified-high-resolution-sorted-source')
    for ext in ('.json','.md')]
observed=[p for p in sorted((R/S).glob('unblock-nine-*')) if p.is_file() and p.suffix in ('.json','.txt')]
new_receipts=[pin(p) for p in observed if p.relative_to(R).as_posix() not in old['allow_exact']]
new['allow_exact']=sorted(set(old['allow_exact']+graphs+[p['path'] for p in new_receipts]))
new['notes'] += [
    'Root-declared graph successor paths explicitly include certified-high-resolution-final-source and certified-high-resolution-sorted-source, each JSON/Markdown, while retaining the unchanged historical pair.',
    'The old final-current-source-graphs invocation was interrupted after a name collision; its exit receipt is diagnostic only and does not establish a graph capture.',
    'Final layout failed on Analysis import casefold order; retain that output and subsequent repaired-sort capture. Discovery-time source hashes are not final sorted-source pins.'
]
spec=importlib.util.spec_from_file_location('v3',P/'check-publication-allowlist-v3.py')
m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
m.verify_policy(new)
assert set(new['allow_exact']) >= set(old['allow_exact'])
for key in set(old)-{'allow_exact','notes'}: assert old[key]==new[key]
for path in graphs: assert m.disposition(path,new)[0]=='select'
for item in new_receipts: assert sha(R/item['path'])==item['sha256']
out=P/'policy-final-02.json'
with out.open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(new,indent=2)+'\n')
data={'status':'PREPARED_POLICY_ROOT_REVIEW_REQUIRED','base_policy':pin(base),'policy':pin(out),
    'added_graph_paths':graphs,'added_observed_receipts':new_receipts,
    'six_graph_paths_including_historical':sorted(p for p in new['allow_exact'] if p.startswith(S+'architecture-graphs/')),
    'checker_sha256':sha(P/'check-publication-allowlist-v3.py'),
    'graph_capture_validated':False,'source_pins_are_discovery_time_only':True,
    'publication_complete':False,'git_invocations':0}
with (P/'policy-final-02-derivation.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'policy':pin(out),'added_receipts':len(new_receipts),'graph_paths':len(data['six_graph_paths_including_historical']),
                  'archives':len(new['archives']),'publication_complete':False}))
