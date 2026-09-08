"""Diagnostic replica of tagged Codex contained job spawn; unchanged checker/guard."""
from pathlib import Path
import ctypes as c
from ctypes import wintypes as w
import hashlib,json,subprocess,sys,time,os
D=Path(__file__).resolve().parent;W=D.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
config=Path('C:/Users/qed_s/.codex/hooks.json');state=Path('C:/Users/qed_s/.cache/book-formalization/session-guards/48511011606d4532ef12a0e6a92d5568a625b5624c4ea45b6ec315b2174e7bdf.json')
before={str(p):sha(p) for p in (config,state)}
hook=json.loads(config.read_bytes())['hooks']['Stop'][0]['hooks'][0]
assert not json.loads(state.read_bytes()).get('explicit_stop')
base=D/'contained-cmd-trace';base.mkdir(exist_ok=False)
kernel=c.WinDLL('kernel32',use_last_error=True);nt=c.WinDLL('ntdll')
class BASIC(c.Structure):
 _fields_=[('PerProcessUserTimeLimit',c.c_int64),('PerJobUserTimeLimit',c.c_int64),('LimitFlags',w.DWORD),('MinimumWorkingSetSize',c.c_size_t),('MaximumWorkingSetSize',c.c_size_t),('ActiveProcessLimit',w.DWORD),('Affinity',c.c_size_t),('PriorityClass',w.DWORD),('SchedulingClass',w.DWORD)]
class IO(c.Structure):
 _fields_=[(n,c.c_uint64) for n in ['ReadOperationCount','WriteOperationCount','OtherOperationCount','ReadTransferCount','WriteTransferCount','OtherTransferCount']]
class EXT(c.Structure):
 _fields_=[('BasicLimitInformation',BASIC),('IoInfo',IO),('ProcessMemoryLimit',c.c_size_t),('JobMemoryLimit',c.c_size_t),('PeakProcessMemoryUsed',c.c_size_t),('PeakJobMemoryUsed',c.c_size_t)]
kernel.CreateJobObjectW.argtypes=[c.c_void_p,w.LPCWSTR];kernel.CreateJobObjectW.restype=w.HANDLE
kernel.SetInformationJobObject.argtypes=[w.HANDLE,c.c_int,c.c_void_p,w.DWORD];kernel.SetInformationJobObject.restype=w.BOOL
kernel.AssignProcessToJobObject.argtypes=[w.HANDLE,w.HANDLE];kernel.AssignProcessToJobObject.restype=w.BOOL
kernel.CloseHandle.argtypes=[w.HANDLE];kernel.CloseHandle.restype=w.BOOL
nt.NtResumeProcess.argtypes=[w.HANDLE];nt.NtResumeProcess.restype=c.c_long
job=kernel.CreateJobObjectW(None,None);assert job,c.get_last_error()
info=EXT();info.BasicLimitInformation.LimitFlags=0x2000|0x800 # KILL_ON_JOB_CLOSE | BREAKAWAY_OK
assert kernel.SetInformationJobObject(job,9,c.byref(info),c.sizeof(info)),c.get_last_error()
shell=os.environ.get('COMSPEC','C:/Windows/System32/cmd.exe')
cmdline=subprocess.list2cmdline([shell])+' /C "'+hook['commandWindows']+'"'
payload={'session_id':'01a07fae-4a67-7770-98b0-b95c4e393705','cwd':str(W),'hook_event_name':'Stop','transcript_path':'C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl'}
env=os.environ.copy()
trace=base/'git-trace.jsonl'
env['GIT_TRACE2_EVENT']='/c/'+str(trace).replace('\\','/')[3:]
start=time.perf_counter();timed_out=False
child=subprocess.Popen(cmdline,cwd=W,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE,creationflags=4,env=env)
assigned=bool(kernel.AssignProcessToJobObject(job,int(child._handle)));assign_error=c.get_last_error() if not assigned else 0
resumed=nt.NtResumeProcess(int(child._handle));assert resumed==0,resumed
try:
 try:out,err=child.communicate(json.dumps(payload).encode(),timeout=30);code=child.returncode
 except subprocess.TimeoutExpired:
  timed_out=True
  kernel.CloseHandle(job);job=None
  out,err=child.communicate(timeout=5);code=child.returncode
finally:
 if job:kernel.CloseHandle(job)
elapsed=time.perf_counter()-start
(base/'stdout.txt').write_bytes(out);(base/'stderr.txt').write_bytes(err)
assert all(sha(Path(p))==h for p,h in before.items())
record={'mode':'contained-cmd-trace','creationflags':4,'job_limits':info.BasicLimitInformation.LimitFlags,'assigned':assigned,'assign_error':assign_error,'nt_resume_status':resumed,'command_line':cmdline,'elapsed_seconds':elapsed,'outer_timed_out':timed_out,'exit_code':code,'stdout_sha256':sha(base/'stdout.txt'),'stderr_sha256':sha(base/'stderr.txt'),'git_trace_sha256':sha(trace) if trace.exists() else None,'state_and_hook_unchanged':True,'limitation':'Replica with exec_command environment and Python pipes; not an actual host Stop event.'}
(base/'receipt.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record));print(out.decode('utf-8',errors='replace'));print(err.decode('utf-8',errors='replace'))
raise SystemExit(code if code is not None else 124)

