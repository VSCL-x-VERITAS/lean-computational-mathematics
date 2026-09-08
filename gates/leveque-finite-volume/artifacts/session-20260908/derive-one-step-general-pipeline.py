from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;src=S/'run-advection-sentence-audit-pipeline.py';raw=src.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='69609838774bfd6e5931e02956420f9f97e68b247f215f69b1039464c4484ff1'
text=raw.decode()
for old,new in [('LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908','LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908'),('sentence-scope-lineage.json','general-domain-lineage.json'),('74fe68c6ce9e15dbc2f8f07fd801905b4b259bf05aa14f553b71608e5203a5be','9d378e48a5d5632f5b7bea33f397645b87433811b245231ca441fedc6d17718d'),('advection-sentence-route','one-step-general-audit-route'),('advection-sentence-prepare','one-step-general-audit-prepare')]:
 assert text.count(old)==1,old;text=text.replace(old,new)
p=S/'run-one-step-general-audit-pipeline.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
print(json.dumps({'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'base_sha256':hashlib.sha256(raw).hexdigest()}))
