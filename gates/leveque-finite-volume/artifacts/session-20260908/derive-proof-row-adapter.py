"""Derive a proof-checked gate adapter from the reviewed reuse adapter."""
from pathlib import Path
S=Path(__file__).resolve().parent
text=(S/"close-reused-row.py").read_text(encoding="utf-8")
def replace(old,new):
 global text
 assert text.count(old)==1, (old,text.count(old))
 text=text.replace(old,new)
replace('"""Bind a completed, validated successor audit to one integrated reused row.',
 '"""Bind an independently accepted audit to an exact newly proved producer.')
replace("    parser.add_argument('--resolution-log', type=Path, required=True)",
"""    parser.add_argument('--resolution-log', type=Path, required=True)
    parser.add_argument('--resolution-exit', type=Path, required=True)
    parser.add_argument('--resolution-manifest', type=Path, required=True)
    parser.add_argument('--check-file', type=Path, required=True)""")
replace("        raise ValueError('ordinary reuse adapter requires an accepted equivalent audit')",
 "        raise ValueError('ordinary proof adapter requires an accepted equivalent audit')")
replace("""    subprocess.run(['git', 'cat-file', '-e', baseline + ':' + task['target']['path']], cwd=root, check=True)
    subprocess.run(['git', 'diff', '--exit-code', baseline, '--', task['target']['path']], cwd=root, check=True)""",
"""    target = root / task['target']['path']
    manifest = read(args.resolution_manifest)
    matches = [f for f in manifest['files'] if f['path'] == task['target']['path']]
    if len(matches) != 1 or matches[0]['sha256'] != hashlib.sha256(target.read_bytes()).hexdigest():
        raise ValueError('proof manifest does not bind the exact current target bytes')
    if declaration not in matches[0]['declarations']:
        raise ValueError('proof manifest does not enumerate the selected declaration')
    check_bytes = args.check_file.read_bytes()
    if hashlib.sha256(check_bytes).hexdigest() != manifest['check_file_sha256']:
        raise ValueError('declaration check file differs from the proof manifest')
    check_text = check_bytes.decode('utf-8-sig')
    for line in ('#check ' + declaration, '#print axioms ' + declaration):
        if line not in check_text.splitlines():
            raise ValueError('check input omits selected declaration: ' + line)
    exit_record = read(args.resolution_exit)
    if exit_record.get('exit_code') != 0 or isinstance(exit_record.get('exit_code'), bool):
        raise ValueError('declaration check did not complete successfully')
    expected_command = 'lake env lean ' + args.check_file.resolve().relative_to(root).as_posix()
    if exit_record.get('command') != expected_command:
        raise ValueError('exit receipt names a different declaration check')
    if re.search(r'(?m)^.*\\.lean:\\d+:\\d+: error:', resolution):
        raise ValueError('declaration output contains a Lean error')
    index_bytes = subprocess.check_output(['git', '-c', 'core.longpaths=true',
        'show', ':' + task['target']['path']], cwd=root)
    if index_bytes != target.read_bytes():
        raise ValueError('target must have exact staged bytes before gate binding')
    resolution_manifest_sha = hashlib.sha256(args.resolution_manifest.read_bytes()).hexdigest()
    resolution_exit_sha = hashlib.sha256(args.resolution_exit.read_bytes()).hexdigest()""")
replace("        raise ValueError('row is not an open audited-reuse candidate')",
 "        raise ValueError('row is not an open audited-proof candidate')")
replace("""        'status': 'REUSED', 'lean_declarations': [declaration],
        'reuse_source': f"Integrated baseline {baseline}; unchanged {task['target']['path']}::{declaration}",
        'reuse_audit': f"Fresh complete-phase validated {task['task_id']}; {task['audit_output']}/decision.json",""",
"""        'status': 'PROVED', 'lean_declarations': [declaration],""")
replace("    binding_dir = task_path.parent / 'gate-bindings' / binding['row_subject_sha256']",
 "    binding_dir = task_path.parent / 'gate-bindings' / checker.canonical_sha256(binding)")
replace("    binding = checker.row_artifact_bindings(row, 1, context)",
"""    if decision.get('adjudicated') is True:
        row['adjudication_required'] = True
        row['adjudication_status'] = 'resolved'
        row['adjudication_audit'] = ('The complete sealed decision accepts both directions after fresh independent adjudication. '
            + (output / 'decision.json').relative_to(root).as_posix()
            + '; original direct/roundtrip classifications: ' + str(decision.get('judge_classifications', {})))
    binding = checker.row_artifact_bindings(row, 1, context)""")
replace("declaration/axiom output SHA-256 {resolution_sha}. {decision['rationale']}",
 "declaration/axiom output SHA-256 {resolution_sha}; exact proof-input manifest SHA-256 {resolution_manifest_sha}; successful native exit receipt SHA-256 {resolution_exit_sha}. Final PASS projects the accepted sealed conclusion, including adjudication when required; original role outcomes remain unchanged. {decision['rationale']}")
replace("    prior = binding_dir / 'prior-gate.json'",
 "    prior = binding_dir / ('prior-gate-' + hashlib.sha256(original_bytes).hexdigest() + '.json')")
replace("print(json.dumps({'row': args.row, 'status': 'REUSED', 'declaration': declaration,",
 "print(json.dumps({'row': args.row, 'status': 'PROVED', 'declaration': declaration,")
(S/"close-audited-proved-row.py").write_text(text,encoding="utf-8",newline="\n")
print("Created close-audited-proved-row.py; not executed against any gate.")
