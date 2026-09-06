# Limitations — chapter 1

Record book, source, or source-to-Lean limitations encountered in this scope. Use stable IDs; never delete history—mark superseded or closed entries.

| ID | Source row | Limitation | Scope/consequence | Lean artifact | Workaround | Status | Owner/next action |
|---|---|---|---|---|---|---|---|
| BF-LEV-CH01-LIMITATION-001 | LEV-CH01-EQ-1.3-ADVECTED-PROFILE | Chapter 1 does not specify whether “solution” is classical, weak, or distributional, nor the profile’s regularity class. | The isolated Chapter 1 wording is ambiguous, but Chapter 2 explicitly requires sufficient smoothness for the differential form and describes smooth translated profiles as solutions. | `NumStability.leveque01_equation03_profilePropagates`; `NumStability.leveque01_equation03_scalarAdvection`; `NumStability.leveque01_equation03_advectedProfile` | Keep rigid propagation unconditional and classical PDE satisfaction under global differentiability; retain the complete accepted audit `LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL`. | mitigated—audited | Reuse this explicit regularity split; do not infer a nonsmooth generalized-solution theorem. |
