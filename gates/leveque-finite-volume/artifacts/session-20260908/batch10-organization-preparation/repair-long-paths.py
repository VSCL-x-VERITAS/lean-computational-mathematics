"""Add native Windows long-path IO and preserve the first failed fixture run."""
from pathlib import Path
here=Path(__file__).resolve().parent
source=(here/'prepare.py').read_text(encoding='utf-8')
source=source.replace('import argparse, ast, hashlib, json, re','import argparse, ast, hashlib, json, os, re')
old='sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()'
new='''def native_path(p):
 p=Path(p)
 if os.name=='nt' and not str(p).startswith('\\\\\\\\?\\\\'):
  return Path('\\\\\\\\?\\\\'+str(p.resolve()))
 return p

sha=lambda p:hashlib.sha256(native_path(p).read_bytes()).hexdigest()'''
assert source.count(old)==1;source=source.replace(old,new)
source=source.replace("p=repo/f['path'];raw=p.read_bytes()","p=repo/f['path'];raw=native_path(p).read_bytes()")
source=source.replace("with (out/name).open('xb') as f:f.write(raw)","with native_path(out/name).open('xb') as f:f.write(raw)")
source=source.replace("with (out/'derivations.json').open('xb') as f:f.write(encode(derivation))","with native_path(out/'derivations.json').open('xb') as f:f.write(encode(derivation))")
target=here/'prepare-v2.py';assert not target.exists();target.write_text(source,encoding='utf-8',newline='\n')
test=(here/'test.py').read_text(encoding='utf-8').replace("HERE/'prepare.py'","HERE/'prepare-v2.py'")
test=test.replace("fixture=HERE/'synthetic-fixture-01'","fixture=module.native_path(HERE/'synthetic-fixture-02')")
target=here/'test-v2.py';assert not target.exists();target.write_text(test,encoding='utf-8',newline='\n')
runner=(here/'run-tests.py').read_text(encoding='utf-8').replace("here/'test.py'","here/'test-v2.py'")
runner=runner.replace("['test.py','prepare.py','run-tests.py']","['test-v2.py','prepare-v2.py','run-tests-v2.py']")
target=here/'run-tests-v2.py';assert not target.exists();target.write_text(runner,encoding='utf-8',newline='\n')
