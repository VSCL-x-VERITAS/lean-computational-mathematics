"""Append verified progress; preserve audit failures and all earlier ledger bytes."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
joint = D / 'dim-joint-primary-witness/final-receipt.json'
assert sha(joint) == '6d124fa8951d855687e196897f40c01ebc4fc5939b84ec6cb326149366fdd63e'
assert read(joint)['actual_exit'] == 0 and read(joint)['declaration_count'] == 40
assert read(joint)['source_acceptance'] is False
retry = D / 'riemann-routine-roundtrip-retry/handoff-plan/execution-receipt.json'
r = read(retry)
assert r['exit_code'] == r['original_wrapper_exit_code'] == 1
assert r['canonical_collection_performed'] is True
assert [x['name'] for x in r['steps']] == ['collect-r2', 'continuation']
assert [x['exit_code'] for x in r['steps']] == [0, 1]
transport = D / 'adjudicator-transport-recovery-v4-retry-lineage/info-a2/plan.json'
assert sha(transport) == '077e83a37b2a5142d27ba3f6ddbc28aed332225a3549bcf6c9d689de4344ed7c'
t = read(transport)
assert t['mapping']['reconstruction_byte_equal'] is True
assert t['mapping']['compact_characters'] == 922598 < 1048576 < t['mapping']['original_characters'] == 1442873
tests = S / 'unblock-nine-publication-v3-guard-tests-exit.json'
assert read(tests)['exit_code'] == 0
assert read(tests)['output_sha256'] == sha(S / 'unblock-nine-publication-v3-guard-tests-output.txt')
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'dd147ada147f8db5869708f646d8cf2b77e092eaa85204306723f5d40d50ca79'
assert sha(process) == 'c040ae3dac41f283a7c230e1112354d4116d8933b7337c95430d9661df85a9f5'
entries = {
    book: [
        '| LEV-C1-HIGH-RESOLUTION-JOINT-WITNESS-106 | LEV-CH01-DIMENSIONAL-SPLITTING | explicit high-resolution interpretation and applicability | Separate family and geometry inhabitants do not establish joint applicability, and a refinement threshold chosen after a fixed level does not establish uniform accuracy | Add a uniform all-refinement perturbed accuracy conclusion and apply the entire corrected primary to the same actual four-cell Cartesian geometry, supplied full-quality CFL1 method and nonconstant moving initial array | Native joint application passed; source audit and production verification remain pending | ' + loc(joint) + '; ' + loc(D / 'directional-reference-repair/complete-core-receipt.json') + ' | The literal user convention remains separate from printed source evidence. The zero physical reference and nonconstant numerical array are one concrete applicability witness; they do not establish arbitrary-law method existence or higher temporal order of a composed sweep. |'
    ],
    process: [
        '| LEV-SKILL-MALFORMED-ROUNDTRIP-RETRY-088 | codex-start-1-v5-0-1-20260908 | Info Routine sealed audit output validation | Original native roundtrip output omitted one hexadecimal character from the source hash and failed the released schema and source-pin checks | Preserve the invalid output and original failed wrapper; retry unchanged roundtrip input in a fresh stateless session, then collect the valid retry and continue unchanged orchestration | Fresh roundtrip collection exited zero; continuation reached required adjudication but its unstarted native input exceeded the character limit | ' + loc(retry) + '; ' + loc(transport) + ' | The separate original schema failure and later input-capacity failure remain distinct. Reviewed V4 preserves five actual runtime entries and reconstructs the 1442873-character prompt from 922598 characters using only exact duplicate spans and JSON formatting whitespace. A launched retry is not an accepted source decision. |',
        '| LEV-SKILL-PUBLICATION-ARCHIVE-SUCCESSOR-089 | codex-start-1-v5-0-1-20260908 | final publication allowlist archive cardinality | Two hard-coded prior archives cannot cover the newly exported Routine expression stream and forthcoming DIM stream | Derive V3 allowing two or more uniquely pinned exact gzip archives while retaining byte reconstruction, raw-file exclusion, size, ownership, staged-byte and concurrency guards | Eleven actual POSIX guard tests passed; final operational policy and staged snapshot remain pending | ' + loc(tests) + '; ' + loc(D / 'publication-preparation/checker-v3-derivation.json') + ' | This changes the number of independently verified archives only. It does not authorize broad session staging or raw oversized artifacts. |'
    ]
}
receipt = {'schema': 1, 'recorder': loc(Path(__file__)), 'source_acceptance': False, 'ledgers': []}
for path, additions in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and all(row.split('|')[1].strip().encode() not in raw for row in additions)
    before = sha(path)
    with path.open('ab') as stream:
        stream.write(('\n'.join(additions) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    receipt['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before,
                              'after_sha256': sha(path), 'entries_appended': len(additions)})
with (D / 'joint-method-and-audit-retry-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
