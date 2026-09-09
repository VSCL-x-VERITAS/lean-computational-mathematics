"""Create only prospective audit inputs; never invoke released preparation or roles."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
D=P.parent;S=D.parent;W=R.parent
# Native filesystem operations use extended paths without changing stored POSIX refs.
def xp(p):return Path('\\\\?\\'+str(p)) if not str(p).startswith('\\\\?\\') else p
raw=lambda p:xp(p).read_bytes()
sha=lambda p:hashlib.sha256(raw(p)).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(raw(p))
def write(name,value):
 p=P/name
 with xp(p).open('x',encoding='utf-8',newline='\n') as f:json.dump(value,f,indent=2,ensure_ascii=False);f.write('\n')
 return ref(p)
prod=D/'dimensional-method-production'
receipt=read(prod/'final-receipt.json');assert sha(prod/'final-receipt.json')=='83a3f2d1f46af4568c4b502161d7ceb12520c11c6665bf299036a9e2e8326907'
inventory=read(prod/'placement-inventory.json');native=read(prod/'comparison02-receipt.json')
verification=read(prod/'declaration-verification.json')
assert native['actual_exit_code']==0 and native['sources_unchanged'] and native['dependencies_unchanged']
assert verification['all47_passed'] and len(verification['declarations'])==47
for row in inventory['files']+native['sources']+native['dependencies']:
 assert sha(R/row['path'])==row['sha256'],row
output=R/native['output']['path'];assert sha(output)==native['output']['sha256']
content=raw(output);names=inventory['checked_declarations'];assert len(names)==47
spans=[]
for i,name in enumerate(names):
 hits=list(re.finditer(rb'(?m)^'+re.escape(name.encode())+rb'(?=\s|\.\{)',content));assert len(hits)==1,name
 start=hits[0].start()
 if i+1<len(names):
  nxt=list(re.finditer(rb'(?m)^'+re.escape(names[i+1].encode())+rb'(?=\s|\.\{)',content));assert len(nxt)==1
  end=nxt[0].start()
 else:end=len(content)
 exact=content[start:end]
 assert b' := by' not in exact and not re.search(rb'(?m)^(theorem|def|noncomputable def|axiom) ',exact)
 assert b'error:' not in exact and b'warning:' not in exact
 spans.append(dict(declaration=name,source_path=output.relative_to(R).as_posix(),source_sha256=sha(output),start_byte=start,end_byte_exclusive=end,span_sha256=hashlib.sha256(exact).hexdigest(),first_line=content[:start].count(b'\n')+1,last_line=content[:end].count(b'\n'),exact_text=exact.decode('utf-8')))
assert b''.join(s['exact_text'].encode() for s in spans)==content
packet=write('native-packet.json',dict(format='proof-free-lean-environment-evidence-1',scope='Exact native types and axiom lists for all 31 new production declarations, 15 explicit nominal-data/type-preservation declarations, and the existing two-direction nonconstant executor witness. The production declarations include the complete simultaneous real-interval physical-data/reference/numerical-method witness and its nonconstant execution. These are supporting dependency/applicability evidence, not additional source claims, prior judgments, an acceptance claim, or a requested classification. No theorem or draft proof body is supplied.',runtime=dict(native_receipt=ref(prod/'comparison02-receipt.json'),native_output=ref(output),native_input_provenance_only=ref(prod/'Comparison.lean'),production_inventory=ref(prod/'placement-inventory.json'),native_exit_code=0,sources_and_compiled_dependencies_unchanged=True,source_bindings=inventory['files']),native_output_spans=spans,probe_commands=[dict(argv=native['command'],cwd=R.as_posix(),receipt=ref(prod/'comparison02-receipt.json'),actual_exit_code=0,already_completed=True)],omissions=['No source text or interpretation is inserted into native dependency meaning.','No prior decision, verdict, evaluator response or proof body is copied into this packet.','The native input and source-owner references are provenance hashes only; their proof bodies are not role payload content.','Blind translation receives only its newly generated exact sealed masked packet. Direct judge and any triggered adjudicator receive this supplement; round-trip judging uses source and blind translation without this native supplement.']))
env={}
for row in native['sources']+native['dependencies']+[ref(output),ref(prod/'comparison02-receipt.json'),ref(prod/'declaration-verification.json'),ref(prod/'placement-inventory.json'),ref(prod/'final-receipt.json')]:
 env[row['path']]=dict(path=row['path'],sha256=row['sha256'])
environment=write('native-environment.json',dict(format='pinned-audit-environment-extension-1',environment_files=list(env.values())))
priorid='LEV-CH01-COORDINATE-SPLITTING-INTERPRETED-PRODUCTION-20260908'
prior=S/'audits'/priorid
oldtask=read(prior/'audit-task.json');source=oldtask['source']
assert sha(R/source['path'])==source['sha256']=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
images=[]
for page in (26,27,28):
 source_image=W/f'workflow-v5.0.1-local/chapter01-source-review/page-{page:03}.png';dest=P/f'page-{page:03}.png'
 with xp(dest).open('xb') as f:f.write(raw(source_image))
 images.append(dict(page=page,**ref(dest)))
user=S/'user-discontinuity-interpretation-20260908.json'
assert sha(user)=='b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
context=write('source-context.json',dict(format='pinned-source-context-extension-1',source={k:source[k] for k in ('path','sha256')},primary_locations=source['locations'],inherited_locations=[
 dict(location='raw PDF page 26; printed Chapter 1 page 4',anchor='Inherited conservation context: Section 1.1.1 equation (1.10) and the following explanation of interval mass changing through endpoint physical fluxes.'),
 dict(location='raw PDF pages 26–27; printed Chapter 1 pages 4–5',anchor='Inherited discontinuity context: Section 1.1.2 explains the smoothness proviso for the differential form and the continuing role of integral conservation at discontinuities.'),
 dict(location='raw PDF page 27; printed Chapter 1 page 5',anchor='Inherited one-dimensional method context: Section 1.2 cell averages, time-step edge fluxes, and numerical fluxes approximating physical fluxes from approximate cell averages.'),
 dict(location='raw PDF pages 27–28; printed Chapter 1 pages 5–6',anchor='Inherited method and geometry context: Section 1.2.1 neighboring cell states and numerical flux information, the continuation concerning approximate Riemann solvers, and the Section 1.3 paragraph immediately preceding the primary splitting selection about edge/face-normal flux problems.')],pages=[26,27,28],images=images,interpretation_receipts=[ref(user)]))
selections=D/'selected-interpretations.json';assert sha(selections)=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
selection=read(selections);choice=next(x for x in selection['choices'] if x['choice_id']=='Q10')
target=inventory['files'][-1];assert target['sha256']=='12c04e96267dd9f87b4cde8225739575219edb70db7fa6f278260010a538c783'
taskid='LEV-CH01-COORDINATE-DIRECTIONAL-METHODS-INTERPRETED-PRODUCTION-20260908'
assert not xp(S/'audits'/taskid).exists()
spec=write('audit-spec.json',dict(prior_config=f'unblock-nine-20260908/{priorid}.config.json',supplement_task='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908',supplement_config='audit-equation10-interpreted-rectangle.config.json',key='coordinate-directional-methods',task_id=taskid,prior_task=priorid,row_id='LEV-CH01-DIMENSIONAL-SPLITTING',choice_id='Q10',pages='26,27,28',target=dict(path=target['path'],declaration=target['declarations'][0]),source_context_extension=context,additional_supplement=dict(packet=packet,environment_config=environment)))
write('authority-boundary.json',dict(primary_locations_exact=source['locations'],source_context_extension=context,coordinator_selection_receipt=ref(selections),choice_exact=choice,authority_exact=selection['authority'],inherited_user_receipt=ref(user),exact_inherited_receipt_bytes_utf8=raw(user).decode('utf-8'),scope_rule='Q10 remains the coordinator selection under the user goal, not a literal detailed answer. The Eq1.10 user receipt is exact, separate and confined to its recorded original scope. Fresh source-facing judges assess applicability; these preparatory artifacts do not broaden either authority or assert a source judgment. Added pages provide inherited context and do not create independent audited rows.',semantic_verdict_supplied=False,prepare_invoked=False,roles_invoked=False))
print(json.dumps(dict(spec=spec,packet=packet,context=context,environment=environment,native_spans=len(spans)),indent=2))
