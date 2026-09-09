from pathlib import Path
import re,json
h=Path(__file__).resolve().parent
files=['Geometry.lean.fragment','Boundary.lean.fragment','Execution.lean.fragment','Nonconstant.lean.fragment','ReferenceConnection.lean.fragment']
inventory=[]
for name in files:
 decls=[]
 for line in (h/name).read_text(encoding='utf-8').splitlines():
  m=re.match(r'^(?:noncomputable )?(def|abbrev|theorem) ([A-Za-z0-9_]+)',line)
  if m:decls.append({'name':'RefiningCartesianWitness.'+m.group(2),'kind':m.group(1)})
 inventory.append({'fragment':name,'declarations':decls})
names=[x['name'] for row in inventory for x in row['declarations']]
assert len(names)==len(set(names))
(h/'declarations.json').write_text(json.dumps(inventory,indent=2)+'\n',encoding='utf-8')
(h/'Checks.lean.fragment').write_text('set_option pp.deepTerms true\nset_option pp.maxSteps 1000000\n\n'+''.join('#check '+x+'\n#print axioms '+x+'\n' for x in names),encoding='utf-8',newline='\n')
print(len(names))
