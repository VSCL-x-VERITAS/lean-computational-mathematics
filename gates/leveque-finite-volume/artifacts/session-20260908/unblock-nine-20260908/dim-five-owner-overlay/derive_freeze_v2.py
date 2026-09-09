"""Complete the freeze-script derivation after preserving its exact-count guard failure."""
import hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent
old=(P/'freeze_replay.py').read_bytes();text=old.decode()
edits=[
 ("P/'verification.json'","P/'verification-v2.json'",2),
 ("P/'verification-exit.json'","P/'verification-exit-v2.json'",2),
 ("P/'runs03/lake-launch/receipt.json'","P/'runs04/lake-launch04/receipt.json'",2),
 ("Two preserved attempts explain","Three preserved diagnostic boundaries explain",1),
 ("Every native `--deps` result","- After all module and proof replays passed, the auxiliary import-closure probe failed on an unqualified `liftIO` identifier. A new probe changes only that diagnostic identifier to `Lean.Elab.Command.liftIO` and exits 0 under the same lake environment and unchanged lib03 outputs. The runs03 parent exit 1 and failed diagnostic are retained; the successful final diagnostic/parent receipts are in runs04.\n\nEvery native `--deps` result",1)
]
for before,after,count in edits:
 assert text.count(before)==count,(before,text.count(before),count)
 text=text.replace(before,after)
compile(text,'freeze_replay_v2.py','exec')
with (P/'freeze_replay_v2.py').open('xb') as stream:stream.write(text.encode())
with (P/'final-verifier-v2-derivation.json').open('xb') as stream:stream.write((json.dumps({
 'verification_v2_sha256':hashlib.sha256((P/'verify_replay_v2.py').read_bytes()).hexdigest(),
 'freeze_before_sha256':hashlib.sha256(old).hexdigest(),'freeze_after_sha256':hashlib.sha256(text.encode()).hexdigest(),
 'edits':edits,'prior_derivation_failure':{'actual_observed_exit':1,'tool_chunk_id':'19a428',
 'failure':"AssertionError: ('freeze_replay.py', \"P/'verification.json'\", 2)",
 'stage':'verify_replay_v2.py had been written; freeze_replay_v2.py and final derivation JSON had not been written',
 'resolution':'This new helper requires the actual two occurrences for the three repeated path strings.'}},indent=2)+'\n').encode())
print(hashlib.sha256(text.encode()).hexdigest())
