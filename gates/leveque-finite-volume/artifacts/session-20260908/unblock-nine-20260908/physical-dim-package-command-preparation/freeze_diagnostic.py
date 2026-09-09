"""Freeze only the actual limited diagnostic; no successful preparation claim."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json

P = Path(__file__).resolve().parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}
read = lambda path: json.loads(path.read_bytes())
children = [read(P / 'native01' / (name + '-exit.json')) for name in ('Defs', 'FTaylorSeries', 'ordinary', 'dossier')]
assert all(item['exit_code'] == 0 for item in children)
assert not (P / 'native01/receipt.json').exists()
for item in children:
    for stream in ('stdout', 'stderr'):
        rel = item[stream]['path'].split('/physical-dim-package-command-preparation/', 1)[1]
        assert sha(P / rel) == item[stream]['sha256']
lean = Path('C:/Users/qed_s/.elan/toolchains/leanprover--lean4---v4.29.0-rc3/src/lean')
source_inputs = [R / '.faithfulness-audit/scripts/common.py', R / '.faithfulness-audit/scripts/prepare_audit.py',
                 R / '.faithfulness-audit/scripts/declaration_dossier.lean', R / '.lake/packages/mathlib/lakefile.lean',
                 lean / 'Lean/Environment.lean', lean / 'Lean/Elab/Frontend.lean', lean / 'Lean/Shell.lean']
record = {'format': 'limited-package-command-runtime-diagnostic-1', 'frozen_at': datetime.now(timezone.utc).isoformat(),
          'status': 'DIAGNOSTIC_ONLY_IMPORT_RESOLUTION_UNSETTLED',
          'adapter_attempt': {'observed_tool_session': 85098, 'observed_process_exit_code': 1,
                              'failure': 'Final harness path-string assertion after four child exit-0 commands',
                              'child_commands_actual_zero': 4, 'fresh_dependency_selection_demonstrated': False},
          'runtime_observation_exit_code': 0,
          'files': [ref(path) for path in sorted(P.rglob('*')) if path.is_file()],
          'source_inputs': [ref(path) for path in source_inputs],
          'official_preparation': False, 'source_acceptance': False, 'new_helper_suite': False,
          'gate_mutation': False, 'canonical_mutation': False, 'git_mutation': False}
with (P / 'diagnostic-receipt.json').open('x', encoding='utf-8') as stream:
    stream.write(json.dumps(record, indent=2) + '\n')
print(json.dumps(ref(P / 'diagnostic-receipt.json')))
