"""Freeze structural identities of the three unchanged baseline Eq. (1.3) declarations."""
from pathlib import Path
import hashlib,importlib.util,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
inp=S/'baseline-equation03-expression-inputs.json'
assert sha(inp)=='552f835ae6afd0542a99bd41ab9e6b9cf25d73ee13a1180ab7d6ca1b51cad99f'
m=read(inp)
for f in m['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/m['exporter_path'])==m['exporter_sha256']
r=S/'baseline-equation03-expression-export-after-prepare-exit.json';receipt=read(r)
assert type(receipt['exit_code']) is int and receipt['exit_code']==0
assert receipt['input_commit']==m['input_commit']
assert receipt['command']=='lake env lean '+m['exporter_path']
assert receipt['output_sha256']==sha(S/'baseline-equation03-expression-export-after-prepare-output.txt')
parser=S/'freeze-chapter01-expression-fingerprints-v3.py'
assert sha(parser)=='fe089bb896ff20a624d9f34efbf957fea3c168a591ea9bfbd4235481dc595702'
spec=importlib.util.spec_from_file_location('fingerprint_parser',parser);p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
records,raw=p.records(R/'.lake/chapter01-baseline-equation03-expressions.jsonl')
assert len(records)==3 and {x['name'] for x in records}==set(m['expected_declarations'])
result={'schema':1,'input_manifest_sha256':sha(inp),'native_receipt_sha256':sha(r),'baseline':m['baseline'],'input_commit':m['input_commit'],'normalization':m['normalization'],'files':m['files'],'legacy_forwarder':m['legacy_forwarder'],'records':sorted(records,key=lambda x:x['name']),'ignored_raw_stream':raw,'scope':'The source owner bytes are identical at the baseline and current checkpoint; compiled structural types/proofs identify the previously selected producers. The current gate uses a different fully reaudited interpreted target. No old acceptance is transplanted.'}
dest=S/'baseline-equation03-expression-fingerprints.json';assert not dest.exists();dest.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'path':dest.relative_to(R).as_posix(),'sha256':sha(dest),'declarations':[{k:x[k] for k in ['name','module','type_sha256','value_sha256']} for x in records],'ignored_raw_bytes':raw['bytes']}))

