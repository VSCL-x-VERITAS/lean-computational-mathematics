"""Specialize the session-local qualified gate projection for the exact discontinuity reply."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
source=S/'bind-interpreted-proved-row.py';original=source.read_bytes()
assert hashlib.sha256(original).hexdigest()=='0d124a269794bc5972804ebbb4cc847a7204691179390dfc6f693fa7d735bbe9'
text=original.decode()
old="""    if args.row not in interpretation['scope'] or interpretation['source_sha256'] != checker.PINNED_SOURCE_SHA256:
        raise ValueError('user interpretation has a different row or source scope')"""
new="""    if (receipt_sha != 'b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
        or args.row != 'LEV-CH01-DISCONTINUITY-INTEGRAL-LAW'
        or interpretation['scope'] != 'Chapter 1 discontinuity discussion around equation (1.10), particularly LEV-CH01-DISCONTINUITY-INTEGRAL-LAW.'
        or interpretation['source_sha256'] != checker.PINNED_SOURCE_SHA256):
        raise ValueError('this adapter requires the exact recorded discontinuity reply and row')"""
assert old in text;text=text.replace(old,new)
text=text.replace("interpretation['limitations']","interpretation['preservation']")
p=S/'bind-discontinuity-interpreted-proved-row.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
receipt={'schema':1,'base_adapter_sha256':hashlib.sha256(original).hexdigest(),'derived_adapter_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'user_receipt_sha256':'b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030','allowed_row':'LEV-CH01-DISCONTINUITY-INTEGRAL-LAW','scope':'Future projection only after independently accepted equivalent complete audit and exact native proof validation. Uses the actual receipt preservation field and checks its exact string scope; no user receipt, target, audit input or released validator is changed.'}
(S/'discontinuity-gate-adapter-derivation.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt))
