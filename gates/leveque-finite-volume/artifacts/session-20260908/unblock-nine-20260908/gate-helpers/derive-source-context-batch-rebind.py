"""Derive source-context-aware batch helpers; never execute either helper."""
from pathlib import Path
import hashlib
import json
import os

H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

def read(name, expected):
    p = H / name
    assert sha(p) == expected, 'Changed frozen input: ' + name
    return p.read_text(encoding='utf-8')

def write(name, data):
    with (H / name).open('xb') as handle:
        handle.write(data)

def derive(source_name, source_sha, output_name, replacements):
    text = read(source_name, source_sha)
    for before, after in replacements:
        assert text.count(before) == 1, (source_name, before)
        text = text.replace(before, after)
    compile(text, output_name, 'exec')
    write(output_name, text.encode())
    return {'source': {'path': source_name, 'sha256': source_sha},
            'output': {'path': output_name, 'sha256': sha(H / output_name)},
            'exact_replacements': [{'before': a, 'after': b} for a, b in replacements]}

prior_derivation = json.loads(read('rebind-validator-derivation.json',
    '0d3393291fb6ebbb8c71cd0915431ca31660c6bd68c52c44e99ee15ea888f51c'))
validator_changes = [(x['before'], x['after']) for x in prior_derivation['exact_replacements']]
assert len(validator_changes) == 3
validator = derive('validate-closed-row-audits-v6.py',
    '95fbb838b7c620228406574f7f9470ba4ca70474396405159ebdf73c7f4ddbe1',
    'validate-closed-row-audits-rebind-v2.py', validator_changes)

batch_changes = [
    ("'qualified_row_support_v2.py': 'c72831c1518610fe7c67bba22322b7418ced275a731bf3b474d9ed6ae8fe64da'",
     "'qualified_row_support_v3.py': '75bca786c37ea46940642b7db271d9501d3569c769e2081756da2e4a74905128'"),
    ("'validate-closed-row-audits-rebind.py': '0c13b89e3b2597d8262ca2da54257b66b4840478ad15e541cd79e2235231c74b'",
     "'validate-closed-row-audits-rebind-v2.py': '" + validator['output']['sha256'] + "'"),
    ("'qualified-refinement-v2-validator-dependencies.json': 'bbf246b042b947bd77b43190a4d0a95810b24c319c431cfdbc5f5b7e3597683f'",
     "'source-context-v3-validator-dependencies.json': 'd6e5b63836455eec9edd42fc210ede4b84972b85ad96fc8d54d17672582ce33f'"),
    ("q = load('batch_qualified_support', 'qualified_row_support_v2.py')",
     "q = load('batch_qualified_support_v3', 'qualified_row_support_v3.py')"),
    ("deps = parse(reader.read(H / 'qualified-refinement-v2-validator-dependencies.json'))",
     "deps = parse(reader.read(H / 'source-context-v3-validator-dependencies.json'))"),
    ("str(H/'validate-closed-row-audits-rebind.py'), '--validate'",
     "str(H/'validate-closed-row-audits-rebind-v2.py'), '--validate'"),
    ("                require(record[key] == row[key], 'Qualified validation binding mismatch: ' + key)\n",
     """                require(record[key] == row[key], 'Qualified validation binding mismatch: ' + key)
            for key in q.SOURCE_CONTEXT_KEYS:
                require((key in record) == (key in row), 'Source-context validation presence mismatch: ' + key)
                if key in row:
                    require(record[key] == row[key], 'Source-context validation binding mismatch: ' + key)
"""),
]
batch = derive('rebind-accepted-row-batch.py',
    '16f782717887402bfe03b5f0319bf25e62adcb5c5ddf672d1ebc9b92ce1eb520',
    'rebind-accepted-row-batch-v2.py', batch_changes)
record = {'schema': 1, 'purpose': 'Refresh accepted row context without dropping separately bound source context.',
          'validator': validator, 'batch': batch,
          'prior_validator_derivation': {'path': 'rebind-validator-derivation.json',
                                         'sha256': sha(H / 'rebind-validator-derivation.json')},
          'runtime_invoked': False, 'gate_mutated': False, 'new_source_semantics': False}
write('source-context-batch-rebind-derivation.json', (json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'validator': validator['output'], 'batch': batch['output']}))
