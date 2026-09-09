"""Keep successful proof receipts and the separately corrected import diagnostic distinct."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent
records=[]
def derive(before_name,after_name,edits):
 old=(P/before_name).read_bytes();text=old.decode()
 for before,after in edits:
  assert text.count(before)==1,(before_name,before,text.count(before))
  text=text.replace(before,after)
 compile(text,after_name,'exec')
 with (P/after_name).open('xb') as f:f.write(text.encode())
 records.append({'before':before_name,'before_sha256':hashlib.sha256(old).hexdigest(),
                 'after':after_name,'after_sha256':hashlib.sha256(text.encode()).hexdigest(),'edits':edits})
derive('verify_replay.py','verify_replay_v2.py',[
 ("P/'completion-v3.json'","P/'completion-v4.json'"),
 ("if not entry.is_dir():continue","if not entry.is_dir():continue\n if entry.name in {'lake-launch','ImportClosureProbe'}:\n  assert load(entry/'receipt.json')['exit_code']==1\n  continue"),
 ("for item in plan['all_read_inputs']:bind(item)","for entry in sorted((P/'runs04').iterdir()):\n receipt=load(entry/'receipt.json');assert receipt['exit_code']==0\n bind(receipt['stdout']);bind(receipt['stderr'])\n assert raw(R/receipt['stderr']['path'])==b''\n receipts.append({'label':entry.name,'receipt':ref(entry/'receipt.json')})\nfor item in plan['all_read_inputs']:bind(item)"),
 ("P/'dependency-resolutions-v3.json'","P/'dependency-resolutions-v4.json'"),
 ("put('verification.json',summary)","put('verification-v2.json',summary)")
])
derive('freeze_replay.py','freeze_replay_v2.py',[
 ("P/'verification.json'","P/'verification-v2.json'"),
 ("P/'verification-exit.json'","P/'verification-exit-v2.json'"),
 ("P/'runs03/lake-launch/receipt.json'","P/'runs04/lake-launch04/receipt.json'"),
 ("Two preserved attempts explain", "Three preserved diagnostic boundaries explain"),
 ("Every native `--deps` result", "- After all module and proof replays passed, the auxiliary import-closure probe failed on an unqualified `liftIO` identifier. A new probe changes only that diagnostic identifier to `Lean.Elab.Command.liftIO` and exits 0 under the same lake environment and unchanged lib03 outputs. The runs03 parent exit 1 and failed diagnostic are retained; the successful final diagnostic/parent receipts are in runs04.\n\nEvery native `--deps` result"),
 ("'verification':ref(P/'verification.json')", "'verification':ref(P/'verification-v2.json')"),
 ("'actual_verification_command':ref(P/'verification-exit.json')", "'actual_verification_command':ref(P/'verification-exit-v2.json')"),
 ("'actual_lake_child_receipt':ref(P/'runs03/lake-launch/receipt.json')", "'actual_lake_child_receipt':ref(P/'runs04/lake-launch04/receipt.json')")
])
with (P/'final-verifier-v2-derivation.json').open('xb') as f:f.write((json.dumps(records,indent=2)+'\n').encode())
print(json.dumps([{'file':x['after'],'sha256':x['after_sha256']} for x in records]))
