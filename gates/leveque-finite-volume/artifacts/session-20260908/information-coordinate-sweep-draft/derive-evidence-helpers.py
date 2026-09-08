from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;S=P.parent;R=P.parents[4];old=S/'returned-field-coordinate-sweep-draft'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old/'manifest.json')=='29db1e9cc4bcfb49cfb9221c9adcf8354d3d9e72c2ffb625db10050d37654bbb'
bindings={x['path']:x['sha256'] for x in json.loads((old/'manifest.json').read_bytes())['artifacts']}
records=[]
for name in ['freeze.py','verify.py']:
 src=old/name;assert sha(src)==bindings[src.relative_to(R).as_posix()]
 t=src.read_text(encoding='utf-8').replace('==31','==34').replace('=31','=34').replace('==31','==34')
 t=t.replace("['Core.lean.fragment','Specializations.lean.fragment']","['Core.lean.fragment','Cartesian.lean.fragment','FieldSpecialization.lean.fragment','Witness.lean.fragment']")
 t=t.replace('cartesian-coordinate-line-composition-draft/final03-input.lean','returned-field-coordinate-sweep-draft/full03-input.lean')
 t=t.replace('frozen_cartesian_input','frozen_returned_field_input')
 t=t.replace("retained_field_contract='full returned field; strict prescribed initial states; all-real temporal trace integrability'","core_field_contract='No returned field, initial-field identity, rectangle certificate, trace or integrability premise',canonical_information_api=True")
 if name=='freeze.py':
  t=t.replace("native_receipt=bind(receipt),native_output=bind(out),complete_input=bind(src),","native_receipt=bind(receipt),native_output=bind(out),complete_input=bind(src),\n    standalone_core_receipt=bind(P/'core01-exit.json'),standalone_core_output=bind(P/'core01-output.txt'),production_context=bind(P/'production-context.json'),placement_plan=bind(P/'PLACEMENT-PLAN.md'),")
  anchor="assert len(r['checked_declarations'])==34\n"
  t=t.replace(anchor,anchor+'''core=json.loads((P/'core01-exit.json').read_bytes())
assert core['mode']=='core' and core['exit_code']==0 and core['inputs_unchanged'] and len(core['checked_declarations'])==17
core_raw=(P/'core01-output.txt').read_bytes();assert hashlib.sha256(core_raw).hexdigest()==core['output_sha256']
core_text=core_raw.decode();assert not re.search(r'error:|warning:|sorryAx',core_text)
core_ax={n:[x.strip() for x in a.split(',') if x.strip()] for n,a in re.findall(r"'([^']+)' depends on axioms:\\s*\\[([^\\]]*)\\]",core_text,re.S)}
core_ax.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",core_text)})
for n in core['checked_declarations']:assert n in core_ax and set(core_ax[n]) <= {'propext','Classical.choice','Quot.sound'},n
core_source=(P/'core01-input.lean').read_text(encoding='utf-8')
assert not re.search(r'RiemannFieldFluxMethod|IsRectangleConservationLawSolution|IntervalIntegrable|\\.field\\b',core_source)
''')
 dest=P/name;assert not dest.exists();dest.write_bytes(t.encode())
 records.append(dict(source=dict(path=src.relative_to(R).as_posix(),sha256=sha(src)),output=dict(path=dest.relative_to(R).as_posix(),sha256=sha(dest))))
out=P/'evidence-helper-derivation.json';assert not out.exists();out.write_bytes((json.dumps(dict(changes='34 new declarations, exact old returned-field complete input, four new fragments, separately checked 17-declaration information-only core, canonical API/context and placement-plan binding; prior helper bytes retained.',helpers=records),indent=2)+'\n').encode())
print(json.dumps(records))
