# Limitations — session codex-continue-2

Record skill, harness, prompt, gate, tool, or agent-process limitations encountered in this scope. Use stable IDs; never delete history—mark superseded or closed entries.

| ID | Observed at | Component | Limitation | Consequence | Workaround | Status | Owner/next action |
|---|---|---|---|---|---|---|---|
| BF-CONT2-LIM001 | 2026-09-10T08:51:33Z | v1 faithfulness-audit blind-role transport | The collaboration runtime exposes no attachment or inline-file transport primitive with which the orchestrator can inject the generated 45,501-byte blind review packet without reproducing it manually in the agent message. | The isolated blind agent must learn the exact packet's filesystem path even though the v1 prompt ideally supplies the packet inline; the path contains the audit task directory name. | Spawned the role without inherited context and authorized one constrained read of only the prompt, schema, and hash-pinned packet, prohibiting every other file, source, target, metadata, prior-output, conversation, and web access. The returned artifact remains mechanically checked against packet SHA-256 `52a609adcc759789515d8423ce3bfae60450bdfe3ebbd36e18a17c72e1566e85`. | open | Provider/runtime owner should add opaque inline attachment support; retain this limitation with the audit evidence. |
