"""Add scoped literal Q10 evidence support; preserve every frozen predecessor."""
from pathlib import Path
import ast
import hashlib
import json

H = Path(__file__).resolve().parent
R = H.parents[5]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
def create(path, data):
    with path.open('xb') as stream:
        stream.write(data)
def writej(path, value):
    create(path, (json.dumps(value, indent=2) + '\n').encode())
records = []
def derive(old, digest, new, changes):
    path = H / old
    assert sha(path) == digest, old
    text = path.read_text(encoding='utf-8')
    for before, after in changes:
        assert text.count(before) == 1, (old, before)
        text = text.replace(before, after)
    compile(text, new, 'exec')
    result = H / new
    create(result, text.encode())
    records.append({'parent': ref(path), 'output': ref(result),
                    'exact_replacements': [{'before': a, 'after': b} for a, b in changes]})
    return ref(result)

fragment = (H / 'high-resolution-context-validation.fragment.py').read_text(encoding='utf-8')
old_receipts = """    require(extension['interpretation_receipts'] == [INHERITED_RECEIPT],
            'only the exact independently recorded Eq1.10 user receipt is supported')
    receipt_path = source_context_environment(INHERITED_RECEIPT, configured, environment)
    receipt_raw = receipt_path.read_bytes()
    receipt = source_context_json(receipt_path)
    require(packet['interpretation_receipts'] == [{'receipt': INHERITED_RECEIPT,
            'exact_receipt_bytes_utf8': receipt_raw.decode('utf-8'), 'exact_fields': receipt}],
            'literal inherited receipt bytes/fields or original authority/scope changed')
    require(receipt['kind'] == 'explicit user-adopted source interpretation' and receipt['source_sha256'] == source['sha256'],
            'inherited authority/source mismatch')
"""
support = derive('qualified_row_support_v3.py', '75bca786c37ea46940642b7db271d9501d3569c769e2081756da2e4a74905128',
    'qualified_row_support_v4.py', [
        ('def validate_source_context(request, task, manifest, config):', fragment + '\n\ndef validate_source_context(request, task, manifest, config):'),
        ("        require(not configured_inherited and not manifested_inherited,", "        require(not configured_inherited and not manifested_inherited\n                and HIGH_RESOLUTION_RECEIPT['path'] not in configured\n                and not any(item['path'] == HIGH_RESOLUTION_RECEIPT['path'] for item in environment),"),
        (old_receipts, "    receipt_refs = validate_scoped_context_receipts(request, extension, packet, source, configured, environment)\n"),
        ('provenance = [*refs.values(), source, INHERITED_RECEIPT,', 'provenance = [*refs.values(), source, *receipt_refs,')])
single = derive('bind-qualified-row-v3.py', '6c2d584bcd96007252a9b9fe074fd176fc84067964d129e0dbb87368a1d01d35',
    'bind-qualified-row-v4.py', [('import qualified_row_support_v3 as q', 'import qualified_row_support_v4 as q')])
validator = derive('validate-closed-row-audits-v6.py', '95fbb838b7c620228406574f7f9470ba4ca70474396405159ebdf73c7f4ddbe1',
    'validate-closed-row-audits-v7.py', [('import qualified_row_support_v3 as qualified', 'import qualified_row_support_v4 as qualified')])
proposal = derive('validate-closed-row-audits-rebind-v2.py', '43ec7d65651ad45a1b62853228538c1fe09f49841a7fc10db97906a845d4de87',
    'validate-closed-row-audits-rebind-v3.py', [('import qualified_row_support_v3 as qualified', 'import qualified_row_support_v4 as qualified')])
old_deps = H / 'source-context-v3-validator-dependencies.json'
assert sha(old_deps) == 'd6e5b63836455eec9edd42fc210ede4b84972b85ad96fc8d54d17672582ce33f'
deps = json.loads(old_deps.read_bytes())
deps['audit_validator'] = validator
deps['validator_dependencies'][0] = support
deps['source_context_protocol_inputs'].extend([
    ref(H.parent / 'user-high-resolution-interpretation-20260908.json'),
    ref(H.parent / 'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json')])
deps['producer'] = ref(Path(__file__).resolve())
new_deps_path = H / 'source-context-v4-validator-dependencies.json'
writej(new_deps_path, deps)
new_deps = ref(new_deps_path)
batch = derive('rebind-accepted-row-batch-v2.py', '6776b4990d9b9bd189d366559623f1b2451aff8c0f1d54fdddc0d4ad5ecb8c41',
    'rebind-accepted-row-batch-v3.py', [
        ("'qualified_row_support_v3.py': '75bca786c37ea46940642b7db271d9501d3569c769e2081756da2e4a74905128'", "'qualified_row_support_v4.py': '" + support['sha256'] + "'"),
        ("'validate-closed-row-audits-rebind-v2.py': '43ec7d65651ad45a1b62853228538c1fe09f49841a7fc10db97906a845d4de87'", "'validate-closed-row-audits-rebind-v3.py': '" + proposal['sha256'] + "'"),
        ("'source-context-v3-validator-dependencies.json': 'd6e5b63836455eec9edd42fc210ede4b84972b85ad96fc8d54d17672582ce33f'", "'source-context-v4-validator-dependencies.json': '" + new_deps['sha256'] + "'"),
        ("q = load('batch_qualified_support_v3', 'qualified_row_support_v3.py')", "q = load('batch_qualified_support_v4', 'qualified_row_support_v4.py')"),
        ("deps = parse(reader.read(H / 'source-context-v3-validator-dependencies.json'))", "deps = parse(reader.read(H / 'source-context-v4-validator-dependencies.json'))"),
        ("str(H/'validate-closed-row-audits-rebind-v2.py'), '--validate'", "str(H/'validate-closed-row-audits-rebind-v3.py'), '--validate'")])
global_path = H / 'bind-final-global-evidence-v2.py'
old_global = global_path.read_text(encoding='utf-8')
assignments = {node.targets[0].id: node for node in ast.parse(old_global).body
               if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Name)}
def assignment(name):
    node = assignments[name]
    return ast.get_source_segment(old_global, node), ast.literal_eval(node.value)
pin_line, _ = assignment('FINAL_VALIDATOR_PIN')
dep_line, global_deps = assignment('FINAL_VALIDATOR_DEPENDENCIES')
assert global_deps[0]['path'].endswith('/qualified_row_support_v3.py')
global_deps[0] = support
global_binder = derive('bind-final-global-evidence-v2.py', 'cbe2ed88c8c595b4db1771692852b2789886b21f9c4ef038f959ff0b8a9113af',
    'bind-final-global-evidence-v3.py', [
        (pin_line, 'FINAL_VALIDATOR_PIN = ' + repr(validator)),
        (dep_line, 'FINAL_VALIDATOR_DEPENDENCIES = ' + repr(global_deps)),
        ("'Final validator must be the exact reviewed v6'", "'Final validator must be the exact reviewed v7'"),
        ("'Final validator dependencies differ from reviewed v6 closure'", "'Final validator dependencies differ from reviewed v7 closure'"),
        ("endswith('/qualified_row_support_v3.py')", "endswith('/qualified_row_support_v4.py')"),
        ("spec_from_file_location('final_global_qualified_v3', path)", "spec_from_file_location('final_global_qualified_v4', path)"),
        ("'Qualified records require the exact v6 support'", "'Qualified records require the exact v7 support'")])
writej(H / 'high-resolution-context-helper-derivation.json', {
    'format': 'additive-literal-source-context-helpers-1',
    'deriver': ref(Path(__file__).resolve()), 'fragment': ref(H / 'high-resolution-context-validation.fragment.py'),
    'derivations': records, 'dependencies': new_deps,
    'unchanged_sealed_protocol': True, 'operational_validations': 0, 'gate_mutations': 0,
    'source_acceptance': False, 'tests_pending': True})
print(json.dumps({'support': support, 'single': single, 'validator': validator,
                  'batch': batch, 'global_binder': global_binder, 'dependencies': new_deps}, sort_keys=True))
