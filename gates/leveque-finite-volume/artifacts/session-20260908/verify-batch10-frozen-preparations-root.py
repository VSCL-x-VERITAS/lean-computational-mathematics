from pathlib import Path
import hashlib,json,os
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def native(value,base):
 value=value.replace('\\','/')
 if os.name!='nt' and value.startswith('C:/'):value='/c/'+value[3:]
 p=Path(value);return p if p.is_absolute() else base/p
def refs(x,base):
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and 'sha256' in x:
   p=native(x['path'],base);assert sha(p)==x['sha256'],p
  for v in x.values():refs(v,base)
 elif isinstance(x,list):
  for v in x:refs(v,base)
for folder,pin in [
 ('batch10-organization-preparation','78eecc11f749dbf173947320913b32d2418002ce531b145f00c429314e96ae61'),
 ('nine-row-local-route-review-batch10','270b25158f597e519dfba22957ec89c7afa94941e7035a06b2e2c20a173fb804')]:
 P=S/folder;m=P/'manifest.json';assert sha(m)==pin
 data=json.loads(m.read_bytes())
 for entry in data['files']:assert sha(P/entry['path'])==entry['sha256']
P=S/'batch10-organization-preparation'
m=json.loads((P/'manifest.json').read_bytes())
for name,pin in m['pinned_parents'].items():assert sha(S/name)==pin
assert sha(R/'docs/architecture/tiers.json')==m['tiers_before_sha256']
receipt=json.loads((P/'tests-02.receipt.json').read_bytes())
assert type(receipt['exit_code']) is int and receipt['exit_code']==0
refs(receipt,P)
tests=json.loads((P/'tests.json').read_bytes())
assert tests['count']==len(tests['tests'])==17
assert all(x['result'] in {'PASS','PASS_REJECTED'} for x in tests['tests'])
assert sha(P/'prepare-v2.py')=='818a7fce01d5e3d0eba0d8abdca7a166ba07493706d0fbb8486016c9227c5c1b'
out=S/'root-batch10-organization-preparation-review.json'
result=dict(status='PASS',source_acceptance=False,helper_sha256=sha(P/'prepare-v2.py'),manifest_sha256=sha(P/'manifest.json'),actual_synthetic_exit=0,synthetic_tests=17,
 root_review='Read complete authoritative helper, README, test code and actual pinned receipt. Strict nine-file inventory, actual runtime HEAD/introduction checks, original 27 prefixes and existing roles, unchanged expression serializer/parser, old-owner hashes and disjoint exact exports retained. IO-only MAX_PATH repair preserves failed attempt. Actual operational derivation and generated-helper review remain required before execution.',
 nine_row_review_manifest_sha256=sha(S/'nine-row-local-route-review-batch10/manifest.json'),
 nine_row_root_byte_check_sha256=sha(S/'root-nine-row-evidence-verification.json'),
 scope='Helper preparation and bounded diagnostic review only; no gate classification, global-zero-actionable assertion, production integration or generated helper execution.')
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(result,indent=2)+'\n')
print(json.dumps(dict(status='PASS',review_sha256=sha(out),synthetic_tests=17)))

