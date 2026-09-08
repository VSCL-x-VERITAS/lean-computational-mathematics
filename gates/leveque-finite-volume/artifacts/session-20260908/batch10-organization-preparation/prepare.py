"""Derive batch10 helpers; never run classification, Lean export, Git or gates."""
from pathlib import Path, PurePosixPath
import argparse, ast, hashlib, json, re

HERE=Path(__file__).resolve().parent
SESSION=HERE.parent
REPO=HERE.parents[4]
PINS={
 'prepare-batch9-organization.py':'1fb23946c7e316e92679cf206a2c31a2db323bebb3894bddf75dfaad2e42dc25',
 'classify-batch9-foundations.py':'8813a6aa49e6dc209638c11b53511ba4ae2415d7f4c40b68ecdb8c440175a20f',
 'export-batch9-declaration-expressions.lean':'e0b43795a2f5b208c47def9906f858f28fc181bed4e49624f632922928e40411',
 'merge-batch9-expression-fingerprints.py':'923d586d51e9c2722c9854bbde0aa5281d93b57a861922cfa795995a9e0a6ac3',
 'freeze-chapter01-expression-fingerprints-v3.py':'fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702',
 'chapter01-current-expression-fingerprints-521f.json':'5c2dcd727b7103b6b47de8899505705a2db6de59beb97228dc6c0ed2677d8553'}
TIERS_SHA='d2e3d27cc54a09021083064eed68f45741e06b2255c672c0bd79dc2307002aa2'
FV='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
EXPECTED_PATHS={FV+x+'.lean' for x in [
 'RiemannInformationFluxMethod','RiemannFieldFluxMethodInformation','RiemannInformationFluxError',
 'Examples/LeftStateInformationFlux','RiemannInformationCoordinateUpdate','RiemannInformationCoordinateSweep',
 'CartesianGridGeometry','CartesianCoordinateUpdate','Examples/LeftStateCoordinateSweep']}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
encode=lambda obj:(json.dumps(obj,indent=2,ensure_ascii=False)+'\n').encode()

def relative_path(value):
 assert isinstance(value,str) and '\\' not in value,value
 p=PurePosixPath(value)
 assert not p.is_absolute() and '..' not in p.parts and ':' not in value and p.as_posix()==value,value
 return p

def strip_comments(text):
 """Only lexical comment stripping for this bounded declaration inventory, not a Lean parser."""
 out=[];depth=0;i=0;quoted=False
 while i<len(text):
  pair=text[i:i+2]
  if not quoted and pair=='/-':depth+=1;i+=2;continue
  if depth and pair=='-/':depth-=1;i+=2;continue
  if depth:
   out.append('\n' if text[i]=='\n' else ' ');i+=1;continue
  if not quoted and pair=='--':
   end=text.find('\n',i);i=len(text) if end<0 else end;continue
  ch=text[i];out.append(ch)
  if ch=='"' and (i==0 or text[i-1]!='\\'):quoted=not quoted
  i+=1
 assert depth==0,'unclosed source comment'
 return ''.join(out)

def authored_names(text):
 frames=[];names=[]
 for raw in strip_comments(text).splitlines():
  line=raw.strip()
  if line.startswith('namespace '):frames.append(('namespace',line.split()[1]));continue
  if re.match(r'^(?:noncomputable )?section(?:\s|$)',line):frames.append(('section',''));continue
  if re.match(r'^end(?:\s|$)',line):
   assert frames,('unmatched end',line)
   frames.pop();continue
  line=re.sub(r'^@\[[^\]]*\]\s*','',line)
  match=re.match(r'^(?:(?:noncomputable|private|protected)\s+)*(?:def|theorem|lemma|abbrev|structure|class|instance)\s+([^\s(:{]+)',line)
  if match:
   prefix='.'.join(value for kind,value in frames if kind=='namespace')
   names.append((prefix+'.' if prefix else '')+match.group(1))
 assert not frames,'unclosed namespace/section'
 return names

def validate_inventory(data,repo):
 assert type(data.get('schema')) is int and data['schema']==1
 files=data.get('files');assert isinstance(files,list) and len(files)==9
 assert {f['path'] for f in files}==EXPECTED_PATHS and len({f['path'] for f in files})==9
 allnames=[]
 for f in files:
  relative_path(f['path']);assert f['module']==f['path'][:-5].replace('/','.')
  assert re.fullmatch('[0-9a-f]{64}',f['sha256'])
  p=repo/f['path'];raw=p.read_bytes();assert sha(p)==f['sha256'],f['path']
  assert b'\r' not in raw,'production LF required'
  assert type(f['lines']) is int and f['lines']>0 and f['lines']==len(raw.splitlines()),f['path']
  names=f['declarations'];assert isinstance(names,list) and names and all(isinstance(n,str) and n.startswith('NumStability.') for n in names)
  assert len(set(names))==len(names)
  if 'declaration_count' in f:assert type(f['declaration_count']) is int and f['declaration_count']==len(names)
  actual=authored_names(raw.decode('utf-8'))
  assert len(actual)==len(names) and set(actual)==set(names),(f['path'],actual,names)
  allnames+=names
 assert len(set(allnames))==len(allnames),'cross-file authored-name collision'
 return sorted(files,key=lambda f:f['path']),sorted(allnames)

def replace_checked(text,old,new,changes,count=1):
 assert text.count(old)==count,(old,text.count(old),count)
 changes.append(dict(old=old,new=new,occurrences=count))
 return text.replace(old,new)

def classifier_text(parent,intro,inventory_rel,inventory_sha,module_count,reusable_count):
 changes=[];text=parent
 replacements=[
  ('six committed','nine committed'),
  ('S=Path(__file__).resolve().parent;R=S.parents[3]','S=Path(__file__).resolve().parents[2];R=S.parents[3]'),
  ('521f73a23a95a842928c581fa011a46379b3b547',intro),
  ('b2b31b08695ca45d1594adc1709e714af0373c560e3bafbc1a8ede2e5f3e6510',TIERS_SHA),
  ("review=json.loads((S/'root-batch9-production-placement-verification.json').read_bytes())",
   f"reviewpath=R/{inventory_rel!r};assert sha(reviewpath)=={inventory_sha!r}\nreview=json.loads(reviewpath.read_bytes())\nassert (S/'batch10-foundations-organization-review.md').is_file()"),
  ("len(review['files'])==6","len(review['files'])==9"),
  ('Generic normalized-average laws, trace estimate, returned-field method, conditional error estimates or explicit example; no source-specific contract.',
   'Generic information-returning method, field adapter, conditional flux errors, admitted coordinate updates/sweeps, Cartesian geometry/update correspondence or explicit example; no source-specific contract.'),
  ('batch9-foundations-organization-review.md','batch10-foundations-organization-review.md'),
  ('==5959','=='+str(module_count)),("roles['reusable']==654","roles['reusable']=="+str(reusable_count)),
  ('assert not check_tiers.validate(R,manifest,modules)',
   "assert manifest['prefixes']==json.loads(before)['prefixes']\nassert manifest['prefix_rules']==json.loads(before)['prefix_rules']\nassert not check_tiers.validate(R,manifest,modules)"),
  ('batch9-tiers-before-','batch10-tiers-before-'),("'new_exact_rules':6","'new_exact_rules':9"),
  ('batch9-tier-update.json','batch10-tier-update.json')]
 for old,new in replacements:text=replace_checked(text,old,new,changes)
 ast.parse(text)
 return text,changes

def exporter_text(parent,modules):
 start=parent.index('private def selectedModules : Array String := #[\n')
 end=parent.index('\n]\n\nrun_cmd do',start)
 before=parent[:start];after=parent[end:]
 assert after.count('.lake/chapter01-batch9-expressions.jsonl')==1
 result=before+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+after.replace('.lake/chapter01-batch9-expressions.jsonl','.lake/chapter01-batch10-expressions.jsonl')
 return result,dict(selected_modules_only=True,stream_path_change=['.lake/chapter01-batch9-expressions.jsonl','.lake/chapter01-batch10-expressions.jsonl'],serializer_and_filters_unchanged=True)

def merger_text(parent,intro,inputs_rel,inputs_sha,authored_count,module_count):
 changes=[];text=parent
 replacements=[
  ('S=Path(__file__).resolve().parent;R=S.parents[3]','S=Path(__file__).resolve().parents[2];R=S.parents[3]'),
  ("out=S/'chapter01-current-expression-fingerprints-521f.json'",f"out=S/'chapter01-current-expression-fingerprints-{intro[:4]}.json'"),
  ('chapter01-current-expression-fingerprints-03c8.json','chapter01-current-expression-fingerprints-521f.json'),
  ('8b8fa9ce9c192a689a613625a77fd25293431c4687db6e01f71864ff519b3b72',PINS['chapter01-current-expression-fingerprints-521f.json']),
  ("inp=S/'batch9-expression-export-inputs.json'",f'inp=R/{inputs_rel!r}'),
  ('67c769f37d40da0e7bdc1479107e1ce47d79eb85c9d592d67c721a860c394547',inputs_sha),
  ('batch9-expression-export','batch10-expression-export',3),
  ('batch9-foundations-full-build','batch10-foundations-full-build'),
  ('batch9-graph-capture','batch10-graph-capture'),('batch9-graph-check','batch10-graph-check'),
  ('chapter01-batch9-expressions.jsonl','chapter01-batch10-expressions.jsonl'),
  ('len(expected)==37','len(expected)=='+str(authored_count)),('len(newpaths)==82','len(newpaths)==91'),
  ('checkpoint-521f73a2-foundations.json',f'checkpoint-{intro[:8]}-foundations.json'),
  ("graph['source']['module_count']==5959","graph['source']['module_count']=="+str(module_count)),
  ('All 96 previous declaration-owner sources retain their exact hashes. Six disjoint new owners',
   'All 102 previous declaration-owner sources retain their exact hashes. Nine disjoint new owners')]
 for item in replacements:text=replace_checked(text,item[0],item[1],changes,item[2] if len(item)==3 else 1)
 ast.parse(text)
 return text,changes

def main():
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--inventory',type=Path,required=True);parser.add_argument('--inventory-sha256',required=True)
 parser.add_argument('--introduction-commit',required=True)
 parser.add_argument('--entry-point-receipt',type=Path,required=True);parser.add_argument('--entry-point-sha256',required=True)
 parser.add_argument('--output-dir',type=Path,required=True)
 args=parser.parse_args()
 intro=args.introduction_commit;assert re.fullmatch('[0-9a-f]{40}',intro)
 out=args.output_dir.resolve();assert out.parent==HERE and not out.exists(),'fresh direct child of this preparation directory required'
 inventory=args.inventory.resolve();entrypath=args.entry_point_receipt.resolve()
 assert inventory.is_relative_to(SESSION) and entrypath.is_relative_to(SESSION)
 assert inventory==SESSION/'root-batch10-production-placement-verification.json'
 assert entrypath==SESSION/'batch10-analysis-imports.json'
 assert sha(inventory)==args.inventory_sha256 and sha(entrypath)==args.entry_point_sha256
 for name,pin in PINS.items():assert sha(SESSION/name)==pin,name
 assert sha(REPO/'docs/architecture/tiers.json')==TIERS_SHA
 reviewed=json.loads(inventory.read_bytes())
 assert reviewed.get('status')=='PASS' and reviewed.get('source_acceptance') is False
 files,expected=validate_inventory(reviewed,REPO)
 modules=sorted(f['module'] for f in files)
 tiers=json.loads((REPO/'docs/architecture/tiers.json').read_bytes())
 assert tiers['counts']['production_modules']==5959 and tiers['counts']['by_role']['reusable']==654
 old=json.loads((SESSION/'chapter01-current-expression-fingerprints-521f.json').read_bytes())
 assert len(old['files'])==102 and len(old['added_production_modules'])==82
 for f in old['files']:assert sha(REPO/f['path'])==f['sha256'],f['path']
 assert not set(modules)&set(old['selected_modules'])
 entry=json.loads(entrypath.read_bytes());relative_path(entry['path'])
 assert entry['path']=='ComputationalMathematics/Analysis.lean' and sha(REPO/entry['path'])==entry['after_sha256']
 assert set(entry['added_imports'])==set(modules) and len(entry['added_imports'])==9
 imports=re.findall(r'^(?:public )?import (\S+)',(REPO/entry['path']).read_text(encoding='utf-8'),re.M)
 assert all(imports.count(m)==1 for m in modules)
 classifier,cchanges=classifier_text((SESSION/'classify-batch9-foundations.py').read_text(encoding='utf-8'),intro,
  inventory.relative_to(REPO).as_posix(),sha(inventory),5968,663)
 exporter,echanges=exporter_text((SESSION/'export-batch9-declaration-expressions.lean').read_text(encoding='utf-8'),modules)
 exporter_path=out/'export-batch10-declaration-expressions.lean'
 inputs=dict(schema=1,files=[{k:f[k] for k in ['path','sha256']} for f in files],selected_modules=modules,
  expected_authored_declarations=expected,exporter_path=exporter_path.relative_to(REPO).as_posix(),
  exporter_sha256=hashlib.sha256(exporter.encode()).hexdigest(),normalization=old['normalization'],
  prior_exporter_sha256=PINS['export-batch9-declaration-expressions.lean'],
  prior_fingerprints_sha256=PINS['chapter01-current-expression-fingerprints-521f.json'],input_commit=intro,
  entry_point_additions=entry,inventory=dict(path=inventory.relative_to(REPO).as_posix(),sha256=sha(inventory)),
  entry_point_receipt=dict(path=entrypath.relative_to(REPO).as_posix(),sha256=sha(entrypath)))
 inputbytes=encode(inputs);inputs_path=out/'batch10-expression-export-inputs.json'
 merger,mchanges=merger_text((SESSION/'merge-batch9-expression-fingerprints.py').read_text(encoding='utf-8'),intro,
  inputs_path.relative_to(REPO).as_posix(),hashlib.sha256(inputbytes).hexdigest(),len(expected),5968)
 assert not (SESSION/f'chapter01-current-expression-fingerprints-{intro[:4]}.json').exists(),'fingerprint output collision'
 outputs={'classify-batch10-foundations.py':classifier.encode(),'export-batch10-declaration-expressions.lean':exporter.encode(),
  'batch10-expression-export-inputs.json':inputbytes,'merge-batch10-expression-fingerprints.py':merger.encode()}
 out.mkdir()
 for name,raw in outputs.items():
  with (out/name).open('xb') as f:f.write(raw)
 derivation=dict(schema=1,prepared_only=True,introduction_commit_supplied_not_independently_resolved=intro,
  inventory=inputs['inventory'],entry_point_receipt=inputs['entry_point_receipt'],pinned_parents=PINS,
  tiers_before_sha256=TIERS_SHA,modules=9,authored_declarations=len(expected),expected_module_count=5968,
  policy='Only nine reusable exact rules; original exact roles and prefixes retained. No helper executed.',
  derivations=[dict(parent='classify-batch9-foundations.py',child='classify-batch10-foundations.py',changes=cchanges),
   dict(parent='export-batch9-declaration-expressions.lean',child='export-batch10-declaration-expressions.lean',changes=echanges),
   dict(parent='merge-batch9-expression-fingerprints.py',child='merge-batch10-expression-fingerprints.py',changes=mchanges)],
  outputs=[dict(path=(out/name).relative_to(REPO).as_posix(),sha256=sha(out/name)) for name in outputs])
 with (out/'derivations.json').open('xb') as f:f.write(encode(derivation))
 print(json.dumps(dict(prepared_only=True,derivations_path=str(out/'derivations.json'),sha256=sha(out/'derivations.json'),modules=9,authored_declarations=len(expected))))

if __name__=='__main__':main()
