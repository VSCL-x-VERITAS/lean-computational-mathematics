"""Derive an interpretation-aware adapter without modifying released validators."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
old=(S/'close-audited-proved-row.py').read_text()
text=old.replace("    args = parser.parse_args()", """    parser.add_argument('--interpretation', type=Path, required=True)
    parser.add_argument('--interpretation-sha256', required=True)
    parser.add_argument('--rebind', action='store_true')
    args = parser.parse_args()""")
text=text.replace("""    if row['status'] not in ('READY', 'IN_PROGRESS'):
        raise ValueError('row is not an open audited-proof candidate')""","""    if args.rebind:
        if row['status'] != 'PROVED' or row.get('faithfulness_task') != task_path.relative_to(root).as_posix() or row.get('lean_declarations') != [declaration]:
            raise ValueError('rebind requires the unchanged already-proved interpreted row')
    elif row['status'] not in ('READY', 'IN_PROGRESS'):
        raise ValueError('row is not an open audited-proof candidate')""")
needle="""    for field in ('next_foundation', 'next_action', 'current_target', 'open_reason'):"""
new="""    receipt_bytes = args.interpretation.read_bytes()
    receipt_sha = hashlib.sha256(receipt_bytes).hexdigest()
    if receipt_sha != args.interpretation_sha256:
        raise ValueError('user interpretation receipt hash mismatch')
    interpretation = read(args.interpretation)
    if args.row not in interpretation['scope'] or interpretation['source_sha256'] != checker.PINNED_SOURCE_SHA256:
        raise ValueError('user interpretation has a different row or source scope')
    config = read(Path(os.environ['FAITHFULNESS_AUDIT_CONFIG']))
    receipt_relative = args.interpretation.resolve().relative_to(root).as_posix()
    if receipt_relative not in config['lean']['environment_files']:
        raise ValueError('receipt was not an environment-bound input to this audit')
    if not any('interpretation-qualified' in f.get('category', '') for f in decision['findings']):
        raise ValueError('audit does not explicitly qualify its acceptance by interpretation')
    source_sha = hashlib.sha256((output / 'agent_outputs/source_contract.json').read_bytes()).hexdigest()
    qualification = ('This contract is audited only under the explicit user-adopted interpretation, recorded at '
        + receipt_relative + ' (SHA-256 ' + receipt_sha + '). '
        + 'The original source-only contract and its ambiguity remain preserved (SHA-256 ' + source_sha + '). ')
    contract['statement'] = qualification + 'Original source account: ' + contract['statement']
    contract['assumptions'] += ['Adopted interpretation: ' + x for x in interpretation['adopted_interpretation']]
    contract['assumptions'] += ['Preserved limitation: ' + x for x in interpretation['limitations']]
    contract['assumptions'] += ['Exact user reply: ' + interpretation['answer']]
    if args.rebind and row['contract_hash'] != checker.canonical_sha256(contract):
        raise ValueError('rebind would change the interpreted contract')
"""+needle
assert needle in text;text=text.replace(needle,new)
text=text.replace('Project the validated independent source contract from the immutable successor audit; retain its full source evidence, conventions and ambiguities in the sealed output.','Project the validated independent source account together with the separately environment-bound, explicitly scoped user interpretation. Acceptance is qualified by that interpretation; the PDF-only ambiguity and original role outcomes remain unchanged.')
text=text.replace("Final PASS projects the accepted sealed conclusion, including adjudication when required;", "Final PASS is explicitly qualified by user interpretation SHA-256 {receipt_sha}, and projects the accepted sealed conclusion, including adjudication when required;")
p=S/'bind-interpreted-proved-row.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
record={'base_sha256':hashlib.sha256(old.encode()).hexdigest(),'derived_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'scope':'Session-local gate projection; sealed audit inputs, decisions, gate schema, and released validators unchanged. Adds scoped environment-bound user receipt and preserved source ambiguity to structured contract; rebind refuses a changed contract.'}
(S/'interpreted-gate-adapter-derivation.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
