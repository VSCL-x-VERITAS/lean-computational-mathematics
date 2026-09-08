from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;P=S/'prospective-eigen-fv-qualification-review';R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
assert sha(P/'verification.json')=='209a97a9f6cdd5ecd1ecafb213ae12e3c9b7db180c1d282f2630aa919bc0e255'
assert sha(P/'QUALIFICATION.md')=='833cffc599cb816d6851061cba4a94ed38644da5451cb803fff2ed4f083f9fcf'
v=read(P/'verification.json');count=0
for ref in v['files']:
 assert sha(P/ref['path'])==ref['sha256'];count+=1
for ref in read(P/'inputs.json')['files']:
 assert sha(Path(ref['path']))==ref['sha256'];count+=1
n=read(P/'native01-exit.json')
assert type(n['exit_code']) is int and n['exit_code']==0 and n['changed_inputs']==[]
for ref in n['inputs']:
 assert sha(Path(ref['path']))==ref['sha256'];count+=1
assert sha(P/'native01-output.txt')==n['output_sha256']==v['native_output_sha256']
raw=(P/'native01-output.txt').read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx',raw)
names=re.findall(r'^#print axioms (\S+)',(P/'Checks.lean').read_text(),re.M)
assert len(names)==len(set(names))==18
for name in names:
 found=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
 assert len(found)==1,name
 actual=sorted({x.strip() for x in found[0].split(',') if x.strip()})
 assert actual==v['axioms'][name] and set(actual)<={'propext','Classical.choice','Quot.sound'}
for c in read(P/'contracts.json')['contracts']:
 p=R/c['path'];assert sha(p)==c['sha256']
 text=p.read_text(encoding='utf-8');start=text.index('theorem '+c['declaration'])
 assert text[start:text.index(' :=',start)]==c['header_without_proof']
 assert text[:start].count('\n')+1==c['line']
dest=S/'root-eigen-fv-qualification-verification.json'
out={'status':'PASS','source_acceptance':False,'binding_occurrences':count,'axiom_reports':18,'native_actual_exit':0,'native_output_sha256':n['output_sha256'],'packet_verification_sha256':sha(P/'verification.json'),'source_contracts_verified':5,'root_review':'Read full qualification, exact check terms and freezer. Three applications reuse actual volume-average and eigenmode-sum producers. Complete finite-vector and integrable slice conditions supply the native Bochner meaning; equality alone is not a genuine-average certificate. Classical EIGEN scope and conditional FV accuracy remain the respective pending source choices. No optional weak uniqueness branch or new norm/measure foundation is imposed.'}
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(out,indent=2)+'\n')
print(json.dumps({'status':'PASS','bindings':count,'sha256':sha(dest)}))

