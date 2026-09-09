"""Additive assembler derivation only; does not invoke the assembler."""
from pathlib import Path
import ast
import difflib
import hashlib
import json
P=Path(__file__).resolve().parent
D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
parent=D/'prepare-final-current-evidence-inputs-dim-roots-v2.py'
assert sha(parent)=='d88f07397354f2d5d8f20ac2578d4124821a8be66ef7e76df8d9b5aa86cc312d'
old=parent.read_text(encoding='utf-8')
tree=ast.parse(old)
def expression(name):
    matches=[n for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id==name for t in n.targets)]
    assert len(matches)==1
    return matches[0]
pins=ast.literal_eval(expression('PINS').value)
for path in [parent,D/'physical-dim-package-runtime-preparation/suite/actual-render-01/manifest.json',
             D/'physical-dim-package-runtime-preparation/ROOT-ADOPTION.md',
             D/'physical-dim-package-runtime-preparation/root-adoption-receipt.json',
             D/'physical-dim-package-runtime-preparation/installation-01/receipt.json']:
    pins[path.relative_to(D).as_posix()]=sha(path)
assert pins['physical-dim-package-runtime-preparation/root-adoption-receipt.json']=='d2e2132524dec5bf69088b23ff94566863123d549b02b9fab008f8594f22627b'
assert pins['physical-dim-package-runtime-preparation/installation-01/receipt.json']=='1869c7fcdb97b75c31244ffaca9b8d3aa1ede30b380bfa4aab2d49dc341e85be'
helpers={
 'prepare':'prepare-successor-audit-with-package-command-v1.py',
 'support':'gate-helpers/qualified_row_support_package_command_v1.py',
 'qualified':'gate-helpers/bind-qualified-row-package-command-v1.py',
 'closed':'gate-helpers/validate-closed-row-audits-package-command-v1.py',
 'rebind_validator':'gate-helpers/validate-closed-row-audits-rebind-package-command-v1.py',
 'batch':'gate-helpers/rebind-accepted-row-batch-package-command-v1.py',
 'global':'gate-helpers/bind-final-global-evidence-package-command-v1.py'}
suite=(P/'suite.py.fragment').read_text(encoding='utf-8')
old_suite=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='suite')
changes=[
 ('Assemble actual all-41 evidence with the adopted DIM module-root v2 suite.',
  'Assemble actual all-41 evidence with the installed package-command v1 suite.'),
 (ast.get_source_segment(old,expression('PINS')),'PINS = '+repr(pins)),
 (ast.get_source_segment(old,expression('HELPERS')),'HELPERS = '+repr(helpers)),
 (ast.get_source_segment(old,old_suite),suite.rstrip()),
 ("spec_from_file_location('final_current_dim_roots_v2', path)","spec_from_file_location('final_current_package_command_v1', path)")]
new=old
for before,after in changes:
    assert new.count(before)==1
    new=new.replace(before,after)
ast.parse(new)
out=D/'prepare-final-current-evidence-inputs-package-command-v1.py'
with out.open('x',encoding='utf-8',newline='\n') as stream:stream.write(new)
with (P/'successor.diff').open('x',encoding='utf-8') as stream:
    stream.write(''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),parent.name,out.name)))
old_functions={n.name:ast.dump(n,include_attributes=False) for n in tree.body if isinstance(n,ast.FunctionDef)}
new_functions={n.name:ast.dump(n,include_attributes=False) for n in ast.parse(new).body if isinstance(n,ast.FunctionDef)}
preserved=sorted(set(old_functions)-{'suite','load_support'})
assert all(old_functions[name]==new_functions[name] for name in preserved)
record={'status':'ASSEMBLER_DERIVED_NOT_EXECUTED','parent':ref(parent),'successor':ref(out),
        'diff':ref(P/'successor.diff'),'preserved_function_asts':preserved,
        'pins':pins,'changes': [{'before':a,'after':b} for a,b in changes]}
with (P/'derivation.json').open('x',encoding='utf-8') as stream:stream.write(json.dumps(record,indent=2)+'\n')
prior_tests=D/'final-current-evidence-dim-roots-preparation/guard_tests.py'
tests=prior_tests.read_text().replace('prepare-final-current-evidence-inputs-dim-roots-v2.py','prepare-final-current-evidence-inputs-package-command-v1.py')
tests=tests.replace(".replace('dim-roots-v2', 'v8')",".replace('package-command-v1', 'dim-roots-v2')")
extra="""
check('exact eleven global dependency refs retained', lambda: a.require(len(selected['validator_dependencies']) == 11, 'Expected 11'))
check('new support selected consistently', lambda: a.require(selected['helpers']['support']['path'].endswith('/qualified_row_support_package_command_v1.py'), 'Mixed support'))
check('actual installed helper suite is bound', lambda: a.require('physical-dim-package-runtime-preparation/installation-01/receipt.json' in selected['pins'], 'Missing installation'))
check('actual coordinator adoption is bound', lambda: a.require('physical-dim-package-runtime-preparation/root-adoption-receipt.json' in selected['pins'], 'Missing adoption'))
old_helpers = dict(a.HELPERS)
try:
    a.HELPERS['closed'] = 'gate-helpers/validate-closed-row-audits-dim-roots-v2.py'
    check('mixed old helper selection rejects', lambda: rejects(lambda: a.suite(a.Reader())))
finally:
    a.HELPERS.clear()
    a.HELPERS.update(old_helpers)
"""
anchor="reader.unchanged()\nprint(json.dumps({'format': 'pure-final-evidence-guards-1'"
assert tests.count(anchor)==1
tests=tests.replace(anchor,extra+'\n'+anchor)
with (P/'guard_tests.py').open('x',encoding='utf-8') as stream:stream.write(tests)
runner=(D/'final-current-evidence-dim-roots-preparation/run_tests.py').read_text().replace(
 'prepare-final-current-evidence-inputs-dim-roots-v2.py','prepare-final-current-evidence-inputs-package-command-v1.py')
with (P/'run_tests.py').open('x',encoding='utf-8') as stream:stream.write(runner)
print(json.dumps(ref(P/'derivation.json')))
