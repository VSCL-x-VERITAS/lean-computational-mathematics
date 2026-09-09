from pathlib import Path
import re,json
h=Path(__file__).resolve().parent
names=[]
for line in (h/'Family.lean.fragment').read_text(encoding='utf-8').splitlines():
 m=re.match(r'^(?:noncomputable )?(def|theorem) ([A-Za-z0-9_]+)',line)
 if m:names.append({'name':'ZeroPhysicalRefinementWitness.'+m.group(2),'kind':m.group(1)})
(h/'declarations.json').write_text(json.dumps(names,indent=2)+'\n',encoding='utf-8')
(h/'Checks.lean.fragment').write_text('set_option pp.deepTerms true\nset_option pp.maxSteps 1000000\n'+''.join('#check '+x['name']+'\n#print axioms '+x['name']+'\n' for x in names)+'#check CapacitySmallBias.constantFlux_hyperbolic\n#print axioms CapacitySmallBias.constantFlux_hyperbolic\n',encoding='utf-8',newline='\n')
print(len(names))
