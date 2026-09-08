Repository Git operations must use the prepared POSIX runtime consistently while the formalization guard uses MSYS2 Git. Native Lean/Lake remains unchanged.

The Chapter 1 investigation reproduced a shared-index cache incompatibility on 2026-09-08. The unchanged gate took 6.429 seconds with the POSIX cache. The exact native finalizer command `git diff --name-only HEAD` reported no file changes but rewrote cached device/inode/ownership fields. The next identical POSIX gate took 39.425 seconds, including a 33,262-entry refresh, and restored the original index hash. This exceeds the guard's unchanged 20-second closure budget. Exact measurements and independent review are in `chapter01-hook-git-cache-diagnosis/empirical-review.json`.

Use this native PowerShell entry point for Git, including status, diff, staging, commit and final hygiene:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -B 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py' 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/posix_git.py' -C 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics' status --short
```

Do not follow a successful POSIX final gate with native Git worktree scans. Even a diff with empty output can refresh the shared index. The inspected diff implementations do not justify relying on `--no-optional-locks` to prevent this refresh. No Git cache freshness setting, hook timeout, guard, validator or source contract was changed for this remedy. After an unavoidable native scan, complete a real POSIX validation before attempting Stop; do not treat a warmed cache as a replacement verdict.

The controlled test establishes this timeout mechanism. It does not by itself prove that every historical timeout had that sole cause or certify the next actual host Stop event. Keep those observations separate.
