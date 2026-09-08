from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def put(p,v):
 assert not p.exists(),p
 p.write_bytes((json.dumps(v,indent=2)+'\n').encode())
r=json.loads((P/'native01-exit.json').read_bytes());assert r['exit_code']==0 and r['inputs_unchanged']
for p,h in (r['input_files']|r['compiled_imports']).items():assert sha(R/p)==h,p
out=P/'native01-output.txt';assert sha(out)==r['output_sha256'];text=out.read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx',text)
ax={n:[x.strip() for x in a.split(',') if x.strip()] for n,a in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.S)}
ax.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",text)})
for n in r['checked_declarations']:assert n in ax and set(ax[n])<={'propext','Classical.choice','Quot.sound'},n
assert len(r['checked_declarations'])==7
t=(P/'Candidate.lean').read_text(encoding='utf-8')
assert (P/'native01-input.lean').read_bytes().startswith((P/'Candidate.lean').read_bytes()+b'\n')
body=t[t.index('def PureInterfaceContract'):t.index('\ntheorem pure_interface_execution')].strip()
doc='# Exact prospective contracts\n\nUnselected scratch mathematics; no source interpretation is adopted.\n\n```lean\n'+body+'\n```\n\n'
for m in re.finditer(r'^theorem (\w+)',t,re.M):
 block=t[m.start():];stop=re.search(r' :=(?: by)?\n',block);assert stop,m.group(1)
 doc+='```lean\n'+block[:stop.start()]+'\n```\n\n'
p=P/'contracts.proof-free.md';assert not p.exists();p.write_bytes(doc.encode('utf-8'))
put(P/'axioms.json',dict(status='PASS',declarations={n:ax[n] for n in r['checked_declarations']}))
artifacts=[bind(p) for p in sorted(P.iterdir()) if p.is_file() and p.name not in ['manifest.json','final-receipt.json']]
put(P/'manifest.json',dict(schema=1,status='prospective_unselected',source_acceptance=False,candidate=bind(P/'Candidate.lean'),native_receipt=bind(P/'native01-exit.json'),native_output=bind(out),review=bind(P/'REVIEW.md'),proof_free_contracts=bind(P/'contracts.proof-free.md'),preparation=bind(P/'preparation.json'),checked_declarations=r['checked_declarations'],canonical_inputs=[dict(path=p,sha256=h) for p,h in r['input_files'].items() if p.startswith('ComputationalMathematics/')],compiled_imports=[dict(path=p,sha256=h) for p,h in r['compiled_imports'].items()],artifacts=artifacts,remaining_scope=dict(accuracy_question='call_1UY4fVuKrjpIIQfhLdeuFoRH',answer_assumed=False,additional_boundary='full returned field, exact initial data, all-real integrable interface trace versus unrestricted approximate-solver representations',source_wrapper_selected=False)))
put(P/'final-receipt.json',dict(schema=1,status='PASS',source_acceptance=False,selected=False,manifest=bind(P/'manifest.json'),candidate=bind(P/'Candidate.lean'),native_exit=0,native_receipt=bind(P/'native01-exit.json'),native_output=bind(out),checked_declarations=7,review=bind(P/'REVIEW.md')))
print(json.dumps(dict(manifest_sha256=sha(P/'manifest.json'),final_receipt_sha256=sha(P/'final-receipt.json'),candidate_sha256=sha(P/'Candidate.lean'))))
