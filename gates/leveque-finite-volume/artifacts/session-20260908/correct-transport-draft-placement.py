"""Avoid creating a new directory beneath an existing declaration owner."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
D = S / 'equation03-transport'
manifest_path = D / 'canonical-drafts-manifest.json'
before = manifest_path.read_bytes()
(D / ('draft-manifest-before-placement-' + hashlib.sha256(before).hexdigest() + '.json')).write_bytes(before)
manifest = json.loads(before)
old = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection.Transport'
new = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics'
assert manifest['files'][0]['path'] == old.replace('.', '/') + '.lean'
manifest['files'][0]['path'] = new.replace('.', '/') + '.lean'
source = S / manifest['files'][2]['draft']
original = source.read_bytes()
(D / ('source-draft-before-placement-' + hashlib.sha256(original).hexdigest() + '.lean')).write_bytes(original)
assert old.encode() in original
source.write_bytes(original.replace(old.encode(), new.encode()))
manifest['files'][2]['sha256'] = hashlib.sha256(source.read_bytes()).hexdigest()
manifest['placement_review'] = 'Transport/Characteristics avoids a directory colliding with the existing LinearAdvection.lean declaration owner. No production bytes changed.'
manifest_path.write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8')
print(json.dumps({'new_path': manifest['files'][0]['path'], 'source_sha256': manifest['files'][2]['sha256']}))
