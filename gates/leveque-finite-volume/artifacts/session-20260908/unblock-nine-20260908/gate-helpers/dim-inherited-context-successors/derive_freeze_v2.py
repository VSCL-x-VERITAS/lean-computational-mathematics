"""Retain the hash freezer's external-launcher path failure and correct only FileRef display."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent
def raw(p):
    with open('\\\\?\\'+str(p),'rb') as f:return f.read()
def write(p,b):
    with open('\\\\?\\'+str(p),'xb') as f:f.write(b)
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(raw(p)).hexdigest()}
source=raw(P/'freeze.py').decode()
old="    return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(raw(p)).hexdigest(),'bytes':len(raw(p))}"
new="    name=p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p)\n    return {'path':name,'sha256':hashlib.sha256(raw(p)).hexdigest(),'bytes':len(raw(p))}"
assert source.count(old)==1
write(P/'freeze_v2.py',source.replace(old,new).encode())
write(P/'freeze-01-failure.json',(json.dumps({'schema':1,'kind':'record of actual exec_command result',
 'tool_chunk_id':'ea626e','actual_exit':1,'wall_time_seconds':0.313818,
 'script':ref(P/'freeze.py'),
 'failure':'ValueError at freeze.py ref(): the unchanged workspace-level POSIX launcher is outside the Lean repository, so relative_to(R) fails.',
 'stage':'hash-only manifest assembly, before any final manifest or receipt write',
 'guard_tests_actual_exit':0,'source_acceptance':False,
 'successor':ref(P/'freeze_v2.py'),
 'correction':'Preserve external path as absolute; no hash/guard/operational-helper changes.'},indent=2)+'\n').encode())
