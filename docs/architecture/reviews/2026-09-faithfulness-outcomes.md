# Faithfulness audit outcomes

The per-claim faithfulness audit packages and their chapter gate documents were
the working record of the audit campaign and were retired from the tree on
2026-09-10. This file preserves their outcomes, which are the durable result.

Recover any package, gate document or decision in full:

```bash
git show afb25bab1:<path>
git restore --source afb25bab1 -- gates/ audits/
```

## Chapter gates

| Gate document | Chapter | Gate | Rows | Row outcomes |
|---|---|---|---:|---|
| `gates/ch01.json` | 1 | **PASS** | 49 | PROVED 41; SKIPPED 3; DISCREPANCY 3; REUSED 1; DEFERRED 1 |
| `gates/ch02.json` | 2 | **ACTIVE** | 130 | PROVED 87; READY 29; SKIPPED 11; HARD_BLOCKED 3 |
| `gates/leveque-finite-volume/chapter-01.json` | 1 | **ACTIVE** | 57 | PROVED 22; REUSED 17; SKIPPED 16; HARD_BLOCKED 1; IN_PROGRESS 1 |

## Audit packages

- `audits/vershynin-hdp`: 147 per-claim packages
- `gates/leveque-finite-volume`: 107 per-claim packages

- sealed decisions: 237

## Method

The audit protocol was the vendored kit in `.faithfulness-audit/` (version 1.1.0),
which adapts the semantic-correctness audit of Meek et al., arXiv:2606.14000v1 §3.2.1.
Its premise, in the kit's own words: kernel acceptance proves that a term inhabits
the Lean type; it does not prove that the type says what the source says.
