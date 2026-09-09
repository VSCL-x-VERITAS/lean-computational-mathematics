"""Add immutable inherited hyperbolicity context for a future DIM successor."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
prior = D / 'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json'
assert sha(prior) == '71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d'
context = json.loads(prior.read_bytes())
source = R / context['source']['path']
assert sha(source) == context['source']['sha256']
origin = S / 'audits/LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908/faithfulness/orchestration/page-025.png'
assert origin.is_file()
out = D / 'dim-inherited-hyperbolicity-context'
out.mkdir()
image = out / 'page-025.png'
with image.open('xb') as stream:
    stream.write(origin.read_bytes())
context['inherited_locations'].insert(0, {
    'location': 'raw PDF page 25; printed Chapter 1 page 3',
    'anchor': 'Inherited definition of hyperbolicity: the opening paragraph specifies real eigenvalues and a complete independent eigenvector set for the coefficient matrix; Section 1.1 equations (1.8)–(1.9) then uses the flux Jacobian and the same matrix conditions for nonlinear conservation laws. This supplies the earlier definition referenced by the selected Chapter 1 numerical-method passage; it is not a new source row or a new interpretation.'
})
context['pages'].insert(0, 25)
context['images'].insert(0, {'page': 25, **ref(image)})
assert context['pages'] == [25, 26, 27, 28, 125, 126]
assert context['primary_locations'] == json.loads(prior.read_bytes())['primary_locations']
assert context['interpretation_receipts'] == json.loads(prior.read_bytes())['interpretation_receipts']
for item in context['images']:
    assert sha(R / item['path']) == item['sha256']
path = out / 'source-context-v3.json'
with path.open('xb') as stream:
    stream.write((json.dumps(context, indent=2, ensure_ascii=False) + '\n').encode())
receipt = {'format': 'inherited-source-context-addition-1', 'prior': ref(prior),
    'new_context': ref(path), 'source_image_origin': ref(origin), 'new_image': ref(image),
    'source_pdf': ref(source), 'recorder': ref(Path(__file__)),
    'root_visual_review': 'Root inspected raw PDF page 25 rendering: the upper paragraph gives the real-eigenvalue/full-independent-eigenvector condition; the final paragraph following (1.9) applies it to the flux Jacobian.',
    'primary_selection_unchanged': True, 'interpretation_receipts_unchanged': True,
    'current_audits_modified': False, 'source_acceptance': False,
    'scope': 'Prepared inherited source context for a future DIM successor. No model role was launched and no current task input or source-row status changed.'}
with (out / 'receipt.json').open('xb') as stream:
    stream.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
