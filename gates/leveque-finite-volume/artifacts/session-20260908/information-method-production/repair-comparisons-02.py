"""Preserve the failed comparison source, then expose both dependent extractors."""
from pathlib import Path
from hashlib import sha256
import json

here = Path(__file__).resolve().parent
source = here / 'Comparisons.lean.fragment'
snapshot = here / 'comparisons-01.fragment'
assert not snapshot.exists()
before = source.read_bytes()
snapshot.write_bytes(before)
text = before.decode('utf-8')
for direction in ['fromDraft', 'toDraft']:
    old = f'({direction} method).extract = method.extract'
    left = 'RiemannInformationFluxMethod' if direction == 'fromDraft' else 'InformationOnlyRiemannDraft.Method'
    right = 'InformationOnlyRiemannDraft.Method' if direction == 'fromDraft' else 'RiemannInformationFluxMethod'
    new = f'@{left}.extract _ _ _ _ ({direction} method) =\n      @{right}.extract _ _ _ _ method'
    assert text.count(old) == 1
    text = text.replace(old, new)
source.write_text(text, encoding='utf-8', newline='\n')
receipt = dict(reason='Two scratch six-field comparisons left the extractor problem index implicit; compare complete dependent extractor functions explicitly.',
               original=dict(path=str(snapshot), sha256=sha256(before).hexdigest()),
               revised=dict(path=str(source), sha256=sha256(source.read_bytes()).hexdigest()),
               production_changed=False)
(here / 'comparison-repair-02.json').write_text(json.dumps(receipt, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(receipt))
