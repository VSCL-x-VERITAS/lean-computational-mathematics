"""Read-only direct-exec baseline; no hook invocation or environment mutation."""
import ctypes
from ctypes import wintypes
from datetime import datetime, timezone
import hashlib
import inspect
import json
import os
from pathlib import Path
import subprocess
import sys

k = ctypes.WinDLL('kernel32', use_last_error=True)
k.GetCurrentProcess.restype = wintypes.HANDLE
k.IsProcessInJob.argtypes = [wintypes.HANDLE, wintypes.HANDLE, ctypes.POINTER(wintypes.BOOL)]
k.IsProcessInJob.restype = wintypes.BOOL
member = wintypes.BOOL()
ok = k.IsProcessInJob(k.GetCurrentProcess(), None, ctypes.byref(member))
safe_keys = [
    'GIT_OPTIONAL_LOCKS', 'GIT_TERMINAL_PROMPT', 'GIT_CONFIG_NOSYSTEM',
    'GIT_DIR', 'GIT_WORK_TREE', 'GIT_INDEX_FILE', 'GIT_CONFIG_COUNT',
    'GIT_CONFIG_SYSTEM', 'GIT_CONFIG_GLOBAL', 'MSYSTEM', 'MSYS', 'CYGWIN',
    'PYTHONHOME', 'PYTHONPATH', 'BOOK_FORMALIZATION_GUARD_STATE_DIR',
    'HOME', 'USERPROFILE', 'HOMEDRIVE', 'HOMEPATH', 'XDG_CONFIG_HOME',
    'TERM', 'ComSpec', 'CODEX_SANDBOX', 'CODEX_SANDBOX_NETWORK_DISABLED',
]
stdlib = Path(subprocess.__file__)
result = {
    'kind': 'direct-exec-only-process-context',
    'captured_at_utc': datetime.now(timezone.utc).isoformat(),
    'pid': os.getpid(), 'parent_pid': os.getppid(), 'cwd': os.getcwd(),
    'python': sys.executable, 'python_version': sys.version,
    'is_process_in_job_api_ok': bool(ok),
    'is_process_in_job': bool(member.value) if ok else None,
    'selected_environment': {key: os.environ.get(key) for key in safe_keys},
    'all_git_variable_names_only': sorted(key for key in os.environ if key.upper().startswith('GIT_')),
    'path_sha256': hashlib.sha256(os.environ.get('PATH', '').encode()).hexdigest(),
    'popen_creationflags_default': inspect.signature(subprocess.Popen).parameters['creationflags'].default,
    'popen_env_default': inspect.signature(subprocess.Popen).parameters['env'].default,
    'stdlib_subprocess': {'path': str(stdlib), 'sha256': hashlib.sha256(stdlib.read_bytes()).hexdigest()},
    'hook_context_observed': False,
    'caveat': 'Job membership alone cannot distinguish this successful direct-exec path from a hook. No actual hook environment or creation flags were captured.',
}
target = Path(__file__).resolve().with_name('direct-context.json')
with target.open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(json.dumps(result, indent=2) + '\n')
print(json.dumps(result))
