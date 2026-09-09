from pathlib import Path
import re,json,hashlib
P=Path(__file__).resolve().parent
names=['Finite.lean','Quality.lean','Execution.fragment','Propagation.lean','Composition.fragment','FiniteCartesian.fragment','Primary.fragment']
records=[]
for name in names:
    namespaces=[]
    for line_number,line in enumerate((P/name).read_text(encoding='utf-8').splitlines(),1):
        n=re.match(r'^namespace\s+(\S+)',line)
        if n: namespaces.append(n.group(1));continue
        if re.match(r'^end\b',line):
            if namespaces:namespaces.pop()
            continue
        d=re.match(r'^(?:noncomputable\s+)?(?:def|theorem|structure)\s+([^\s(:]+)',line)
        if d:records.append({'name':'.'.join(namespaces+[d.group(1)]),'file':name,'line':line_number})
assert len({r['name'] for r in records})==len(records)
primary=(P/'Primary.lean').read_text(encoding='utf-8')
checks='\n'.join('#check '+r['name']+'\n#print axioms '+r['name'] for r in records)
(P/'CoreChecks.lean').write_text(primary+'\n'+checks+'\n',encoding='utf-8',newline='\n')
(P/'core-authored-check-input.json').write_text(json.dumps({'status':'names-await-native-check','declarations':records,
    'sources':[{ 'path':n,'sha256':hashlib.sha256((P/n).read_bytes()).hexdigest()} for n in names]},indent=2)+'\n',encoding='utf-8',newline='\n')
print(len(records))
