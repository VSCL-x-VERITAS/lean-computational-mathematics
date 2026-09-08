"""Passive Windows child-process observer. Run explicitly; importing does not observe."""
from __future__ import annotations
import argparse
import ctypes as C
from ctypes import wintypes as T
import datetime
import hashlib
import json
import os
from pathlib import Path
import queue
import subprocess
import threading
import time

ALLOWED = {'cmd.exe', 'python.exe', 'python3.exe', 'bash.exe', 'git.exe'}
BASE = Path(__file__).resolve().parent

class PROCESSENTRY32W(C.Structure):
    _fields_ = [('dwSize', T.DWORD), ('cntUsage', T.DWORD), ('th32ProcessID', T.DWORD),
                ('th32DefaultHeapID', C.c_size_t), ('th32ModuleID', T.DWORD),
                ('cntThreads', T.DWORD), ('th32ParentProcessID', T.DWORD),
                ('pcPriClassBase', T.LONG), ('dwFlags', T.DWORD), ('szExeFile', T.WCHAR * 260)]

class IO_COUNTERS(C.Structure):
    _fields_ = [(n, C.c_ulonglong) for n in ['ReadOperationCount', 'WriteOperationCount',
                'OtherOperationCount', 'ReadTransferCount', 'WriteTransferCount', 'OtherTransferCount']]

def utc():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()

def filetime(value):
    return (value.dwHighDateTime << 32) | value.dwLowDateTime

def api():
    k = C.WinDLL('kernel32', use_last_error=True)
    signatures = {
        'CreateToolhelp32Snapshot': ([T.DWORD, T.DWORD], T.HANDLE),
        'Process32FirstW': ([T.HANDLE, C.POINTER(PROCESSENTRY32W)], T.BOOL),
        'Process32NextW': ([T.HANDLE, C.POINTER(PROCESSENTRY32W)], T.BOOL),
        'OpenProcess': ([T.DWORD, T.BOOL, T.DWORD], T.HANDLE),
        'CloseHandle': ([T.HANDLE], T.BOOL),
        'QueryFullProcessImageNameW': ([T.HANDLE, T.DWORD, T.LPWSTR, C.POINTER(T.DWORD)], T.BOOL),
        'GetProcessTimes': ([T.HANDLE, *([C.POINTER(T.FILETIME)] * 4)], T.BOOL),
        'GetProcessIoCounters': ([T.HANDLE, C.POINTER(IO_COUNTERS)], T.BOOL),
        'GetExitCodeProcess': ([T.HANDLE, C.POINTER(T.DWORD)], T.BOOL),
        'WaitForSingleObject': ([T.HANDLE, T.DWORD], T.DWORD),
    }
    for name, (args, result) in signatures.items():
        f = getattr(k, name)
        f.argtypes, f.restype = args, result
    return k

def snapshot(k):
    h = k.CreateToolhelp32Snapshot(2, 0)  # TH32CS_SNAPPROCESS
    if h == C.c_void_p(-1).value:
        raise C.WinError(C.get_last_error())
    rows = {}
    try:
        entry = PROCESSENTRY32W()
        entry.dwSize = C.sizeof(entry)
        more = k.Process32FirstW(h, C.byref(entry))
        while more:
            rows[int(entry.th32ProcessID)] = {'pid': int(entry.th32ProcessID),
                'parent_pid': int(entry.th32ParentProcessID), 'name': entry.szExeFile.lower()}
            more = k.Process32NextW(h, C.byref(entry))
        error = C.get_last_error()
        if error != 18:  # ERROR_NO_MORE_FILES
            raise C.WinError(error)
    finally:
        k.CloseHandle(h)
    return rows

def is_descendant(pid, rows, ancestors, excluded):
    visited = set()
    while pid and pid not in visited:
        if pid in excluded:
            return False
        if pid in ancestors:
            return True
        visited.add(pid)
        if pid not in rows:
            return False
        pid = rows[pid]['parent_pid']
    return False

def open_process(k, pid):
    # Query and wait rights only; never VM_READ, mutation or termination rights.
    return k.OpenProcess(0x1000 | 0x100000, False, pid)

def metadata(k, handle):
    result = {}
    created, exited, kernel, user = T.FILETIME(), T.FILETIME(), T.FILETIME(), T.FILETIME()
    if k.GetProcessTimes(handle, C.byref(created), C.byref(exited), C.byref(kernel), C.byref(user)):
        result.update(creation_filetime=filetime(created), exit_filetime=filetime(exited),
                      kernel_seconds=filetime(kernel) / 10_000_000, user_seconds=filetime(user) / 10_000_000)
    else:
        result['times_error'] = C.get_last_error()
    io = IO_COUNTERS()
    if k.GetProcessIoCounters(handle, C.byref(io)):
        result['io'] = {name: int(getattr(io, name)) for name, _ in IO_COUNTERS._fields_}
    else:
        result['io_error'] = C.get_last_error()
    signal = k.WaitForSingleObject(handle, 0)
    result['status'] = 'exited' if signal == 0 else ('running' if signal == 258 else 'unknown')
    if signal == 0:
        code = T.DWORD()
        if k.GetExitCodeProcess(handle, C.byref(code)):
            result['exit_code'] = int(code.value)
    return result

def image_name(k, handle):
    size = T.DWORD(32768)
    buffer = C.create_unicode_buffer(size.value)
    return buffer.value if k.QueryFullProcessImageNameW(handle, 0, buffer, C.byref(size)) else None

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root-pid', type=int, default=10588)
    parser.add_argument('--duration', type=float, default=180)
    parser.add_argument('--interval-ms', type=int, default=200)
    parser.add_argument('--output-dir', type=Path, required=True)
    parser.add_argument('--no-cim', action='store_true', help='Skip optional one-time sanitized command-role query for each new PID')
    args = parser.parse_args()
    if os.name != 'nt':
        parser.error('Windows native Python is required')
    if not (1 <= args.duration <= 180 and 100 <= args.interval_ms <= 250 and args.root_pid > 0):
        parser.error('duration must be 1..180 seconds, interval 100..250 ms, root PID positive')
    output = args.output_dir.resolve()
    if output == BASE or not output.is_relative_to(BASE):
        parser.error('output-dir must be a fresh child directory under this observer folder')
    output.mkdir(parents=False, exist_ok=False)
    k = api()
    root_handle = open_process(k, args.root_pid)
    if not root_handle:
        raise C.WinError(C.get_last_error())
    root_meta = metadata(k, root_handle)
    if root_meta['status'] != 'running':
        k.CloseHandle(root_handle)
        raise RuntimeError('Root app-server is not running')
    root_image = image_name(k, root_handle)
    if not root_image or Path(root_image).name.lower() != 'codex.exe':
        k.CloseHandle(root_handle)
        raise RuntimeError('Root PID does not resolve to codex.exe')

    started = time.monotonic()
    deadline = started + args.duration
    sampling_deadline = started + max(1, args.duration - 3)
    lock = threading.Lock()
    finished = threading.Event()
    pending = queue.Queue()
    tracked = {}
    seen = set()
    counts = {'snapshots': 0, 'processes': 0, 'exits': 0, 'cim_queries': 0, 'snapshot_errors': 0}
    trace_path = output / 'events.jsonl'
    trace = trace_path.open('x', encoding='utf-8', newline='\n')
    last_flush = started
    def emit(event, **fields):
        nonlocal last_flush
        value = {'event': event, 'utc': utc(), 'elapsed_seconds': time.monotonic() - started, **fields}
        with lock:
            trace.write(json.dumps(value, ensure_ascii=False) + '\n')
            if time.monotonic() - last_flush >= 1 or event != 'sample':
                trace.flush()
                last_flush = time.monotonic()

    def cim_worker():
        powershell = Path(os.environ.get('SystemRoot', 'C:/Windows')) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
        while not finished.is_set():
            try:
                first = pending.get(timeout=0.1)
            except queue.Empty:
                continue
            batch = [first]
            while len(batch) < 20:
                try:
                    batch.append(pending.get_nowait())
                except queue.Empty:
                    break
            if deadline - time.monotonic() < 3:
                continue
            # Integers only; no source/user command text is interpolated into the shell.
            predicate = ' OR '.join('ProcessId=' + str(item['pid']) for item in batch)
            command = "[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new(); Get-CimInstance Win32_Process -Filter '" + predicate + "' | Select-Object ProcessId,CreationDate,CommandLine | ConvertTo-Json -Compress"
            try:
                result = subprocess.run([str(powershell), '-NoLogo', '-NoProfile', '-NonInteractive', '-Command', command],
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=2, check=False,
                    creationflags=subprocess.CREATE_NO_WINDOW)
                counts['cim_queries'] += 1
                if result.returncode:
                    emit('command_role_unavailable', pids=[x['pid'] for x in batch], reason='CIM exit', code=result.returncode)
                    continue
                text = result.stdout.decode('utf-8-sig').strip()
                values = json.loads(text) if text else []
                if isinstance(values, dict):
                    values = [values]
                expected = {x['pid']: x for x in batch}
                for value in values:
                    pid = int(value['ProcessId'])
                    commandline = value.get('CommandLine') or ''
                    normalized = commandline.replace('\\', '/').lower()
                    markers = [name for name in ['formalization_session_guard.py', 'formalization-hook-bridge.py',
                        'run_workflow_posix.py', 'posix_exec.py', '/module/scripts/gate.py',
                        'reconciliation', 'campaign', 'merge-base', 'rev-parse', 'ls-files', '--binary', '--name-only'] if name in normalized]
                    emit('command_role', pid=pid, observed_creation_filetime=expected[pid].get('creation_filetime'),
                         cim_creation_date=value.get('CreationDate'), markers=markers,
                         commandline_sha256=hashlib.sha256(commandline.encode('utf-8')).hexdigest(),
                         commandline_characters=len(commandline), raw_commandline_saved=False,
                         note='CIM query is delayed; verify creation date against observed FILETIME before interpreting a reused PID')
            except (subprocess.TimeoutExpired, OSError, ValueError, KeyError) as exc:
                emit('command_role_unavailable', pids=[x['pid'] for x in batch], reason=type(exc).__name__)

    worker = threading.Thread(target=cim_worker, name='sanitized-command-role', daemon=True)
    outcome = 'completed'
    exit_status = 0
    try:
        emit('observer_start', observer_pid=os.getpid(), root_pid=args.root_pid, root_image=root_image,
             root_metadata=root_meta, duration_seconds=args.duration, interval_ms=args.interval_ms,
             allowed_executables=sorted(ALLOWED), command_role_cim=not args.no_cim)
        with (output / 'ready.json').open('x', encoding='utf-8') as ready:
            json.dump({'observer_pid': os.getpid(), 'root_pid': args.root_pid, 'started_at_utc': utc(),
                       'root_creation_filetime': root_meta.get('creation_filetime'), 'events': str(trace_path)}, ready)
        if not args.no_cim:
            worker.start()
        first_poll = True
        while time.monotonic() < sampling_deadline:
            tick = time.monotonic()
            if k.WaitForSingleObject(root_handle, 0) == 0:
                emit('root_exited', root_pid=args.root_pid, metadata=metadata(k, root_handle))
                outcome = 'root_exited'
                break
            try:
                rows = snapshot(k)
                counts['snapshots'] += 1
            except OSError as exc:
                counts['snapshot_errors'] += 1
                emit('snapshot_error', winerror=exc.winerror)
                time.sleep(min(args.interval_ms / 1000, max(0, deadline - time.monotonic())))
                continue
            # Query existing handles before PID discovery, preserving true exit codes after disappearance.
            for pid, item in list(tracked.items()):
                state = metadata(k, item['handle'])
                emit('exit_observed' if state['status'] == 'exited' else 'sample',
                     pid=pid, parent_pid=item['parent_pid'], name=item['name'], **state)
                if state['status'] == 'exited':
                    counts['exits'] += 1
                    k.CloseHandle(item['handle'])
                    del tracked[pid]
            ancestors = {args.root_pid, *tracked.keys()}
            for pid, row in rows.items():
                if row['name'] not in ALLOWED or pid in tracked or pid == os.getpid():
                    continue
                if not is_descendant(pid, rows, ancestors, {os.getpid()}):
                    continue
                handle = open_process(k, pid)
                if not handle:
                    emit('process_unavailable', **row, winerror=C.get_last_error())
                    continue
                state = metadata(k, handle)
                identity = (pid, state.get('creation_filetime'))
                if identity in seen:
                    k.CloseHandle(handle)
                    continue
                seen.add(identity)
                item = {**row, 'handle': handle, 'creation_filetime': state.get('creation_filetime')}
                tracked[pid] = item
                counts['processes'] += 1
                emit('baseline_process' if first_poll else 'spawn_observed', **row,
                     image=image_name(k, handle), **state)
                if not args.no_cim:
                    pending.put({'pid': pid, 'creation_filetime': state.get('creation_filetime')})
            first_poll = False
            time.sleep(max(0, min(args.interval_ms / 1000 - (time.monotonic() - tick), sampling_deadline - time.monotonic())))
    except KeyboardInterrupt:
        outcome, exit_status = 'interrupted', 130
    except Exception as exc:
        outcome, exit_status = 'observer_error', 1
        emit('observer_error', error_type=type(exc).__name__, error=str(exc))
    finally:
        finished.set()
        if worker.is_alive():
            worker.join(timeout=3)
        emit('observer_complete', outcome=outcome, exit_status=exit_status, counts=counts,
             still_observed_pids=sorted(tracked), command_worker_finished=not worker.is_alive())
        for item in tracked.values():
            k.CloseHandle(item['handle'])
        k.CloseHandle(root_handle)
        trace.flush()
        os.fsync(trace.fileno())
        trace.close()
    receipt = {'kind': 'passive-windows-child-process-observation', 'outcome': outcome,
               'exit_status': exit_status, 'elapsed_seconds': time.monotonic() - started,
               'root_pid': args.root_pid, 'root_creation_filetime': root_meta.get('creation_filetime'),
               'counts': counts, 'events_sha256': hashlib.sha256(trace_path.read_bytes()).hexdigest(),
               'observer_script_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
               'hooks_or_gates_invoked': 0, 'processes_terminated': 0,
               'raw_commandlines_or_environment_saved': False,
               'limits': ['Sampling can miss processes living less than one interval.',
                          'Late orphan discovery without an observed ancestry chain is omitted.',
                          'CPU and IO are cumulative counters, not a wait-stack or open-pipe inventory.',
                          'CIM roles are best effort; unavailable/short-lived/reused PIDs require caution.',
                          'The duration budget reserves up to 3 seconds for helper cleanup; default sampling is approximately 177 seconds.',
                          'OS scheduling or a blocking Windows API can overrun a wall-clock budget; this is not a hard real-time monitor.']}
    with (output / 'completion.json').open('x', encoding='utf-8', newline='\n') as handle:
        handle.write(json.dumps(receipt, indent=2) + '\n')
    print(json.dumps({'output_dir': str(output), **receipt}))
    return exit_status

if __name__ == '__main__':
    raise SystemExit(main())
