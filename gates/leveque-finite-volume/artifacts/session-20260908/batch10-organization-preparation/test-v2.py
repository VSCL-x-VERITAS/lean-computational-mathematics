"""Synthetic/read-only checks only: no generated classifier/exporter/merger execution."""
from pathlib import Path
import ast,copy,hashlib,importlib.util,json

HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('batch10_prepare',HERE/'prepare-v2.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
fixture=module.native_path(HERE/'synthetic-fixture-02');assert not fixture.exists();fixture.mkdir()
files=[]
for index,path in enumerate(sorted(module.EXPECTED_PATHS)):
 target=fixture/path;target.parent.mkdir(parents=True,exist_ok=True)
 content=f'/- SYNTHETIC INPUT ONLY; no mathematical or production claim. -/\nnamespace NumStability.Synthetic\ndef item{index} : Nat := {index}\nend NumStability.Synthetic\n'
 target.write_text(content,encoding='utf-8',newline='\n')
 files.append(dict(path=path,module=path[:-5].replace('/','.'),sha256=module.sha(target),
  declarations=[f'NumStability.Synthetic.item{index}'],lines=len(content.splitlines())))
data=dict(schema=1,status='PASS',source_acceptance=False,files=files,
          metadata='Explicit synthetic test data; not a production verification receipt.')
results=[]
def success(name,action):
 action();results.append(dict(test=name,result='PASS'))
def reject(name,edit):
 changed=copy.deepcopy(data);edit(changed)
 try:module.validate_inventory(changed,fixture)
 except (AssertionError,FileNotFoundError,KeyError):results.append(dict(test=name,result='PASS_REJECTED'))
 else:raise AssertionError('invalid fixture accepted: '+name)
success('valid required fields with extra root metadata',lambda:module.validate_inventory(data,fixture))
with_count=copy.deepcopy(data)
for f in with_count['files']:f['declaration_count']=1
success('optional matching declaration_count',lambda:module.validate_inventory(with_count,fixture))
reject('wrong optional declaration_count',lambda d:d['files'][0].update(declaration_count=2))
reject('wrong hash',lambda d:d['files'][0].update(sha256='0'*64))
reject('wrong line count',lambda d:d['files'][0].update(lines=99))
reject('wrong module',lambda d:d['files'][0].update(module='ComputationalMathematics.Wrong'))
reject('wrong authored name',lambda d:d['files'][0].update(declarations=['NumStability.Wrong']))
reject('missing ninth file',lambda d:d['files'].pop())
reject('duplicate file',lambda d:d['files'].__setitem__(0,copy.deepcopy(d['files'][1])))
reject('unapproved path',lambda d:d['files'][0].update(path='ComputationalMathematics/Unapproved.lean'))
reject('boolean line count',lambda d:d['files'][0].update(lines=True))
commented='''/- outer
theorem fake : True := by trivial
/- nested -/
-/
namespace NumStability.Test
section
@[simp] theorem actual : True := by trivial
end
end NumStability.Test
'''
assert module.authored_names(commented)==['NumStability.Test.actual']
results.append(dict(test='nested comments, attribute and section inventory',result='PASS'))
placement=json.loads((module.SESSION/'information-method-production/placement-map.json').read_bytes())
for f in placement['new_files']:
 assert set(module.authored_names(Path(f['path']).read_text(encoding='utf-8')))==set(f['declarations'])
results.append(dict(test='read-only inventory of four frozen canonical leaves',result='PASS',declarations=24))
for name,pin in module.PINS.items():assert module.sha(module.SESSION/name)==pin
intro='f'*40
classifier,cchanges=module.classifier_text((module.SESSION/'classify-batch9-foundations.py').read_text(encoding='utf-8'),
 intro,'synthetic/inventory.json','a'*64,5968,663)
ast.parse(classifier)
assert "manifest['prefixes']==json.loads(before)['prefixes']" in classifier
assert "manifest['prefix_rules']==json.loads(before)['prefix_rules']" in classifier
assert "matching_prefixes(module,prefixes)" in classifier
assert "git('log','--diff-filter=A','-1','--format=%H'" in classifier
results.append(dict(test='classifier derivation AST and retained policy/introduction guards',result='PASS',replacements=len(cchanges)))
parent=(module.SESSION/'export-batch9-declaration-expressions.lean').read_text(encoding='utf-8')
exporter,changes=module.exporter_text(parent,sorted(f['module'] for f in files))
marker='private def selectedModules : Array String := #[\n'
assert parent.split(marker)[0]==exporter.split(marker)[0]
assert parent.split('\n]\n\nrun_cmd do')[1].replace('batch9-expressions','batch10-expressions')==exporter.split('\n]\n\nrun_cmd do')[1]
results.append(dict(test='exporter serializer and generated-name filter byte-text preservation',result='PASS'))
merger,mchanges=module.merger_text((module.SESSION/'merge-batch9-expression-fingerprints.py').read_text(encoding='utf-8'),
 intro,'synthetic/inputs.json','b'*64,9,5968)
ast.parse(merger)
for guard in ["type(e['exit_code']) is int and e['exit_code']==0",
 "e['input_commit']==new['input_commit']", "set(old['selected_modules'])&set(new['selected_modules'])",
 "len({r['name'] for r in records})==len(records)","len(newpaths)==91",
 "assert not git('diff','--name-only','HEAD','--','ComputationalMathematics').strip()",
 module.PINS['freeze-chapter01-expression-fingerprints-v3.py']]:assert guard in merger,guard
results.append(dict(test='FP merger AST and original receipt/parser/coverage/clean-tree guards',result='PASS',replacements=len(mchanges)))
try:module.replace_checked('changed parent','missing','replacement',[])
except AssertionError:results.append(dict(test='derivation rejects changed parent replacement anchor',result='PASS_REJECTED'))
else:raise AssertionError('missing anchor accepted')
record=dict(scope='Synthetic/helper tests only; no production classifier, expression exporter, merger, Git or gate executed.',
 tests=results,count=len(results),prepare_sha256=module.sha(HERE/'prepare-v2.py'),
 synthetic_fixture_files=[dict(path=str(fixture/f['path']),sha256=f['sha256']) for f in files])
out=HERE/'tests.json';assert not out.exists();out.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(status='PASS',scope=record['scope'],count=len(results),tests_sha256=module.sha(out))))
