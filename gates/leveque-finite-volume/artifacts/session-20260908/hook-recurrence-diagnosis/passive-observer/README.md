This passive observer is prepared **but has not been started**. It invokes no hook or gate. Root may launch it hidden immediately before an actual host Stop.

Use native Python. Choose a fresh run directory; the observer refuses an existing directory and refuses output outside this folder. Example PowerShell invocation (not executed during preparation):

```powershell
$observerBase = 'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\workflow-v5.0.1-local\chapter01-hook-stop-observer'
$observerRun = Join-Path $observerBase 'actual-stop-01'
$observerPython = 'C:\Users\qed_s\AppData\Local\Programs\Python\Python312-arm64\python.exe'
$observerScript = Join-Path $observerBase 'observe.py'
Start-Process -FilePath $observerPython -WindowStyle Hidden -ArgumentList @('-B', $observerScript, '--root-pid', '10588', '--duration', '180', '--interval-ms', '200', '--output-dir', $observerRun)
```

These supplied paths contain no spaces. If relocating to paths containing spaces, quote each affected `Start-Process` argument according to its Windows command-line rules. Do not reuse the run directory. Confirm `ready.json` exists before the actual Stop. `ready.json` reports the observer PID and the checked root creation time/image; root must independently confirm 10588 is still the intended app-server. The script itself requires a live `codex.exe` at that PID.

Defaults are a 200 ms sample interval and 180-second overall budget, reserving three seconds for the optional helper to finish (approximately 177 seconds of sampling). Intervals outside 100–250 ms and durations above 180 seconds are rejected. As with all user-space Windows sampling, blocking API calls and scheduling mean this is not a hard real-time upper bound.

The core uses Python stdlib and `ctypes`: Toolhelp32 process snapshots; query/wait-only process handles; `QueryFullProcessImageNameW`; process creation/exit/kernel/user times; and cumulative I/O operation/byte counters. It follows ancestry through the snapshot but records only `cmd.exe`, `python.exe`, `python3.exe`, `bash.exe` and `git.exe` below the selected app-server. The observer and its descendants are excluded. It retains handles for true observed exit codes and distinguishes PID reuse by creation time. It never requests process-memory read, modification or termination access.

`QueryFullProcessImageNameW` supplies an executable path, not a command line. A separate asynchronous, hidden PowerShell CIM query runs once for newly observed PIDs, batched where possible and capped at two seconds. It stores only known command-role markers (guard, bridge, gate, campaign/reconciliation or Git operation), length and SHA-256; **raw command lines and environment values are not saved**. CIM is best effort: short-lived processes may disappear, and its creation date must be checked against the event's observed FILETIME before assigning a role to a reused PID. Add `--no-cim` to omit this optional helper entirely.

Files are exclusive creations. `events.jsonl` is flushed on lifecycle events and at least about once per second. It contains UTC and monotonic-relative times, baseline/spawn observations, resource samples, exit observations, query failures and a completion event. `completion.json` binds the event bytes, actual outcome, observer script hash and counters. An observer crash before setup completes may leave an incomplete fresh directory; absence of completion is not success.

For the timeout distinction, compare the actual gate-role Python process and its Git descendants. An active Git with advancing CPU/I/O points toward ongoing work; an exited gate followed by continued parent waiting points toward process/pipe completion. A sampled process remaining alive with stable counters does not identify its wait reason. This observer does not inspect pipe handles or stacks, prove deadlock, or prove hook success. Processes shorter than one sampling interval and descendants first seen only after unobserved ancestors disappear can be missed.

Preparation validation is syntax/static only. No observation run, hook run, gate run or operational mutation was performed.
