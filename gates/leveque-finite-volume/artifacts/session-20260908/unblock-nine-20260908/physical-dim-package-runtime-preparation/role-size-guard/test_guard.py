"""Focused local construction/cap rejection tests; never invoke a semantic role."""
import importlib.util,json,os,sys
from pathlib import Path
P=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('role_size_guard',P/'guard.py')
g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
out=P/sys.argv[1];assert not os.path.exists(g.disk(out));os.mkdir(g.disk(out))
checks=[]
def expect(label,fn):
 try:fn()
 except AssertionError:checks.append({'test':label,'result':'rejected'});return
 raise AssertionError('Expected rejection: '+label)
def put(name,text):
 path=out/name;g.create(path,text.encode());return path
g.size_guard(b'a'*g.LIMIT);checks.append({'test':'exact byte boundary','result':'accepted'})
expect('one byte above boundary',lambda:g.size_guard(b'a'*(g.LIMIT+1)))
expect('UTF-8 bytes rather than codepoints',lambda:g.size_guard(('x'*(g.LIMIT-1)+'∞').encode()))
input_path=put('source.txt','Exact Unicode α and\nnewlines.\n')
header="import sys\nfrom pathlib import Path\ntask,role,stem,pages=sys.argv[1:5]\nparts=[]\nrecords=[]\nimages=[]\n"
body=f"parts.append(Path({str(input_path)!r}).read_bytes())\n"
tail="message=b''.join(parts)\nraise RuntimeError('The tail must not execute')\n"
good=put('good.py',header+body+tail)
a=g.assemble(good,g.TID,'source-contract','s',g.PAGES)
b=g.assemble(good,g.TID,'source-contract','s',g.PAGES)
assert a==b and a[0]==g.raw(input_path)
checks.append({'test':'exact AST prefix and repeated byte equality','result':'accepted'})
victim=out/'forbidden.txt'
bad=put('write.py',header+f"Path({str(victim)!r}).write_text('forbidden')\n"+tail)
expect('prefix file write denied',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
assert not os.path.exists(g.disk(victim))
missing=out/'forbidden-dir'
bad=put('mkdir.py',header+f"Path({str(missing)!r}).mkdir()\n"+tail)
expect('prefix directory creation denied',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
assert not os.path.exists(g.disk(missing))
bad=put('process.py',header+"import subprocess\nsubprocess.run(['forbidden'])\n"+tail)
expect('prefix subprocess rejected statically',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
bad=put('wrong-assignment.py',header+"message=b'other'\n")
expect('unreviewed message assignment rejected',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
pin=g.ref(input_path);g.verify(pin)
expect('changed hash rejected',lambda:g.verify({**pin,'sha256':'0'*64}))
receipt={'runner':g.ref(P/'guard.py'),'test':g.ref(Path(__file__)),'checks':checks,
 'semantic_roles_run':False,'audit_files_written':False}
g.write(out/'receipt.json',receipt)
print(json.dumps({'receipt':g.ref(out/'receipt.json'),'checks':len(checks),'semantic_roles_run':False},indent=2))
