from pathlib import Path
import re,json
h=Path(__file__).resolve().parent
decls=[]
for line in (h/'Application.lean.fragment').read_text(encoding='utf-8').splitlines():
 m=re.match(r'^(?:noncomputable )?(def|theorem) ([A-Za-z0-9_]+)',line)
 if m:decls.append({'name':'PhysicalRefinementJointPrimary.'+m.group(2),'kind':m.group(1)})
(h/'declarations.json').write_text(json.dumps(decls,indent=2)+'\n',encoding='utf-8')
(h/'Checks.lean.fragment').write_text('set_option pp.deepTerms true\nset_option pp.maxSteps 1000000\n'+''.join('#check '+x['name']+'\n#print axioms '+x['name']+'\n' for x in decls),encoding='utf-8',newline='\n')
print(len(decls))
