"""Synthetic guard checks and read-only real pin check. Never executes preparer main."""
from pathlib import Path
import ast, copy, hashlib, json, os, sys

P=Path(__file__).resolve().parent;D=P.parent;H=D/'gate-helpers'
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
assert len(sys.argv)==2 and sys.argv[1].startswith('checks-') and sys.argv[1].replace('-','').isalnum()
A=P/sys.argv[1];A.mkdir(exist_ok=False)
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
clone=copy.deepcopy
results=[]

def require(ok,message='guard rejected'):
    if not ok:raise ValueError(message)

def check(name,fn,reject=False):
    try:
        fn()
    except (AssertionError,ValueError,KeyError,FileNotFoundError) as e:
        if not reject:raise
        results.append({'name':name,'result':'PASS','observed':'rejected','exception':type(e).__name__})
    else:
        assert not reject,('guard accepted invalid fixture',name)
        results.append({'name':name,'result':'PASS','observed':'accepted'})

def extract(path,names,prefix):
    tree=ast.parse(path.read_text(encoding='utf-8'))
    selected=[n for n in tree.body if
        isinstance(n,ast.FunctionDef) and n.name in names or
        isinstance(n,ast.Assign) and isinstance(n.targets[0],ast.Name) and n.targets[0].id.startswith(prefix)]
    ns={'Path':Path,'json':json,'hashlib':hashlib,'require':require}
    exec(compile(ast.Module(body=selected,type_ignores=[]),str(path),'exec'),ns)
    return ns

prep=D/'prepare-successor-audit-with-dim-module-roots-v2.py'
names=['load_dim_module_roots','apply_dim_module_roots','verify_dim_module_roots']
real=extract(prep,names,'DIM_MODULE_')
spec={'choice_id':'Q10','row_id':'LEV-CH01-DIMENSIONAL-SPLITTING',
      'task_id':'LEV-CH01-SYNTHETIC-GUARD-PRODUCTION-20260908','target':real['DIM_MODULE_TARGET'],
      'source_context_extension':real['DIM_MODULE_CONTEXT'],
      'module_source_root_extension':real['DIM_MODULE_EXTENSION']}
check('real_exact_mirror_upstream_compiled_context_pins_read_only',lambda:real['load_dim_module_roots'](R,spec))

# Only these synthetic files are written. No target, task or gate is created.
F=A/'synthetic-fixture';F.mkdir(exist_ok=False)
def put(rel,data):
    path=F/rel;path.parent.mkdir(parents=True,exist_ok=True)
    if not isinstance(data,bytes):data=(json.dumps(data,indent=2)+'\n').encode()
    path.write_bytes(data)
    return {'path':rel,'sha256':sha(path)}

literal=put('receipt.json',{'answer':'Adopt this explicit convention',
    'question_item_id':['request_user_input_async','call_1OyqIuAHK4eJ8CPSAKCpAt08',0]})
mods=[]
for name in ['Defs','FTaylorSeries']:
    raw=('synthetic '+name+'\n').encode()
    mods.append({'module':'Mathlib.Analysis.Calculus.ContDiff.'+name,
        'mirror':put('mirror/Mathlib/Analysis/Calculus/ContDiff/'+name+'.lean',raw),
        'upstream':put('upstream/'+name+'.lean',raw),
        'compiled':put('compiled/'+name+'.olean',b'SYNTHETIC NOT LEAN'), 'bytes':len(raw)})
proposal=put('proposal.json',{'blind_config_extension':{'lean.module_source_roots':['.','mirror'],
    'exact_upstream_mirrors':[dict(x['mirror'],bytes=x['bytes']) for x in mods]}})
context=put('context.json',{'interpretation_receipts':[literal]})
plan={'format':'exact-dim-mathlib-module-roots-1','proposal':proposal,'roots':['.','mirror'],
      'modules':mods,'literal_receipt':literal,
      'environment_files':[proposal,literal,*[x[k] for x in mods for k in ('mirror','upstream','compiled')]]}
extension=put('extension.json',plan)
fx=extract(prep,names,'DIM_MODULE_')
fx.update(DIM_MODULE_PLAN=plan,DIM_MODULE_EXTENSION=extension,DIM_MODULE_CONTEXT=context)
fs=clone(spec);fs.update(source_context_extension=context,module_source_root_extension=extension)
refs=[extension,*plan['environment_files']]
cfg={'lean':{'module_source_roots':['.'],'environment_files':[]},'untouched':{'x':[1,2,3]}}
new=fx['apply_dim_module_roots'](cfg,plan)
new['lean']['environment_files']=[x['path'] for x in refs]
manifest={'lean_environment':clone(refs)}
check('synthetic_valid_complete_root_binding',lambda:fx['verify_dim_module_roots'](F,fs,new,manifest))
check('config_clone_preserves_parent',lambda:require(cfg=={'lean':{'module_source_roots':['.'],'environment_files':[]},'untouched':{'x':[1,2,3]}}))
check('config_clone_preserves_unrelated_fields',lambda:require(new['untouched']==cfg['untouched']))

for key,value in [('choice_id','Q7'),('row_id','OTHER'),('task_id','LEV-CH01-NOT-A-PRODUCTION-TASK'),
                  ('target',{'path':'other.lean','declaration':'other'}),
                  ('source_context_extension',dict(context,sha256='0'*64)),
                  ('module_source_root_extension',dict(extension,sha256='0'*64))]:
    bad=clone(fs);bad[key]=value
    check('reject_spec_'+key,lambda b=bad:fx['load_dim_module_roots'](F,b),True)
for roots in [[],['.','other'],['mirror','.'],['.','mirror']]:
    bad=clone(cfg);bad['lean']['module_source_roots']=roots
    check('reject_nonpristine_prior_roots_'+repr(roots),lambda b=bad:fx['apply_dim_module_roots'](b,plan),True)

for item in [extension,context,*plan['environment_files']]:
    path=F/item['path'];old=path.read_bytes()
    try:
        path.write_bytes(old+b'changed')
        check('reject_changed_file_'+item['path'],lambda:fx['load_dim_module_roots'](F,fs),True)
    finally:path.write_bytes(old)
for item in refs:
    bad=clone(new);bad['lean']['environment_files'].remove(item['path'])
    check('reject_missing_config_'+item['path'],lambda b=bad:fx['verify_dim_module_roots'](F,fs,b,manifest),True)
    badm=clone(manifest);next(x for x in badm['lean_environment'] if x['path']==item['path'])['sha256']='0'*64
    check('reject_stale_manifest_'+item['path'],lambda b=badm:fx['verify_dim_module_roots'](F,fs,new,b),True)
bad=clone(new);bad['lean']['environment_files'].append(extension['path'])
check('reject_duplicate_config',lambda:fx['verify_dim_module_roots'](F,fs,bad,manifest),True)
badm=clone(manifest);badm['lean_environment'].append(extension)
check('reject_duplicate_manifest',lambda:fx['verify_dim_module_roots'](F,fs,new,badm),True)
bad=clone(new);bad['lean']['module_source_roots']=['.','other']
check('reject_replaced_output_roots',lambda:fx['verify_dim_module_roots'](F,fs,bad,manifest),True)
extra=F/'mirror/unreviewed.lean';extra.write_bytes(b'synthetic extra')
try:check('reject_extra_mirror_module',lambda:fx['load_dim_module_roots'](F,fs),True)
finally:extra.unlink()

# Exercise closed plan and nested JSON duplicate rejection with deliberately
# rebound synthetic hashes; immutable real constants are never changed.
def mutate_extension(payload):
    old=(F/'extension.json').read_bytes();oldref=fx['DIM_MODULE_EXTENSION'];testspec=clone(fs)
    try:
        replacement=put('extension.json',payload)
        fx['DIM_MODULE_EXTENSION']=replacement;testspec['module_source_root_extension']=replacement
        fx['load_dim_module_roots'](F,testspec)
    finally:
        (F/'extension.json').write_bytes(old);fx['DIM_MODULE_EXTENSION']=oldref
badplan=clone(plan);badplan['extra']='unreviewed'
check('reject_extra_plan_key_even_rehashed',lambda:mutate_extension(badplan),True)
duplicate=json.dumps(plan).replace('"format":','"format":"duplicate", "format":',1).encode()
check('reject_duplicate_plan_key_even_rehashed',lambda:mutate_extension(duplicate),True)

# The binder uses its existing real source_context_environment helpers. The
# injected bound() below points only to this synthetic fixture directory.
support=H/'qualified_row_support_dim_roots_v2.py'
snames=['validate_exact_dim_module_root_lineage','source_context_json','source_context_ref','source_context_environment']
q=extract(support,snames,'DIM_ROOT_')
def bound(item):
    require(set(item)=={'path','sha256'})
    p=F/item['path'];require(p.is_file() and sha(p)==item['sha256']);return p
q.update(bound=bound,DIM_ROOT_PLAN=plan,DIM_ROOT_EXTENSION=extension,DIM_ROOT_CONTEXT=context)
request={'row':'LEV-CH01-DIMENSIONAL-SPLITTING','source_context_extension':context}
lineage={'preparer_sha256':q['DIM_ROOT_PREPARER']['sha256'],'module_source_root_extension':extension,
         'module_source_roots':plan['roots']}
check('binder_returns_all_new_freshness_inputs',lambda:require(q['validate_exact_dim_module_root_lineage'](request,lineage,new,manifest)==refs))
check('ordinary_preparer_branch_unaffected',lambda:require(q['validate_exact_dim_module_root_lineage']({}, {'preparer_sha256':'fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'}, {}, {})==[]))
for key,val in [('row','OTHER'),('source_context_extension',{})]:
    bad=clone(request);bad[key]=val
    check('binder_reject_'+key,lambda b=bad:q['validate_exact_dim_module_root_lineage'](b,lineage,new,manifest),True)
for key,val in [('module_source_root_extension',{}),('module_source_roots',['.'])]:
    bad=clone(lineage);bad[key]=val
    check('binder_reject_'+key,lambda b=bad:q['validate_exact_dim_module_root_lineage'](request,b,new,manifest),True)
for item in refs:
    bad=clone(new);bad['lean']['environment_files'].remove(item['path'])
    check('binder_reject_missing_'+item['path'],lambda b=bad:q['validate_exact_dim_module_root_lineage'](request,lineage,b,manifest),True)
    badm=clone(manifest);next(x for x in badm['lean_environment'] if x['path']==item['path'])['sha256']='0'*64
    check('binder_reject_stale_'+item['path'],lambda b=badm:q['validate_exact_dim_module_root_lineage'](request,lineage,new,b),True)

# Exact delta reconstruction verifies all retained statements/commands, not
# merely function counts. No released validator is run by these tests.
for file in ['derivation.json','derivation-v2.json']:
    derivation=json.loads((P/file).read_bytes())
    for item in derivation['derivations']:
        old=R/item['parent']['path'];out=R/item['output']['path'];diff=R/item['diff']['path']
        require(sha(old)==item['parent']['sha256'] and sha(out)==item['output']['sha256'] and sha(diff)==item['diff']['sha256'])
        text=old.read_text(encoding='utf-8')
        for delta in item['replacements']:
            require(text.count(delta['before'])==1);text=text.replace(delta['before'],delta['after'])
        require(text.encode()==out.read_bytes());ast.parse(text)
        results.append({'name':file+':exact_parent_delta:'+out.name,'result':'PASS','observed':'byte_identical_reconstruction'})
    dep=json.loads((R/derivation['dependencies']['path']).read_bytes())
    require(sha(R/derivation['dependencies']['path'])==derivation['dependencies']['sha256'])
    def refs_in(obj):
        if isinstance(obj,dict):
            if set(obj)=={'path','sha256'}:yield obj
            else:
                for x in obj.values():yield from refs_in(x)
        elif isinstance(obj,list):
            for x in obj:yield from refs_in(x)
    for item in refs_in(dep):require(sha(R/item['path'])==item['sha256'],item['path'])
    results.append({'name':file+':all_dependency_pins_current','result':'PASS','observed':'exact_pins'})

# Preparation fails closed before the first task/config write, and adds no
# commands to the released helper or role bodies.
pt=prep.read_text();old=(D/'prepare-successor-audit-with-source-context-long-paths.py').read_text()
check('root_guard_precedes_first_operational_write',lambda:require(pt.index('module_root_plan=load_dim_module_roots(R,spec)')<pt.index('T.mkdir(')))
check('same_subprocess_calls_as_original',lambda:require(pt.count('subprocess.run(')==old.count('subprocess.run(')))
check('same_role_prompt_and_collection_source',lambda:require(pt[pt.index("parent_id='LEV-CH01-EQ-1.10"):pt.index('verify_dim_module_roots(R,spec,cfg,json.loads',pt.index("parent_id='LEV-CH01-EQ-1.10"))]==old[old.index("parent_id='LEV-CH01-EQ-1.10"):old.index('if recovery_pins:verify_partial_recovery(T,recovery_pins)\nprint(json.dumps')]))
qt=support.read_text();check('new_evidence_enters_existing_freshness_checks',lambda:require('provenance += module_root_provenance' in qt and "checked_files += [bound(item) for item in source_context['provenance']]" in qt))
payload={'format':'synthetic-guard-and-read-only-pin-tests-1','checks':results,'count':len(results),
         'operational_preparation_runs':0,'released_validator_runs':0,'role_launches':0,'gate_mutations':0,'source_acceptance':False}
with (A/'checks-output.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(payload,f,indent=2);f.write('\n')
print(json.dumps({'passed':len(results),'output_sha256':sha(A/'checks-output.json'),'operational_runs':0}))
