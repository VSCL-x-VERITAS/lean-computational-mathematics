"""Derive the seventh, four-owner preparation from the prior frozen increment."""
from pathlib import Path
import ast,hashlib,json,re
F=Path(__file__).resolve().parent;B=F.parent/'dim-high-resolution-fingerprints'
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
source=(B/'prepare.py').read_text(encoding='utf-8')
old=source
def replace(a,b):
    global source
    assert source.count(a)==1,(a,source.count(a))
    source=source.replace(a,b)
replace("(D/'riemann-routine-fingerprints/additional-expression-fingerprints.json','af1b54db80c0b2663989b9eb7683ab2f0f049fa17ec6e302f684f1e7a2ddc1f6')]",
    "(D/'riemann-routine-fingerprints/additional-expression-fingerprints.json','af1b54db80c0b2663989b9eb7683ab2f0f049fa17ec6e302f684f1e7a2ddc1f6'),\n (D/'dim-high-resolution-fingerprints/additional-expression-fingerprints.json','a5ebaa1d6fc0af3331421f683763046813505a9d0741504b03fd4e9b52366a49')]")
for a,b in [('151','167'),('1126','1419'),('150','7'),('16','4')]:source=re.sub(r'\b'+a+r'\b',b,source)
source=source.replace('sixteen-owner','four-owner').replace('Sixteen frozen directional high-resolution','Four frozen certified Riemann routine').replace('sixteen separately','four separately')
source=source.replace('directional-high-resolution-production/','riemann-certified-production/')
replace("assert sha(owner_manifest)=='cb7623870ad874124148177f971a30c9e18e6b0172d2e21e59c6ae135f9c4538'",
    "assert sha(owner_manifest)=='034d23abd186f3084cc06e7f11150f5cf29ad5f3e32e9c0d456fce2bce90cb41'")
replace(" assert len((R/f['path']).read_text(encoding='utf-8').splitlines())==f['lines']\n",'')
source=source.replace('ExportDirectionalDeclarations.lean','ExportCertifiedDeclarations.lean')
source=source.replace("ref(D/'riemann-certified-production/final-receipt.json')","ref(D/'riemann-certified-production/receipt.json')")
ast.parse(source);compile(source,str(F/'prepare.py'),'exec')
with (F/'prepare.py').open('x',encoding='utf-8',newline='\n') as out:out.write(source)
record={'base':{'path':str((B/'prepare.py').resolve()),'sha256':hashlib.sha256((B/'prepare.py').read_bytes()).hexdigest()},
    'derived':{'path':str((F/'prepare.py').resolve()),'sha256':hashlib.sha256((F/'prepare.py').read_bytes()).hexdigest()},
    'changes':'Exact four-owner/7-author census, six prior inventory pins, production inventory refs, exporter filename and counting prose only; serializer remains copied by unchanged extraction.',
    'prior_owners':167,'prior_constants':1419,'new_owners':4,'new_authored':7,'invocation':False}
with (F/'prepare-derivation.json').open('x',encoding='utf-8') as out:json.dump(record,out,indent=2);out.write('\n')
print(json.dumps(record,indent=2))
