from pathlib import Path
import ast,hashlib,json,re
G=Path(__file__).resolve().parent;R=G.parents[5];D=G.parent
initial=json.loads((G/'initial-placement.json').read_text())
rename=initial['namespace_changes']+[
 ('coordinate_highResolution_sourceContract','coordinate_highResolution_specification')]
def changed(t):
    for a,b in rename:t=t.replace(a,b)
    return t
def declarations(t):
    ns=[];items=[]
    for line in t.splitlines():
        n=re.match(r'^namespace\s+(\S+)',line)
        if n:ns.append(n[1]);continue
        if re.match(r'^end\b',line):
            if ns:ns.pop()
            continue
        d=re.match(r'^(?:@\[[^]]+\]\s*)?(?:noncomputable\s+)?(def|theorem|structure|abbrev)\s+([^\s(:]+)',line)
        if d:items.append({'name':'.'.join(ns+[d[2]]),'kind':d[1]})
    return items
files=[]
for f in initial['files']:
    p=R/f['path'];t=p.read_text();ds=declarations(t)
    files.append({**f,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'declarations':[d['name'] for d in ds], 'declaration_kinds':ds,'lines':len(t.splitlines())})
imports='\n'.join('import '+f['module'] for f in files)+'\n'
checks='\n'.join('#check '+n+'\n#print axioms '+n for f in files for n in f['declarations'])+'\n'
(G/'CanonicalChecks.lean').write_text(imports+'\n'+checks,encoding='utf-8',newline='\n')
parts=[];refs=[]
for name in ('Fixture.lean.fragment','Application.lean.fragment'):
    p=D/'dim-joint-primary-witness'/name;raw=p.read_bytes();refs.append({'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(raw).hexdigest()});parts.append(changed(raw.decode()))
joint='\n'.join(parts)
jointchecks='\n'.join('#check '+d['name']+'\n#print axioms '+d['name'] for d in declarations(joint))+'\n'
(G/'Joint.lean').write_text(imports+'\n'+joint+'\n'+jointchecks,encoding='utf-8',newline='\n')
(G/'native.py').write_bytes((D/'directional-reference-repair/native.py').read_bytes())
(G/'current-check-inventory.json').write_text(json.dumps({'files':files,'joint_inputs':refs,'joint_declarations':declarations(joint),'renames':rename},indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'production_declarations':sum(len(f['declarations']) for f in files),'joint_declarations':len(declarations(joint))}))
