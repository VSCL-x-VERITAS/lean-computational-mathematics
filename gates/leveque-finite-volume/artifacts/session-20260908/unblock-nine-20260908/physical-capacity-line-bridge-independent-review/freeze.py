import hashlib,json
from pathlib import Path
R=Path(r'\\?\C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-capacity-line-bridge-independent-review'
def ref(path):
 data=path.read_bytes()
 return {'path':path.relative_to(R).as_posix(),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
def load(path):return json.loads(path.read_text(encoding='utf-8'))
def put(name,data):
 with (P/name).open('xb') as stream:stream.write((json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode())
verification=load(P/'verification.json')
assert load(P/'check-exit.json')['exit_code']==0
for item in verification['verified_inputs']:assert ref(R/item['path'])['sha256']==item['sha256'],item
files=[ref(path) for path in sorted(P.iterdir()) if path.is_file() and path.name not in {'manifest.json','receipt.json'}]
put('manifest.json',{'schema':1,'kind':'independent-read-only-capacity-bridge-review','source_acceptance':False,'files':files})
put('receipt.json',{'schema':1,'status':'REVIEW_COMPLETE','source_acceptance':False,
 'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),'verification':ref(P/'verification.json'),
 'check_receipt':ref(P/'check-exit.json'),'actual_check_exit':0,
 'theorem_corrections_required':False,'new_proof_runs':0,'new_api_implemented':False,
 'remaining':'Actual capacity-family refinement/projection/order and physical/ghost/face correspondence; admission work is separately assigned.'})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md')}))
