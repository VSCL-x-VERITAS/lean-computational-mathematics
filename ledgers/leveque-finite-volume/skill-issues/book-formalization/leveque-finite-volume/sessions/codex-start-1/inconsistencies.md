# Inconsistencies — session codex-start-1

Record skill, harness, prompt, gate, tool, or agent-process inconsistencies encountered in this scope. Use stable IDs; never delete history—mark superseded or closed entries.

| ID | Observed at | Surfaces compared | Inconsistency | Evidence | Risk | Status | Owner/next action |
|---|---|---|---|---|---|---|---|
| BF-LEV-S01-INCONSISTENCY-001 | 2026-08-31T22:59:29Z | generated gate template vs mandatory initialization preflight | `gate.py init` writes all four organization counters as `-1`, while `organization_preflight.py` rejects every negative counter; therefore the mandated immediate preflight cannot pass until a separate repository scan and gate update occur. | Gate initialization exited 0, then the required preflight exited 1 with `organization counters are missing or invalid`. | A naïve runner may misclassify the expected initialization transition as repository organization debt or may skip the preflight entirely. | open | Workflow maintainer: make initialization emit or invoke a current scan, or document the required scan/update transition; coordinator: populate counters only from current scan evidence and rerun preflight. |
