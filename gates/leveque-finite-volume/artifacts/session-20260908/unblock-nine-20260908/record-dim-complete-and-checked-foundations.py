"""Record the actual completed adjudication and checked replacement foundations."""
from pathlib import Path
import hashlib, json, os

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def immutable(path, value):
    with path.open('xb') as stream:
        stream.write((json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode())

O = S / 'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness'
execution_path = D / 'adjudicator-plaintext-dictionary-v1/dim-a2-01/execution-receipt.json'
execution = read(execution_path)
assert execution['exit_code'] == 0 and execution['audit_completed']
assert execution['all_original_static_inputs_unchanged'] and execution['original_statuses_preserved']
assert len(execution['steps']) == 5 and all(step['exit_code'] == 0 for step in execution['steps'])
assert execution['released_complete_validation_exit_code'] == 0
decision = read(O / 'decision.json')
assert sha(O / 'decision.json') == '4f12b693e0c12b2b69488358c565ca327ba8b709efac73a7a885e8cb08bd4058'
assert decision['accepted'] is False and decision['classification'] == 'undetermined'
pins = {
    'dim-five-owner-overlay/receipt.json': '6d84c698bd2ddc3e203709f6686e85264b6da5f908fe5dc20d76b18348251e17',
    'dim-two-direction-cinfty-replay-02/verification.json': 'b19de83ff555a1776a8372b8a1b270faec563678adf450b06ce2f1b3ab0e547b',
    'dim-shared-accuracy-certificate/final-receipt.json': '09f2006450369c5f47d9a9ca384fe6a28d7d3bc3a600e5dd9cb840b9e19ee2c6',
    'capacity-net-reference-error-draft/receipt.json': 'e47312a4778bc1d72f5bdf54b9eb09124e42ec5c36ed55d38ea8f385e1bbb78c',
    'capacity-coordinate-realization-draft/receipt.json': 'f8d2c68fb03bb64f69231151fbe505a322222ca3eeedf3b3dffea8513200a377',
    'dim-interval-quality-repair/final-receipt.json': '8c8de86c1f8f87999c9add3616e9e9dc9575f91a86a49a9806073fd670d0d300',
    'combined-certificate-net-error-review/receipt.json': '5263e77b4658579c3b805bdfac726426f6d5b3592d2baa6c5fc46f341da4ef50',
    'gate-helpers/dim-inherited-context-successors/receipt.json': '083dabc8062cb7f943762fe82d7329b4e3db4c1482493cb03bc9b6932ea8db51',
}
for name, digest in pins.items():
    assert sha(D / name) == digest, name
out = D / 'dim-completed-adjudication-and-foundations'
out.mkdir()
record = {
    'format': 'dim-completed-adjudication-and-foundations-1',
    'execution': ref(execution_path), 'actual_execution_exit_code': 0,
    'actual_step_exit_codes': [step['exit_code'] for step in execution['steps']],
    'decision': ref(O / 'decision.json'), 'report': ref(O / 'report.md'),
    'manifest': ref(O / 'manifest.json'), 'runtime': ref(O / 'orchestration/a2_runtime.json'),
    'classification': decision['classification'], 'accepted': decision['accepted'],
    'findings': decision['findings'], 'remaining_uncertainties': decision['remaining_uncertainties'],
    'historical_statuses': {
        'original_wrapper': execution['lineage']['original_wrapper_exit_code'],
        'direct_recovery': execution['lineage']['direct_recovery_exit_code'],
        'ordinary_adjudication_continuation': execution['lineage']['adjudicator_continuation_exit_code'],
    },
    'checked_foundation_receipts': [ref(D / name) for name in pins],
    'scope': 'These actual checked artifact-only components do not yet replace the whole source-facing theorem or certify either open row. The interval quality instance is not a general physical-geometry instance. The shared certificate and physical net-error bounds require explicit compatible reference/boundary data when composed.',
    'next_foundation': 'A physical-refinement quality contract using the same fixed physical reference, measured projections, actual cell diameters, explicit boundary inputs, nonempty admitted time-step domains and shared all-level certificates; then full source-primary repair and fresh independent audit.',
    'source_acceptance': False, 'newly_closed_rows': 0,
}
assert record['historical_statuses'] == {'original_wrapper': 1, 'direct_recovery': 0, 'ordinary_adjudication_continuation': 1}
immutable(out / 'diagnosis.json', record)
book = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book) == 'dd86feb64bc39f4ce35da7643fcb632e2408226f7597dd5e747a4a1bd9f1a1a4'
assert sha(process) == '31cf369f077b73b7173554b50e323cc8a5fa74306db2e67bbc94547d5beb5274'
loc = (out / 'diagnosis.json').relative_to(R).as_posix() + ' SHA256 ' + sha(out / 'diagnosis.json')
entries = {
    book: '| LEV-C1-HIGH-RESOLUTION-COMPLETE-ADJUDICATION-112 | LEV-CH01-DIMENSIONAL-SPLITTING | Complete original high-resolution audit | Final adjudicator is undetermined and unaccepted; it confirms missing nonsmooth admission, isolated threshold vacuity and extra quality/realization scope, while resolving the stability witness | Use the checked C-infinity overlay, shared certificate, independent core quality and capacity execution foundations to repair the full physical-reference contract, then audit a fresh target | IN_PROGRESS; two original-nine rows remain open | ' + loc + ' | Actual recovery completion is not source acceptance. Fixed arbitrary ghosts require explicit reference-boundary treatment. The source ambiguity and literal adopted convention are preserved. |',
    process: '| LEV-SKILL-DIM-PLAINTEXT-ADJUDICATOR-RECOVERY-097 | codex-start-1-v5-0-1-20260908 | Exact plaintext transport recovery | Reviewed all-inline representation reconstructs every original byte through two decoders and fits the measured native character limit; the actual fresh adjudicator, collector, finalizer and complete validator all exit 0 | Retain exact original inputs, roles, independent model identity and all historical statuses; use the actual nonaccepted decision as repair evidence | Recovery COMPLETE; semantic work remains ACTIVE | ' + loc + ' | Original statuses remain 1/0/1. This is an additive local transport recovery with no released-validator changes or requested verdict. New helper guards and native mathematics are separate evidence, not gate acceptance. |',
}
receipt = {'diagnosis': ref(out / 'diagnosis.json'), 'ledgers': []}
for path, entry in entries.items():
    before = path.read_bytes()
    assert before.endswith(b'\n') and entry.split('|')[1].strip().encode() not in before
    with path.open('ab') as stream: stream.write((entry + '\n').encode())
    assert path.read_bytes().startswith(before)
    receipt['ledgers'].append({'before_sha256': hashlib.sha256(before).hexdigest(), 'after': ref(path)})

gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
gate_raw = gate_path.read_bytes()
gate = json.loads(gate_raw)
original_rows = json.loads(json.dumps(gate['rows']))
updates = {
    'LEV-CH01-DIMENSIONAL-SPLITTING': (
        'Repair the full physical-refinement high-resolution contract after completed unaccepted adjudication 4f12b693e0c12b2b69488358c565ca327ba8b709efac73a7a885e8cb08bd4058.',
        'Connect checked C-infinity regularity, admitted discontinuous inputs, shared all-level accuracy, explicit boundary projections and measured-capacity coordinate execution; keep stability separate, then run a fresh complete independent audit.'),
    'LEV-CH01-RIEMANN-INTERFACE-FLUX': (
        'Resolve the pending separately scoped reference-representative interpretation from completed unaccepted certified-routine audit 0ac08662a5a89231c70add2f6706e855f86704a7d57206cff558d8f2addd0308.',
        'Preserve the pending actual user question and source ambiguity; upon an actual adoption, bind its literal receipt and page-25 inherited hyperbolicity context in a fresh independent audit of the checked certified routine contract.'),
}
for row in gate['rows']:
    if row['id'] in updates:
        assert row['status'] == 'IN_PROGRESS'
        row['current_target'], row['next_action'] = updates[row['id']]
assert sum(row['status'] in {'PROVED', 'REUSED'} for row in gate['rows']) == 39
for before, after in zip(original_rows, gate['rows']):
    if before['id'] not in updates: assert before == after
    else:
        assert {k: v for k, v in before.items() if k not in {'current_target', 'next_action'}} == {
            k: v for k, v in after.items() if k not in {'current_target', 'next_action'}}
immutable(out / 'gate-before.json', json.loads(gate_raw))
new_raw = (json.dumps(gate, indent=2, ensure_ascii=False) + '\n').encode()
with (out / 'gate-after.json').open('xb') as stream: stream.write(new_raw)
assert gate_path.read_bytes() == gate_raw
temporary = gate_path.with_name('chapter-01.dim-foundations.tmp')
with temporary.open('xb') as stream: stream.write(new_raw)
os.replace(temporary, gate_path)
receipt['gate'] = {'before_sha256': hashlib.sha256(gate_raw).hexdigest(), 'after': ref(gate_path),
    'changed_fields': ['current_target', 'next_action'], 'changed_rows': list(updates),
    'closed_rows_preserved': 39, 'newly_closed_rows': 0}
immutable(out / 'receipt.json', receipt)
print(json.dumps(receipt, indent=2))
