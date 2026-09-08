from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime
import json
import re

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
target = HERE / 'final-receipt.json'
assert not target.exists(), 'append-only freeze'
digest = lambda p: sha256(p.read_bytes()).hexdigest()
record = lambda p: dict(path=str(p), sha256=digest(p), bytes=p.stat().st_size)
read = lambda p: json.loads(p.read_text(encoding='utf-8'))
receipt = read(HERE / 'native-01.receipt.json')
assert receipt['exit_code'] == 0 and receipt['source_unchanged'] and receipt['dependencies_unchanged']
source, output = Path(receipt['source']), Path(receipt['output'])
assert digest(source) == receipt['source_sha256_before'] == receipt['source_sha256_after']
assert digest(output) == receipt['output_sha256']
assert digest(HERE / 'run.py') == receipt['runner_sha256']
assert digest(HERE / 'Witness.lean.fragment') == receipt['fragment_sha256']
base = Path(receipt['frozen_base']['path'])
assert digest(base) == receipt['frozen_base']['sha256'] == 'dc65d2f7412a99594efbe8b0936ee59685d71e3fd8cd1ec3501cd73dd19a5ec7'
checks = '\n'.join(f'#check {name}\n#print axioms {name}' for name in receipt['new_declarations'] + receipt['reused_declaration_checks']).encode()
assert source.read_bytes() == base.read_bytes() + b'\n\n' + (HERE / 'Witness.lean.fragment').read_bytes() + b'\n\n' + checks + b'\n'
bindings = receipt['dependencies'] + read(HERE / 'reuse.json')['inputs']
for row in bindings:
    path = Path(row['path'])
    if not path.is_absolute():
        path = REPO / path
    assert digest(path) == row['sha256']
for search in read(HERE / 'reuse.json')['searches']:
    assert search['exit_code'] == 0
    assert digest(Path(search['output'])) == search['output_sha256']
body = output.read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx', body)
canonical = lambda s: re.sub(r'\.\{[^}]*\}', '', s.strip())
reports = []
for match in re.finditer(r"^'([^'\n]+)'\s+(?:depends on axioms:\s*\[([^]]*)\]|does not depend on any axioms)", body, re.M):
    deps = [canonical(x) for x in (match.group(2) or '').split(',') if x.strip()]
    assert set(deps) <= {'propext', 'Classical.choice', 'Quot.sound'}
    reports.append(dict(declaration=canonical(match.group(1)), axioms=deps))
assert len(reports) == 26
requests = re.findall(r'^#print axioms\s+(\S+)', source.read_text(encoding='utf-8'), re.M)
requests = [x if '.' in x else 'NumStability.ProspectiveSourceAlternatives.' + x for x in requests]
assert Counter(requests) == Counter(x['declaration'] for x in reports)
assert len(receipt['new_declarations']) == 10 and len(receipt['reused_declaration_checks']) == 5
extra = [
    SESSION / 'prospective-density-material-riemann-capstones-draft/measure-final-02.native.txt',
    SESSION / 'prospective-density-material-riemann-capstones-draft/measure-final-02.receipt.json',
    SESSION / 'batch9-capstone-independent-review/verification.json',
]
known = ['dc5efb2006a71349d71f19cff59d6ca56b4cbeb456512e9f0b3d687790a54433',
         '45efe412834416a2e69a85806941b0d1f8571c170360be256ec934379b3209c5',
         'bda324b936a10019f2444c7831288649ca59ccbc7256978f69bc3936748f2d99']
for p, expected in zip(extra, known):
    assert digest(p) == expected
manifest = dict(kind='literal-fin-one-density-capstone-nonvacuity', frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                checked_source=record(source), fragment=record(HERE / 'Witness.lean.fragment'),
                actual_native_receipt=record(HERE / 'native-01.receipt.json'), actual_exit_code=0,
                native_output=record(output), exact_frozen_base=record(base),
                all_requested_axiom_reports_present=True, axiom_reports=reports,
                checked_new_declarations=receipt['new_declarations'], reused_declarations=receipt['reused_declaration_checks'],
                checked_new_declaration_count=10, new_definition_count=4, new_theorem_count=6,
                total_axiom_report_count=26, failed_native_attempts=[],
                bindings=bindings, measure_and_review_supplement=[record(p) for p in extra],
                artifacts=[record(p) for p in sorted(HERE.iterdir()) if p.is_file() and p != target],
                source_interpretation_adopted=False, source_faithfulness_judgment=None,
                all_assertions_passed=True,
                scope='New scratch folder only; old capstones/review, canonical, gate, audits, ledgers and Git unchanged.')
target.write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(receipt=str(target), sha256=digest(target), source_sha256=digest(source),
                      fragment_sha256=digest(HERE / 'Witness.lean.fragment'), review_sha256=digest(HERE / 'REVIEW.md'),
                      actual_native_exit=0, new_declarations=10, total_axiom_reports=26)))
