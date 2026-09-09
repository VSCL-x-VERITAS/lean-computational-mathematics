"""Bind the completed manual review to the root-corrected source snapshot."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,ast,hashlib,json,os,re,subprocess,sys
assert os.name!='nt','Use unchanged POSIX launcher'
sys.dont_write_bytecode=True
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
parser=argparse.ArgumentParser();parser.add_argument('--analysis-sha256',required=True);args=parser.parse_args()
assert args.analysis_sha256=='1e247ea03ff424c89d1067c35cdca6593edb4cf2928dc234fd649ad95b94dabb'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(path,value):
 with path.open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(value,indent=2)+'\n')
commands=[]
def git(label,argv):
 cmd=['git','--no-optional-locks','-c','core.longpaths=true',*argv]
 result=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 for suffix,raw in (('stdout.bin',result.stdout),('stderr.txt',result.stderr)):
  with (P/(label+'.'+suffix)).open('xb') as out:out.write(raw)
 commands.append({'command':cmd,'exit_code':result.returncode,'stdout':ref(P/(label+'.stdout.bin')),'stderr':ref(P/(label+'.stderr.txt'))})
 assert result.returncode==0
 return result.stdout
old=read(P/'snapshot.json');observation=read(P/'scoped-observations.json')
head=git('final-head',['rev-parse','HEAD']).decode().strip();assert head==old['head']
actual=git('final-anchor-paths',['diff','--name-only','-z',old['anchor'],'--','ComputationalMathematics','NumStability','docs/architecture/tiers.json'])
actual+=git('final-untracked-source',['ls-files','--others','--exclude-standard','-z','--','ComputationalMathematics','NumStability'])
names=sorted({x.decode() for x in actual.split(b'\0') if x})
assert names==[x['path'] for x in old['anchor_changed_paths']]
staged=git('final-staged-paths',['diff','--cached','--name-only','-z','--','ComputationalMathematics','NumStability','docs/architecture/tiers.json'])
assert sorted(x.decode() for x in staged.split(b'\0') if x)==[x['path'] for x in old['staged_changed_paths']]
source=[]
for pin in observation['scope_files']:
 current=ref(R/pin['path'])
 assert current==pin or (pin['path']=='ComputationalMathematics/Analysis.lean' and current['sha256']==args.analysis_sha256)
 source.append(current)
assert len(source)==209
repair_path=D/'analysis-casefold-order-repair/receipt.json';repair=read(repair_path)
for key in ('before','after','runner','trigger'):
 assert sha(R/repair[key]['path'])==repair[key]['sha256']
assert repair['after']==ref(R/'ComputationalMathematics/Analysis.lean')
before=(R/repair['before']['path']).read_text();after=(R/repair['after']['path']).read_text()
imports=lambda text:re.findall(r'^(?:public\s+)?import\s+(\S+)',text,re.M)
assert set(imports(before))==set(imports(after))
assert imports(after)==sorted(set(imports(after)),key=str.casefold)
assert re.sub(r'^(?:public\s+)?import\s+.*\n','',before,flags=re.M)==re.sub(r'^(?:public\s+)?import\s+.*\n','',after,flags=re.M)
sys.path.insert(0,str(R/'tools/architecture'))
import check_tiers as tier
import check_placeholders as hygiene
policy=read(R/'docs/architecture/tiers.json');prefixes={x['prefix']:x['tier'] for x in policy['prefixes']}
findings={key:[] for key in ('unexpected_changes','unclassified_modules','mixed_pending_split','duplicate_wrappers','placeholder_findings','canonical_placement_pending')}
roles={};imports_by_path={};structural=[];collisions=[]
for pin in source:
 path=pin['path'];p=R/path;text=p.read_text();code=hygiene.strip_lean_comments_and_strings(text)
 role,rule=tier.resolve(path[:-5].replace('/','.'),policy['exact'],prefixes);roles[path]={'role':role,'rule':rule}
 if role=='unclassified':findings['unclassified_modules'].append(path)
 if role=='mixed':findings['mixed_pending_split'].append(path)
 for regex in (hygiene.PLACEHOLDER_RE,hygiene.AXIOM_DECL_RE):
  for match in regex.finditer(code):findings['placeholder_findings'].append({'path':path,'line':code.count('\n',0,match.start())+1,'matched':match.group(0)})
 im=imports(code);imports_by_path[path]=im
 if role=='aggregate' and im!=sorted(set(im),key=str.casefold):structural.append(path)
 if p.with_suffix('').is_dir() and role not in ('aggregate','compatibility'):collisions.append(path)
assert not structural and not collisions
assert not any(findings.values())
anchor_policy=git('protected-anchor-layout-policy',['show',old['anchor']+':docs/architecture/layout-exceptions.json'])
ratchet=read(R/'docs/architecture/layout-exceptions.json')
anchor_digest=hashlib.sha256(anchor_policy).hexdigest()
assert anchor_digest==sha(R/'docs/architecture/layout-exceptions.json')
assert anchor_digest==sha(D/'final-current-organization-review/protected-anchor-layout-exceptions.json')
staged_paths={x['path'] for x in old['staged_changed_paths'] if x['path'].endswith('.lean')}
aggregate={'ComputationalMathematics/Analysis.lean','ComputationalMathematics/Source/LeVeque/Chapter01.lean'}
early_receipt=read(D/'organization/receipt.json');early=set(early_receipt['source_files_unchanged'])
for path,digest in early_receipt['source_files_unchanged'].items():assert sha(R/path)==digest
inventory=lambda path:{x['path'] for x in read(path)['files']}
high=inventory(D/'directional-high-resolution-production/production-files-frozen.json')
cert=inventory(D/'riemann-certified-production/production-files-frozen.json')
routine=inventory(D/'riemann-routine-production/files.json')
local=staged_paths-aggregate-early-high-cert-routine
assert [len(x) for x in (early,local,routine,high,cert,aggregate)]==[8,12,4,16,4,2]
prior={x['path'] for x in old['anchor_changed_paths'] if x['path'].endswith('.lean')}-staged_paths
assert len(prior)==91
groups=[]
def group(label,paths,reviews,rationale):
 refs=[ref(path) for path in reviews]
 groups.append({'group':label,'covered_source_paths':sorted(paths),'review_evidence':refs,'rationale':rationale})
group('earlier-committed-families',prior,[D/'final-current-organization-review/REVIEW.md',D/'final-current-organization-review/unit-scope-review.draft.json',S/'production-organization-review.md',S/'batch10-foundations-organization-review.md'],
 'Preserved preceding Chapter01/unit review plus exact unchanged source pins; no new semantic proof audit is claimed.')
group('early-eight-source-wrappers',early,[D/'material-review/REVIEW.md',D/'linear-review/REVIEW.md',D/'numerics-review/REVIEW.md',D/'organization/receipt.json'],
 'Thin correspondences over existing density, topology, averaging, acoustic, Riemann-data and finite-volume producers; old source alternatives remain.')
group('local-reference-and-geometry',local,[D/'organization-local-replacements/REVIEW.md',D/'organization-local-replacements/receipt.json'],
 'Local estimates, finite-slab information, full-lattice physical references and directional composition; generic ownership separate from three source wrappers.')
group('pure-information-routine',routine,[D/'organization-riemann-routine/REVIEW.md',D/'riemann-routine-production/receipt.json'],
 'Pure domain/solve/extract/flux execution, optional consistency, physical comparison and biased example; old Method preserved.')
group('finite-high-resolution-coordinate-family',high,[D/'organization-high-resolution/REVIEW.md',D/'directional-high-resolution-production/REVIEW.md',D/'directional-high-resolution-production/final-receipt.json'],
 'Actual finite geometry and refining methods with analytic, execution, estimates, Cartesian and example boundaries; one source wrapper.')
group('certified-information-routine',cert,[D/'organization-certified-routine/REVIEW.md',D/'riemann-certified-independent-review/verification.json',D/'riemann-certified-production/receipt.json'],
 'Separate optional accuracy certificate and actual-reference update assembly; existing pure routine/Method and scalar reference reused.')
group('public-exposure',aggregate,[repair_path,D/'organization-high-resolution/receipt.json',D/'organization-certified-routine/receipt.json'],
 'Declaration-free current canonical imports, same-set casefold repair and unchanged existing owner bodies.')
covered={p for g in groups for p in g['covered_source_paths']}
assert covered=={x['path'] for x in old['anchor_changed_paths'] if x['path'].endswith('.lean')}
manifest=D/'final-certified-complete-declarations/manifest.json'
for entry in read(manifest)['files']:assert sha(R/entry['path'])==entry['sha256']
all_evidence=[ref(P/'REVIEW.md'),ref(P/'snapshot.json'),ref(P/'scoped-observations.json'),ref(repair_path),ref(manifest),
 ref(D/'final-organization-current-input-preparation/scope-and-ratchet-blueprint.json'),
 ref(R/'tools/architecture/check_layout.py'),ref(R/'tools/architecture/check_tiers.py'),ref(R/'tools/architecture/check_placeholders.py')]
scope_ref=ref(P/'REVIEW.md')
data={'schema':1,'status':'root-review-required','kind':'manual-organization-scope-assessment','observed_at_utc':datetime.now(timezone.utc).isoformat(),
 'anchor':old['anchor'],'head':head,'review':scope_ref,'source_files':source,
 'source_files_sha256':hashlib.sha256(json.dumps(source,sort_keys=True,separators=(',',':')).encode()).hexdigest(),
 'reviewed_changed_source_paths':sorted(covered),'staged_changed_source_paths':sorted(staged_paths),
 'tier_policy':ref(R/'docs/architecture/tiers.json'),'roles':roles,'placement_groups':groups,'review_evidence':all_evidence,
 'placement_review_for_config':{'evidence':scope_ref,'rationale':'Independent current whole-unit ownership/reuse review, prior unchanged-owner verification, explicit final changed-path coverage and corrected aggregate ordering. No source acceptance or final checker applicability is inferred.',
  'covered_source_paths':sorted(covered)},
 'scope_assessment':{'rationale':'Exact changed-path set is covered by preserved and current manual placement reviews; current scoped tier resolution and comment-aware source inspection found no unclassified, mixed or placeholder entries. No confirmed duplicate or unresolved canonical placement was identified from the inspected contracts. Root adoption and current repository-wide measurement remain required.',
  'unit_scope':findings},
 'aggregate_order':{'repository_sort_key':'str.casefold','all_bound_aggregates_sorted_unique':True,'repair':ref(repair_path),'same_import_set_and_nonimport_content':True},
 'source_counts':{'anchor_changed_lean':137,'current_staged_lean':46,'metadata_paths':1,'unit_dependency_files':208,'aggregate_boundary_files':1,'unit_files':209},
 'preservation':{'previous_bound_files_unchanged':183,'changed_prior_aggregates':sorted(aggregate),
  'prior_observation':ref(P/'scoped-observations.json')},
 'legacy_ratchet':{'anchor':old['anchor'],'anchor_policy':ref(P/'protected-anchor-layout-policy.stdout.bin'),
  'current_policy':ref(R/'docs/architecture/layout-exceptions.json'),'policy_bytes_identical':True,
  'baseline_legacy_sets':json.loads(anchor_policy)['legacy'],'current_policy_legacy_sets':ratchet['legacy'],
  'current_measured_debt_sets':None,'reason':'Policy exception lists are not measured debt. Root binds the actual final layout/graph result separately.'},
 'final_complete_declaration_manifest':ref(manifest),'read_only_git_commands':commands,
 'limits':['This is an organization code/scope assessment, not a source-faithfulness audit or approval.',
  'No current full checker receipt, graph/native census, or operational measurement is manufactured by the manual review.',
  'Historical source contracts retain their separate stronger/weaker/different scopes and frozen audit provenance.',
  'Source/dependency signatures and module roles were reviewed; this does not repeat every historical proof or establish exhaustive mathematical inequivalence.',
  'Raw audit/evidence artifact publication and replay coverage are outside this production organization scope.'],
 'source_acceptance':False,'operational_measurement':False,'gate_mutation':False,'git_mutation':False}
assert git('final-head-recheck',['rev-parse','HEAD']).decode().strip()==head
for pin in source+[data['tier_policy']]:assert sha(R/pin['path'])==pin['sha256']
write(P/'review-data.json',data)
files=[ref(p) for p in sorted(P.iterdir()) if p.is_file()]
write(P/'manifest.json',{'schema':1,'files':files,'source_acceptance':False,'status':'root-review-required'})
receipt={'schema':1,'status':'FROZEN_ROOT_REVIEW_REQUIRED','review':ref(P/'REVIEW.md'),'data':ref(P/'review-data.json'),'manifest':ref(P/'manifest.json'),
 'head':head,'analysis_sha256':args.analysis_sha256,'unit_scope':findings,'source_acceptance':False,
 'operational_measurement':False,'all_readonly_git_exits_zero':all(x['exit_code']==0 for x in commands)}
write(P/'receipt.json',receipt)
print(json.dumps({'receipt':ref(P/'receipt.json'),**receipt},indent=2))
