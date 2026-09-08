from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime
import json
import re
import subprocess

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
assert not (HERE / 'final-receipt.json').exists(), 'append-only freeze'
digest = lambda p: sha256(p.read_bytes()).hexdigest()
record = lambda p: dict(path=str(p), sha256=digest(p), bytes=p.stat().st_size)
read = lambda p: json.loads(p.read_text(encoding='utf-8'))
final = read(HERE / 'native-02.receipt.json')
first = read(HERE / 'native-01.receipt.json')
assert final['exit_code'] == 0 and first['exit_code'] == 1
assert final['source_unchanged'] and final['dependencies_unchanged']
for rec in (first, final):
    assert digest(Path(rec['source'])) == rec['source_sha256_before'] == rec['source_sha256_after']
    assert digest(Path(rec['output'])) == rec['output_sha256']
for row in final['inputs']:
    assert digest(Path(row['path'])) == row['sha256']
for row in final['canonical_import_closure'].values():
    for key in ('source', 'compiled'):
        assert digest(Path(row[key]['path'])) == row[key]['sha256']
reuse = read(HERE / 'reuse.json')
for row in reuse['inputs']:
    assert digest(Path(row['path'])) == row['sha256']
for row in reuse['searches']:
    assert row['exit_code'] in (0, 1)
    assert digest(Path(row['output'])) == row['sha256']
body = Path(final['output']).read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx', body)
reports = []
canonical = lambda name: re.sub(r'\.\{[^}]*\}', '', name.strip())
for match in re.finditer(r"^'([^'\n]+)'\s+(?:depends on axioms:\s*\[([^]]*)\]|does not depend on any axioms)", body, re.M):
    deps = [canonical(x) for x in (match.group(2) or '').split(',') if x.strip()]
    assert set(deps) <= {'propext', 'Classical.choice', 'Quot.sound'}
    reports.append(dict(declaration=canonical(match.group(1)), axioms=deps))
expected = final['new_declarations'] + final['reused_declaration_checks']
assert len(final['new_declarations']) == 24 and len(reports) == 29
assert Counter(expected) == Counter(row['declaration'] for row in reports)
assert Counter(re.findall(r'^#print axioms\s+(\S+)', Path(final['source']).read_text(encoding='utf-8'), re.M)) == Counter(expected)
assert first['new_declarations'] == final['new_declarations']
prefix = ('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxError\n'
          'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField\n\n').encode()
core, accuracy, examples = [HERE / f'{name}.lean.fragment' for name in ('Core', 'Accuracy', 'Examples')]
check_start = b'\n\n#check NumStability.InformationOnlyRiemannDraft.Method\n'
assembled_body, tail = Path(final['source']).read_bytes().split(check_start, 1)
assert assembled_body == prefix + b'\n\n'.join(p.read_bytes() for p in (core, accuracy, examples))
first_body, first_tail = Path(first['source']).read_bytes().split(check_start, 1)
assert first_tail == tail
offset = len(prefix) + len(core.read_bytes()) + 2 + len(accuracy.read_bytes()) + 2
assert first_body[:offset] == (prefix + core.read_bytes() + b'\n\n' + accuracy.read_bytes() + b'\n\n')
old_examples = first_body[offset:]
old_expected = next(row['sha256'] for row in first['inputs'] if row['path'].endswith('Examples.lean.fragment'))
assert sha256(old_examples).hexdigest() == old_expected
assert old_examples.replace(b'rw [extraction_eq_localTrace]', b'rw [extraction_eq_localTrace result \xcf\x84]') == examples.read_bytes()
old_runner = next(row['sha256'] for row in first['inputs'] if row['path'].endswith('run.py'))
assert digest(HERE / 'run-01.py') == old_runner
for name in ('Candidate.lean', 'contracts.proof-free.md', 'native-01-Examples.lean.fragment', 'native-version.output.txt'):
    assert not (HERE / name).exists(), 'append-only output: ' + name
(HERE / 'Candidate.lean').write_bytes(Path(final['source']).read_bytes())
(HERE / 'native-01-Examples.lean.fragment').write_bytes(old_examples)
(HERE / 'contracts.proof-free.md').write_text('# Exact native contracts\n\n'
    'These are the successful native type, structure, definition and axiom outputs. '
    'No theorem proof bodies or source verdict are included.\n\n```text\n' + body + '```\n', encoding='utf-8', newline='\n')
command = ['C:/Users/qed_s/.elan/bin/lake.exe', 'env', 'lean', '--version']
runtime = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
(HERE / 'native-version.output.txt').write_bytes(runtime.stdout)
assert runtime.returncode == 0 and b'4.29.0-rc3' in runtime.stdout
tools = [Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/bin') / (name + '.exe') for name in ('lean', 'lake')]
manifest = dict(kind='information-only-riemann-method-draft', frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                candidate=record(HERE / 'Candidate.lean'), review=record(HERE / 'REVIEW.md'),
                proof_free_contracts=record(HERE / 'contracts.proof-free.md'),
                native_final=record(HERE / 'native-02.receipt.json'), native_final_exit_code=0,
                native_failed=record(HERE / 'native-01.receipt.json'), native_failed_exit_code=1,
                failed_fragment_recovered_from_exact_input=record(HERE / 'native-01-Examples.lean.fragment'),
                new_declarations=final['new_declarations'], reused_checks=final['reused_declaration_checks'],
                axiom_reports=reports, total_axiom_reports=29, all_assertions_passed=True,
                canonical_import_closure=final['canonical_import_closure'], reuse=record(HERE / 'reuse.json'),
                runtime=dict(command=command, cwd=str(REPO), exit_code=runtime.returncode,
                             output=record(HERE / 'native-version.output.txt'), tools=[record(p) for p in tools]),
                source_faithfulness_judgment=None, source_interpretation_adopted=False,
                artifacts=[record(p) for p in sorted(HERE.iterdir()) if p.is_file()],
                scope='This scratch folder only; old evidence/production/gate/audit/ledger/Git untouched.')
manifest_path = HERE / 'manifest.json'
manifest_path.write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8', newline='\n')
result = dict(manifest=record(manifest_path), candidate=record(HERE / 'Candidate.lean'),
              actual_native_exit=0, new_declarations=24, axiom_reports=29,
              allowed_axioms=['propext', 'Classical.choice', 'Quot.sound'],
              retained_failed_native_exit=1, all_assertions_passed=True,
              review=record(HERE / 'REVIEW.md'), source_interpretation_adopted=False)
target = HERE / 'final-receipt.json'
target.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(receipt=record(target), manifest=record(manifest_path), candidate=record(HERE / 'Candidate.lean'),
                      actual_native_exit=0, new_declarations=24, axiom_reports=29)))
