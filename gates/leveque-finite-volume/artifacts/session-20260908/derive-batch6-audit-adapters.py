"""Add narrowly scoped successors; never modify a released or frozen adapter."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
records=[]
parent=S/'validate-closed-row-audits.py'
assert sha(parent)=='6ee00aee77c5e3ed323d13114f4c032a53ee2dfb9db1db73984f0af436fedfda'
text=parent.read_text(encoding='utf-8')
text=text.replace('the exact pinned smooth-bridge applicability and native nonvacuity evidence.','the exact pinned smooth-bridge or production applicability and native nonvacuity evidence.')
needle="    read, sha, require = stronger.read, stronger.sha, stronger.require\n"
addition="""    production_path = session / 'bind-audited-stronger-production-rows.py'
    require(sha(production_path) == '2b6e6d26931f831970479cfdae30f066d3712586363ef08e6ce0b830306782d6',
            'Pinned production stronger checker changed')
    pspec = importlib.util.spec_from_file_location('production_stronger_checks', production_path)
    production = importlib.util.module_from_spec(pspec)
    require(pspec.loader is not None, 'Missing production evidence loader')
    pspec.loader.exec_module(production)
"""
assert text.count(needle)==1;text=text.replace(needle,needle+addition)
needle="            stronger.validate_strengthening_evidence(root, task_path, task, manifest, decision,\n                                                     evidence_path, row=row)"
assert text.count(needle)==1
text=text.replace(needle,"            selected = stronger if row['id'] == stronger.ROW_ID else production\n            selected.validate_strengthening_evidence(root, task_path, task, manifest, decision,\n                                                     evidence_path, row=row)")
text=text.replace('stronger.DECISION_SHA in adjudication',"sha(output / 'decision.json') in adjudication").replace('stronger.EVIDENCE_SHA in adjudication','sha(evidence_path) in adjudication')
dest=S/'validate-closed-row-audits-v2.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(text)
records.append({'parent':parent.name,'parent_sha256':sha(parent),'successor':dest.name,'successor_sha256':sha(dest),'changes':'Dispatch only the pinned two production stronger tasks in addition to the unchanged smooth-bridge checker; preserve all released complete-validation and ordinary row checks.'})
parent=S/'bind-discontinuity-interpreted-proved-row.py'
assert sha(parent)=='772e16c50f09b023d96ce9addf8ff7506eec85379f9791231e947f755cca1186'
text=parent.read_text(encoding='utf-8')
needle="or args.row != 'LEV-CH01-DISCONTINUITY-INTEGRAL-LAW'"
assert text.count(needle)==1;text=text.replace(needle,"or args.row != 'LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION'")
needle="    decision = read(output / 'decision.json')\n"
extra="""    if (task['task_id'] != 'LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'
        or task['target'] != {'path': 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation10RectangleConservation.lean', 'declaration': 'NumStability.leveque01_equation10_rectangleConservation_iff_integrated_and_ae_rate'}
        or hashlib.sha256((output / 'decision.json').read_bytes()).hexdigest() != 'eb47998419d4a3ffed864a3df8abe133d9865083b808df11d0c28d0171ccf9cf'
        or hashlib.sha256((output / 'manifest.json').read_bytes()).hexdigest() != '3b740c98cc7db21d3870e3552d13b235e4b619fb031387b37a47b5278e8716c9'):
        raise ValueError('Only the exact interpreted equation (1.10) successor audit is supported')
"""
assert text.count(needle)==1;text=text.replace(needle,needle+extra)
text=text.replace('exact recorded discontinuity reply and row','exact recorded reply for the discussion around equation (1.10) and the equation row')
dest=S/'bind-equation10-interpreted-proved-row.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(text)
records.append({'parent':parent.name,'parent_sha256':sha(parent),'successor':dest.name,'successor_sha256':sha(dest),'changes':'Select only the pinned equation (1.10) task/target/decision/manifest. Preserve the user receipt bytes and its original around-equation scope, native proof checks, qualified contract, preserved ambiguity and unchanged sealed validator.'})
p=S/'batch6-audit-adapter-derivations.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps({'schema':1,'records':records},indent=2)+'\n')
print(json.dumps({'records':records,'derivation_sha256':sha(p)}))
