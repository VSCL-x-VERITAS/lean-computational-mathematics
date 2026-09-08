from pathlib import Path
here=Path(__file__).resolve().parent
old=here/'prepare.py';new=here/'prepare-v2.py'
assert not new.exists()
raw=old.read_text(encoding='utf-8')
needle="in prior frozen preparation.json')))"
assert raw.count(needle)==1
new.write_text(raw.replace(needle,"in prior frozen preparation.json'))"),encoding='utf-8',newline='\n')
