"""Add precisely the reviewed DIM page-25 context; no operational validation."""
from pathlib import Path
import ast
import difflib
import hashlib
import json

H=Path(__file__).resolve().parent
R=H.parents[5]
P=H/'dim-inherited-context-successors'
sha=lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p): return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def create(p,b):
    with p.open('xb') as f: f.write(b)
def writej(p,value): create(p,(json.dumps(value,indent=2)+'\n').encode())
P.mkdir(exist_ok=True)
records=[]
def derive(old,digest,new,changes):
    path=H/old
    assert sha(path)==digest,old
    before=path.read_text(encoding='utf-8'); text=before
    for a,b in changes:
        assert text.count(a)==1,(old,a)
        text=text.replace(a,b)
    compile(text,new,'exec')
    create(H/new,text.encode())
    create(P/(new+'.diff'),''.join(difflib.unified_diff(before.splitlines(True),text.splitlines(True),old,new)).encode())
    records.append({'parent':ref(path),'output':ref(H/new),
      'exact_replacements':[{'before':a,'after':b} for a,b in changes]})
    return ref(H/new)

context=H.parent/'dim-inherited-hyperbolicity-context/source-context-v3.json'
assert sha(context)=='d7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'
oldcontext=H.parent/'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json'
assert sha(oldcontext)=='71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d'
old=json.loads(oldcontext.read_bytes()); new=json.loads(context.read_bytes())
for k in ('format','source','primary_locations','interpretation_receipts'):
    assert old[k]==new[k],k
assert new['pages']==[25,*old['pages']]
assert new['images'][1:]==old['images'] and new['images'][0]['page']==25
assert new['inherited_locations'][1:]==old['inherited_locations']
for item in [new['source'],*new['interpretation_receipts'],*new['images']]:
    assert sha(R/item['path'])==item['sha256']
insert=('DIM_INHERITED_HYPERBOLICITY_CONTEXT = '+repr(ref(context))+'\n'
        'REVIEWED_HIGH_RESOLUTION_CONTEXTS = (HIGH_RESOLUTION_CONTEXT, DIM_INHERITED_HYPERBOLICITY_CONTEXT)\n\n\n')
support=derive('qualified_row_support_v4.py','63c2f673e1c1c94e041fd4d07f8f54748114397885d7757d2d7b98273caecde9',
 'qualified_row_support_v5.py',[
 ('def validate_scoped_context_receipts(request, extension, packet, source, configured, environment):',
  insert+'def validate_scoped_context_receipts(request, extension, packet, source, configured, environment):'),
 ("request['source_context_extension'] == HIGH_RESOLUTION_CONTEXT", "request['source_context_extension'] in REVIEWED_HIGH_RESOLUTION_CONTEXTS"),
 ("request['source_context_extension'] != HIGH_RESOLUTION_CONTEXT", "request['source_context_extension'] not in REVIEWED_HIGH_RESOLUTION_CONTEXTS")])
single=derive('bind-qualified-row-v4.py','b77f4959728065241054a4f39d26452a9b7c16f6b5eb88af182bdfbf1e8d43d1',
 'bind-qualified-row-v5.py',[('import qualified_row_support_v4 as q','import qualified_row_support_v5 as q')])
validator=derive('validate-closed-row-audits-v7.py','54112f833689d41ea2dd363620e152de057992385ace01db467a8611833eaf8b',
 'validate-closed-row-audits-v8.py',[('import qualified_row_support_v4 as qualified','import qualified_row_support_v5 as qualified')])
proposal=derive('validate-closed-row-audits-rebind-v3.py','7df9caf7df97df4a0dec8115064e434ed023b481ddbb503a9c2cd708ae7f2d35',
 'validate-closed-row-audits-rebind-v4.py',[('import qualified_row_support_v4 as qualified','import qualified_row_support_v5 as qualified')])
depspath=H/'source-context-v4-validator-dependencies.json'
assert sha(depspath)=='77477920f53fbde550d4f7e0463af8e28d423e714b7a8c848478269374a1c473'
deps=json.loads(depspath.read_bytes())
assert deps['validator_dependencies'][0]['path'].endswith('/qualified_row_support_v4.py')
deps['audit_validator']=validator
deps['validator_dependencies'][0]=support
deps['source_context_protocol_inputs'].append(ref(context))
deps['producer']=ref(Path(__file__))
writej(H/'source-context-v5-validator-dependencies.json',deps)
newdeps=ref(H/'source-context-v5-validator-dependencies.json')
batch=derive('rebind-accepted-row-batch-v3.py','90bf20d921939f3a3d6fa6801857a3456e220d40d87602ca262283eb0e8b0b88',
 'rebind-accepted-row-batch-v4.py',[
 ("'qualified_row_support_v4.py': '63c2f673e1c1c94e041fd4d07f8f54748114397885d7757d2d7b98273caecde9'", "'qualified_row_support_v5.py': '"+support['sha256']+"'"),
 ("'validate-closed-row-audits-rebind-v3.py': '7df9caf7df97df4a0dec8115064e434ed023b481ddbb503a9c2cd708ae7f2d35'", "'validate-closed-row-audits-rebind-v4.py': '"+proposal['sha256']+"'"),
 ("'source-context-v4-validator-dependencies.json': '77477920f53fbde550d4f7e0463af8e28d423e714b7a8c848478269374a1c473'", "'source-context-v5-validator-dependencies.json': '"+newdeps['sha256']+"'"),
 ("q = load('batch_qualified_support_v4', 'qualified_row_support_v4.py')", "q = load('batch_qualified_support_v5', 'qualified_row_support_v5.py')"),
 ("deps = parse(reader.read(H / 'source-context-v4-validator-dependencies.json'))", "deps = parse(reader.read(H / 'source-context-v5-validator-dependencies.json'))"),
 ("str(H/'validate-closed-row-audits-rebind-v3.py'), '--validate'", "str(H/'validate-closed-row-audits-rebind-v4.py'), '--validate'")])
globaltext=(H/'bind-final-global-evidence-v3.py').read_text(encoding='utf-8')
assignments={n.targets[0].id:n for n in ast.parse(globaltext).body
             if isinstance(n,ast.Assign) and isinstance(n.targets[0],ast.Name)}
def assignment(name):
    node=assignments[name]
    return ast.get_source_segment(globaltext,node),ast.literal_eval(node.value)
pin_line,_=assignment('FINAL_VALIDATOR_PIN')
dep_line,globaldeps=assignment('FINAL_VALIDATOR_DEPENDENCIES')
assert globaldeps[0]['path'].endswith('/qualified_row_support_v4.py')
globaldeps[0]=support
globalbinder=derive('bind-final-global-evidence-v3.py','e91823bfdba863cef3e8b9c1cc027f0da921ac9f62228297bdbe227cd7c47ddb',
 'bind-final-global-evidence-v4.py',[
 (pin_line,'FINAL_VALIDATOR_PIN = '+repr(validator)),
 (dep_line,'FINAL_VALIDATOR_DEPENDENCIES = '+repr(globaldeps)),
 ("'Final validator must be the exact reviewed v7'", "'Final validator must be the exact reviewed v8'"),
 ("'Final validator dependencies differ from reviewed v7 closure'", "'Final validator dependencies differ from reviewed v8 closure'"),
 ("endswith('/qualified_row_support_v4.py')", "endswith('/qualified_row_support_v5.py')"),
 ("spec_from_file_location('final_global_qualified_v4', path)", "spec_from_file_location('final_global_qualified_v5', path)"),
 ("'Qualified records require the exact v7 support'", "'Qualified records require the exact v8 support'")])
writej(P/'derivation.json',{'schema':1,'deriver':ref(Path(__file__)),
 'derivations':records,'dependency_parent':ref(depspath),'dependencies':newdeps,
 'contexts':[ref(oldcontext),ref(context)],'literal_receipts':new['interpretation_receipts'],
 'exact_context_delta':'One inherited page-25 location, leading page 25 and exact rendering only; primary/source/receipts unchanged.',
 'operational_validations':0,'gate_mutations':0,'source_acceptance':False})
print(json.dumps({'support':support,'single':single,'validator':validator,'proposal_validator':proposal,
 'batch':batch,'global_binder':globalbinder,'dependencies':newdeps},indent=2))
