from pathlib import Path
import hashlib,json
F=Path(__file__).resolve().parent;D=F.parent;O=D/'riemann-routine-fingerprints'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
t=(O/'prepare.py').read_text()
reps=[('four-owner','sixteen-owner'),('Four frozen Info Routine production owners','Sixteen frozen directional high-resolution production owners'),('len(known)==147 and len(oldnames)==1089','len(known)==151 and len(oldnames)==1126'),("owner_manifest=D/'riemann-routine-production/files.json'","owner_manifest=D/'directional-high-resolution-production/production-files-frozen.json'"),('4c910ec10cee56f2d1db68fb9042852dfd62335b3690255385cfb5320287f535','cb7623870ad874124148177f971a30c9e18e6b0172d2e21e59c6ae135f9c4538'),('len(files)==4 and sum(len(x[\'declarations\']) for x in files)==22','len(files)==16 and sum(len(x[\'declarations\']) for x in files)==150'),("ExportRoutineDeclarations.lean","ExportDirectionalDeclarations.lean"),('prior_owner_count=147,prior_constant_count=1089','prior_owner_count=151,prior_constant_count=1126'),('four separately pinned worktree owners','sixteen separately pinned worktree owners'),("ref(D/'riemann-routine-production/manifest.json'),ref(D/'riemann-routine-production/receipt.json')","ref(D/'directional-high-resolution-production/manifest.json'),ref(D/'directional-high-resolution-production/final-receipt.json')"),('owners=4,authored_new_declarations=22','owners=16,authored_new_declarations=150'),('prior_constants=1089,prior_owners=147','prior_constants=1126,prior_owners=151')]
for a,b in reps:assert a in t,a;t=t.replace(a,b)
a="(D/'local-replacement-fingerprints/additional-expression-fingerprints.json','301f6e2f2098742eac520acc28bf5ffbd66c4b6cdff64b22572c9cd2c4991734')]"
b=a[:-1]+",\n (D/'riemann-routine-fingerprints/additional-expression-fingerprints.json','af1b54db80c0b2663989b9eb7683ab2f0f049fa17ec6e302f684f1e7a2ddc1f6')]"
assert a in t;t=t.replace(a,b);reps.append((a,b))
(F/'prepare.py').write_text(t,encoding='utf-8',newline='\n')
(F/'head.py').write_bytes((O/'head.py').read_bytes())
(F/'prepare-derivation.json').write_text(json.dumps({'source':{'path':str(O/'prepare.py'),'sha256':sha(O/'prepare.py')},'replacements':reps,'derived_sha256':sha(F/'prepare.py'),'serializer_and_parser_unchanged':True},indent=2)+'\n',encoding='utf-8',newline='\n')
