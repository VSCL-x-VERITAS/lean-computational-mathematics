"""Prepare-only exact mirror-root extension and additive helper-suite successor."""
from pathlib import Path
import ast,difflib,hashlib,json,os
P=Path(__file__).resolve().parent;D=P.parent;H=D/'gate-helpers'
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(p,b):
 if not isinstance(b,bytes):b=(json.dumps(b,indent=2,ensure_ascii=False)+'\n').encode()
 with p.open('xb') as f:f.write(b)
 return ref(p)
records=[]
def derive(old,new,changes):
 before=old.read_text(encoding='utf-8');after=before
 for a,b in changes:
  assert after.count(a)==1,(old.name,'replacement count',a[:100])
  after=after.replace(a,b)
 ast.parse(after)
 out=put(new,after.encode())
 diff=put(P/(new.name+'.diff'),''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),old.name,new.name)).encode())
 records.append({'parent':ref(old),'output':out,'diff':diff,'replacements':[{'before':a,'after':b} for a,b in changes]})
 return out
proposal=D/'dim-blind-evidence-repair/five-owner-proposal.json'
obj=json.loads(proposal.read_bytes());extension=obj['blind_config_extension']
modules=[]
for item in extension['exact_upstream_mirrors']:
 mirror=R/item['path'];assert sha(mirror)==item['sha256'] and len(mirror.read_bytes())==item['bytes']
 modulepath=item['path'].split('/m/',1)[1]
 upstream=R/'.lake/packages/mathlib'/modulepath
 compiled=R/'.lake/packages/mathlib/.lake/build/lib/lean'/Path(modulepath).with_suffix('.olean')
 assert upstream.read_bytes()==mirror.read_bytes() and compiled.is_file()
 modules.append({'module':modulepath[:-5].replace('/','.'),'mirror':ref(mirror),'upstream':ref(upstream),'compiled':ref(compiled),'bytes':item['bytes']})
assert [x['mirror']['sha256'] for x in modules]==['793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711','a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa']
context=ref(D/'dim-inherited-hyperbolicity-context/source-context-v3.json')
assert context['sha256']=='d7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'
literal=ref(D/'user-high-resolution-interpretation-20260908.json')
assert literal['sha256']=='5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'
target={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean','declaration':'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract'}
plan={'format':'exact-dim-mathlib-module-roots-1','proposal':ref(proposal),'roots':extension['lean.module_source_roots'],
 'modules':modules,'literal_receipt':literal,
 'environment_files':[ref(proposal),literal,*[x[k] for x in modules for k in ('mirror','upstream','compiled')]]}
planref=ref(P/'module-root-extension.json');assert json.loads((P/'module-root-extension.json').read_bytes())==plan
constants='DIM_MODULE_EXTENSION = '+repr(planref)+'\nDIM_MODULE_PLAN = '+repr(plan)+'\nDIM_MODULE_CONTEXT = '+repr(context)+'\nDIM_MODULE_TARGET = '+repr(target)+'\n\n'
guard=(P/'root_guard.py.fragment').read_text()
parent=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(parent)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
preparer=derive(parent,D/'prepare-successor-audit-with-dim-module-roots-v2.py',[
 ('assert len(sys.argv) in (2,6)',constants+guard+'\nassert len(sys.argv) in (2,6)'),
 ("spec=json.loads(Path(sys.argv[1]).read_bytes())","spec=json.loads(Path(sys.argv[1]).read_bytes())\nmodule_root_plan=load_dim_module_roots(R,spec)"),
 ("cfgpath=S/spec['prior_config'];cfg=json.loads(cfgpath.read_bytes())","cfgpath=S/spec['prior_config'];cfg=json.loads(cfgpath.read_bytes())\ncfg=apply_dim_module_roots(cfg,module_root_plan)"),
 ("cfg['lean']['environment_files']=list(dict.fromkeys(envfiles))","envfiles.extend(x['path'] for x in [DIM_MODULE_EXTENSION,*module_root_plan['environment_files']])\ncfg['lean']['environment_files']=list(dict.fromkeys(envfiles))\nverify_dim_module_roots(R,spec,cfg)"),
 ("'partial_recovery_manifest':{'path':Path(sys.argv[3])", "'module_source_root_extension':spec['module_source_root_extension'],'module_source_roots':module_root_plan['roots'],'partial_recovery_manifest':{'path':Path(sys.argv[3])"),
 ("def released(label,script,args,cwd):\n", "def released(label,script,args,cwd):\n verify_dim_module_roots(R,spec,cfg)\n"),
 ("parent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'", "verify_dim_module_roots(R,spec,cfg,json.loads((T/'faithfulness/manifest.json').read_bytes()))\nparent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'"),
 ("if recovery_pins:verify_partial_recovery(T,recovery_pins)\nprint(json.dumps({'prepared':", "verify_dim_module_roots(R,spec,cfg,json.loads((T/'faithfulness/manifest.json').read_bytes()))\nif recovery_pins:verify_partial_recovery(T,recovery_pins)\nprint(json.dumps({'prepared':")])
qparent=H/'qualified_row_support_v5.py';assert sha(qparent)=='abc07db16099a1010a213249d5db5a3a0aed5f631f6ec30748819791b3410d25'
qextra='''
def validate_exact_dim_module_root_lineage(request, lineage, config, manifest):
    if lineage['preparer_sha256'] != DIM_ROOT_PREPARER['sha256']:
        return []
    require(request['row'] == 'LEV-CH01-DIMENSIONAL-SPLITTING', 'DIM root preparer used for another row')
    require(request['source_context_extension'] == DIM_ROOT_CONTEXT, 'DIM root context changed')
    require(lineage.get('module_source_root_extension') == DIM_ROOT_EXTENSION, 'missing or changed exact module-root lineage')
    require(lineage.get('module_source_roots') == DIM_ROOT_PLAN['roots'], 'module-root lineage changed')
    plan_path = source_context_environment(DIM_ROOT_EXTENSION, config['lean']['environment_files'], manifest['lean_environment'])
    require(source_context_json(plan_path) == DIM_ROOT_PLAN, 'module-root plan differs')
    require(config['lean']['module_source_roots'] == DIM_ROOT_PLAN['roots'], 'configured module roots differ')
    for item in DIM_ROOT_PLAN['environment_files']:
        source_context_environment(item, config['lean']['environment_files'], manifest['lean_environment'])
    return [DIM_ROOT_EXTENSION, *DIM_ROOT_PLAN['environment_files']]


'''
qconst='DIM_ROOT_PREPARER = '+repr(preparer)+'\nDIM_ROOT_EXTENSION = '+repr(planref)+'\nDIM_ROOT_PLAN = '+repr(plan)+'\nDIM_ROOT_CONTEXT = '+repr(context)+'\n'
qtext=qparent.read_text();node=next(x for x in ast.parse(qtext).body if isinstance(x,ast.Assign) and isinstance(x.targets[0],ast.Name) and x.targets[0].id=='SOURCE_CONTEXT_PREPARERS')
origmap=ast.get_source_segment(qtext,node);newmap=ast.literal_eval(node.value);newmap[preparer['sha256']]=Path(preparer['path']).name
support=derive(qparent,H/'qualified_row_support_dim_roots_v2.py',[
 (origmap,'SOURCE_CONTEXT_PREPARERS = '+repr(newmap)),
 ('def validate_source_context(request, task, manifest, config):',qconst+qextra+'def validate_source_context(request, task, manifest, config):'),
 ("require(lineage['preparer_sha256'] == sha(preparer), 'source-context preparer changed')", "require(lineage['preparer_sha256'] == sha(preparer), 'source-context preparer changed')\n    module_root_provenance = validate_exact_dim_module_root_lineage(request, lineage, config, manifest)"),
 ("    recovery_ref = lineage.get('partial_recovery_manifest')","    provenance += module_root_provenance\n    recovery_ref = lineage.get('partial_recovery_manifest')")])
single=derive(H/'bind-qualified-row-v5.py',H/'bind-qualified-row-dim-roots-v2.py', [('import qualified_row_support_v5 as q','import qualified_row_support_dim_roots_v2 as q')])
validator=derive(H/'validate-closed-row-audits-v8.py',H/'validate-closed-row-audits-dim-roots-v2.py',[('import qualified_row_support_v5 as qualified','import qualified_row_support_dim_roots_v2 as qualified')])
proposalvalidator=derive(H/'validate-closed-row-audits-rebind-v4.py',H/'validate-closed-row-audits-rebind-dim-roots-v2.py',[('import qualified_row_support_v5 as qualified','import qualified_row_support_dim_roots_v2 as qualified')])
depsparent=H/'source-context-v5-validator-dependencies.json';deps=json.loads(depsparent.read_bytes())
deps['audit_validator']=validator;deps['validator_dependencies'][0]=support;deps['producer']=ref(Path(__file__))
deps['source_context_protocol_inputs'].extend([preparer,planref,*plan['environment_files']])
deps['source_context_protocol_inputs']=list({item['path']:item for item in deps['source_context_protocol_inputs']}.values())
depsref=put(H/'source-context-dim-roots-v2-validator-dependencies.json',deps)
batchparent=H/'rebind-accepted-row-batch-v4.py';batchtext=batchparent.read_text()
changes=[]
for old,new in [('qualified_row_support_v5.py',support),('validate-closed-row-audits-rebind-v4.py',proposalvalidator),('source-context-v5-validator-dependencies.json',depsref)]:
 needle=repr(old)+': '+repr(sha(H/old));replacement=repr(Path(new['path']).name)+': '+repr(new['sha256']);changes.append((needle,replacement))
changes += [("q = load('batch_qualified_support_v5', 'qualified_row_support_v5.py')","q = load('batch_qualified_support_dim_roots_v2', 'qualified_row_support_dim_roots_v2.py')"),
 ("deps = parse(reader.read(H / 'source-context-v5-validator-dependencies.json'))","deps = parse(reader.read(H / 'source-context-dim-roots-v2-validator-dependencies.json'))"),
 ("str(H/'validate-closed-row-audits-rebind-v4.py'), '--validate'","str(H/'validate-closed-row-audits-rebind-dim-roots-v2.py'), '--validate'")]
batch=derive(batchparent,H/'rebind-accepted-row-batch-dim-roots-v2.py',changes)
gp=H/'bind-final-global-evidence-v4.py';gt=gp.read_text();assign={x.targets[0].id:x for x in ast.parse(gt).body if isinstance(x,ast.Assign) and isinstance(x.targets[0],ast.Name)}
gn=assign['FINAL_VALIDATOR_DEPENDENCIES'];gd=ast.literal_eval(gn.value);assert gd[0]['path'].endswith('/qualified_row_support_v5.py');gd[0]=support
globalbinder=derive(gp,H/'bind-final-global-evidence-dim-roots-v2.py',[
 (ast.get_source_segment(gt,assign['FINAL_VALIDATOR_PIN']),'FINAL_VALIDATOR_PIN = '+repr(validator)),
 (ast.get_source_segment(gt,gn),'FINAL_VALIDATOR_DEPENDENCIES = '+repr(gd)),
 ("endswith('/qualified_row_support_v5.py')","endswith('/qualified_row_support_dim_roots_v2.py')"),
 ("spec_from_file_location('final_global_qualified_v5', path)","spec_from_file_location('final_global_qualified_dim_roots_v2', path)")])
put(P/'derivation-v2.json',{'schema':1,'deriver':ref(Path(__file__)),'derivations':records,'module_root_extension':planref,
 'dependency_parent':ref(depsparent),'dependencies':depsref,'canonical_five_owner_bytes_not_guarded':True,
 'operational_runs':0,'role_launches':0,'gate_mutations':0,'source_acceptance':False})
put(P/'spec-extension-v2.json',{'module_source_root_extension':planref})
print(json.dumps({'preparer':preparer,'support':support,'validator':validator,'dependencies':depsref},indent=2))
