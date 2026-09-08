"""Derive a bounded frozen-file stager; preserve every earlier helper."""
from pathlib import Path
S=Path(__file__).resolve().parent
p=S/'stage-acoustic-checkpoint.py'
t=p.read_text()
t=t.replace('transport-acoustic-organized-verification.json','right-domain-increment-verification.json')
t=t.replace('acoustic-checkpoint','right-domain-checkpoint')
t=t.replace('for p in S.iterdir():\n if p.is_file() and p.suffix != ".log" and not p.name.startswith(("library-build", "right-domain-checkpoint-")):\n  files.add(p.relative_to(R).as_posix())', '''for p in S.iterdir():
 if p.is_file() and p.name.startswith((
    "right-domain-", "right-mode-", "real-measure-root-", "verify-real-measure-",
    "run-frozen-command-20260908b", "record-right-", "derive-right-", "place-right-",
    "prepare-right-", "validate-right-", "prepared-final-LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-",
    "chapter01-current-producer-", "inventory-current-chapter01-", "verify-current-chapter01-",
    "chapter01-source-inventory-", "snapshot-source-inventory-", "transport-integral-nonaccepted-",
    "source-ledger-before-right-mode-", "gate-before-right-mode-", "gate-before-right-domain-",
    "tiers-before-right-domain-", "ledger-before-LEV-C1-TRANSPORT-", "ledger-before-BF-LEV-RUN-20260908-013-",
    "ledger-before-BF-LEV-RUN-20260908-014-", "stage-right-domain-"
 )) and not p.name.startswith("right-domain-checkpoint-"):
  files.add(p.relative_to(R).as_posix())''')
t=t.replace('"LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908"]:',
'''"LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908",
 "LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908",
 "LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908"]:''')
t=t.replace('for p in (S/"audits").glob("*/audit-task.json"):\n files.add(p.relative_to(R).as_posix())',
'''for p in (S/"audits").glob("*/audit-task.json"):
 if "TRANSPORT-CONTEXT" not in p.parent.name:
  files.add(p.relative_to(R).as_posix())''')
t=t.replace('"equation04-acoustic-model"]:', '"equation04-acoustic-model", "acoustics-algebraic-domain", "real-measure-dependency"]:')
t=t.replace('# These nine roots', '# These eleven roots')
t=t.replace('"library-build*","all non-frozen audit output roots"','"library-build*","all non-frozen audit output roots","fresh context task/config still being prepared"')
dest=S/'stage-right-domain-checkpoint.py'
assert not dest.exists()
assert 'right-domain-increment-verification.json' in t and 'TRANSPORT-CONTEXT' in t
dest.write_text(t,encoding='utf-8')
print(dest)
