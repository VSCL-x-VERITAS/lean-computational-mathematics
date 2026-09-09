from pathlib import Path
import ast,hashlib,json
F=Path(__file__).resolve().parent;R=next(p for p in F.parents if (p/'lean-toolchain').exists())
xp=lambda p:Path('\\\\?\\'+str(p)) if not str(p).startswith('\\\\?\\') else p
def sha(p):
 h=hashlib.sha256()
 with xp(p).open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(xp(p).read_bytes())
def write(name,value):
 p=F/name
 with xp(p).open('x',encoding='utf-8',newline='\n') as f:json.dump(value,f,indent=2);f.write('\n')
 return ref(p)
receipt=read(F/'fingerprint-receipt.json');assert receipt['actual_exit_code']==0 and receipt['total_constant_records']==148
assert receipt['combined_disjoint_constants']==1089 and receipt['combined_owner_files']==147
fp=read(R/receipt['fingerprints']['path'])
for x in fp['files']+fp['prior_fingerprints']+[receipt['fingerprints'],receipt['mapping'],receipt['native_receipt'],receipt['native_output'],receipt['archive']]:
 assert sha(R/x['path'])==x['sha256'],x
syntax=[]
for p in F.glob('*.py'):
 text=xp(p).read_text(encoding='utf-8');ast.parse(text);compile(text,str(p),'exec');syntax.append(ref(p))
syntax_ref=write('syntax-validation.json',dict(actual_result='PASS',scripts=syntax,execution='ast.parse and compile only; helper main bodies and optional committed-blob command not executed'))
files=[ref(F/p.name) for p in xp(F).iterdir() if p.is_file() and p.suffix!='.jsonl' and p.name not in ('stage-files.json','final-package.json','final-receipt.json')]
staging=write('stage-files.json',dict(files=files,excluded=[dict(path=fp['native_raw_stream']['path'],sha256=fp['native_raw_stream']['sha256'],bytes=fp['native_raw_stream']['bytes'],reason='Large raw stream retained locally; the exact deterministic gzip is included instead.')],staging_performed=False))
manifest=write('final-package.json',dict(status='FROZEN-NATIVE-FINGERPRINTS-NO-SEMANTIC-VERDICT',fingerprint_receipt=ref(F/'fingerprint-receipt.json'),readme=ref(F/'README.md'),syntax_validation=syntax_ref,stage_files=staging,records=148,owners=13,new_owners=12,unchanged_dependency_owners=1,authored_new_declarations=44,combined_records=1089,combined_owners=147,all_prior_inventories_unchanged=True,later_committed_blob_check_pending=True,no_staging_git_gate_or_audit_mutation=True))
final=write('final-receipt.json',dict(final_package=manifest,fingerprints=receipt['fingerprints'],mapping=receipt['mapping'],archive=receipt['archive'],fingerprint_receipt=ref(F/'fingerprint-receipt.json'),native_actual_exit=0,syntax_validation=syntax_ref,staging_list=staging,input_commit=receipt['input_commit'],unchanged_source_olean_tools_and_head=True,prepared_commit_verifier_not_executed=True))
print(json.dumps(dict(receipt=final,manifest=manifest,fingerprints=receipt['fingerprints'],archive=receipt['archive'],staging_list=staging),indent=2))
