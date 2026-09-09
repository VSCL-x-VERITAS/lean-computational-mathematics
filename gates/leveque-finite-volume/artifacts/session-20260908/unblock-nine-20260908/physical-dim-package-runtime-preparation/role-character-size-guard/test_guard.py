"""Local code-point and exact-construction fixtures; no operational role calls."""
import ast, importlib.util, json, os, sys
from pathlib import Path
H=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('character_guard_test',H/'guard.py')
g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
out=H/sys.argv[1];assert not os.path.exists(g.disk(out));os.mkdir(g.disk(out))
checks=[]
def accept(label,message):
 assert g.size_guard(message)==g.digest(message)
 checks.append({'test':label,'result':'accepted','bytes':len(message),'codepoints':len(message.decode())})
def reject(label,fn,error=AssertionError):
 try:fn()
 except error:checks.append({'test':label,'result':'rejected'});return
 raise AssertionError('Expected rejection: '+label)
accept('ASCII exact native boundary',b'a'*g.LIMIT)
reject('ASCII one above native boundary',lambda:g.size_guard(b'a'*(g.LIMIT+1)))
accept('UTF8 bytes exceed limit but codepoints equal limit',('x'*(g.LIMIT-1)+'∞').encode())
accept('nonBMP counts once at exact boundary',('x'*(g.LIMIT-1)+'😀').encode())
reject('nonBMP one codepoint above limit',lambda:g.size_guard(('x'*g.LIMIT+'😀').encode()))
accept('multibyte string exact codepoint boundary',('α'*g.LIMIT).encode())
reject('invalid UTF8 rejected before counting',lambda:g.size_guard(b'\xff'),UnicodeDecodeError)
reject('surrogate UTF8 rejected',lambda:g.size_guard(b'\xed\xa0\x80'),UnicodeDecodeError)
reject('text instead of exact bytes rejected',lambda:g.size_guard('text'))
def put(name,text):
 p=out/name;g.create(p,text.encode());return p
input_path=put('source.txt','Exact Unicode α and 😀\nnewlines.\n')
header="import sys\nfrom pathlib import Path\ntask,role,stem,pages=sys.argv[1:5]\nparts=[]\nrecords=[]\nimages=[]\n"
tail="message=b''.join(parts)\nraise RuntimeError('The tail must not execute')\n"
good=put('good.py',header+f"parts.append(Path({str(input_path)!r}).read_bytes())\n"+tail)
a=g.assemble(good,g.TID,'source-contract','s',g.PAGES)
b=g.assemble(good,g.TID,'source-contract','s',g.PAGES)
assert a==b and a[0]==g.raw(input_path)
checks.append({'test':'unchanged AST exact prefix and repeated byte equality','result':'accepted'})
victim=out/'forbidden.txt'
bad=put('write.py',header+f"Path({str(victim)!r}).write_text('forbidden')\n"+tail)
reject('prefix file write denied',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
assert not os.path.exists(g.disk(victim))
missing=out/'forbidden-dir'
bad=put('mkdir.py',header+f"Path({str(missing)!r}).mkdir()\n"+tail)
reject('prefix directory creation denied',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
assert not os.path.exists(g.disk(missing))
bad=put('process.py',header+"import subprocess\nsubprocess.run(['forbidden'])\n"+tail)
reject('prefix subprocess rejected statically',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
bad=put('wrong-assignment.py',header+"message=b'other'\n")
reject('unreviewed message assignment rejected',lambda:g.assemble(bad,g.TID,'source-contract','s',g.PAGES))
pin=g.ref(input_path);g.verify(pin)
reject('changed hash rejected',lambda:g.verify({**pin,'sha256':'0'*64}))
old=H.parent/'role-size-guard'
def functions(p):
 return {x.name:ast.dump(x,include_attributes=False) for x in ast.parse(g.raw(p)).body if isinstance(x,(ast.FunctionDef,ast.AsyncFunctionDef))}
prior=functions(old/'guard.py');current=functions(H/'guard.py')
changed={name for name in prior if prior[name]!=current[name]}
assert changed=={'size_guard','prepare','execute'}
assert set(prior)==set(current)
assert g.raw(old/'staged.py')==g.raw(H/'staged.py')
checks.append({'test':'only metric preparation execution functions changed; staged identical','result':'accepted'})
g.write(out/'receipt.json',{'fixture_only':True,'subject':g.ref(H/'guard.py'),'test':g.ref(Path(__file__)),
 'checks':checks,'semantic_roles_run':False,'operational_plans_created':False,'audit_files_written':False})
print(json.dumps({'checks':len(checks),'receipt':g.ref(out/'receipt.json'),'semantic_roles_run':False},indent=2))
