from pathlib import Path
import ast, hashlib, json
P=Path(__file__).resolve().parent
source=(P/'run-defs.py').read_text(encoding='utf-8')
text=source.replace("'defs-options-04'", "'defs-setup-05'")
text=text.replace("environment['LEAN_PATH']=str(F)+os.pathsep+original_path", "# Preserve the complete Lake search path; select only FTaylor using Lean's explicit artifact map.")
text=text.replace("records=[]\nfor label,args in [('dependencies',['--deps',str(target)]),('compile',['-o',str(target.with_suffix('.olean')),str(target)])]:", """setup={'name':'Mathlib.Analysis.Calculus.ContDiff.Defs','isModule':True,
       'importArts':{'Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries':
           [str(fresh_ft),str(fresh_ft.with_suffix('.ir')),str(fresh_ft.with_suffix('.olean.server')),str(fresh_ft.with_suffix('.olean.private'))]}}
write(P/'setup-positive.json',setup)
negative=json.loads(json.dumps(setup))
negative['importArts']['Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries'][0]=str(P/'deliberately-missing-FTaylor.olean')
assert not (P/'deliberately-missing-FTaylor.olean').exists()
write(P/'setup-negative.json',negative)
records=[]
for label,args in [('dependencies',['--deps',str(target)]),
                   ('isolation-negative',['--setup='+str(P/'setup-negative.json'),str(target)]),
                   ('compile',['--setup='+str(P/'setup-positive.json'),'-o',str(target.with_suffix('.olean')),str(target)])]:""")
old="""        assert len(matches)==1 and Path(matches[0]).resolve()==fresh_ft.resolve(), matches
        write(P/'resolution.json',{'exact_ftaylor_dependency':ref(fresh_ft),'reported_path':matches[0],
            'overlay_first':True,'base_environment':'Actual lake env, unchanged except the single overlay prefix.'})"""
new="""        assert len(matches)==1 and Path(matches[0]).resolve()==old_ft.resolve(), matches
        write(P/'dependency-search.json',{'reported_ftaylor':matches[0],
            'meaning':'Plain --deps ignores --setup; this is the unchanged base Lake resolution, not the compile selection.'})
    elif label=='isolation-negative':
        assert result.returncode!=0
        assert 'deliberately-missing-FTaylor.olean' in (P/'isolation-negative-stdout.txt').read_text(encoding='utf-8')+(P/'isolation-negative-stderr.txt').read_text(encoding='utf-8')
        write(P/'resolution.json',{'setup':ref(P/'setup-positive.json'),
            'negative_setup':ref(P/'setup-negative.json'),'negative_exit':ref(P/'isolation-negative-exit.json'),
            'fresh_ftaylor':ref(fresh_ft),'base_environment':'Unchanged actual Lake environment',
            'meaning':'Compile uses the explicit importArts map; a missing FTaylor entry is rejected. Plain --deps is not evidence of setup selection.'})"""
assert text.count(old)==1
text=text.replace(old,new)
assert text.count('deliberately-missing-FTaylor.olean')==3
ast.parse(text)
with (P/'run-defs-v5.py').open('xb') as f:f.write(text.encode())
with (P/'defs-v5-derivation.json').open('xb') as f:
    f.write((json.dumps({'original_sha256':hashlib.sha256(source.encode()).hexdigest(),
        'successor_sha256':hashlib.sha256(text.encode()).hexdigest(),
        'changes':['Fresh short scratch root','Unchanged Lake search path, exact FTaylor importArts mapping','Expected missing-artifact negative and positive compilation','Explicit statement that --deps ignores setup']},indent=2)+'\n').encode())
