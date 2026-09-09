from pathlib import Path
h=Path(__file__).resolve().parent
prior=h.parent/'dim-two-direction-joint-witness/run.py'
p=h/'run.py'
assert not p.exists()
s=prior.read_text(encoding='utf-8').replace('Current canonical imports, artifact-only two-direction fixture; requires replay after pending C-infinity repair.',
 'Artifact-only inputwise time-step admission. No smooth-order or source-acceptance claim. Exact current canonical dependency pins retained.')
p.write_text(s,encoding='utf-8')
