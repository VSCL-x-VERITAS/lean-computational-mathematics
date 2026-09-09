from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent
p=h/'reference-native/Candidate.lean';b=p.read_bytes()
assert hashlib.sha256(b).hexdigest()=='9ab601c4c9474e01b05c2ffd2beb05f3fe262f03e8e920246e2f720b18074133'
s=b.decode();s=s[s.index('namespace CartesianDirectionalAffineReference'):]
(h/'Reference.lean.fragment').write_text(s,encoding='utf-8',newline='\n')
(h/'copied-reference.json').write_text(json.dumps({'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'span_sha256':hashlib.sha256(s.encode()).hexdigest(),'receipt':{'path':str(h/'reference-native/receipt.json'),'sha256':'7d28c47c018ea4e3cde278b38e723c1ac83b728d44203c79201dc2073a900446'}},indent=2)+'\n',encoding='utf-8')
