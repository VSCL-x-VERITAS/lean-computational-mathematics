"""Derive the next bounded stager from the prior byte-verifying adapter."""
from pathlib import Path
S = Path(__file__).resolve().parent
source = (S / 'stage-transport-checkpoint.py').read_text()
source = source.replace('transport-intro-proof-verification.json', 'transport-acoustic-organized-verification.json')
source = source.replace('transport-checkpoint-', 'acoustic-checkpoint-')
source = source.replace('"ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"})',
    '"ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md",\n "ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md"})')
source = source.replace('# These eight roots are explicitly frozen by the audit coordinator.',
    '# These nine roots are explicitly frozen by the audit coordinator.')
source = source.replace('"LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908"]:',
    '"LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908",\n "LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908"]:')
destination = S / 'stage-acoustic-checkpoint.py'
assert not destination.exists()
assert 'transport-acoustic-organized-verification.json' in source
assert 'codex-start-1-v5-0-1-20260908/issues.md' in source
assert 'LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908' in source
destination.write_text(source, encoding='utf-8')
print(destination)

