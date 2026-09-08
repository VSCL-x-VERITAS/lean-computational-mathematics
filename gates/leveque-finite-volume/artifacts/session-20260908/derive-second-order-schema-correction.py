"""Correct the local projection's contract schema while retaining the failed attempt."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
src=S/'bind-second-order-classification-proved-row.py';text=src.read_text(encoding='utf-8')
start=text.index("        'source_extraction_sha256':")
end=text.index("\n    derivation = ",start)
old=text[start:end]
text=text[:start]+"    }"+text[end:]
text=text.replace("'source_extraction_sha256': contract['source_extraction_sha256'],","'source_extraction_sha256': hashlib.sha256((output / 'agent_outputs/source_contract.json').read_bytes()).hexdigest(),\n        'lean_implies_source': decision['implications']['lean_implies_source'],\n        'source_implies_lean': decision['implications']['source_implies_lean'],\n        'findings': decision['findings'],\n        'broader_extraction_retained': (output / 'agent_outputs/source_contract.json').relative_to(root).as_posix(),")
dest=S/'bind-second-order-classification-proved-row-v2.py';assert not dest.exists()
compile(text,str(dest),'exec');dest.write_text(text,encoding='utf-8')
print(json.dumps({'path':str(dest),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()}))

