"""Freeze the actual user answer and add context without changing prior evidence."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
W = R.parent
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
def write(path, value):
    with path.open('xb') as stream:
        stream.write((json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode('utf-8'))

receipt_path = D / 'user-high-resolution-interpretation-20260908.json'
receipt = {
    'schema': 1,
    'kind': 'explicit user-adopted source interpretation',
    'recorded_at_utc': datetime.now(timezone.utc).isoformat(),
    'question_item_id': ['request_user_input_async', 'call_1OyqIuAHK4eJ8CPSAKCpAt08', 0],
    'question': 'Section 1.3 does not define “high-resolution.” Should I record an explicit convention requiring supplied one-dimensional methods to have order greater than one on smooth solutions and quantitative control of oscillations near discontinuities, then prove their coordinate-by-coordinate execution and error propagation? The source ambiguity would remain recorded.',
    'answer': 'Adopt this explicit convention',
    'source_sha256': 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
    'scope': 'Chapter 1 Section 1.3 high-resolution dimensional splitting, LEV-CH01-DIMENSIONAL-SPLITTING. This adds a method-quality convention to the separately recorded Q10 geometry convention.',
    'adopted_interpretation': [
        'Require supplied one-dimensional methods to have order greater than one on smooth solutions.',
        'Require quantitative control of oscillations near discontinuities.',
        'Prove their coordinate-by-coordinate execution and error propagation.'
    ],
    'preservation': [
        'Preserve the printed source wording and its ambiguity; this explicit convention is not attributed to Chapter 1 as a printed hypothesis.',
        'Keep Q10 geometry and the earlier equation (1.10) convention separately attributed with their original scopes.',
        'Keep prior incomplete and nonaccepted audits unchanged; perform a fresh independent audit of the repaired target.',
        'The answer does not prescribe a particular norm, limiter, CFL condition, total-variation inequality, numerical order above one, or existence theorem for all hyperbolic laws.',
        'Later source context in Section 6.3 may explain the terminology but does not silently replace or enlarge this literal answer.'
    ],
    'authority_limit': 'This records the actual user reply supplied in this task, not a host event, source-text correction, audit verdict, operator receipt, integration authorization, or permission for remote writes.'
}
old_path = D / 'dimensional-method-audit-preparation/source-context.json'
assert sha(old_path) == '22151add6890efe8addc5a4bf688de101feed2349655a5f9b86cfd65f83aa262'
old = json.loads(old_path.read_bytes())
extra_images = []
for page, digest in [(125, 'e016faa12271d7cc32dc539e009780e17909f4d189d0a90946d6d8dba5174e2d'),
                     (126, '1ddb7257c00420b8915ab264453ab84a8f5fd0d3e30c74524c1d39a80acaaad3')]:
    path = D / 'directional-complete-repair-review' / f'page-{page}.png'
    assert sha(path) == digest
    raw = path.read_bytes()
    assert raw.startswith(b'\x89PNG\r\n\x1a\n')
    transport = W / 'workflow-v5.0.1-local/chapter01-source-review' / f'page-{page}.png'
    if transport.exists():
        assert transport.read_bytes() == raw
    else:
        with transport.open('xb') as stream:
            stream.write(raw)
    extra_images.append({'page': page, **ref(path)})

write(receipt_path, receipt)
context = json.loads(json.dumps(old))
context['inherited_locations'].append({
    'location': 'raw PDF pages 125–126; printed pages 103–104',
    'anchor': 'Inherited terminology context only: Section 6.3 High-Resolution Methods describes combining second-order accuracy where possible with monotone behavior in regions where the solution is expected to be monotone, retaining the limitations near nonsmooth portions and the use of characteristic-wave limiting for systems. This is context for the Chapter 1 Section 1.3 claim, not a new Chapter 6 audited row.'
})
context['pages'].extend([125, 126])
context['images'].extend(extra_images)
context['interpretation_receipts'].append(ref(receipt_path))
context_path = D / 'directional-complete-repair-review/source-context-with-user-high-resolution.json'
write(context_path, context)
output = {
    'format': 'literal-user-convention-recording-1',
    'recorder': ref(Path(__file__).resolve()),
    'receipt': ref(receipt_path),
    'source_context': ref(context_path),
    'prior_context': ref(old_path),
    'prior_context_unchanged': True,
    'source_acceptance_claimed': False
}
write(D / 'directional-complete-repair-review/user-convention-recording-receipt.json', output)
print(json.dumps(output, sort_keys=True))
