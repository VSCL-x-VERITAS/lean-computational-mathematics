from pathlib import Path
S = Path(__file__).resolve().parent
source = (S / 'validate-acoustic-prepared.py').read_text()
source = source.replace('LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908',
    'LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-PRODUCTION-20260908')
source = source.replace('acoustic-prepared-validation.json', 'right-domain-prepared-validation.json')
source = source.replace('acoustic model successor', 'positive-ratio right-mode successor')
path = S / 'validate-right-domain-prepared.py'
assert not path.exists()
path.write_text(source, encoding='utf-8')

