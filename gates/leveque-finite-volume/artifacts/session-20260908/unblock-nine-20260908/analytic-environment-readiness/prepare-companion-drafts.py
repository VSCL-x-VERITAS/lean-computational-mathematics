"""Inspect native packets and append existing operator evidence in new drafts only."""
from pathlib import Path
import ast
import copy
import hashlib
import json
import os
import re

H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
D = H.parent; S = D.parent; R = S.parents[3]
observed = {}

def sha(p):
    result = hashlib.sha256(p.read_bytes()).hexdigest()
    observed[p] = result
    return result

def ref(p): return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def read(p):
    sha(p)
    return json.loads(p.read_bytes())
def write(p, value):
    with p.open('xb') as f: f.write((json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode())

preparer = D / 'prepare-successor-audit-with-companions.py'
tree = ast.parse(preparer.read_text())
definition = next(x for x in tree.body if isinstance(x, ast.FunctionDef) and x.name == 'load_additional_supplement')
namespace = {'Path': Path, 'hashlib': hashlib, 'json': json}
exec(compile(ast.Module(body=[definition], type_ignores=[]), str(preparer), 'exec'), namespace)
load = namespace['load_additional_supplement']
preparer_ref = ref(preparer)
operators = read(D / 'measure-operator-evidence/additional-supplement.json')
operator_packet, _, operator_pins = load(R, operators)
for item in operator_pins: assert ref(R / item['path']) == item
native = read(D / 'measure-operator-evidence/native-02/receipt.json')
native_output = D / 'measure-operator-evidence/native-02/output.txt'
assert native['exit_code'] == 0 and sha(native_output) == native['output_sha256']
assert native['command'][1:3] == ['env', 'lean']
assert sha(R / native['command'][3]) == native['input_snapshot_sha256']
for pin in native['inputs']:
    assert pin['sha256_before'] == pin['sha256_after'] == sha(R / pin['path'])
axioms = re.findall(r"depends on axioms: \[([^]]*)\]", native_output.read_text())
assert len(axioms) == 21 and all(set(x.strip() for x in a.split(',') if x.strip()) <= {'propext', 'Classical.choice', 'Quot.sound'} for a in axioms)
terms = ['MeasureTheory.integral_def', 'MeasureTheory.L1.integral_def', 'MeasureTheory.L1.integralCLM',
         'MeasureTheory.Lp.simpleFunc.denseRange', 'MeasureTheory.SimpleFunc.integral_eq_sum']
operator_text = '\n'.join(x['exact_text'] for x in operator_packet['native_output_spans'])
assert all(x in operator_text for x in terms)
tasks = [
    ('information', D / 'local-riemann-information-interface-audit-spec.json'),
    ('directional', D / 'dimensional-method-audit-preparation/audit-spec.json')]
results = []
for label, spec_path in tasks:
    spec = read(spec_path); task_dir = S / 'audits' / spec['task_id']
    prepared_path = task_dir / 'dependency-environment-packet.json'
    config_path = D / (spec['task_id'] + '.config.json')
    manifest_path = task_dir / 'faithfulness/manifest.json'
    prepared = read(prepared_path); config = read(config_path); manifest = read(manifest_path)
    config_ref = ref(config_path)
    assert config_ref in manifest['audit_setup']
    environment = {x['path']: x['sha256'] for x in manifest['lean_environment']}
    assert len(environment) == len(manifest['lean_environment'])
    for path in config['lean']['environment_files']:
        assert path in environment and sha(R / path) == environment[path]
    texts = '\n'.join(x['exact_text'] for x in prepared['native_output_spans'])
    presence = {term: term in texts for term in terms}
    assert not any(presence.values())
    assert not any('measure-operator-evidence/' in x for x in config['lean']['environment_files'])
    for span in prepared['native_output_spans']:
        p = R / span['source_path']; data = p.read_bytes()
        assert sha(p) == span['source_sha256'] and environment[span['source_path']] == span['source_sha256']
        exact = data[span['start_byte']:span['end_byte_exclusive']]
        assert exact == span['exact_text'].encode() and hashlib.sha256(exact).hexdigest() == span['span_sha256']
    base, _, base_pins = load(R, spec['additional_supplement'])
    for pin in base_pins: assert ref(R / pin['path']) == pin
    for span in base['native_output_spans']: assert span in prepared['native_output_spans']
    merged = copy.deepcopy(base)
    merged['scope'] += ' Appended exact native specifications of restriction, integrability and the Bochner/L1/simple-function construction; no target proof or source judgment added.'
    merged['runtime']['measure_operator_supplement'] = {'packet': operators['packet'], 'environment_config': operators['environment_config'], 'native_runtime': operator_packet['runtime']}
    merged['native_output_spans'] += copy.deepcopy(operator_packet['native_output_spans'])
    merged['probe_commands'] += copy.deepcopy(operator_packet['probe_commands'])
    merged['omissions'] += copy.deepcopy(operator_packet['omissions'])
    merged['omissions'].append('This additive draft is not installed in an active audit and asserts no readiness or faithfulness verdict.')
    pins = {}
    for pin in [*base_pins, *operator_pins]:
        assert pin['path'] not in pins or pins[pin['path']] == pin['sha256']
        pins[pin['path']] = pin['sha256']
    packet_path = H / (label + '-native-packet-draft.json')
    environment_path = H / (label + '-environment-draft.json')
    write(packet_path, merged)
    write(environment_path, {'format': 'pinned-audit-environment-extension-1',
                            'environment_files': [{'path': p, 'sha256': pins[p]} for p in sorted(pins)]})
    extension = {'packet': ref(packet_path), 'environment_config': ref(environment_path)}
    write(H / (label + '-additional-supplement-draft.json'), extension)
    loaded, _, refs = load(R, extension)
    assert loaded['native_output_spans'][:len(base['native_output_spans'])] == base['native_output_spans']
    assert loaded['native_output_spans'][len(base['native_output_spans']):] == operator_packet['native_output_spans']
    results.append({'label': label, 'task_id': spec['task_id'], 'original_spec': ref(spec_path),
                    'prepared_packet': ref(prepared_path), 'original_config': config_ref,
                    'prepared_manifest': ref(manifest_path), 'prepared_native_spans': len(prepared['native_output_spans']),
                    'original_additional_supplement': spec['additional_supplement'],
                    'existing_operator_declarations': presence, 'operator_environment_present': False,
                    'original_additional_spans_preserved': len(base['native_output_spans']),
                    'added_operator_spans': len(operator_packet['native_output_spans']),
                    'draft': extension, 'draft_span_count': len(loaded['native_output_spans']),
                    'closed_loader_validation': True, 'configured_files_checked': len(config['lean']['environment_files'])})
for p, expected in list(observed.items()):
    assert hashlib.sha256(p.read_bytes()).hexdigest() == expected, ('Changed observed input', p)
report = {'schema': 1, 'scope': 'Prepared native environment readiness only; no judge outputs inspected',
          'originals_unchanged': True, 'active_audits_modified': False, 'launches': 0,
          'native_replay_performed': False, 'existing_native_exit': native['exit_code'],
          'existing_native_axiom_reports': len(axioms), 'original_operator_supplement': operators,
          'loader': preparer_ref, 'results': results,
          'observed_inputs': [{'path': p.relative_to(R).as_posix(), 'sha256': value} for p, value in sorted(observed.items(), key=lambda x: str(x[0]))],
          'limitations': ['No source-faithfulness or audit-outcome judgment.',
                         'Original inherited volume spans stay with the configured supplement_task; drafts replace only additional_supplement in a future separately prepared specification.',
                         'No active specification is modified and no successor task ID is invented.',
                         'Exact operator evidence is provided; whether it resolves any judge concern remains an independent audit question.']}
write(H / 'readiness.json', report)
print(json.dumps({'report': ref(H / 'readiness.json'), 'tasks': [{'label': x['label'], 'existing_operator_declarations': x['existing_operator_declarations'], 'draft': x['draft'], 'draft_span_count': x['draft_span_count']} for x in results]}, indent=2))
