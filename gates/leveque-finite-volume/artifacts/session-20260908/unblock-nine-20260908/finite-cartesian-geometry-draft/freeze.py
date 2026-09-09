"""Freeze exact scratch constructor, nonvacuity fixture, native types and actual receipt."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,ast
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
 path=F/name
 with path.open('x',encoding='utf-8') as f:json.dump(value,f,indent=2,ensure_ascii=False);f.write('\n')
 return ref(path)
receipt=read(F/'final01-receipt.json')
assert receipt['exit_code']==0 and receipt['inputs_unchanged'] and receipt['immutable_finite_body_match']
assert sha(F/'Cartesian.lean.fragment')=='926ae4ab17980f2820d3af1e6c50a153d6c67414fffb2848acbdddd44e04585c'
for item in receipt['inputs']:assert sha(R/item['path'])==item['sha256'],item
output=(R/receipt['output']['path']).read_bytes();text=output.decode()
assert hashlib.sha256(output).hexdigest()==receipt['output']['sha256']
assert not re.search(r'\b(?:error|warning)[:(]|sorryAx',text)
inventory=read(F/'declaration-inventory.json');assert inventory['count']==len(inventory['declarations'])==39
axioms={}
for row in inventory['declarations']:
 name=row['name']
 assert len(re.findall(r'(?m)^'+re.escape(name)+r'(?=\s|\.\{)',text))==1,name
 reports=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',text)
 assert len(reports)==1,name
 actual=sorted(set(x.strip() for x in reports[0].split(',') if x.strip()))
 assert set(actual)<= {'propext','Classical.choice','Quot.sound'},(name,actual)
 axioms[name]=actual
source=(R/receipt['input']['path']).read_text(encoding='utf-8')
commands=[line for line in source.splitlines() if line.startswith(('#check ','#print axioms '))]
assert len(commands)==96
packet=write('native-types.json',{'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact native types/axiom reports for finite Cartesian geometry and a concrete two-cell fixture. No proof bodies or source verdicts.',
 'runtime':{'receipt':ref(F/'final01-receipt.json'),'input':receipt['input'],'actual_exit_code':0,'inputs_unchanged':True},
 'native_output_spans':[{'source_path':receipt['output']['path'],'source_sha256':receipt['output']['sha256'],
 'start_byte':0,'end_byte_exclusive':len(output),'span_sha256':hashlib.sha256(output).hexdigest(),'exact_text':text}],
 'probe_commands':commands,'omissions':['Proof bodies','Failed draft outputs','Source interpretation or acceptance judgments']})
syntax=[]
for p in F.glob('*.py'):
 content=p.read_text(encoding='utf-8');ast.parse(content);compile(content,str(p),'exec');syntax.append(ref(p))
syntax_ref=write('syntax-checks.json',{'result':'PASS','scripts':syntax,'execution':'Syntax compilation only; entry points not rerun.'})
manifest=write('manifest.json',{'format':'finite-cartesian-geometry-scratch-inventory-1',
 'files':[ref(p) for p in sorted(F.iterdir()) if p.is_file() and p.name not in ('manifest.json','final-receipt.json')],
 'current_constructor':ref(F/'Cartesian.lean.fragment'),'current_fixture':ref(F/'Fixture.lean.fragment'),
 'current_native_input':receipt['input'],'current_native_receipt':ref(F/'final01-receipt.json'),
 'current_proof_free_packet':packet,'producer_inputs':receipt['inputs'],
 'authored_declaration_count':39,'axioms':axioms,'no_production_or_gate_or_git_mutation':True})
final=write('final-receipt.json',{'status':'FROZEN-SCRATCH-NATIVE-PASS-NO-SOURCE-ACCEPTANCE',
 'frozen_at_utc':datetime.now(timezone.utc).isoformat(),'manifest':manifest,'proof_free_packet':packet,
 'constructor':ref(F/'Cartesian.lean.fragment'),'fixture':ref(F/'Fixture.lean.fragment'),
 'native_receipt':ref(F/'final01-receipt.json'),'native_output':receipt['output'],
 'native_actual_exit_code':0,'native_elapsed_seconds':receipt['elapsed_seconds'],
 'authored_declarations_checked':39,'permitted_axioms_only':True,'source_and_compiled_inputs_unchanged':True,
 'syntax':syntax_ref,'consumer_integration_owner':'Laplace/root','source_acceptance':False})
print(json.dumps({'receipt':final,'manifest':manifest,'packet':packet,'native_output':receipt['output'],
 'constructor':ref(F/'Cartesian.lean.fragment'),'fixture':ref(F/'Fixture.lean.fragment')},indent=2))
