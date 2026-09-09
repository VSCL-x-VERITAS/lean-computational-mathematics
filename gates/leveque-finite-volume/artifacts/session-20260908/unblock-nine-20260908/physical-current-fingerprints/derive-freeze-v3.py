from pathlib import Path
import hashlib,json
F=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
p=F/'freeze-v2.py'
assert sha(p)=='42ad1bea408507cd5fff348da1bf53a5a8e8f71a925cd661a381a9bf798aa71f'
s=p.read_text()
s=s.replace("fresh, raw = parser.records(R / inputs['raw_stream_path'])", "fresh, raw = parser.records(R / inputs['raw_stream_path'])\nparsed_cache = write('parsed-current-560.json', {'parser': ref(parser_path), 'raw': raw, 'records': fresh})")
before="assert set(replaced) <= set(fresh_by_name), 'Old selected public constants unexpectedly disappeared'"
after="""removed_name = '_private.ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods.0.NumStability.termV'
assert set(replaced) - set(fresh_by_name) == {removed_name}
assert replaced[removed_name]['type'] == 'Lean.Expr.const `Lean.ParserDescr []'
old_source = F.parent / 'dim-five-owner-overlay/overlay/ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'
assert sha(old_source) == 'e7d3da45027462919030380de761642cb5013f00a451df12bdebbc0a4a8efc54'
assert 'local notation "V" => Fin m → ℝ' in old_source.read_text()
removed_evidence = write('removed-private-notation.json', {'name': removed_name,
    'record': replaced[removed_name], 'old_source': ref(old_source),
    'line': 28, 'source_text': 'local notation "V" => Fin m → ℝ',
    'scope': 'Only this exact old source wrapper private parser helper is removed. Every other prior selected name is required. Root independently reviewed and adopted this exact exclusion.'})"""
assert before in s;s=s.replace(before,after)
s=s.replace("for name, record in sorted(replaced.items()):\n    now", "for name, record in sorted(replaced.items()):\n    if name == removed_name: continue\n    now")
s=s.replace("'fresh_selected_count': len(fresh), 'all_prior_selected_names_retained': True,", "'fresh_selected_count': len(fresh), 'all_prior_selected_names_retained': False,\n    'all_prior_selected_public_names_retained': True, 'exact_removed_private_helper': removed_evidence,")
s=s.replace("changes=change_report, native_receipt=", "changes=change_report, parsed_cache=parsed_cache, removed_private_helper=removed_evidence, native_receipt=")
with (F/'freeze-v3.py').open('x',encoding='utf-8',newline='\n') as out:out.write(s)
run=(F/'run-freeze-v2.py').read_text().replace('freeze-v2','freeze-v3')
with (F/'run-freeze-v3.py').open('x',encoding='utf-8',newline='\n') as out:out.write(run)
with (F/'freeze-v3-derivation.json').open('x',encoding='utf-8',newline='\n') as out:json.dump({'parent':{'path':p.name,'sha256':sha(p)},'derived':{'path':'freeze-v3.py','sha256':sha(F/'freeze-v3.py')},'changes':['Persist exact unchanged-parser output before subsequent assertions','Allow only exact removed private source notation helper, with old exact source and ParserDescr type evidence','Require every other old selected constant; explicitly report removal and distinguish eligible/private from public names']},out,indent=2);out.write('\n')
print(sha(F/'freeze-v3.py'))
