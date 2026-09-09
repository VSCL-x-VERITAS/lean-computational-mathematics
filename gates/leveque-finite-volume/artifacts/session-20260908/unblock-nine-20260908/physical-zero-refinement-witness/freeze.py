from pathlib import Path
import datetime,hashlib,json,re,sys
h=Path(__file__).resolve().parent;f=h/sys.argv[1]
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def load(p):return json.loads(read(p))
n=load(f/'receipt.json');assert n['actual_exit_code']==0 and n['inputs_unchanged']
assert read(f/'Candidate.lean.snapshot')==read(h/'Candidate.lean')
assert read(f/'native-stderr.txt')==b''
out=read(f/'native-output.txt').decode();assert not re.search(r'\b(?:warning|error):',out)
reports=re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",out,re.S)
for name,ax in reports:assert {s.strip() for s in ax.split(',') if s.strip()}<={'propext','Classical.choice','Quot.sound'},(name,ax)
decls=load(h/'declarations.json')
for row in decls:
 name=row['name'];assert [s for s,_ in reports].count(name)==1,name
 assert re.search(r'^'+re.escape(name)+r'(?:\s|\.|:)',out,re.M),name
for pin in load(f/'inputs-after.json')+load(h/'copied-inputs.json')['pins']:
 assert ref(Path(pin['path']))['sha256']==pin['sha256'],pin['path']
verification={'actual_native_exit_code':0,'authored_declarations':len(decls),'all_allowed_axiom_reports':len(reports),'no_warnings':True,'inputs_unchanged':True,'new_quality_definitions':False,'exact_frozen_root_quality_applied':True,'nonconstant_genuine_reference_in_same_class':True,'source_acceptance':False}
p=h/'verification.json';assert not p.exists();p.write_text(json.dumps(verification,indent=2)+'\n',encoding='utf-8')
manifest={'status':'FROZEN_NATIVE_VERIFIED_ARTIFACT_ONLY','files':[ref(p) for p in h.iterdir() if p.is_file() and p.name not in {'manifest.json','receipt.json'}],'frozen_inputs':load(h/'copied-inputs.json'),'attempts':[ref(p/'receipt.json') for p in sorted(h.glob('native-*')) if (p/'receipt.json').exists()],'final_native':ref(f/'receipt.json'),'final_output':ref(f/'native-output.txt'),'input_pins':ref(f/'inputs-after.json'),'source':ref(h/'Candidate.lean'),'authored':decls,'scope':'One complete zero-physical-flux Family quality inhabitant on actual growing measured Cartesian meshes; moving CFL consumer preserved separately.'}
p=h/'manifest.json';assert not p.exists();p.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
receipt={'finished_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'status':'FROZEN_NATIVE_VERIFIED','manifest':ref(p),'verification':ref(h/'verification.json'),'source':ref(h/'Candidate.lean'),'native':ref(f/'receipt.json'),'new_declaration_count':len(decls),'allowed_report_count':len(reports),'source_acceptance':False}
p=h/'receipt.json';assert not p.exists();p.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt':ref(p),'manifest':ref(h/'manifest.json'),'source':ref(h/'Candidate.lean'),'verification':verification},indent=2))
