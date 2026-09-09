"""Append the user's explicit unresolved choice to the book/source ledger."""
from pathlib import Path
import hashlib
import json
import os

assert os.name == 'posix'
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lakefile.toml').is_file())
sha = lambda data: hashlib.sha256(data).hexdigest()
response_path = P / 'riemann-interpretation-user-response.json'
response_raw = response_path.read_bytes()
response = json.loads(response_raw)
assert response['answer'] == 'Keep the interpretation unresolved'
assert response['interpretation_adopted'] is False
ledger = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before = ledger.read_bytes()
assert sha(before) == '02ec03dff2d1e45d99e2d9c5fb377be883dfdb80bc51b4d2f491f8655db71943'
issue = 'LEV-C1-CERTIFIED-ROUTINE-INTERPRETATION-UNRESOLVED-115'
assert before.endswith(b'\n') and issue.encode() not in before
entry = ('| '+issue+' | LEV-CH01-RIEMANN-INTERFACE-FLUX | User-kept representative/certificate ambiguity | '
         'The printed source leaves the reference representative and solver certificate convention implicit | '
         'The compiled rectangle-reference/actual-endpoint-flux/numerical-error convention was offered explicitly; '
         'the user answered Keep the interpretation unresolved | UNRESOLVED by explicit user choice; no convention adopted and no source acceptance | '
         +response_path.relative_to(R).as_posix()+' SHA256 '+sha(response_raw)+'; prior unaccepted decision 0ac08662a5a89231c70add2f6706e855f86704a7d57206cff558d8f2addd0308 | '
         'Retain the ambiguity and all earlier audit outcomes. Existing native proofs do not close the source obligation; independent dimensional-splitting work continues. |\n')
with ledger.open('ab') as stream:
    stream.write(entry.encode())
after = ledger.read_bytes()
assert after == before + entry.encode()
record = {'kind':'book-source-choice-ledger-append', 'issue':issue,
          'before_sha256':sha(before), 'after_sha256':sha(after),
          'ledger':ledger.relative_to(R).as_posix(), 'gate_mutated':False,
          'interpretation_adopted':False, 'source_acceptance':False}
with (P / 'book-choice-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record,indent=2))
