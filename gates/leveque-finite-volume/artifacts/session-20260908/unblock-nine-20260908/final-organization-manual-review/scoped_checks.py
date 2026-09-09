"""Pure source/policy inspection; does not run organization or gate validators."""
from pathlib import Path
import ast,collections,hashlib,json,re
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file());S=P.parent.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
snapshot=read(P/'snapshot.json')
def functions(path,names,scope):
 nodes=[x for x in ast.parse(path.read_bytes()).body if isinstance(x,ast.FunctionDef) and x.name in names]
 assert len(nodes)==len(names)
 exec(compile(ast.Module(body=nodes,type_ignores=[]),str(path)+'::pure-functions','exec'),scope)
 return scope
tier_path=R/'tools/architecture/check_tiers.py'
ts=functions(tier_path,{'resolve','matching_prefixes'},{})
hygiene_path=R/'tools/architecture/check_placeholders.py'
hs=functions(hygiene_path,{'strip_lean_comments_and_strings'},{})
tiers=read(R/'docs/architecture/tiers.json')
prefixes={x['prefix']:x['tier'] for x in tiers['prefixes']}
pins=snapshot['chapter_and_changed_dependency_closure']+[x for x in snapshot['anchor_changed_paths'] if x['path']=='ComputationalMathematics/Analysis.lean']
by_path={x['path']:x for x in pins}
roles={};imports={};findings={'unclassified_modules':[],'mixed_pending_split':[],'placeholder_findings':[]}
module_to_path={p[:-5].replace('/','.'):p for p in by_path}
missing_docs=[];wrapper_decls=[];unsorted=[]
declarations=re.compile(r'(?m)^\s*(?:(?:noncomputable|protected|private|unsafe)\s+)*(?:def|abbrev|structure|class|theorem|lemma|instance|axiom|constant)\b')
for path,pin in by_path.items():
 p=R/path;assert sha(p)==pin['sha256'];text=p.read_text(encoding='utf-8')
 role,rule=ts['resolve'](path[:-5].replace('/','.'),tiers['exact'],prefixes)
 roles[path]={'role':role,'rule':rule}
 if role=='unclassified':findings['unclassified_modules'].append(path)
 if role=='mixed':findings['mixed_pending_split'].append(path)
 code=hs['strip_lean_comments_and_strings'](text)
 for match in re.finditer(r"(?<![A-Za-z0-9_'.])(sorry|admit)(?![A-Za-z0-9_'])|(?m:^\s*(?:axiom|constant)\s+[A-Za-z_][A-Za-z0-9_'.]*)",code):
  findings['placeholder_findings'].append({'path':path,'line':code.count('\n',0,match.start())+1,'matched':match.group(0).strip()})
 imports[path]=re.findall(r'^(?:public\s+)?import\s+(\S+)',code,re.M)
 if '/-!' not in text:missing_docs.append(path)
 if role in ('aggregate','compatibility'):
  if declarations.search(code):wrapper_decls.append(path)
  if role=='aggregate' and imports[path]!=sorted(set(imports[path])):unsorted.append(path)
violations=[]
for path,role in roles.items():
 if role['role']!='reusable':continue
 todo=[(path,[path])];seen=set()
 while todo:
  p,trail=todo.pop()
  if p in seen:continue
  seen.add(p)
  for name in imports[p]:
   child=module_to_path.get(name)
   if child is not None:
    if roles[child]['role'] in ('source','compatibility'):
     violations.append(trail+[child])
    todo.append((child,trail+[child]))
old=read(P.parent/'final-current-organization-review/unit-scope-review.draft.json')
preserved=[];changed=[]
for pin in old['source_files']:
 now=ref(R/pin['path'])
 (preserved if now==pin else changed).append({'previous':pin,'current':now})
assert {x['current']['path'] for x in changed}=={'ComputationalMathematics/Analysis.lean','ComputationalMathematics/Source/LeVeque/Chapter01.lean'}
views=[]
for item in snapshot['staged_changed_paths']:
 path=item['path']
 if not path.endswith('.lean'):continue
 text=(R/path).read_text(encoding='utf-8');docs=re.findall(r'/\-!([\s\S]*?)\-/',text)
 views.append('FILE '+path+'\nROLE '+roles[path]['role']+'\nDOC\n'+('\n'.join(docs))+'\nIMPORTS\n'+'\n'.join(imports[path])+'\nDECLARATIONS\n'+'\n'.join(item['declarations']))
with (P/'staged-owner-views.txt').open('x',encoding='utf-8',newline='\n') as f:f.write('\n\n'.join(views)+'\n')
out={'schema':1,'status':'scoped-observations-root-review-required','snapshot':ref(P/'snapshot.json'),
 'pure_scanner_sources':[ref(tier_path),ref(hygiene_path)],'tier_policy':ref(R/'docs/architecture/tiers.json'),
 'scope_files':pins,'roles':roles,'source_findings':findings,
 'missing_module_docs':missing_docs,'declarations_in_structural_wrappers':wrapper_decls,
 'unsorted_or_duplicate_aggregate_imports':unsorted,'reusable_to_source_or_compatibility_paths':violations,
 'prior_review_source_preservation':{'review':ref(P.parent/'final-current-organization-review/REVIEW.md'),
  'previous_scope':ref(P.parent/'final-current-organization-review/unit-scope-review.draft.json'),
  'unchanged':preserved,'changed_aggregate_boundaries':changed},
 'limits':['Pure predicates applied only to the exact bound unit/import scope; no full repository checker or completion validator was run.',
  'Manual duplicate and placement conclusions require the separate review; role counts alone do not establish either.']}
with (P/'scoped-observations.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(out,indent=2)+'\n')
print(json.dumps({'observations':ref(P/'scoped-observations.json'),'scope_files':len(pins),
 'findings':findings,'missing_docs':missing_docs,'structural_wrapper_declarations':wrapper_decls,
 'unsorted_aggregates':unsorted,'forbidden_paths':violations,'preserved_prior_files':len(preserved),'changed_prior_files':len(changed)},indent=2))
