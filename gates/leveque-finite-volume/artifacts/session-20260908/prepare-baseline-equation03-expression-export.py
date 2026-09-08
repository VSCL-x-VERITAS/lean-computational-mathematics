"""Prepare a native identity export for the accepted baseline Eq. (1.3) producers."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
git=lambda *args:subprocess.check_output(['git','-c','core.longpaths=true',*args],cwd=R)
B='9e2225705fed906b1120d55105d607baabef57c9'
old=read(S/'chapter01-expression-export-v2-inputs.json');src=R/old['exporter_path'];assert sha(src)==old['exporter_sha256']
paths=['ComputationalMathematics/Source/LeVeque/Chapter01/Equation03.lean','ComputationalMathematics/Source/LeVeque/Chapter01/Equation03AdvectedProfile.lean']
files=[]
for path in paths:
 data=git('show',B+':'+path);assert data==(R/path).read_bytes()
 files.append({'path':path,'sha256':hashlib.sha256(data).hexdigest(),'baseline_blob':git('rev-parse',B+':'+path).decode().strip()})
# Existing declarations have no changed owner; only audited additions and aggregate imports changed.
modified=git('diff','--name-only','--diff-filter=M',B,'HEAD','--','ComputationalMathematics','NumStability').decode().splitlines()
assert set(modified)=={'ComputationalMathematics/Analysis.lean','ComputationalMathematics/Source/LeVeque/Chapter01.lean'}
assert not git('diff','--name-only','HEAD','--','ComputationalMathematics','NumStability').strip()
gate_bytes=git('show',B+':gates/leveque-finite-volume/chapter-01.json');gate=json.loads(gate_bytes)
row=next(r for r in gate['rows'] if r['id']=='LEV-CH01-EQ-1.3-ADVECTED-PROFILE');assert row['status']=='PROVED'
legacy='NumStability/Source/LeVeque/Chapter01/Equation03AdvectedProfile.lean'
assert git('show',B+':'+legacy)==(R/legacy).read_bytes()
text=src.read_text();start=text.index('private def selectedModules : Array String := #[\n');end=text.index('\n]\n\nrun_cmd do',start)
modules=sorted(p[:-5].replace('/','.') for p in paths)
text=text[:start]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+text[end:]
text=text.replace('.lake/chapter01-declaration-expressions.jsonl','.lake/chapter01-baseline-equation03-expressions.jsonl')
p=S/'export-baseline-equation03-expressions.lean';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
result={'schema':1,'baseline':B,'input_commit':git('rev-parse','HEAD').decode().strip(),'baseline_gate_sha256':hashlib.sha256(gate_bytes).hexdigest(),'baseline_row':row,'files':files,'selected_modules':modules,'legacy_forwarder':{'path':legacy,'sha256':sha(R/legacy)},'exporter_path':p.relative_to(R).as_posix(),'exporter_sha256':sha(p),'normalization':old['normalization'],'serializer_sha256':sha(src),'expected_declarations':row['lean_declarations'],'scope':'Read current compiled identities only for exact unchanged baseline producers. Current source-row acceptance comes exclusively from its fresh interpreted audit; this export does not revive the baseline certificate.'}
dest=S/'baseline-equation03-expression-inputs.json';assert not dest.exists();dest.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'input_sha256':sha(dest),'exporter_sha256':sha(p),'expected_declarations':row['lean_declarations']}))

