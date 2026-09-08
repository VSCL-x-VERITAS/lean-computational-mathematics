from pathlib import Path
import hashlib,json,re,sys

P=Path(__file__).resolve().parent; R=P.parents[4]
label=sys.argv[1]; assert re.fullmatch('full[0-9]+',label)
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p): return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def put(p,v):
    assert not p.exists(),p
    p.write_bytes((json.dumps(v,indent=2)+'\n').encode())

receipt=P/(label+'-exit.json'); r=json.loads(receipt.read_bytes())
assert r['mode']=='full' and r['exit_code']==0 and r['inputs_unchanged']
for p,h in (r['input_files']|r['compiled_imports']).items(): assert sha(R/p)==h,p
out=P/(label+'-output.txt'); assert sha(out)==r['output_sha256']
raw=out.read_bytes(); text=raw.decode('utf-8')
assert not re.search(r'error:|warning:|sorryAx',text)
ax={n:[x.strip() for x in a.split(',') if x.strip()] for n,a in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.S)}
ax.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",text)})
src=P/(label+'-input.lean'); source=src.read_bytes(); all_names=re.findall(r'^#print axioms (\S+)',source.decode(),re.M)
assert len(r['checked_declarations'])==31
for n in all_names:
    assert n in ax and set(ax[n]) <= {'propext','Classical.choice','Quot.sound'},n
for n in r['checked_declarations']: assert n in all_names
base=R/'gates/leveque-finite-volume/artifacts/session-20260908/cartesian-coordinate-line-composition-draft/final03-input.lean'
assert source.count(base.read_bytes())==1
for name in ['Core.lean.fragment','Specializations.lean.fragment']:
    assert source.count((P/name).read_bytes())==1
offset=raw.index((r['checked_declarations'][0]+'.').encode())
pf=P/'native-declarations.proof-free.txt'; assert not pf.exists(); pf.write_bytes(raw[offset:])
put(P/'axioms.json',dict(status='PASS',new_declarations={n:ax[n] for n in r['checked_declarations']},all_checked_declarations={n:ax[n] for n in all_names}))
attempts=[]
for p in sorted(P.glob('*-exit.json')):
    a=json.loads(p.read_bytes()); stem=p.name.removesuffix('-exit.json'); output=P/(stem+'-output.txt'); inp=P/(stem+'-input.lean')
    assert a['inputs_unchanged'] and sha(output)==a['output_sha256']
    assert a['input_files'][inp.relative_to(R).as_posix()]==sha(inp)
    attempts.append(dict(label=stem,exit_code=a['exit_code'],receipt=bind(p),input=bind(inp),output=bind(output)))
artifacts=[bind(p) for p in sorted(P.iterdir()) if p.is_file() and p.name not in ['manifest.json','final-receipt.json','verification.json']]
manifest=dict(schema=1,status='prospective_unselected',source_acceptance=False,
    native_receipt=bind(receipt),native_output=bind(out),complete_input=bind(src),
    fragments=[bind(P/n) for n in ['Core.lean.fragment','Specializations.lean.fragment']],
    frozen_cartesian_input=bind(base),review=bind(P/'REVIEW.md'),preparation=bind(P/'preparation.json'),
    proof_free_native_output=dict(**bind(pf),parent=bind(out),byte_offset=offset,byte_length=len(raw)-offset),
    checked_declarations=r['checked_declarations'],inherited_checked_declarations=[n for n in all_names if n not in r['checked_declarations']],
    canonical_inputs=[dict(path=p,sha256=h) for p,h in r['input_files'].items() if p.startswith('ComputationalMathematics/')],
    compiled_imports=[dict(path=p,sha256=h) for p,h in r['compiled_imports'].items()],
    attempts=attempts,artifacts=artifacts,
    limits=dict(no_total_solver_assumption=True,all_executed_intermediate_states_require_admission=True,
        off_domain_fallback_has_no_solver_meaning=True,information_only_draft_imported=False,
        selected_source_wrapper=False,interpretation_answer_assumed=False,
        retained_field_contract='full returned field; strict prescribed initial states; all-real temporal trace integrability',
        geometry_question='call_axfTXsEjNKG3lawf5Dq10qQv',accuracy_question='call_1UY4fVuKrjpIIQfhLdeuFoRH',
        historical_receipts='Historical editable fragment hashes are preserved as on-run evidence; their full named Lean input snapshots remain immutable. Only final current dependency hashes are revalidated.'))
put(P/'manifest.json',manifest)
put(P/'final-receipt.json',dict(schema=1,status='PASS',selected=False,source_acceptance=False,
    manifest=bind(P/'manifest.json'),native_exit=0,native_receipt=bind(receipt),native_output=bind(out),
    complete_input=bind(src),new_declarations=len(r['checked_declarations']),
    all_declaration_checks=len(all_names),review=bind(P/'REVIEW.md')))
print(json.dumps(dict(manifest_sha256=sha(P/'manifest.json'),final_receipt_sha256=sha(P/'final-receipt.json'),complete_input_sha256=sha(src),new_declarations=len(r['checked_declarations']),all_declaration_checks=len(all_names))))
