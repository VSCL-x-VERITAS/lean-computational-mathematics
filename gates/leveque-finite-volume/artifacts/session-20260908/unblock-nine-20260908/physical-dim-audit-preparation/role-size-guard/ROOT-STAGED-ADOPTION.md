# Root review of staged audit collection and completion

The root coordinator reviewed the complete `staged.py` (SHA256 `0e64d2d9051d2b5dbeb52ce1aa32f5eb914557c3cea113c856322695cce57e83`), the generated collector's provenance checks, the fourteen fixture checks and their actual exit-zero receipt (`569304a2494aa4160935738fd5328427853c458d8c16a0169b9111a116e6d0ed`). The staged helper is adopted for this task.

Collection captures the unchanged collector's actual execution, validates its exact guarded-input hash, and retains before/after agent-run snapshots. Collections run sequentially because they append to one agent-run ledger. The adjudication check uses the released implementation and preserves its actual stdout and required/exit relationship. Finalization validates the supplied role receipts and outputs, invokes the released finalizer and complete-phase validator, and creates an aggregate only on actual success. The aggregate truthfully records that `q.py` was not invoked. Failed attempts remain separate and cannot overwrite retained evidence.

The reviewed fixture successes establish helper behavior only. They are not audit evidence. An actual completed but unaccepted audit remains unaccepted; source acceptance is independently enforced by the existing row-binding consumer. No model output, source interpretation or verdict is supplied by this adoption.
