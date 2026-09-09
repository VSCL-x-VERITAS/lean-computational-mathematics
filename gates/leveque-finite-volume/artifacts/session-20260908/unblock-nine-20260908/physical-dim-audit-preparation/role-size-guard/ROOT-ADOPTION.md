# Root review of exact-input size guard

The root coordinator reviewed all of `guard.py` (SHA256 `39e28bffe47dce039e70a17450f4ce026b762e78621673ade23cd2c544dcd17a`), its nine focused construction/cap tests, and their retained receipt. The guard is adopted for this task's staged role execution.

The guard evaluates the unchanged generated runner's constructor through `message = b''.join(parts)`, rejects writes and subprocesses during this read-only construction, and freezes two identical constructions with their input hashes. Execution runs the same runner and compares the actual CLI stdin byte-for-byte immediately before launch. The conservative 1,048,576-byte UTF-8 limit cannot truncate or summarize evidence. An oversized input is retained and rejected for separate diagnosis.

The original role isolation, prompts, schemas, source images, native evidence, runtime command and collector remain unchanged. Each role uses a fresh stem and fresh CLI session. This adoption concerns transport correctness only; it supplies no source interpretation or requested audit verdict. Subsequent collector/finalization commands must record their actual outcomes. No semantic role has run as a consequence of writing this review.
