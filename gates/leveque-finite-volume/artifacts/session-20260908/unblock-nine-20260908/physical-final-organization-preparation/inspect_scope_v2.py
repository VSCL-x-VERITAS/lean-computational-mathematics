"""Read-only POSIX Git/source scope preparation; no organization capture or verdict."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, subprocess, sys, time
assert os.name!='nt','Use the unchanged POSIX launcher'
sys.dont_write_bytecode=True
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
ANCHOR='9e2225705fed906b1120d55105d607baabef57c9'
HEAD='5e3f63594aa964263469ada134aee2809559d50d'
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--build-receipt',required=True);parser.add_argument('--build-sha256',required=True)
parser.add_argument('--out',required=True);args=parser.parse_args()
assert '/' not in args.out and chr(92) not in args.out and args.out.startswith('scope-')
O=P/args.out;O.mkdir(exist_ok=False)
observed={};git_runs=[]
def ref(p):
    raw=p.read_bytes();h=hashlib.sha256(raw).hexdigest()
    if p in observed:assert observed[p]==h,str(p)
    observed[p]=h
    return {'path':p.relative_to(R).as_posix(),'sha256':h}
def read(p):ref(p);return json.loads(p.read_bytes())
def write(name,obj):
    with (O/name).open('x',encoding='utf-8',newline='\n') as f:json.dump(obj,f,indent=2);f.write('\n')
def git(label,*args):
    argv=['git','--no-optional-locks','-c','core.longpaths=true',*args]
    start=time.monotonic_ns();result=subprocess.run(argv,cwd=R,capture_output=True)
    for suffix,raw in [('stdout.bin',result.stdout),('stderr.txt',result.stderr)]:
        with (O/(label+'-'+suffix)).open('xb') as f:f.write(raw)
    git_runs.append({'label':label,'argv':argv,'exit_code':result.returncode,
        'elapsed_ms':(time.monotonic_ns()-start)//1000000,
        'stdout':ref(O/(label+'-stdout.bin')),'stderr':ref(O/(label+'-stderr.txt'))})
    assert result.returncode==0,(label,result.stderr.decode(errors='replace'))
    return result.stdout
def paths(raw):return sorted({x.decode('utf-8') for x in raw.split(b'\0') if x})
def production(path):return path.endswith('.lean') and (path in ['ComputationalMathematics.lean','NumStability.lean'] or path.startswith(('ComputationalMathematics/','NumStability/')))

started=datetime.datetime.now(datetime.timezone.utc).isoformat()
assert git('head','rev-parse','HEAD').decode().strip()==HEAD
assert git('anchor','rev-parse',ANCHOR+'^{commit}').decode().strip()==ANCHOR
changed=paths(git('changed-anchor','diff','--name-only','-z',ANCHOR,'--'))
untracked=paths(git('untracked','ls-files','--others','--exclude-standard','-z'))
staged=paths(git('staged-head','diff','--cached','--name-only','-z','HEAD','--'))
tracked=set(paths(git('tracked-production','ls-files','-z','--','ComputationalMathematics/*.lean',
    'ComputationalMathematics.lean','NumStability/*.lean','NumStability.lean')))
changed=sorted(p for p in set(changed+untracked) if production(p))
print(json.dumps({'stage':'git-complete','changed_lean':len(changed),'staged_lean':sum(production(p) for p in staged)}),flush=True)

sys.path.insert(0,str(R/'tools/architecture'))
import generate_baseline as engine
for p in [R/'tools/architecture/generate_baseline.py',R/'tools/architecture/project_roots.py',
          D/'final-organization-successor-preparation/support.py',
          D/'final-organization-successor-preparation/capture_current_v2.py',
          D/'final-organization-successor-preparation/prepare_draft_v2.py']:
    ref(p)
source,modules=engine.scan_sources(R)
by_path={m.path:m for m in modules};by_name={m.name:m for m in modules}
assert set(by_path)==tracked,'Filesystem production census differs from tracked staged source census'
assert set(changed)<=set(by_path),'Changed/deleted source outside existing production census'
oldconfig=read(D/'final-organization-actual/config.json')
priorunit=read(D/'final-organization-actual/capture/unit-source-pins.json')
oldfiles={x['path']:x['sha256'] for x in priorunit['files']}
owners={};historical_inventories=[]
for item in oldconfig['fingerprints']:
    p=R/item['inventory']['path'];assert ref(p)==item['inventory']
    fp=read(p);historical_inventories.append({'inventory':item['inventory'],'owner_paths':[x['path'] for x in fp['files']],
        'meaning':'historical owner seed census only; records are not accepted as current by this preparer'})
    for x in fp['files']:
        assert x['path'] in by_path
        owners[x['path']]=x['sha256']
buildpath=R/args.build_receipt
assert buildpath.resolve().is_relative_to(R) and hashlib.sha256(buildpath.read_bytes()).hexdigest()==args.build_sha256
build=read(buildpath)
assert build['actual_exit_code']==0
assert ref(R/build['output']['path'])==build['output']
for item in build['input_sources']:assert ref(R/item['path'])==item
new_seeds={x['path'] for x in build['input_sources']}
prefixes=('ComputationalMathematics.Source.LeVeque.Chapter01','NumStability.Source.LeVeque.Chapter01')
starts={n for n in by_name if any(n==p or n.startswith(p+'.') for p in prefixes)}
todo=list(starts|{by_path[p].name for p in set(owners)|new_seeds});closure=set()
while todo:
    name=todo.pop()
    if name in closure:continue
    closure.add(name)
    todo.extend(n for n in by_name[name].imports if n in by_name and n not in closure)
semantic=sorted(by_name[n].path for n in closure)
assert set(oldfiles)<=set(semantic),'Old semantic owner/dependency omitted'
unit=sorted(set(semantic)|{'ComputationalMathematics/Analysis.lean'})
assert set(changed)<=set(unit),'Changed production Lean outside derived scope'
pins=[ref(R/p) for p in unit]
changes=[{'path':p,'previous_sha256':h,'current_sha256':ref(R/p)['sha256']}
         for p,h in owners.items() if ref(R/p)['sha256']!=h]
imports=[{'module':by_path[p].name,'path':p,'imports':list(by_path[p].imports),
          'internal_imports':[n for n in by_path[p].imports if n in by_name],
          'external_imports':[n for n in by_path[p].imports if n not in by_name]} for p in semantic]
compiled=[];missing=[]
for p in unit:
    stem=p.removesuffix('.lean')
    items=[]
    for suffix in ['.olean','.ilean','.olean.private','.olean.server']:
        artifact=R/'.lake/build/lib/lean'/(stem+suffix)
        if artifact.is_file():items.append(ref(artifact))
        elif suffix=='.olean':missing.append(artifact.relative_to(R).as_posix())
    compiled.append({'source_path':p,'module':by_path[p].name,'existing_compiled_assets':items})
analysis=R/'ComputationalMathematics/Analysis.lean'
old_analysis=git('analysis-at-head','show',HEAD+':ComputationalMathematics/Analysis.lean')
current_analysis=analysis.read_bytes()
def import_set(raw):return set(engine.IMPORT_RE.findall(engine.remove_lean_comments(raw.decode('utf-8-sig'))))
policy='docs/architecture/layout-exceptions.json'
baseline=git('baseline-policy','show',ANCHOR+':'+policy)
with (O/'protected-anchor-layout-exceptions.json').open('xb') as f:f.write(baseline)
write('all-production-source-pins.json',{'source':source,'files':[ref(R/m.path) for m in modules]})
write('unit-source-scope.json',{'status':'prepared-source-scope-not-organization-review','input_commit':HEAD,'anchor':ANCHOR,
    'source_tree_sha256':source['source_tree_sha256'],'source_tree_normalization':source['source_tree_sha256_normalization'],
    'production_modules':len(modules),'semantic_and_dependency_files':len(semantic),'unit_files':len(unit),
    'aggregate_boundaries':['ComputationalMathematics/Analysis.lean'],'source_files':pins,'semantic_paths':semantic,
    'starts':sorted(starts),'historical_owner_seed_count':len(owners),'additional_owner_seeds':sorted(new_seeds-set(owners)),
    'retained_old_semantic_files':len(oldfiles),'historical_owner_hash_changes':changes,
    'reviewed_changed_source_paths':changed,'staged_lean_paths':[p for p in staged if production(p)],
    'changed_untracked_lean':[p for p in untracked if production(p)],
    'changed_paths_outside_semantic_scope':sorted(set(changed)-set(semantic)),
    'new_semantic_paths_since_old_capture':sorted(set(semantic)-set(oldfiles)),
    'limits':'Scope only. Historical fingerprints seed owner paths but do not certify changed owners; no six zero finding lists or current native record count inferred.'})
write('import-and-build-assets.json',{'source_imports':imports,'compiled_project_assets':compiled,
    'absent_project_olean_cache_paths':missing,'meaning':'Observed build-cache availability only. Absent legacy forwarder caches do not imply a production build failure. This is not a compiler receipt or dependency freshness certification.'})
write('historical-inventory-seeds.json',historical_inventories)
write('analysis-import-delta.json',{'path':analysis.relative_to(R).as_posix(),'before_head':HEAD,
    'before_sha256':hashlib.sha256(old_analysis).hexdigest(),'after':ref(analysis),
    'added_imports':sorted(import_set(current_analysis)-import_set(old_analysis)),
    'removed_imports':sorted(import_set(old_analysis)-import_set(current_analysis)),
    'non_import_lines_equal':[l for l in old_analysis.decode().splitlines() if not l.startswith('import ')]==
        [l for l in current_analysis.decode().splitlines() if not l.startswith('import ')]})
write('baseline-boundary.json',{'anchor':ANCHOR,'git_blob_path':policy,
    'preserved_exact_baseline':ref(O/'protected-anchor-layout-exceptions.json'),
    'current_policy':ref(R/policy),'current_tiers':ref(R/'docs/architecture/tiers.json'),
    'meaning':'Protected layout-policy legacy item sets only. This is not current measured debt and does not fabricate a new baseline.'})
for p,h in observed.items():assert hashlib.sha256(p.read_bytes()).hexdigest()==h,('changed during inspection',str(p))
assert git('final-head','rev-parse','HEAD').decode().strip()==HEAD
finalchanged=paths(git('final-changed-anchor','diff','--name-only','-z',ANCHOR,'--'))
finaluntracked=paths(git('final-untracked','ls-files','--others','--exclude-standard','-z'))
assert sorted(p for p in set(finalchanged+finaluntracked) if production(p))==changed
write('receipt.json',{'format':'actual-posix-source-scope-inspection-1','started_at_utc':started,
    'completed_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'input_commit':HEAD,'anchor':ANCHOR,
    'commands':git_runs,'input_files':[{'path':p.relative_to(R).as_posix(),'sha256':h} for p,h in observed.items()],
    'source_tree_sha256':source['source_tree_sha256'],'production_modules':len(modules),
    'semantic_files':len(semantic),'unit_files':len(unit),'changed_lean':len(changed),
    'historical_owner_pins_changed':len(changes),'operational_organization_capture_runs':0,'draft_runs':0,
    'validator_runs':0,'git_mutations':0,'source_acceptance':False})
print(json.dumps({'source_tree_sha256':source['source_tree_sha256'],'production_modules':len(modules),
    'semantic_files':len(semantic),'unit_files':len(unit),'changed_lean':len(changed),
    'historical_owner_pins_changed':changes,'absent_project_olean_cache_paths':missing,'receipt':ref(O/'receipt.json')}),flush=True)
