"""Add an explicit proposed-gate input to the frozen v5 validator; do not run it."""
from pathlib import Path
import hashlib
import json

H = Path(__file__).resolve().parent
old = H / 'validate-closed-row-audits-v5.py'
assert hashlib.sha256(old.read_bytes()).hexdigest() == 'ad6791fe5786f1b5660713e62c798c8a03e51c0210b59b98fc6f0582ef9bb59b'
source = old.read_text(encoding='utf-8')
changes = [
    ("    args = parser.parse_args()\n", """    parser.add_argument('--gate-input', type=Path)
    parser.add_argument('--gate-input-sha256')
    args = parser.parse_args()
"""),
    ("    gate = read(gate_path)\n", """    require((args.gate_input is None) == (args.gate_input_sha256 is None),
            'proposal path and exact hash must be supplied together')
    proposal = None
    if args.gate_input is not None:
        require(args.validate, 'proposal validation requires --validate')
        selected_gate = args.gate_input.resolve()
        require(selected_gate.is_relative_to(root.resolve()) and selected_gate != gate_path.resolve(),
                'proposal must be separate repository evidence')
        require(sha(selected_gate) == args.gate_input_sha256, 'proposal hash mismatch')
        proposal = {'path': selected_gate.relative_to(root).as_posix(), 'sha256': sha(selected_gate)}
    else:
        selected_gate = gate_path
    gate = read(selected_gate)
"""),
    ("    print(json.dumps({'mode': 'released-complete-validation' if args.validate else 'inventory-only-not-validation',\n"
     "                      'closed_rows': len(rows), 'records': inventory}, indent=2))\n", """    if proposal is not None:
        require(sha(selected_gate) == proposal['sha256'], 'proposal changed during validation')
    result = {'mode': 'released-complete-validation' if args.validate else 'inventory-only-not-validation',
              'closed_rows': len(rows), 'records': inventory}
    if proposal is not None:
        result['validated_gate_input'] = proposal
        result['current_bindings'] = context['bindings']
    print(json.dumps(result, indent=2))
"""),
]
for before, after in changes:
    assert source.count(before) == 1
    source = source.replace(before, after)
new = H / 'validate-closed-row-audits-rebind.py'
with new.open('xb') as f:
    f.write(source.encode())
record = {'schema': 1, 'purpose': 'Separate proposed-gate validation; existing v5 checks unchanged.',
          'source': {'path': old.name, 'sha256': hashlib.sha256(old.read_bytes()).hexdigest()},
          'output': {'path': new.name, 'sha256': hashlib.sha256(new.read_bytes()).hexdigest()},
          'exact_replacements': [{'before': a, 'after': b} for a, b in changes],
          'validation_invoked': False, 'gate_mutated': False}
with (H / 'rebind-validator-derivation.json').open('xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record['output']))
