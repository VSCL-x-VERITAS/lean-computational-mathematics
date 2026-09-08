"""Derive six-leaf organization helpers from preserved reviewed batch-eight helpers."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
head=subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()
assert head=='521f73a23a95a842928c581fa011a46379b3b547'
def write(p,text):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(text)
derivations=[]
def derive(parent,target,changes):
 src=(S/parent).read_text(encoding='utf-8')
 for old,new in changes:
  assert old in src,(parent,old)
  src=src.replace(old,new)
 write(S/target,src)
 derivations.append({'parent':parent,'parent_sha256':sha(S/parent),'child':target,
  'child_sha256':sha(S/target),'changes':changes})
derive('classify-batch8-foundations.py','classify-batch9-foundations.py',[
 ('ten committed','six committed'),('03c81fa2a551b5089133c958deedc4828899adbd',head),
 ('7e7bd763431edadb9e87b4deb48e1bc7796a3294907b6b06f69c1a57304b244e','b2b31b08695ca45d1594adc1709e714af0373c560e3bafbc1a8ede2e5f3e6510'),
 ('root-batch8-placement-verification.json','root-batch9-production-placement-verification.json'),
 ("len(review['files'])==10","len(review['files'])==6"),
 ('Generic mathematics or explicit example in the reviewed jump, rectangle production balance, coordinate-line conservation or admitted-method flux-error API; no source-specific contract.',
  'Generic normalized-average laws, trace estimate, returned-field method, conditional error estimates or explicit example; no source-specific contract.'),
 ('batch8-foundations-organization-review.md','batch9-foundations-organization-review.md'),
 ('==5953','==5959'),("roles['reusable']==648","roles['reusable']==654"),
 ('batch8-tiers-before-','batch9-tiers-before-'),("'new_exact_rules':10","'new_exact_rules':6"),
 ('batch8-tier-update.json','batch9-tier-update.json')])
oldpath=S/'chapter01-current-expression-fingerprints-03c8.json'
assert sha(oldpath)=='8b8fa9ce9c192a689a613625a77fd25293431c4687db6e01f71864ff519b3b72'
old=read(oldpath)
for f in old['files']:assert sha(R/f['path'])==f['sha256']
review=read(S/'root-batch9-production-placement-verification.json')
assert sha(S/'root-batch9-production-placement-verification.json')=='7972c821babf7148e14e7b4c3a8e2ad28fb04a072f795c224163dff7f393cddd'
entry=read(S/'batch9-analysis-imports.json');assert sha(R/entry['path'])==entry['after_sha256']
files=[{k:f[k] for k in ('path','sha256')} for f in review['files']]
modules=sorted(f['module'] for f in review['files'])
assert len(modules)==6 and not set(modules)&set(old['selected_modules'])
parent=S/'export-batch8-declaration-expressions.lean';src=parent.read_text(encoding='utf-8')
start=src.index('private def selectedModules : Array String := #[\n');end=src.index('\n]\n\nrun_cmd do',start)
src=src[:start]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+src[end:]
assert src.count('.lake/chapter01-batch8-expressions.jsonl')==1
src=src.replace('.lake/chapter01-batch8-expressions.jsonl','.lake/chapter01-batch9-expressions.jsonl')
export=S/'export-batch9-declaration-expressions.lean';write(export,src)
expected=sorted(n for f in review['files'] for n in f['declarations']);assert len(set(expected))==len(expected)==37
inputs={'schema':1,'files':files,'selected_modules':modules,'expected_authored_declarations':expected,
 'exporter_path':export.relative_to(R).as_posix(),'exporter_sha256':sha(export),'normalization':old['normalization'],
 'prior_exporter_sha256':sha(parent),'prior_fingerprints_sha256':sha(oldpath),'input_commit':head,'entry_point_additions':entry}
inp=S/'batch9-expression-export-inputs.json';write(inp,json.dumps(inputs,indent=2)+'\n')
derive('merge-batch8-expression-fingerprints.py','merge-batch9-expression-fingerprints.py',[
 ("out=S/'chapter01-current-expression-fingerprints-03c8.json'","out=S/'chapter01-current-expression-fingerprints-521f.json'"),
 ('chapter01-current-expression-fingerprints-4d4b.json','chapter01-current-expression-fingerprints-03c8.json'),
 ('05f80d5c97bdeb92cdc2acabb13b19004568b79c80de02012b2c44ad8cd149df',sha(oldpath)),
 ('batch8-expression-export-inputs.json','batch9-expression-export-inputs.json'),
 ('b92840a966312c1e4f00dbd61239cd12727b6a0840e90e8fe52beb73ae1c3df2',sha(inp)),
 ('batch8-expression-export','batch9-expression-export'),
 ('batch8-foundations-full-build-after-exposure','batch9-foundations-full-build'),
 ('batch8-graph-capture','batch9-graph-capture'),('batch8-graph-check','batch9-graph-check'),
 ('chapter01-batch8-expressions.jsonl','chapter01-batch9-expressions.jsonl'),
 ('len(expected)==43','len(expected)==37'),('len(newpaths)==76','len(newpaths)==82'),
 ('checkpoint-03c81fa2-foundations.json','checkpoint-521f73a2-foundations.json'),('==5953','==5959'),
 ('All 86 previous declaration-owner sources retain their exact hashes. Ten disjoint new owners',
  'All 96 previous declaration-owner sources retain their exact hashes. Six disjoint new owners')])
out=S/'batch9-organization-derivations.json';write(out,json.dumps({'schema':1,'input_commit':head,
 'derivations':derivations,'exporter_parent_sha256':sha(parent),'exporter_sha256':sha(export),
 'export_inputs_sha256':sha(inp),'expression_serializer_and_parser_unchanged':True},indent=2)+'\n')
print(json.dumps({'status':'PASS','derivations_sha256':sha(out),'export_inputs_sha256':sha(inp),
 'exporter_sha256':sha(export),'modules':6,'expected_authored_declarations':37}))
