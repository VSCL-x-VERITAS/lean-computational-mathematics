"""Derive an explicit frozen-evidence checkpoint selection from the verified stager."""
from pathlib import Path
S = Path(__file__).resolve().parent
text = (S / 'stage-production-checkpoint.py').read_text()
start = text.index('files=set(')
end = text.index('selection=S/', start)
selection = '''files={
 "ComputationalMathematics/Analysis.lean",
 "ComputationalMathematics/Source/LeVeque/Chapter01.lean",
 "ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean",
 "docs/architecture/tiers.json",
 "gates/leveque-finite-volume/chapter-01.json",
 "ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"}
# Every top-level check has finished; the full-library build is still mutable.
for p in S.iterdir():
 if p.is_file() and p.suffix != ".log" and not p.name.startswith(("library-build", "organized-checkpoint-")):
  files.add(p.relative_to(R).as_posix())
# These six roots are explicitly frozen by the audit coordinator.
for ident in [
 "LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908",
 "LEV-CH01-SCALAR-HYPERBOLICITY-CANONICAL-20260908",
 "LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908",
 "LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908"]:
 for p in (S/"audits"/ident).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
for p in (S/"audits").glob("*/audit-task.json"):
 files.add(p.relative_to(R).as_posix())
# Both completed draft directories are frozen, with no canonical placement claimed.
for name in ["rectangle-riemann-interface", "equation03-transport"]:
 for p in (S/name).rglob("*"):
  if p.is_file():files.add(p.relative_to(R).as_posix())
'''
text = text[:start] + selection + text[end:]
text = text.replace('production-checkpoint-', 'organized-checkpoint-')
text = text.replace('"all non-frozen audit output roots","rectangle-riemann-interface"', '"all non-frozen audit output roots"')
text = text.replace('frozen introductory production/evidence', 'frozen organization and semantic-finding evidence')
(S / 'stage-organized-checkpoint.py').write_text(text, encoding='utf-8', newline='\n')
print('Wrote stage-organized-checkpoint.py; no staging performed.')
