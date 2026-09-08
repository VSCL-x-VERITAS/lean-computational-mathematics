"""Select the frozen transport introduction while excluding active audit preparations."""
from pathlib import Path
S = Path(__file__).resolve().parent
text = (S / 'stage-organized-checkpoint.py').read_text()
text = text.replace('organized-checkpoint-', 'transport-checkpoint-')
needle = 'files={\n'
assert text.count(needle) == 1
text = text.replace(needle,
    'files=set(f["path"] for f in json.loads((S/"transport-intro-proof-verification.json").read_text())["files"])\nfiles.update({\n')
needle = '"ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md"}'
assert text.count(needle) == 1
text = text.replace(needle, needle + ')')
text = text.replace('"LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908"]:',
    '"LEV-CH01-EQ-1.3-ADVECTED-PROFILE-GLOBAL-CANONICAL-20260908",\n "LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908",\n "LEV-CH01-ADVECTION-WAVE-IDENTITY-CANONICAL-20260908"]:')
text = text.replace('These six roots', 'These eight roots')
text = text.replace('["rectangle-riemann-interface", "equation03-transport"]',
    '["rectangle-riemann-interface", "equation03-transport", "equation02-transport", "equation04-acoustic-model"]')
text = text.replace('Both completed draft directories', 'All selected completed draft directories')
(S / 'stage-transport-checkpoint.py').write_text(text, encoding='utf-8', newline='\n')
print('Wrote stage-transport-checkpoint.py; no staging performed.')
