"""Permit explicitly pinned additional expression archives; preserve all screening."""
from pathlib import Path
import ast
import hashlib
import json
H = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
old = H / 'check-publication-allowlist-v2.py'
assert sha(old) == '5419329812f0ec4aa7310fc01f3aa6d8910092a174f3c00c5861210709d27015'
before = "    assert len(policy['archives']) == 2"
after = """    assert isinstance(policy['archives'], list) and len(policy['archives']) >= 2
    for entry in policy['archives']:
        assert set(entry) == {'receipt', 'archive', 'raw'}
        for key in ('receipt', 'archive', 'raw'):
            item = entry[key]
            assert isinstance(item, dict) and safe_name(item['path'])
            assert re.fullmatch(r'[0-9a-f]{64}', item['sha256'])
        for key in ('archive', 'raw'):
            assert type(entry[key]['bytes']) is int and entry[key]['bytes'] > 0
        assert entry['archive']['path'].endswith('.gz')
        assert entry['archive']['path'] != entry['raw']['path']
    for key in ('receipt', 'archive', 'raw'):
        assert len({entry[key]['path'] for entry in policy['archives']}) == len(policy['archives'])"""
text = old.read_text()
assert text.count(before) == 1
new_text = text.replace(before, after)
new = H / 'check-publication-allowlist-v3.py'
compile(new_text, str(new), 'exec')
old_functions = {n.name: ast.dump(n) for n in ast.parse(text).body if isinstance(n, ast.FunctionDef)}
new_functions = {n.name: ast.dump(n) for n in ast.parse(new_text).body if isinstance(n, ast.FunctionDef)}
assert old_functions.keys() == new_functions.keys()
assert all(old_functions[name] == new_functions[name] for name in old_functions if name != 'verify_policy')
with new.open('xb') as stream:
    stream.write(new_text.encode())
record = {'schema': 1, 'source_sha256': sha(old), 'output_sha256': sha(new),
          'exact_replacements': [{'before': before, 'after': after}],
          'all_other_functions_ast_identical': True, 'operational_snapshot_executed': False,
          'rationale': 'The new routine export adds a third exact archive. Each archive remains explicitly pinned in the reviewed policy, fully decompressed and hash/size checked; every raw path must remain excluded. All staged/live size, path ownership, regular-file, placeholder, concurrency and index guards are unchanged.'}
with (H / 'checker-v3-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
