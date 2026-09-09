from pathlib import Path
import hashlib,json,ast
F=Path(__file__).resolve().parent;O=F.parent/'riemann-routine-fingerprints'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
inputsha=sha(F/'inputs.json');records=[]
for name in ('run-native.py','run-freeze.py','freeze.py'):
    source=O/name;t=source.read_text();reps=[]
    if name in ('run-native.py','freeze.py'):
        a='6fa0a8a7f6a0a090023c2e2fb417fdcbae3e9ed60f136b2f812e198eae5ccede';assert a in t;t=t.replace(a,inputsha);reps.append((a,inputsha))
    if name=='freeze.py':
        changes=[('four-owner','sixteen-owner'),("assert len(records)==len({x['name'] for x in records})==37","assert len(records)==len({x['name'] for x in records}) and len(records)>=150"),('len(oldnames)==1089 and len(oldowners)==147','len(oldnames)==1126 and len(oldowners)==151'),('len(expected)==22','len(expected)==150'),("len(inputs['files'])==len(inputs['selected_modules'])==4","len(inputs['files'])==len(inputs['selected_modules'])==16"),('authored_new_declaration_count=22','authored_new_declaration_count=150'),('prior_owner_pins_verified_unchanged=147','prior_owner_pins_verified_unchanged=151'),('prior_constants_untouched=1089','prior_constants_untouched=1126'),('four retained prior inventories','five retained prior inventories'),('authored_new_declarations=22,owner_modules=4,new_owner_modules=4','authored_new_declarations=150,owner_modules=16,new_owner_modules=16'),('prior_owner_files_untouched=147','prior_owner_files_untouched=151'),('1089+len(records)','1126+len(records)'),('combined_owner_files=151','combined_owner_files=167')]
        for a,b in changes:assert a in t,a;t=t.replace(a,b);reps.append((a,b))
    ast.parse(t);compile(t,str(F/name),'exec');(F/name).write_text(t,encoding='utf-8',newline='\n')
    records.append({'source':{'path':str(source),'sha256':sha(source)},'derived':{'path':str(F/name),'sha256':sha(F/name)},'replacements':reps})
(F/'runner-derivation.json').write_text(json.dumps({'input_manifest_sha256':inputsha,'scripts':records,'syntax':'ast.parse+compile successful; no model role or Git mutation'},indent=2)+'\n',encoding='utf-8',newline='\n')
