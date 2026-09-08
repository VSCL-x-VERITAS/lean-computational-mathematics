"""Derive an additive, task-specific projection of the adjudicated classification scope."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
src=S/'close-audited-proved-row.py';text=src.read_text(encoding='utf-8')
def change(old,new):
 global text
 assert text.count(old)==1,old[:100]
 text=text.replace(old,new,1)
change('    decision = read(output / \'decision.json\')',"""    decision_path = output / 'decision.json'
    if task['task_id'] != 'LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908' or args.row != 'LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY':
        raise ValueError('This projection is restricted to the adjudicated classification assertion.')
    if hashlib.sha256(decision_path.read_bytes()).hexdigest() != 'ec1f5ba91a50a7a6f18e3ff7065a9354ca62d628b572560ccadedb307423b439':
        raise ValueError('The reviewed scope decision changed.')
    decision = read(decision_path)
    if decision.get('adjudicated') is not True:
        raise ValueError('Scope projection requires the frozen adjudication.')""")
old="""    contract = {
        'statement': source['contract_plain_english'],
        'assumptions': source['statement']['hypotheses'] + source['statement']['implicit_context'],
        'quantifiers': source['statement']['binders'],
    }"""
new="""    if hashlib.sha256((output / 'agent_outputs/source_contract.json').read_bytes()).hexdigest() != 'd226eed74a63211672f1046b713ab936ea0ff08bef79d271e1a4717c4b80ecb5':
        raise ValueError('The independent extraction changed.')
    if 'classification' not in task['source']['locations'][0]['anchor']:
        raise ValueError('The locator must independently select the classification.')
    contract = {
        'statement': source['statement']['conclusions'][1],
        'assumptions': [
            source['statement']['hypotheses'][1],
            source['statement']['implicit_context'][0],
            'The adjudicator accepts positive bulk modulus and density as inherited physical acoustic context, not verbatim source inequalities or an unrestricted material domain.',
        ],
        'quantifiers': source['statement']['binders'][2:],
        'source_extraction_sha256': hashlib.sha256((output / 'agent_outputs/source_contract.json').read_bytes()).hexdigest(),
        'adjudicated_scope': {
            'decision_sha256': hashlib.sha256(decision_path.read_bytes()).hexdigest(),
            'lean_implies_source': decision['implications']['lean_implies_source'],
            'source_implies_lean': decision['implications']['source_implies_lean'],
            'findings': decision['findings'],
            'remaining_uncertainties': decision['remaining_uncertainties'],
            'broader_extraction_retained': (output / 'agent_outputs/source_contract.json').relative_to(root).as_posix(),
            'separate_derivation_row': 'LEV-CH01-EQ-1.7-WAVE-EQUATION',
        },
    }
    derivation = next(r for r in gate['rows'] if r['id'] == 'LEV-CH01-EQ-1.7-WAVE-EQUATION')
    if derivation['status'] not in checker.CLOSED_LEAN_STATUSES:
        raise ValueError('The separately tracked derivation must remain independently closed.')
    if row['source_label'] != 'Equation (1.7) is hyperbolic under the standard classification of second-order linear equations':
        raise ValueError('The inventoried classification scope changed.')
    row['adjudicated_scope_note'] = {
        'classification_only': True,
        'separate_derivation_row': derivation['id'],
        'decision_sha256': hashlib.sha256(decision_path.read_bytes()).hexdigest(),
        'source_extraction_sha256': contract['source_extraction_sha256'],
        'source_ambiguities_preserved': source['ambiguities'],
        'limitations': decision['remaining_uncertainties'],
    }"""
change(old,new)
change("procedure = 'Project the validated independent source contract from the immutable successor audit; retain its full source evidence, conventions and ambiguities in the sealed output.'",
 "procedure = 'Project the source extraction classification conclusion selected by the exact locator and frozen independent adjudication. Preserve the broader extraction and every scope/material-domain note by hash; the separate derivation has its own independently closed row.'")
dest=S/'bind-second-order-classification-proved-row.py'
assert not dest.exists();dest.write_text(text,encoding='utf-8')
print(json.dumps({'path':str(dest),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()}))

