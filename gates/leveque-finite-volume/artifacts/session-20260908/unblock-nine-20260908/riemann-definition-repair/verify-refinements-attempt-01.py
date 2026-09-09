"""Read-only input verification; additive evidence writes in this directory only."""
from pathlib import Path
import hashlib
import json
import sys
from datetime import datetime, timezone

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'lean-toolchain').is_file())
EXPECTED = {
    'interpretation-refinement.json': '8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21',
    'q6-interpretation-refinement.json': '8658feb83ed55f4c7a4a5c64a95c45313814c44b62573372ea716b5c791e97f3',
    'minimal-refinement-receipt.json': '35f2f5053025cacd2dde3741c5699dc039c26f841cdc97497ea00f4c57039a6a',
    'q6-minimal-refinement-receipt.json': '9eec82e9f497f1ab08daa5b3c57c86757c16eaba96a90012fe56bb46770183a7',
}

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def ref(p):
    return {'path': p.relative_to(ROOT).as_posix(), 'sha256': sha(p)}

bindings = []
def inspect(obj, location):
    if isinstance(obj, dict):
        if 'path' in obj and 'sha256' in obj:
            p = (ROOT / obj['path']).resolve()
            if not p.is_relative_to(ROOT) or not p.is_file():
                raise ValueError(f'Invalid reference at {location}: {p}')
            actual = sha(p)
            if actual != obj['sha256']:
                raise ValueError(f'Hash mismatch at {location}: {p}')
            bindings.append({'location': location, **ref(p)})
        for k, v in obj.items():
            inspect(v, f'{location}.{k}')
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            inspect(v, f'{location}[{i}]')

docs = {}
for name, expected in EXPECTED.items():
    p = HERE / name
    if sha(p) != expected:
        raise ValueError(f'Frozen file changed: {name}')
    docs[name] = json.loads(p.read_text(encoding='utf-8'))
    inspect(docs[name], name)

q9 = docs['interpretation-refinement.json']
q6 = docs['q6-interpretation-refinement.json']
required = set(q9)
if not required <= set(q6):
    raise ValueError(f'Q6 lacks Q9 schema keys: {required - set(q6)}')
selection = json.loads((ROOT / q9['prior_selection_receipt']['path']).read_text(encoding='utf-8'))
for q in (q9, q6):
    assert q['format'] == 'coordinator-selected-interpretation-refinement-1'
    assert isinstance(q['selected_model'], dict) and q['selected_model']
    assert isinstance(q['source_ambiguities_preserved'], list) and q['source_ambiguities_preserved']
    assert q['prior_selection_receipt'] == q9['prior_selection_receipt']
    selected = [v for v in selection['choices'] if v['choice_id'] == q['prior_choice_id']]
    assert len(selected) == 1 and q['prior_choice_exact'] == selected[0]
    for k in ('authority', 'exact_user_objective', 'goal_observation_sha256'):
        assert q[k] == selection[k]
    assert q['no_production_or_native_supplement_change'] is True

rel = 'gates/leveque-finite-volume/artifacts/session-20260908/audits/'
evidence = []
for ident in ('LEV-CH01-RIEMANN-DEFINITION-INTERPRETED-PRODUCTION-20260908',
              'LEV-CH01-SOURCE-TERMS-INTERPRETED-PRODUCTION-20260908'):
    directory = ROOT / rel / ident
    for name in ('audit-task.json', 'faithfulness/decision.json', 'faithfulness/report.md',
                 'faithfulness/inputs/declaration_dossier.md', 'faithfulness/source_contract.json'):
        p = directory / name
        if not p.is_file():
            raise ValueError(f'Expected reviewed evidence missing: {p}')
        evidence.append(ref(p))
for name in (
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FirstOrderEquation.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/FirstOrderRiemann.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/RectangleBalance.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/RectangleBalanceTemporalDerivative.lean',
    'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/prepare-successor-audit-with-companions.py',
):
    evidence.append(ref(ROOT / name))

def create_json(name, data):
    p = HERE / name
    with p.open('x', encoding='utf-8', newline='\n') as f:
        f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')
    return ref(p)

manifest = create_json('review-evidence-manifest.json', {
    'format': 'additive-interpretation-review-evidence-1',
    'created_at_utc': datetime.now(timezone.utc).isoformat(),
    'review': ref(HERE / 'REVIEW.md'),
    'verified_binding_occurrences': len(bindings),
    'verified_unique_bound_paths': len({v['path'] for v in bindings}),
    'verified_bindings': bindings,
    'additional_reviewed_evidence': evidence,
    'new_files': [ref(p) for p in sorted(HERE.iterdir()) if p.is_file()
                  and p.name not in ('review-evidence-manifest.json', 'final-receipt.json')],
    'interpretation_validation_only': True,
    'no_new_semantic_judgment_or_native_compile': True,
})
receipt = create_json('final-receipt.json', {
    'format': 'additive-interpretation-review-receipt-1',
    'status': 'FROZEN-READY-FOR-FRESH-INDEPENDENT-AUDIT',
    'manifest': manifest,
    'review': ref(HERE / 'REVIEW.md'),
    'packets': [ref(HERE / name) for name in ('interpretation-refinement.json', 'q6-interpretation-refinement.json')],
    'verification': {
        'script': ref(Path(__file__).resolve()),
        'python': sys.executable,
        'argv': sys.argv,
        'checks_passed': True,
        'binding_occurrences': len(bindings),
        'unique_bound_paths': len({v['path'] for v in bindings}),
        'original_choice_dicts_exact': True,
        'common_schema_fields_preserved': True,
    },
    'source_acceptance': False,
    'production_changes': False,
    'semantic_roles_launched': False,
    'new_lean_checks': False,
    'prior_audits_unchanged': True,
})
print(json.dumps({'manifest': manifest, 'receipt': receipt, 'verification': 'PASS'}, indent=2))
