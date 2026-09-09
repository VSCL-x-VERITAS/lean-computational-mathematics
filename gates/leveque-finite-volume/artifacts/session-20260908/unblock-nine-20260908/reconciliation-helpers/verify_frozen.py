"""Read-only packet verification; emits a new receipt in this directory only."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent;R=P.parents[5]
def read(p):return json.loads(p.read_bytes())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def resolved(v):
    p=Path(v['path']);return p if p.is_absolute() else R/p
receipt=read(P/'final-receipt.json');manifest=read(P/'manifest.json');count=0
for pin in [receipt['manifest'],receipt['ready_invocations'],*receipt['helper_files'],*manifest['files'],*manifest['old_helpers']]:
    assert sha(resolved(pin))==pin['sha256'],pin;count+=1
for label in ('fixtures-02','actual-refs-01','actual-inventories-01'):
    record=read(P/(label+'-receipt.json'))
    assert record['exit_code']==0 and sha(P/(label+'-output.txt'))==record['output_sha256']
    script={'fixtures-02':'test_helpers.py','actual-refs-01':'probe_real.py','actual-inventories-01':'validate_real_inventories.py'}[label]
    assert sha(P/script)==record['script_sha256']
    count+=2
assert receipt['actual_fixture_cases']==18 and receipt['actual_changed_blobs_per_lane']==[8955,8955]
assert receipt['old_helpers_unchanged'] and not receipt['runtime_or_ref_mutations']
assert not receipt['candidate_created'] and not receipt['epoch_validated']
out={'status':'PASS','binding_occurrences':count,'final_receipt_sha256':sha(P/'final-receipt.json'),
     'manifest_sha256':sha(P/'manifest.json'),'ready_invocations_sha256':sha(P/'ready-invocations.json'),
     'review_sha256':sha(P/'REVIEW.md'),'verification_script_sha256':sha(Path(__file__)),
     'actual_fixtures':18,'actual_changed_blobs_per_lane':[8955,8955],
     'no_candidate_epoch_admission_or_operational_mutation':True}
path=P/'verification.json';assert not path.exists()
path.write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(out))
