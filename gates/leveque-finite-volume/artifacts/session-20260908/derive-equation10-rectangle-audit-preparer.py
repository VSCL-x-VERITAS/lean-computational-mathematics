"""Derive a fresh Eq. (1.10) audit setup; never modify the earlier audit."""
from pathlib import Path
import ast, hashlib, json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parent=S/'prepare-linear-riemann-measure-context.py'
assert sha(parent)=='bbb49165d428267a588fc37d412d0859ecf381d4ad112445dd5d87e7c8335387'
code=parent.read_text(encoding='utf-8')
changes=[]
def once(old,new):
 global code
 assert code.count(old)==1,(old,code.count(old))
 code=code.replace(old,new); changes.append(old)
old='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908'
task='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'
once("OLD = 'LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908'", "OLD = "+repr(old))
once("TASK = 'LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908'", "TASK = "+repr(task))
once("CONFIG = 'audit-linear-riemann-measure-context.config.json'", "CONFIG = 'audit-equation10-interpreted-rectangle.config.json'")
once("'manifest.json': 'bde8b0c0e3c257ee1f53c8d0477e31d0e1e5612cb6b4a832197794d1cf3772a7', 'decision.json': 'b525d59b4604c818a66ed4c9453e4a1cb26c42eda6862f2cdc09b7b7f6cd8094', 'report.md': '7b750e911256d672273b46955274a62e6ba2e75a30e9f5ca301b848a5e10209a'",
     "'manifest.json': 'ef3c6ce50c0a202acce5a2daa6b54b26f03c6c907227a0b962f86518dd29ab5d', 'decision.json': 'be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052', 'report.md': '70377c3770d33f792acbac049541d8b7812f798822888eba2a89f7de0c47f302'")
once("assert sha(R/task['target']['path'])=='9057f66a6ca85e9a164fcf8dbde7d12e251b264fd55cbf642323e48de1d6d8d8'",
 "assert sha(R/task['target']['path'])=='5dcc799b4e236870500f1c0d38dbe8ce5ae1a5a10be12e65a7e7320b1a3b4d13'\n"+
 "assert sha(S/'definition-repairs-production-verification.json')=='53b710615834dfb6522713c9c3b7489b56eeb55d8138497e1b130cb0314a86d5'\n"+
 "task['target']={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/Equation10RectangleConservation.lean','declaration':'NumStability.leveque01_equation10_rectangleConservation_iff_integrated_and_ae_rate'}\n"+
 "assert sha(R/task['target']['path'])=='b714622cdbb1ba1b36a8f64b7dc96199a82805043f8256728a4b1298257593e2'")
interpretation='''
user_receipt=S/'user-discontinuity-interpretation-20260908.json'
assert sha(user_receipt)=='b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
user=json.loads(user_receipt.read_bytes())
assert user['scope']=='Chapter 1 discontinuity discussion around equation (1.10), particularly LEV-CH01-DISCONTINUITY-INTEGRAL-LAW.'
writej(T/'user-interpretation-packet.json',{
 'format':'user-adopted-source-interpretation-1',
 'authority':'Existing explicit user instruction for the discontinuity discussion around equation (1.10). This selected task audits (1.10) under that recorded scope, not a new convention or a printed-source assertion.',
 'receipt':{'path':SR+'/user-discontinuity-interpretation-20260908.json','sha256':sha(user_receipt)},
 'exact_receipt_fields':user,
 'exact_source_preservation':'Keep the original printed source wording and ambiguity unchanged.',
 'comparison_rule':'Independently compare the exact selected equation (1.10) target and both implications under the recorded rectangle and intervalwise almost-everywhere mass-rate convention. Any acceptance must be qualified by that interpretation. Do not infer a requested verdict or silently extend this task to unrelated source rows.',
 'selection_provenance':'The complete exact user receipt is supplied by JSON value. No prior audit outcomes or review conclusions are supplied.'})
cfg['lean']['environment_files'] += [SR+'/user-discontinuity-interpretation-20260908.json',SR+'/audits/'+TASK+'/user-interpretation-packet.json']
'''
once("for p in cfg['lean']['environment_files']: assert (R/p).is_file(), p", interpretation+"\nfor p in cfg['lean']['environment_files']: assert (R/p).is_file(), p")
once("expected = {'r.py':'f46124b1d53e7cc45c94860eb991fd12fdf01b7298dc63e91dc500536e3cfbe1','c.py':'256a743ee7e693d146323b401e6a0f7316ef22ad345912225177dee03e5140e0','q.py':'4c9d73114aa5932b719679767e2589c0a8feb43bdafdbc2dd06e48bb1c087cb7'}",
 "ROLE_PARENT='LEV-CH01-DISCONTINUITY-INTERPRETED-GENERAL-PRODUCTION-20260908'\nexpected = {'r.py':'a1733ffb068317d8748a807a153e6de19e721ca75ccd2773d61e8f4556b56d9d','c.py':'a45b3653a4683e12f4620759c86a586967fcc6d136691473e67b9c02ba9f9344','q.py':'902bd45dcaaa7262e23de6f63f1bd7407f0372c82b05e10d45d78d965f98863d'}")
once("src = prior/'faithfulness/orchestration'/name", "src = S/'audits'/ROLE_PARENT/'faithfulness/orchestration'/name")
once(".replace(CONTEXT,TASK).replace('audit-transport-context.config.json',CONFIG)", ".replace(ROLE_PARENT,TASK).replace('audit-discontinuity-interpreted-general.config.json',CONFIG)")
once("'user_interpretation_supplied':False", "'user_interpretation_supplied':True")
once("'28': 'ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984'", "'26': 'c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d'")
once("'pages_argument':'23,25,27,28'", "'pages_argument':'23,25,26,27'")
ast.parse(code)
dest=S/'prepare-equation10-interpreted-rectangle.py'; assert not dest.exists()
dest.write_text(code,encoding='utf-8',newline='')
rec=S/'equation10-interpreted-preparer-derivation.json'; assert not rec.exists()
rec.write_text(json.dumps({'parent_sha256':sha(parent),'derived_sha256':sha(dest),'exact_replacements':changes,
 'roles_invoked':False,'preserved':'Released sealed v1 scripts, immutable source and locator, source-only extraction, fully masked blind packet, native measure evidence, isolated judge roles, actual exits, original audit artifacts.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'preparer':str(dest),'sha256':sha(dest),'derivation_sha256':sha(rec)}))
