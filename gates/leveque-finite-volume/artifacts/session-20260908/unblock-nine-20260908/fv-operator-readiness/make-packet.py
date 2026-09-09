"""Freeze a readiness-only supplement, reusing exact existing operator evidence."""
from datetime import datetime, timezone
from pathlib import Path
import ast
import hashlib
import json
import os
import re

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p/'lean-toolchain').is_file())
M = D.parent/'measure-operator-evidence'
shim = D.parent/'fv-local-domain-review/native-long-path-io.py'
exec(compile(shim.read_bytes(), str(shim), 'exec'), globals())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}

def write(path, value):
    with path.open('xb') as handle:
        handle.write((json.dumps(value,indent=2,ensure_ascii=False)+'\n').encode())

preparer = D.parent/'prepare-successor-audit-with-source-context-long-paths.py'
tree = ast.parse(preparer.read_bytes())
nodes = [node for node in tree.body if isinstance(node,ast.FunctionDef)
         and node.name=='load_additional_supplement']
assert len(nodes)==1
namespace = {'Path':Path,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(preparer)+'::loader','exec'),namespace)
load = namespace['load_additional_supplement']

original = read(M/'additional-supplement.json')
assert original['packet']['sha256']=='7cb6676ee8033a635c944eaca89a4deaf69fc1477a584e87b6b0214b106efd1e'
base, base_bytes, _ = load(R,original)
base_config = read(R/original['environment_config']['path'])
base_receipt = read(M/'native-02/receipt.json')
assert type(base_receipt['exit_code']) is int and base_receipt['exit_code']==0
assert base_receipt['inputs_unchanged']
assert sha(M/'native-02/output.txt')==base_receipt['output_sha256']

receipt_path = D/'native-01/receipt.json'
receipt = read(receipt_path)
output = D/'native-01/output.txt'
raw = output.read_bytes()
text = raw.decode()
assert type(receipt['exit_code']) is int and receipt['exit_code']==0
assert receipt['inputs_unchanged'] and sha(output)==receipt['output_sha256']
assert sha(D/'run-probe.py')==receipt['runner_sha256']
assert (D/'PiNorm.lean').read_bytes()==(D/'native-01/PiNorm.lean.snapshot').read_bytes()
assert not re.search(r'\b(?:error|warning):|sorryAx',text)
commands = [line for line in (D/'PiNorm.lean').read_text().splitlines()
            if line.startswith(('#check ','#print ','#synth '))]
expected = [line.removeprefix('#print axioms ') for line in commands
            if line.startswith('#print axioms ')]
reports = re.findall(r"^'(.+)' depends on axioms:\s*\[([^\]]*)\]",text,re.M)
no_axioms = re.findall(r"^'(.+)' does not depend on any axioms",text,re.M)
assert {name for name,_ in reports}|set(no_axioms)==set(expected)
assert len(reports)+len(no_axioms)==len(expected)==10
for _,names in reports:
    assert {re.sub(r'\.\{[^}]*\}','',n.strip()) for n in names.split(',')} <= {
        'propext','Classical.choice','Quot.sound'}
for fragment in ['Finset.univ.sup','Pi.normedAddCommGroup','Pi.normedSpace',
                 'Fin m → ℝ','L1.integral','ENNReal.toReal_top']:
    assert fragment in text,fragment

environment = list(base_config['environment_files'])
for item in receipt['inputs']:
    p = R/item['path']
    assert sha(p)==item['sha256_before']==item['sha256_after']
    environment.append(ref(p))
environment += [ref(p) for p in [output,receipt_path,D/'native-01/PiNorm.lean.snapshot',
    D/'run-probe.py',M/'dependency-packet.json',M/'environment-extension.json',
    M/'additional-supplement.json',M/'receipt.json',M/'manifest.json',M/'packet-verification.json']]
dedup = {}
for item in environment:
    assert sha(R/item['path'])==item['sha256']
    assert item['path'] not in dedup or dedup[item['path']]==item['sha256']
    dedup[item['path']]=item['sha256']
environment = [{'path':p,'sha256':h} for p,h in sorted(dedup.items())]

new_span = {'label':'Actual finite Pi norm, target-space completeness and real conversion',
    'source_path':output.relative_to(R).as_posix(),'source_sha256':sha(output),
    'start_byte':0,'end_byte_exclusive':len(raw),'span_sha256':sha(output),
    'exact_text':text,'first_line':1,'last_line':raw.count(b'\n')}
packet = {'format':'proof-free-lean-environment-evidence-1',
    'scope':'Generic operator evidence only: the unchanged frozen measure/operator packet plus exact native finite Pi norm, target-space instance/completeness, and ENNReal conversion output.',
    'runtime':{'reused_operator_packet':original['packet'],
        'reused_operator_environment':original['environment_config'],
        'reused_operator_receipt':ref(M/'native-02/receipt.json'),
        'new_native_receipt':ref(receipt_path),'new_probe':ref(D/'PiNorm.lean'),
        'new_probe_source_import':'ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeLocalFluxUpdate',
        'native_lake':receipt['native_lake']},
    'native_output_spans':base['native_output_spans']+[new_span],
    'probe_commands':base['probe_commands']+commands,
    'omissions':['No target proof bodies, live judge outputs, source interpretations, faithfulness conclusions or requested classifications are included.',
        'The existing measure/operator packet and all its native spans are reused byte-for-byte; its probe was not rerun.',
        'This optional fallback is not installed in any active audit and does not imply that a final audit finding exists.',
        'Selected source/compiled owners are pinned; this is not a complete transitive import inventory.']}
write(D/'dependency-packet.json',packet)
write(D/'environment-extension.json',{'format':'pinned-audit-environment-extension-1',
    'environment_files':environment})
extension={'packet':ref(D/'dependency-packet.json'),'environment_config':ref(D/'environment-extension.json')}
loaded,loaded_raw,_=load(R,extension)
assert loaded==packet and loaded_raw==(D/'dependency-packet.json').read_bytes()
assert base_bytes==(M/'dependency-packet.json').read_bytes()
write(D/'additional-supplement.json',extension)

# Read only supplied dependency inputs, never any live role output.
audit = D.parent.parent/'audits/LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908'
inventory_path = audit/'faithfulness/inputs/dependency_inventory.json'
supplied_packet_path = audit/'dependency-environment-packet.json'
inventory = read(inventory_path)
names = {'Real.measureSpace','Pi.normedAddCommGroup','Pi.normedAddGroup',
         'ENNReal.toReal','MeasureTheory.integral','IntervalIntegrable'}
selected = [x for x in inventory['dependencies'] if x['name'] in names]
assert {x['name'] for x in selected}==names
supplied = read(supplied_packet_path)
for span in supplied['native_output_spans']:
    p=R/span['source_path']; b=p.read_bytes()
    assert sha(p)==span['source_sha256']
    piece=b[span['start_byte']:span['end_byte_exclusive']]
    assert piece.decode()==span['exact_text']
    assert hashlib.sha256(piece).hexdigest()==span['span_sha256']
write(D/'verification.json',{'schema':1,'status':'PASS_READINESS_PREPARATION_ONLY',
    'observed_at_utc':datetime.now(timezone.utc).isoformat(),
    'supplied_inventory':ref(inventory_path),'supplied_packet':ref(supplied_packet_path),
    'selected_supplied_dependencies':selected,'verified_supplied_native_spans':len(supplied['native_output_spans']),
    'additional_supplement':extension,'reused_operator_packet':original,
    'reused_native_exit':0,'new_native_exit':0,'new_axiom_reports':len(expected),
    'new_output_bytes':len(raw),'reused_spans':len(base['native_output_spans']),
    'pinned_environment_files':len(environment),'loader_source':ref(preparer),
    'long_path_io':ref(shim),'loader_function':'load_additional_supplement',
    'preparer_invoked':False,'roles_invoked':False,'active_audits_modified':False,
    'source_or_production_modified':False,'source_acceptance':False})
print(json.dumps({'additional_supplement':extension,'verification':ref(D/'verification.json'),
    'actual_native_exit':0,'new_axiom_reports':len(expected)},indent=2))
