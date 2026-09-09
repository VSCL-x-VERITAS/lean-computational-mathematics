"""Append actual findings and the literal new convention; preserve prior entries."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
loc = lambda p: p.relative_to(R).as_posix() + ' SHA256 ' + sha(p)
decision_path = S / 'audits/LEV-CH01-FV-LOCAL-FLUX-UPDATE-OPERATOR-QUALIFIED-20260908/faithfulness/decision.json'
assert sha(decision_path) == '2fa401b7a73b382e108d45903600185c6631ba522ab809b523c8d7a20f7f2ad8'
decision = read(decision_path)
assert decision['classification'] == 'undetermined' and not decision['accepted']
literal_path = D / 'user-high-resolution-interpretation-20260908.json'
assert sha(literal_path) == '5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'
assert read(literal_path)['answer'] == 'Adopt this explicit convention'
context_path = D / 'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json'
assert sha(context_path) == '71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d'
helper_path = D / 'gate-helpers/high-resolution-context-helper-final-receipt.json'
assert sha(helper_path) == '9b6531b990995d7e38fa72957ba2cf3b59f112d8f52fdc2c1a548829411bd135'
assert read(helper_path)['actual_final_exit'] == 0 and read(helper_path)['final_tests'] == 43
norm_path = D / 'fv-norm-complete-evidence/receipt.json'
assert sha(norm_path) == '25b8d51b52384c2ab0e92ff56245daeeb37cda9137918322a153b3119721440a'
assert read(norm_path)['native_actual_exit'] == 0
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'bc20b47ae4273838558d5d11e4290b0be7e61dca1bf4bbeca241a8e5b3fcdf86'
assert sha(process) == '382f940395a8d6be8bfd61c8efbe7117d5267b8ec42601e83c5a00dc19467a40'
entries = {
    book: [
        '| LEV-C1-FV-NORM-IDENTIFICATION-102 | LEV-CH01-FINITE-VOLUME-FLUX-UPDATE | product norm instance identification | The completed operator audit resolves integral and measure normalization but cannot identify the additive-group norm with the normed-ring norm from its supplied proof-free evidence | Supply exact native instance projections, finite-vector norm and extended-norm bridges without changing the target | IN_PROGRESS; fresh norm-complete audit required | ' + loc(decision_path) + '; ' + loc(norm_path) + ' | Native evidence passes; it is not a replacement for independent semantic acceptance. |',
        '| LEV-C1-HIGH-RESOLUTION-CONVENTION-103 | LEV-CH01-DIMENSIONAL-SPLITTING | Chapter 1 method-quality scope | The user explicitly adopted order greater than one on smooth solutions, quantitative oscillation control near discontinuities, and coordinate execution/error propagation | Preserve the literal answer separately from coordinator Q10 geometry and equation (1.10); include later Section 6.3 terminology as inherited source context | IN_PROGRESS; complete target and fresh audit required | ' + loc(literal_path) + '; ' + loc(context_path) + ' | The source ambiguity remains; this supplies no printed norm, limiter, universal TVD requirement or all-law existence theorem. |'
    ],
    process: [
        '| LEV-SKILL-EXACT-AUDIT-ID-083 | codex-start-1-v5-0-1-20260908 | redundant role-orchestrator suffix guard | A reviewed exact task ID ended in QUALIFIED although the generic suffix guard admitted only PRODUCTION or CANONICAL | Preserve the generated orchestrator and replace only its redundant generic suffix assertion with the same exact task assertion in an additive transport | Actual operator audit wrapper exited zero; semantic result remains undetermined | ' + loc(D / 'fv-operator-id-transport/derivation.json') + ' | No source, role protocol, verdict or original transport bytes changed. New successors use the existing PRODUCTION suffix. |',
        '| LEV-SKILL-LITERAL-Q10-CONTEXT-084 | codex-start-1-v5-0-1-20260908 | separately scoped literal user evidence | The old projection helper recognized only the exact equation (1.10) receipt | Add exact two-receipt validation solely for the pinned dimensional-splitting context, retain native and sealed-complete requirements, and preserve old behavior | Forty-three guard regressions passed; no operational row validation or mutation | ' + loc(helper_path) + ' | The first fixture named the wrong function and was corrected with its failed output retained. The context title was corrected additively to Section 6.3 Preview of Limiters after visual review. |'
    ]
}
result = {'schema': 1, 'recorder': loc(Path(__file__).resolve()), 'source_acceptance': False, 'ledgers': []}
for path, additions in entries.items():
    raw = path.read_bytes()
    assert raw.endswith(b'\n') and all(row.split('|')[1].strip().encode() not in raw for row in additions)
    before = sha(path)
    with path.open('ab') as stream:
        stream.write(('\n'.join(additions) + '\n').encode())
    assert path.read_bytes().startswith(raw)
    result['ledgers'].append({'path': path.relative_to(R).as_posix(), 'before_sha256': before,
                              'after_sha256': sha(path), 'entries_appended': len(additions)})
with (D / 'norm-gap-and-high-resolution-ledger-receipt.json').open('xb') as stream:
    stream.write((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps(result))
