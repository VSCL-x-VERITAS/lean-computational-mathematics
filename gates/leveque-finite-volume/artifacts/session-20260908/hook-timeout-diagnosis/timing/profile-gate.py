"""One unchanged released gate check; profiler outputs confined to this folder."""
import cProfile
import io
import json
import os
from pathlib import Path
import pstats
import runpy
import sys
import time

folder = Path(__file__).resolve().parent
gate_script, gate_path = sys.argv[1:]
sys.argv = [gate_script, 'check', gate_path, '--unit', '1', '--mode', 'default']
os.environ['GIT_TRACE2_EVENT'] = str(folder / 'git-trace2.jsonl')
profiler = cProfile.Profile()
start = time.perf_counter()
exit_code = 0
try:
    profiler.runcall(runpy.run_path, gate_script, run_name='__main__')
except SystemExit as exc:
    exit_code = exc.code if isinstance(exc.code, int) else (0 if exc.code is None else 1)
finally:
    elapsed = time.perf_counter() - start
    profiler.dump_stats(str(folder / 'gate.pstats'))
    stream = io.StringIO()
    stats = pstats.Stats(profiler, stream=stream).sort_stats('cumulative')
    stats.print_stats(50)
    stats.print_callers('lean_worktree_fingerprint|lean_changed_paths|_run_git|read_bytes|stat')
    (folder / 'profile.txt').write_text(stream.getvalue(), encoding='utf-8')
    (folder / 'profile-run.json').write_text(json.dumps({
        'command': sys.argv, 'gate_exit_code': exit_code,
        'profiled_gate_elapsed_seconds': elapsed,
        'sys_executable': sys.executable, 'git_trace2_event': os.environ['GIT_TRACE2_EVENT'],
        'profiling_overhead_included': True,
    }, indent=2) + '\n', encoding='utf-8')
raise SystemExit(exit_code)
