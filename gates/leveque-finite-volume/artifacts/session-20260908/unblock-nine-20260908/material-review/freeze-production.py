"""Verify completed native captures and freeze the three new source leaves."""
from pathlib import Path
import datetime
import hashlib
import json
import re

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p/'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
stems = ['SourceTermsRectangleBalance', 'MaterialInterfaceLocalRiemannData', 'MaterialCellVolumeAveraging']
names = ['leveque01_sourceTermsRectangleBalance', 'leveque01_materialInterfaceLocalRiemannData',
         'leveque01_materialCellVolumeAveraging']
expected_hashes = ['abe9b14705618401012fe913719eaee6e8c2d09b9db3cbd2ded4ad1b1101e1ac',
                   'af6663917b1d2008418502e2ffcc9e2c138665acea35067fd9b97cc6187c5f66',
                   '59939905a34b7b4188d3f16eec7f956c163d0e158ce46e1f5ee4ef7efb52c75a']
files = []
for stem, name, expected in zip(stems, names, expected_hashes):
    p = R/('ComputationalMathematics/Source/LeVeque/Chapter01/'+stem+'.lean')
    assert sha(p) == expected and b'\r' not in p.read_bytes()
    source = p.read_text(encoding='utf-8')
    declarations = re.findall(r'^theorem\s+(\w+)', source, re.M)
    assert declarations == [name]
    assert not re.search(r'\b(sorry|admit|axiom|unsafe)\b', source)
    files.append({'path':p.relative_to(R).as_posix(), 'module':p.relative_to(R).with_suffix('').as_posix().replace('/','.'),
                  'sha256':sha(p), 'lines':len(source.splitlines()), 'declarations':['NumStability.'+name],
                  'imports':re.findall(r'^import\s+(\S+)',source,re.M)})

runs = []
for label in ['build-01','source-01','source-02','source-03','checks-01','checks-final']:
    p = D/label/'receipt.json'
    record = json.loads(p.read_text(encoding='utf-8'))
    assert record['exit_code']==0 and record['inputs_unchanged']
    assert sha(Path(record['output']))==record['output_sha256']
    for binding in record['inputs']:
        assert binding['sha256_before']==binding['sha256_after']==binding['snapshot_sha256']
        assert sha(Path(binding['snapshot']))==binding['snapshot_sha256']
        if label == 'checks-final':
            assert sha(Path(binding['path'])) == binding['sha256_after']
    assert record['runner_sha256'] == sha(D/'run-native.py')
    runs.append({'label':label,'receipt':str(p),'receipt_sha256':sha(p),
                 'actual_exit':record['exit_code'],'output':record['output'],
                 'output_sha256':record['output_sha256'],'elapsed_seconds':record['elapsed_seconds']})

output = (D/'checks-final/output.txt').read_text(encoding='utf-8')
assert not re.search(r'(?:error:|warning:|\bsorryAx\b)',output)
reports = {}
for name, body in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",output,re.S):
    assert name not in reports
    reports[name] = [x.strip() for x in body.split(',') if x.strip()]
for name in re.findall(r"'([^']+)' does not depend on any axioms",output):
    assert name not in reports
    reports[name] = []
assert len(reports)==22, len(reports)
assert all(set(xs)<={'propext','Classical.choice','Quot.sound'} for xs in reports.values())
for name in names:
    assert 'NumStability.'+name in reports
assert 'NumStability.MaterialUnblockingChecks.source_capstone_instance' in reports
assert 'NumStability.MaterialUnblockingChecks.equal_average_applicability' in reports

# Native output contains theorem types, axioms and explicitly requested definition bodies only.
proof_free = D/'contracts.proof-free.txt'
with proof_free.open('xb') as target:
    target.write((D/'checks-final/output.txt').read_bytes())

# Observe the exact local canonical import closure used by these source leaves and checks.
closure = {}
pending = [R/f['path'] for f in files] + [D/'Checks.lean']
while pending:
    p=pending.pop()
    if str(p) in closure:
        continue
    text=p.read_text(encoding='utf-8')
    entry={'path':str(p),'source_sha256':sha(p)}
    if p.is_relative_to(R/'ComputationalMathematics'):
        compiled=R/'.lake/build/lib/lean'/p.relative_to(R).with_suffix('.olean')
        assert compiled.is_file()
        entry.update(compiled_path=str(compiled),compiled_sha256=sha(compiled))
    closure[str(p)]=entry
    for module in re.findall(r'^(?:public\s+)?import\s+(ComputationalMathematics\.[\w.]+)',text,re.M):
        pending.append(R/(module.replace('.','/')+'.lean'))

prior_review=json.loads((D/'review.json').read_text(encoding='utf-8'))
for entry in prior_review['current_inputs']:
    assert sha(R/entry['path'])==entry['sha256']
selection=D.parent/'selected-interpretations.json'
assert sha(selection)=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
artifacts=[{'path':str(p),'sha256':sha(p),'bytes':p.stat().st_size}
           for p in sorted(D.rglob('*')) if p.is_file() and '__pycache__' not in p.parts]
manifest={'schema':1,'kind':'three-interpreted-source-capstones-production-freeze',
          'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'files':files,
          'public_declaration_count':3,'source_lines':sum(f['lines'] for f in files),
          'actual_native_runs':runs,'axiom_report_count':len(reports),'axiom_reports':reports,
          'new_failure_count':0,'historical_checks_version':'checks-01 remains unchanged; checks-final qualifies witness names and prints their types.',
          'proof_free_native_output':{'path':str(proof_free),'sha256':sha(proof_free)},
          'canonical_dependencies_observed_after_checks':list(closure.values()),
          'reviewed_preexisting_inputs_unchanged':True,
          'selected_interpretations':{'path':str(selection),'sha256':sha(selection)},
          'authority':'Coordinator-selected conventions under the user objective to unblock all nine; not literal detailed user answers.',
          'source_sha256':'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
          'artifacts':artifacts,'git_mutations':False,'source_acceptance':False,
          'outstanding_root_work':['Fresh interpreted statement audits','Aggregate and tier exposure','Organization and full-library validation','Gate and checkpoint disposition']}
p=D/'production-manifest.json'
with p.open('x',encoding='utf-8',newline='\n') as target:
    target.write(json.dumps(manifest,indent=2)+'\n')
receipt={'schema':1,'status':'PASS','scope':'Native production validation and evidence binding only',
         'manifest':str(p),'manifest_sha256':sha(p),'files':files,'actual_final_exit':0,
         'axiom_report_count':len(reports),'source_acceptance':False}
p=D/'production-receipt.json'
with p.open('x',encoding='utf-8',newline='\n') as target:
    target.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'receipt':str(p),'receipt_sha256':sha(p),
                  'manifest_sha256':sha(D/'production-manifest.json'),'files':files,
                  'axiom_reports':len(reports),'dependency_observations':len(closure)},indent=2))
