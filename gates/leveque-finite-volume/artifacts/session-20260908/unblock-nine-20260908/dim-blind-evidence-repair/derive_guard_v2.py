from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent
s=(h/'analyze_and_guard.py').read_text(encoding='utf-8')
changes=[
 ('primary-promoted-03-output.txt','primary-two-owner-04-output.txt'),
 ('exact-mathlib-root','m'),
 ("'Mathlib.Analysis.Calculus.ContDiff.Defs'}","'Mathlib.Analysis.Calculus.ContDiff.Defs','Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries'}"),
 ("check('only one added local module',set(order)==expected)",
 "check('public-import parser boundary retained','Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries' not in order)\n"
 "future_source='import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries\\n'+(ROOT/manifest['target']['path']).read_text(encoding='utf-8')\n"
 "future_order,_,_=sealed.collect_local_imports(future_source,{'_module_source_roots':[ROOT,HERE/'m']})\n"
 "check('two-owner promotion discovered after explicit genuine dependency import',set(future_order)==expected)"),
 ('only the exact mirror module source root','the exact two-owner mirror module source root plus one explicit genuine FTaylorSeries import'),
]
for a,b in changes:
 assert a in s,a
 s=s.replace(a,b)
p=h/'analyze_and_guard_v2.py'
if p.exists():raise SystemExit('Refusing overwrite')
p.write_text(s,encoding='utf-8')
(h/'guard-v2-derivation.json').write_text(json.dumps({'source_sha256':hashlib.sha256((h/'analyze_and_guard.py').read_bytes()).hexdigest(),
 'output_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'exact_replacements':changes,
 'prior_shell_attempt':'PowerShell parser rejected a quoted inline derivation before execution; no files written by that attempt.'},indent=2)+'\n',encoding='utf-8')
