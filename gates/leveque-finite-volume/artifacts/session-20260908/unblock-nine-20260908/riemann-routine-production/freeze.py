from pathlib import Path
import hashlib,json,re,datetime,subprocess
E=Path(__file__).resolve().parent
D=E.parent; S=D.parent; R=S.parents[3]; W=R.parent
def read(p):
 p=Path(p).resolve()
 return Path('\\\\?\\'+str(p)).read_bytes()
def sha(p): return hashlib.sha256(read(p)).hexdigest()
def ref(p):
 p=Path(p).resolve()
 try: n=p.relative_to(R).as_posix()
 except ValueError: n=str(p)
 return dict(path=n,sha256=sha(p),bytes=len(read(p)))
def write(name,data):
 p=E/name
 with p.open('xb') as f:f.write((json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode())
 return ref(p)
inventory=json.loads(read(E/'files-before-check.json'))
source_entry=inventory['files'][-1]
assert source_entry['sha256']==sha(E/'source-build-02.lean.snapshot')
old=read(E/'source-build-02.lean.snapshot').decode()
expected=old
for name in ['hab','holdDensity','hnewDensity','hleftFlux','hrightFlux','hphysicalBalance']:
 expected=expected.replace('('+name+' :','(_'+name+' :',1)
assert read(R/source_entry['path']).decode()==expected
source_entry['sha256']=sha(R/source_entry['path'])
decls=[]
for f in inventory['files']:
 assert sha(R/f['path'])==f['sha256']
 assert b'\r' not in read(R/f['path'])
 decls+=f['declarations']
checks={
 'unblock-nine-routine-core-build-01':(1,'core-build-01.lean.snapshot'),
 'unblock-nine-routine-update-build-01':(0,'update-before-localization.lean.snapshot'),
 'unblock-nine-routine-source-build-01':(1,'source-build-01.lean.snapshot'),
 'unblock-nine-routine-source-build-02':(0,'source-build-02.lean.snapshot'),
 'unblock-nine-routine-source-build-03':(0,None),
 'unblock-nine-routine-example-build-01':(1,'example-build-01.lean.snapshot'),
 'unblock-nine-routine-example-build-02':(0,None),
 'unblock-nine-routine-declarations-01':(0,'Declarations.lean'),
 'unblock-nine-routine-declarations-02':(0,'Declarations.lean'),
 'unblock-nine-routine-applicability-01':(1,'applicability-01.lean.snapshot'),
 'unblock-nine-routine-applicability-02':(1,'applicability-02.lean.snapshot'),
 'unblock-nine-routine-applicability-03':(0,'Applicability.lean'),
 'unblock-nine-routine-applicability-04':(0,'Applicability.lean')}
native=[]
for label,(code,inputfile) in checks.items():
 receipt=S/(label+'-exit.json'); output=S/(label+'-output.txt')
 j=json.loads(read(receipt))
 assert j['exit_code']==code and sha(output)==j['output_sha256']
 assert j['capture_script_sha256']==sha(D/'capture-check.py')
 txt=read(output).decode('utf8')
 warnings=len(re.findall(r'\bwarning:',txt))
 if code==0:
  assert not re.search(r'\berror:|sorryAx',txt)
  if label=='unblock-nine-routine-source-build-02': assert warnings==6
  else: assert warnings==0
 native.append(dict(label=label,actual_exit=code,receipt=ref(receipt),output=ref(output),
  input=ref(E/inputfile) if inputfile else None,command=j['command'],elapsed_ms=j['elapsed_ms'],
  warnings=warnings,source_snapshot=ref(E/'source-build-02.lean.snapshot') if label in {
   'unblock-nine-routine-declarations-01','unblock-nine-routine-applicability-01',
   'unblock-nine-routine-applicability-02','unblock-nine-routine-applicability-03'} else None))
def axioms(label,expected):
 txt=read(S/(label+'-output.txt')).decode()
 matches=re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",txt)
 found={name.split('.{')[0]:[s.strip() for s in raw.split(',') if s.strip()] for name,raw in matches}
 assert set(found)==set(expected),(set(found),set(expected))
 assert len(matches)==len(expected)
 for name,used in found.items():assert set(used)<={'propext','Classical.choice','Quot.sound'},(name,used)
 return found
reports=axioms('unblock-nine-routine-declarations-02',decls)
fixture_names=['LocalRoutineApplicability.actual_two_face_source_application',
 'LocalRoutineApplicability.actual_reference_and_nonconsistency']
fixture_reports=axioms('unblock-nine-routine-applicability-04',fixture_names)
base='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
modules=[base+n+'.lean' for n in ['LocalRiemannInformation','LocalRiemannInformationUpdate',
 'LocalCellErrorBounds','CellAverage','CellVolumeAverage','Examples/LeftStateInformationFlux',
 'Examples/StationaryRiemannField']]
modules+=['.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean',
 '.lake/packages/mathlib/Mathlib/Analysis/Normed/Module/Basic.lean']
dependencies=[]
for rel in modules:
 p=R/rel
 if rel.startswith('.lake/packages/mathlib/'):
  o=R/'.lake/packages/mathlib/.lake/build/lib/lean'/Path(rel.removeprefix('.lake/packages/mathlib/')).with_suffix('.olean')
 else:o=R/'.lake/build/lib/lean'/Path(rel).with_suffix('.olean')
 dependencies.append(dict(source=ref(p),compiled=ref(o)))
prior=S/'audits/LEV-CH01-LOCAL-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908/faithfulness'
prior_manifest=json.loads(read(prior/'manifest.json'))
assert sha(prior/'decision.json')=='afc764d552b0f3ee9739eea5ec2a5377d1718635410c12bd957f444ac947178c'
assert sha(R/prior_manifest['target']['path'])==prior_manifest['target']['sha256']
pdf=R/prior_manifest['source']['path']
assert sha(pdf)=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert sha(D/'selected-interpretations.json')=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
runtime=[ref(R/'lean-toolchain'),ref(R/'lake-manifest.json'),ref(D/'capture-check.py'),
 ref(W/'workflow-v5.0.1-local/run_workflow_posix.py'),ref(W/'workflow-v5.0.1-local/posix_git.py')]
runtime+=[ref(Path('C:/Users/qed_s/.elan/bin/lake.exe')),
 ref(Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin/lean.exe'))]
sources=[ref(pdf),ref(prior/'manifest.json'),ref(prior/'decision.json'),ref(prior/'inputs/source_locator.json'),
 ref(D/'selected-interpretations.json'),ref(R/prior_manifest['target']['path'])]
sources += [ref(W/f'workflow-v5.0.1-local/chapter01-source-review/page-{i:03}.png') for i in [26,27,28]]
search=[['rg','-n','norm_add_le|norm_sub_le',str(R/modules[-2])],
 ['rg','-n','finiteVolumeLocalCell_error_contract|oneDimensionalCellAverage_isCellAverage|selected_flux_eq_reference_average|reference_rectangle|reference_initial',
  *[str(R/(base+n+'.lean')) for n in ['LocalCellErrorBounds','CellAverage','Examples/LeftStateInformationFlux','Examples/StationaryRiemannField']]]]
search_records=[]
for i,cmd in enumerate(search):
 result=subprocess.run(cmd,cwd=R,capture_output=True)
 path=E/f'selected-reuse-search-{i+1:02}.txt'
 with path.open('xb') as f:f.write(result.stdout+result.stderr)
 search_records.append(dict(argv=cmd,actual_exit=result.returncode,output=ref(path)))
assert len(decls)==22
final_inventory=write('files.json',inventory)
manifest=write('manifest.json',dict(schema=1,status='NATIVE_CHECKED',source_acceptance=False,
 files=inventory['files'],declaration_count=22,lines=sum(f['lines']for f in inventory['files']),
 normalized_files=final_inventory,
 native=native,axioms=reports,fixture_axioms=fixture_reports,dependencies=dependencies,runtime=runtime,
 production_compiled=[ref(R/'.lake/build/lib/lean'/Path(f['path']).with_suffix('.olean')) for f in inventory['files']],
 source_and_interpretation=sources,searches=search_records,
 proof_free_check=ref(E/'Declarations.lean'),applicability=ref(E/'Applicability.lean'),review=ref(E/'REVIEW.md'),
 evidence=[ref(p) for p in sorted(E.iterdir()) if p.is_file() and p.name not in {'manifest.json','receipt.json'}]))
receipt=write('receipt.json',dict(schema=1,status='PASS',source_acceptance=False,
 created_at_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),manifest=manifest,
 final_production_hashes={f['path']:f['sha256']for f in inventory['files']},
 native_declarations_exit=0,authored_declarations=22,fixture_declarations=2,
 permitted_axioms=['propext','Classical.choice','Quot.sound'],
 old_source_target_unchanged=ref(R/prior_manifest['target']['path']),
 limitations=['No new source audit or acceptance','No aggregate, tier, gate, ledger or Git mutation',
 'Native builds and checks cover only the four new leaves and explicit fixtures']))
print(json.dumps(dict(manifest=manifest,receipt=receipt)))
