from pathlib import Path
import datetime,hashlib,json,re,sys
h=Path(__file__).resolve().parent
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def load(p):return json.loads(read(p))
folder=h/sys.argv[1]
native=load(folder/'receipt.json')
assert native['actual_exit_code']==0 and native['inputs_unchanged']
assert read(folder/'Candidate.lean.snapshot')==read(h/'Candidate.lean')
assert read(folder/'native-stderr.txt')==b''
output=read(folder/'native-output.txt').decode()
assert not re.search(r'\b(?:error|warning):',output)
inventory=load(h/'declarations.json')
names=[x['name'] for row in inventory for x in row['declarations']]
reports=re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",output,re.S)
allowed={'propext','Classical.choice','Quot.sound'}
for name,axioms in reports:
 found={x.strip() for x in axioms.split(',') if x.strip()}
 assert found<=allowed,(name,found)
reported=[name for name,_ in reports]
for name in names:
 assert reported.count(name)==1,(name,reported.count(name))
 assert re.search(r'^'+re.escape(name)+r'(?:\s|\.|:)',output,re.M),name
for row in load(folder/'inputs-after.json'):
 assert ref(Path(row['path']))['sha256']==row['sha256'],row['path']
for pinname in ['copied-inputs.json','copied-capacity-inputs.json','copied-reference.json']:
 def verify(obj):
  if isinstance(obj,dict):
   if 'path' in obj and 'sha256' in obj:assert ref(Path(obj['path']))['sha256']==obj['sha256'],obj['path']
   for v in obj.values():verify(v)
  elif isinstance(obj,list):
   for v in obj:verify(v)
 verify(load(h/pinname))
assert all(row['actual_exit_code']==0 for row in load(h/'search-receipt.json'))
verification={'actual_native_exit_code':0,'authored_declaration_count':len(names),'allowed_axiom_report_count':len(reports),'authored_reports_exactly_once':True,'warnings':False,'source_snapshot_equal':True,'native_inputs_unchanged':True,'source_and_compiled_pin_count':len(load(folder/'inputs-after.json')),'copied_inputs_revalidated':True,'scope':'Measured growing Cartesian geometry and nonconstant CFL-one consumers; no generic quality/source acceptance.'}
for target,data in [('verification.json',verification)]:
 p=h/target;assert not p.exists();p.write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8')
files=[ref(p) for p in h.iterdir() if p.is_file() and p.name not in {'manifest.json','receipt.json'}]
attempts=[ref(p/'receipt.json') for p in sorted(h.glob('native-*')) if (p/'receipt.json').exists()]
manifest={'schema':1,'status':'NATIVE_VERIFIED_ARTIFACT_ONLY','files':files,'native_attempts':attempts,'reference_companion_receipt':ref(h/'reference-native/receipt.json'),'final_native_receipt':ref(folder/'receipt.json'),'final_native_output':ref(folder/'native-output.txt'),'native_input_inventory':ref(folder/'inputs-after.json'),'source':ref(h/'Candidate.lean'),'declarations':inventory,'scope_limits':['No generic PhysicalRefinementQuality instance in this packet','No source acceptance or production placement','Ico Cartesian boxes and sup product metric','Separate directional C-infinity references, not an unsplit PDE theorem','Unused ghost slots totalized to bounded genuine boxes; exact equality proved on used neighbors']}
p=h/'manifest.json';assert not p.exists();p.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
receipt={'schema':1,'finished_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'status':'FROZEN_NATIVE_VERIFIED','manifest':ref(p),'verification':ref(h/'verification.json'),'source':ref(h/'Candidate.lean'),'final_native_receipt':ref(folder/'receipt.json'),'authored_declaration_count':len(names),'allowed_axiom_report_count':len(reports),'no_source_acceptance':True}
p=h/'receipt.json';assert not p.exists();p.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt':ref(p),'manifest':ref(h/'manifest.json'),'source':ref(h/'Candidate.lean'),'verification':verification},indent=2))
