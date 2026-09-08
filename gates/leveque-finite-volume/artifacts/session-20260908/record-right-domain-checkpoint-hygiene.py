"""Preserve raw evidence whitespace and check production/metadata independently."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent
R=S.parents[3]
records=[]
for label,args in [
    ('all',['diff','--cached','--check']),
    ('production',['diff','--cached','--check','--','.',':(exclude)gates/leveque-finite-volume/artifacts/session-20260908/**'])]:
    cmd=['git','-c','core.longpaths=true',*args]
    run=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    p=S/('right-domain-checkpoint-hygiene-'+label+'-output.txt')
    assert not p.exists();p.write_bytes(run.stdout)
    records.append({'command':cmd,'exit_code':run.returncode,'output':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(run.stdout).hexdigest()})
    if label=='production': assert run.returncode==0,run.stdout.decode('utf-8',errors='replace')
    else:
        assert run.returncode in [0,1,2]
        for line in run.stdout.decode('utf-8').splitlines():
            if ': trailing whitespace.' in line or ': new blank line at EOF.' in line or ': space before tab in indent.' in line:
                assert line.startswith('gates/leveque-finite-volume/artifacts/session-20260908/'),line
record={'schema':1,'checks':records,
    'raw_evidence_findings':'Retained exact CRLF/log/snapshot/script bytes already hash-bound in audit and producer receipts; no frozen artifact is normalized for Git whitespace cosmetics.',
    'production_and_metadata':'Actual scoped git diff --cached --check passed for all production, tiers, gate and ledgers.'}
receipt=S/'right-domain-checkpoint-hygiene.json';assert not receipt.exists()
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
paths=[Path(__file__).resolve(),receipt,*[R/e['output'] for e in records]]
for p in paths:
    rel=p.relative_to(R).as_posix()
    subprocess.run(['git','-c','core.longpaths=true','add','--',rel],cwd=R,check=True)
    assert subprocess.check_output(['git','-c','core.longpaths=true','show',':'+rel],cwd=R)==p.read_bytes()
print(json.dumps({'production_exit':records[1]['exit_code'],'all_evidence_exit':records[0]['exit_code'],'receipt_sha256':hashlib.sha256(receipt.read_bytes()).hexdigest(),'staged_exact_files':len(paths)}))
