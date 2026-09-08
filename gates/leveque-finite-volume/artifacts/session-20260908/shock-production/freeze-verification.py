"""Bind successful native build, every focused elaboration and all declarations."""
import hashlib
import json
from pathlib import Path
import re

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[4]
ALLOWED={'propext','Classical.choice','Quot.sound'}

def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def read_json(name):
    return json.loads((HERE/name).read_text(encoding='utf-8-sig'))

def check_record(record, expected):
    assert record['command']==expected, record
    assert record['exit_code']==0, record
    output=HERE/record['output']
    assert output.resolve().parent==HERE
    text=output.read_text(encoding='utf-8-sig')
    assert not re.search(r'\b(error|warning|sorryAx)\b',text), output
    return {**record,'output_sha256':digest(output)}

modules=read_json('modules.json')
before=read_json('files-before-check.json')
declarations=read_json('declarations.json')
assert len(modules)==10
assert len(before)==len(modules)
assert len(declarations)==56
source_names=[]
for row in before:
    path=REPO/row['path']
    assert digest(path)==row['sha256'], path
    body=path.read_text(encoding='utf-8')
    assert len(body.splitlines())==row['lines']
    assert row['lines']<=300
    namespace=re.search(r'^namespace (\S+)',body,re.MULTILINE).group(1)
    source_names += [namespace+'.'+m.group(2) for m in
                    re.finditer(r'^(def|theorem) ([A-Za-z0-9_]+)',body,re.MULTILINE)]
    # These reviewed files contain no nested comments or source-code string literals.
    code=re.sub(r'/-.*?-/', '', body, flags=re.DOTALL)
    code=re.sub(r'--[^\n]*', '', code)
    assert not re.search(r'\b(sorry|admit|axiom|unsafe|opaque)\b',code),path
    assert not re.search(r'set_option\s+(linter|debug|compiler)',code),path
    assert not re.search(r'(?m)[ \t]+$',body),path
    assert 'ShockContinuation' not in body
    assert not re.search(r'^import NumStability\.',body,re.MULTILINE)
    if '/Source/' not in row['path']:
        assert not re.search(r'^import .*\.Source\.',body,re.MULTILINE)
assert source_names==[d['name'] for d in declarations]
assert len(set(source_names))==len(source_names)
mapping=read_json('candidate-producer-map.json')
assert len(mapping)==54
assert all(row['producer'] in source_names for row in mapping.values())
assert set(source_names)-{row['producer'] for row in mapping.values()}=={
    'NumStability.huberFlux_not_affine',
    'NumStability.HuberShock.shockState_isRectangleConservationLawSolution'}

build=check_record(read_json('focused-build-first-exit.json'),
                   'lake build ComputationalMathematics.Source.LeVeque.Chapter01.NonlinearShockFormation')
focused=read_json('focused-exits.json')
assert len(focused)==len(before)
focused=[check_record(r,'lake env lean '+f['path']) for r,f in zip(focused,before)]
decl_exit=check_record(read_json('declarations-exit.json'),
                       'lake env lean gates/leveque-finite-volume/artifacts/session-20260908/shock-production/Declarations.lean')
output=(HERE/decl_exit['output']).read_text(encoding='utf-8-sig')
axioms={}
for match in re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",output):
    name=match.group(1)
    assert name not in axioms
    values=[a.strip() for a in (match.group(2) or '').split(',') if a.strip()]
    assert set(values)<=ALLOWED,(name,values)
    axioms[name]=values
assert set(axioms)==set(source_names)
for name in source_names:
    assert re.search(r'^'+re.escape(name)+r'(?:\s|\.|:)',output,re.MULTILINE),name

scratch=HERE.parent/'shock-continuation'
assert digest(scratch/'candidate.lean')=='ba18e8fc4caadc0d6e46128bb09d1e4a34cf873d59e25676241f4b5389854027'
assert digest(scratch/'final-verification.json')=='75b99985a415ab7b9e5cb15c319a1e138a856a2258ff41062611ae88ef7f1a57'
assert digest(scratch/'balance-fourth-elaboration.txt')=='3401adc5d0ea2a25415ed26f887840afe196b6af05c438ef85a9ceddc11a402d'
report=(HERE/'extraction-review.md').read_text(encoding='utf-8')
assert 'Verification is pending' not in report
evidence=['modules.json','candidate-producer-map.json','declarations.json','Declarations.lean',
          'files-before-check.json','focused-exits.json','declarations-exit.json',
          'focused-build-first-exit.json','reuse-searches.json','piecewise-producer-search.json',
          'extraction-review.md','extract.py','prepare-checks.py','run-focused-checks.ps1',
          'freeze-verification.py']
rectangle=REPO/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/Rectangle.lean'
receipt={
    'schema':'leveque-ch01-production-extraction-verification-1',
    'source_pdf_sha256':'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
    'workflow_tag':'formalization-workflow-v5.0.1',
    'workflow_commit':'7d9cbf158607ace1c94d9ce13e26106c43e12a23',
    'stage':'leveque-chapter01-codex-20260908',
    'working_directory':str(REPO),'files':before,'build':build,'focused':focused,
    'declaration_check':decl_exit,'declarations':declarations,'axioms':axioms,
    'public_theorem_count':sum(d['kind']=='theorem' for d in declarations),
    'definition_count':sum(d['kind']=='def' for d in declarations),
    'evidence_sha256':{p:digest(HERE/p) for p in evidence},
    'lean_toolchain':(REPO/'lean-toolchain').read_text(encoding='utf-8').strip(),
    'lake_manifest_sha256':digest(REPO/'lake-manifest.json'),
    'shared_rectangle_source_sha256':digest(rectangle),
    'frozen_scratch_unchanged':True,
    'source_faithfulness_audit':False,'gate_row_closure':False,
    'full_library_and_compatibility_build':False,'umbrella_and_tier_integration':False,
    'git_integration':False,'full_spacetime_entropy_inequality':False,
    'scope':'New semantic producers and thin source existential; coordinator owns remaining audits and integration.'}
target=HERE/'final-verification.json'
target.write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n',encoding='utf-8')
print(json.dumps({'status':'PASS','receipt':str(target),'sha256':digest(target),
                  'modules':len(modules),'theorems':receipt['public_theorem_count'],
                  'definitions':receipt['definition_count']},indent=2))
