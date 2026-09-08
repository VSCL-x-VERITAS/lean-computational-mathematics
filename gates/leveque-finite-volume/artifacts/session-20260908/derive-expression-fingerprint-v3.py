from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
src=S/'freeze-chapter01-expression-fingerprints-v2.py';raw=src.read_bytes();text=raw.decode()
assert hashlib.sha256(raw).hexdigest()=='08ed9d36651515169377fd7ff9bc61b57e6660e792b9eed5ca85f3bf663028a6'
text=text.replace("assert len(authored_new)==180,len(authored_new)","assert len(authored_new)==224,len(authored_new)")
text=text.replace('new_authored_declarations','new_module_declaration_constants').replace("'new_authored'","'new_module_constants'")
text=text.replace('chapter01-declaration-expression-fingerprints-v2.json','chapter01-declaration-expression-fingerprints-v3.json')
text=text.replace("'declaration_count':len(data)","'declaration_count':len(data),'counting_note':'Environment constants include generated recursors and constructors; this is not a count of authored source declarations.'")
dst=S/'freeze-chapter01-expression-fingerprints-v3.py';assert not dst.exists();dst.write_text(text,encoding='utf-8',newline='\n')
record={'previous_parser_sha256':hashlib.sha256(raw).hexdigest(),'successor_sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'previous_actual_exit':1,'previous_failure':'AssertionError: 224 at authored_new count, after 287 unique constants parsed. No fingerprint artifact was written.','correction':'Distinguish all compiled environment constants in new modules from authored source declarations. Preserve exact expression hashes and all constants, including recursors/constructors.','original_obsolete_parser':'Verified Windows process 4372 command line; stopped after successor exposed the invalid count guard. Actual launcher exit will remain in tool evidence.'}
(S/'expression-fingerprint-v3-derivation.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record))
