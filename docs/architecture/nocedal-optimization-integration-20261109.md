# Nocedal Chapter 1 architecture integration

The eight new `ComputationalMathematics.Optimization` modules contain reusable
convexity, discrete-domain, and modeling mathematics. They do not encode a
numbered book claim. The `ComputationalMathematics.Optimization` tier prefix
therefore assigns them the reusable role. The existing
`ComputationalMathematics.Source` prefix assigns the Nocedal chapter modules
the source role.

`ComputationalMathematics.All` imports the eight reusable modules;
`ComputationalMathematics.Source` imports the Nocedal entry point and the
Chapter 1 local/global clarification companion. This makes
the new product files reachable from the established complete-tree API while
preserving their narrower imports. No existing theorem statement or proof is
changed by this integration.

The Chapter 1 product files are the 39 exact files in the local reviewed
checkpoint and first appeared on branch commit `13bb96e60`. Its pinned v5
Chapter 1 gate accepted 14 of 14 Lean rows and recorded three separate
source ambiguities as deferred. The current-main focused build of
`ComputationalMathematics.Source.NocedalWright` passed with 2,516 jobs.

Integration checks:

- `python3 tools/architecture/check_layout.py`
- `python3 tools/architecture/check_tiers.py`
- `python3 tools/architecture/check_placeholders.py`
- `python3 tools/architecture/check_provenance.py`
- `lake build ComputationalMathematics.Source.NocedalWright`

The Chapter 2 product is prepared as a separate branch and remains an active
chapter. This architecture note grants it no chapter or publication credit.
