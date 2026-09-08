"""Root verification of frozen final reviews before operational installation."""
from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
def host(v,base=R):
 v=str(v)
 if v.startswith('/c/'):v='C:/'+v[3:]
 p=Path(v)
 if not p.is_absolute():p=base/p
 return Path('\\\\?\\'+str(p.resolve())) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
def sha(p):return hashlib.sha256(host(p).read_bytes()).hexdigest()
def read(p):return json.loads(host(p).read_bytes())
def bound(item,base=R):
 p=host(item['path'],base);assert sha(p)==item['sha256'],item
 return p
A=S/'final-material-choice-independent-review-80f5';B=S/'final-blocked-proposal-independent-review-80f5'
pins=[
(A/'manifest.json','13c53784327f1b3f448173672529744e45f84c24ced2eee6d2bdca5d2749f21e'),
(A/'review.json','9048c6fe38d8f1bbb553c28acf6416084c28a32c70666abbf7409431e31f325a'),
(A/'REVIEW.md','e0734c72030c19d951dab87dbb4dd082aa4a3b97079908df3c457caaf8f66478'),
(A/'verification-v2.json','e5a1e0770271dd81f0f1d74e0895212db6e16afbb1fda1469b4fe027d585f7de'),
(B/'manifest.json','9c70bdf2630e3ae3126a77ade4299973086136ca7f49305d265428985d7bdd7c'),
(B/'final-receipt.json','83d9a79753d8367f578c42ea8c09463d1544d42813998c38b7c0c934f45d1b50'),
(B/'REVIEW.md','493063148d7284baf81131cb64c2e4a72be1c98c2c2366117feb273152ac0d94'),
]
for p,h in pins:assert sha(p)==h,(p,h)
count=0
for directory,key in [(A,'observed_files'),(B,'input_files')]:
 m=read(directory/'manifest.json')
 for item in m['files']:bound(item,directory)
 v=read(directory/('verification-v2.json' if directory==A else 'verification.json'))
 for item in v[key]:bound(item);count+=1
 assert len(v[key])==(661 if directory==A else 338)
e=read(A/'verification-v2-exit.json');assert e['exit_code']==0
assert sha(A/'verification-v2-output.txt')==e['output_sha256']
e=read(B/'check-01.exit.json');assert e['exit_code']==0
for item in e['inputs']+[e['output']]:bound(item)
review=read(A/'review.json');assert len(review['rows'])==9
for row in review['rows']:
 assert row['supports_proposed_local_completion_within_reviewed_contract'] is True
 for key in ['necessary_local_math_gaps','necessary_consumer_gaps','necessary_integration_gaps','necessary_source_review_gaps','unwarranted_choice_blockers']:assert row[key]==[]
gate=R/'gates/leveque-finite-volume/chapter-01.json'
assert sha(gate)=='b5538b8881e3a3e58e6cc43aa03344072f4bb9d692516599144820f049599d2e'
head=subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()
assert head=='80f5d4340d507dbc347a806717ff31c5a9aace72'
result={'kind':'root-final-reviews-verification','input_commit':head,'reviewed_pins':[{'path':str(p),'sha256':h} for p,h in pins],'verified_input_bindings':count,
'local_completion_review_supported':True,'mechanical_review_passed':True,'operational_gate_sha256':sha(gate),
'root_assessment':'Accept both bounded reviews within their stated prospective contracts. Preserve all source ambiguity. Execute the reviewed exact installer and separate installed verification; no source choice or terminal verdict is inferred from this review.'}
target=S/'root-final-reviews-verification-80f5.json'
with target.open('xb') as f:f.write((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'status':'PASS','bindings':count,'receipt_sha256':sha(target)}))
