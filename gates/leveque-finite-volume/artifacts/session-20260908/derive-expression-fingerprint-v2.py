from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
src=S/'freeze-chapter01-expression-fingerprints.py';raw=src.read_bytes();text=raw.decode()
assert text.count('buffering=1024*1024')==1 and text.count('peek(65536)')==1
text=text.replace('buffering=1024*1024','buffering=4096').replace('peek(65536)','peek(4096)')
text=text.replace("chapter01-declaration-expression-fingerprints.json","chapter01-declaration-expression-fingerprints-v2.json")
dst=S/'freeze-chapter01-expression-fingerprints-v2.py';assert not dst.exists();dst.write_text(text,encoding='utf-8',newline='\n')
receipt={'original_sha256':hashlib.sha256(raw).hexdigest(),'successor_sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'change':'Bound BufferedReader.peek copies to 4096 bytes instead of a megabyte per escaped delimiter; identical parsing and hash algorithm, separate immutable output path.'}
(S/'expression-fingerprint-v2-derivation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
