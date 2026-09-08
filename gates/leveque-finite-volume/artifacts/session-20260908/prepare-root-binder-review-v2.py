from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
base=S/'prepare-root-batch10-evidence-verifications.py'
text=base.read_text(encoding='utf-8')
start=text.index("B=S/'blocked-gate-binding-preparation'")
header=text[:text.index("P=S/'returned-field-coordinate-sweep-draft'")]
tail=text[start:].replace("root-batch10-blocked-binder-fixtures.txt","root-batch10-blocked-binder-fixtures-output.txt")
tail=tail.replace("print(json.dumps({'sweep_derivation':derivation,'blocked_review':out}))","print(json.dumps({'blocked_review':out}))")
dest=S/'verify-blocked-binder-root-v2.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(header+tail)
record={'original_sha256':hashlib.sha256(base.read_bytes()).hexdigest(),'derived_sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),'actual_original_exit':1,'original_failure':'FileNotFoundError at root-batch10-blocked-binder-fixtures.txt; actual runner suffix is -output.txt, confirmed by rg and reading runner. Sweep verifier derivation already completed and independently exited0.','resolution':'Additive split verifier for remaining binder review; correct exact observed output path; preserves all assertions and prior files.'}
p=S/'root-batch10-verifier-path-correction.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))

