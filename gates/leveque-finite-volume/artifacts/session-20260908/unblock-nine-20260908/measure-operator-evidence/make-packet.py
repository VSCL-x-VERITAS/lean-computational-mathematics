"""Package already checked native declarations; invoke no audit or model role."""
from pathlib import Path
import ast
import hashlib
import json
import re

D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p/'lean-toolchain').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}


def create(path, data):
    with path.open('xb') as handle:
        handle.write(data)


def write(path, data):
    create(path, (json.dumps(data, indent=2, ensure_ascii=False)+'\n').encode())


receipt_path = D/'native-02/receipt.json'
receipt = read(receipt_path)
output_path = D/'native-02/output.txt'
raw = output_path.read_bytes()
text = raw.decode('utf-8')
assert type(receipt['exit_code']) is int and receipt['exit_code'] == 0
assert sha(output_path) == receipt['output_sha256'] and receipt['inputs_unchanged']
assert (D/'Operators.lean').read_bytes() == (D/'native-02/Operators.lean.snapshot').read_bytes()
assert sha(D/'run-probe.py') == receipt['runner_sha256']
assert not re.search(r'\b(?:error|warning):|sorryAx', text)
axioms = re.findall(r"^'(.+)' depends on axioms:\s*\[([^\]]*)\]", text, re.M)
commands = [line for line in (D/'Operators.lean').read_text().splitlines() if line.startswith(('#check ', '#print '))]
axiom_commands = [line.removeprefix('#print axioms ') for line in commands if line.startswith('#print axioms ')]
assert len(axioms) == len(axiom_commands) == 21
assert {name for name, _ in axioms} == set(axiom_commands)
for _, names in axioms:
    assert {re.sub(r'\.\{[^}]*\}', '', name.strip()) for name in names.split(',')} <= {'propext', 'Classical.choice', 'Quot.sound'}

# The first failed probe's runner differed only by the three subsequently added
# owner-module lines. Retain a recovered counterpart only after exact hash check.
old = read(D/'native-01/receipt.json')
recovered = (D/'run-probe.py').read_bytes()
for line in (b"    'MeasureTheory/Measure/Real',\n", b"    'MeasureTheory/Function/SimpleFuncDenseLp',\n", b"    'Analysis/Normed/Operator/Extend',\n"):
    assert recovered.count(line) == 1
    recovered = recovered.replace(line, b'', 1)
assert hashlib.sha256(recovered).hexdigest() == old['runner_sha256']
create(D/'native-01/run-probe.py.snapshot', recovered)

environment = []
for item in receipt['inputs']:
    path = R/item['path']
    assert sha(path) == item['sha256_before'] == item['sha256_after']
    environment.append(ref(path))

# Measure.real's exact owner is MeasureSpaceDef, while Measure/Real was also
# recorded by the run. Bind that owner explicitly as a post-run observation.
owner = R/'.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/MeasureSpaceDef.lean'
compiled = R/'.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/MeasureTheory/Measure/MeasureSpaceDef.olean'
owner_observations = [ref(owner), ref(compiled)]
for suffix in ('.private', '.server'):
    path = Path(str(compiled)+suffix)
    if path.exists():
        owner_observations.append(ref(path))
environment += owner_observations
starts = [0, text.index('def MeasureTheory.IntegrableOn'), text.index('@MeasureTheory.integral_def'),
          text.index("'MeasureTheory.Measure.restrict_apply' depends on axioms:")]
labels = ['restriction laws and real-valued measure', 'integrability and lower integral definitions',
          'Bochner integral construction and characterizations', 'native axiom reports']
spans = []
for index, start_char in enumerate(starts):
    end_char = starts[index+1] if index+1 < len(starts) else len(text)
    start, end = len(text[:start_char].encode()), len(text[:end_char].encode())
    exact = raw[start:end]
    spans.append({'label': labels[index], 'source_path': output_path.relative_to(R).as_posix(),
                  'source_sha256': sha(output_path), 'start_byte': start, 'end_byte_exclusive': end,
                  'span_sha256': hashlib.sha256(exact).hexdigest(), 'exact_text': exact.decode(),
                  'first_line': raw[:start].count(b'\n')+1, 'last_line': raw[:end].count(b'\n')})
packet = {'format': 'proof-free-lean-environment-evidence-1',
          'scope': 'Exact native specifications of measure restriction, integrability, lower integration and Bochner integration.',
          'runtime': {'command_receipt': ref(receipt_path), 'probe': ref(D/'Operators.lean'),
                      'native_lake': receipt['native_lake'], 'environment_files': environment,
                      'post_run_owner_observations': owner_observations},
          'native_output_spans': spans, 'probe_commands': commands,
          'omissions': ['No target theorem proof, source interpretation, prior judgment or requested classification is included.',
                        'Selected owner source and compiled files are pinned; this is not a complete transitive import inventory.']}
packet_path = D/'dependency-packet.json'
write(packet_path, packet)
pins = environment + [ref(p) for p in (output_path, receipt_path, D/'run-probe.py', D/'native-02/Operators.lean.snapshot')]
assert len({row['path'] for row in pins}) == len(pins)
config_path = D/'environment-extension.json'
write(config_path, {'format': 'pinned-audit-environment-extension-1', 'environment_files': pins})
extension = {'packet': ref(packet_path), 'environment_config': ref(config_path)}

# Execute only the exact read-only loader definition, not the preparer's module.
preparer = D.parent/'prepare-successor-audit-with-companions.py'
tree = ast.parse(preparer.read_text())
nodes = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == 'load_additional_supplement']
assert len(nodes) == 1
namespace = {'Path': Path, 'hashlib': hashlib, 'json': json}
exec(compile(ast.Module(body=nodes, type_ignores=[]), str(preparer)+'::load_additional_supplement', 'exec'), namespace)
loaded, loaded_raw, loaded_pins = namespace['load_additional_supplement'](R, extension)
assert loaded == packet and loaded_raw == packet_path.read_bytes()
write(D/'additional-supplement.json', extension)
write(D/'packet-verification.json', {'schema': 1, 'status': 'PASS', 'additional_supplement': extension,
    'loader_source': ref(preparer), 'loader_function': 'load_additional_supplement',
    'preparer_invoked': False, 'model_roles_invoked': False, 'native_exit': 0,
    'native_axiom_reports': len(axioms), 'pinned_environment_files': len(pins),
    'span_bytes': sum(row['end_byte_exclusive']-row['start_byte'] for row in spans),
    'output_bytes': len(raw), 'historical_runner_recovery': ref(D/'native-01/run-probe.py.snapshot')})
print(json.dumps({'additional_supplement': extension, 'verification_sha256': sha(D/'packet-verification.json'),
                  'native_exit': 0, 'axioms': len(axioms), 'environment_files': len(pins)}, indent=2))
