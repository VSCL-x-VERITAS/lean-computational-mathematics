"""Exact Defs source replay in a child Lake environment, with the new FTaylor first."""
from pathlib import Path
import hashlib, json, os, re, shutil, subprocess, sys, time
H = Path(__file__).resolve().parent
P = H.parent / 'defs-options-04'
R = H.parents[5]
F = H.parent / 'ftaylor-options-03'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p): return {'path': str(p), 'sha256': sha(p), 'bytes': p.stat().st_size}
def write(p, v):
    with p.open('xb') as f: f.write((json.dumps(v, indent=2, ensure_ascii=False)+'\n').encode())
assert os.name == 'nt' and R.name == 'lean-computational-mathematics'
if '--child' not in sys.argv:
    P.mkdir(exist_ok=False)
    command = [shutil.which('lake'), 'env', sys.executable, '-X', 'utf8', '-B', str(Path(__file__).resolve()), '--child']
    started = time.monotonic()
    with (P/'outer-stdout.txt').open('xb') as out, (P/'outer-stderr.txt').open('xb') as err:
        result = subprocess.run(command, cwd=R, stdout=out, stderr=err)
    write(P/'outer-exit.json', {'argv':command,'cwd':str(R),'exit_code':result.returncode,
        'elapsed_ms':round((time.monotonic()-started)*1000),'stdout':ref(P/'outer-stdout.txt'),
        'stderr':ref(P/'outer-stderr.txt'),'runner':ref(Path(__file__))})
    print(json.dumps({'outer_exit':result.returncode,'receipt':ref(P/'outer-exit.json')}))
    sys.exit(result.returncode)

package=R/'.lake/packages/mathlib'
rel=Path('Mathlib/Analysis/Calculus/ContDiff/Defs.lean')
source=package/rel
target=P/rel
target.parent.mkdir(parents=True,exist_ok=False)
with target.open('xb') as f:f.write(source.read_bytes())
assert sha(target)==sha(source)
flags=['-DautoImplicit=false','-DmaxSynthPendingDepth=3','-Dpp.unicode.fun=true']
ftrel=Path('Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.olean')
fresh_ft=F/ftrel
old_ft=package/'.lake/build/lib/lean'/ftrel
write(P/'ftaylor-binary-comparison.json', {'fresh':ref(fresh_ft),'cached':ref(old_ft),
    'byte_equal':sha(fresh_ft)==sha(old_ft),'claim':'Binary equality only. Different binaries do not establish different or equal structural declarations.'})
pins=[source,package/'lakefile.lean',R/'lean-toolchain',R/'lake-manifest.json',F/'receipt.json',F/'inputs.json']
for module in ['Mathlib.Analysis.Calculus.ContDiff.Defs',
               *re.findall(r'^public import (\S+)',source.read_text(encoding='utf-8'),re.M)]:
    for base in [package/'.lake/build/lib/lean'] + ([F] if module.endswith('.FTaylorSeries') else []):
        stem=base/Path(module.replace('.','/'))
        for suffix in ['.olean','.olean.private','.olean.server']:
            q=stem.with_suffix(suffix)
            if q.exists():pins.append(q)
    src=package/Path(module.replace('.','/')).with_suffix('.lean')
    if src not in pins:pins.append(src)
before=[ref(p) for p in pins]
write(P/'inputs.json',{'exact_source':ref(source),'copy':ref(target),'pins':before,'flags':flags,
    'scope':'Exact current source and direct compiled dependency pins, with existing and freshly compiled FTaylor artifacts. Not a claim of whole transitive closure.'})
environment=os.environ.copy()
original_path=environment.get('LEAN_PATH','')
assert original_path, 'Lake environment omitted LEAN_PATH'
environment['LEAN_PATH']=str(F)+os.pathsep+original_path
lean=shutil.which('lean')
assert lean
records=[]
for label,args in [('dependencies',['--deps',str(target)]),('compile',['-o',str(target.with_suffix('.olean')),str(target)])]:
    command=[lean,*flags,'--root',str(P),*args]
    start=time.monotonic()
    with (P/(label+'-stdout.txt')).open('xb') as out,(P/(label+'-stderr.txt')).open('xb') as err:
        result=subprocess.run(command,cwd=R,env=environment,stdout=out,stderr=err)
    item={'argv':command,'cwd':str(R),'exit_code':result.returncode,
          'elapsed_ms':round((time.monotonic()-start)*1000),
          'stdout':ref(P/(label+'-stdout.txt')),'stderr':ref(P/(label+'-stderr.txt'))}
    write(P/(label+'-exit.json'),item); records.append(item)
    print(json.dumps(item),flush=True)
    if label=='dependencies':
        assert result.returncode==0
        dependencies=(P/'dependencies-stdout.txt').read_text(encoding='utf-8').splitlines()
        matches=[line for line in dependencies if line.endswith('ContDiff/FTaylorSeries.olean') or line.endswith('ContDiff\\FTaylorSeries.olean')]
        assert len(matches)==1 and Path(matches[0]).resolve()==fresh_ft.resolve(), matches
        write(P/'resolution.json',{'exact_ftaylor_dependency':ref(fresh_ft),'reported_path':matches[0],
            'overlay_first':True,'base_environment':'Actual lake env, unchanged except the single overlay prefix.'})
after=[ref(p) for p in pins]
assert before==after and sha(source)==sha(target)
write(P/'receipt.json',{'schema':1,'kind':'isolated-defs-package-options-replay','commands':records,
    'inputs':ref(P/'inputs.json'),'resolution':ref(P/'resolution.json'),
    'binary_comparison':ref(P/'ftaylor-binary-comparison.json'),'source_and_compiled_pins_unchanged':True,
    'source_modified':False,'canonical_outputs_modified':False,
    'scratch_artifacts':[ref(p) for p in sorted(target.parent.iterdir()) if p.is_file()],
    'runner':ref(Path(__file__))})
print(json.dumps({'receipt':ref(P/'receipt.json')}),flush=True)
sys.exit(records[-1]['exit_code'])
