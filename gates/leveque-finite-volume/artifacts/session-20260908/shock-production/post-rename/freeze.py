"""Freeze the post-rename producers without overwriting any pre-rename evidence."""
import hashlib
import json
from pathlib import Path
import re

HERE=Path(__file__).resolve().parent
PRE=HERE.parent
SESSION=PRE.parent
REPO=PRE.parents[4]
ALLOWED={'propext','Classical.choice','Quot.sound'}

def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read_json(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def record(base,row,command):
    assert row['command']==command
    assert row['exit_code']==0
    output=base/row['output']
    assert output.resolve().parent==base
    text=output.read_text(encoding='utf-8-sig')
    assert not re.search(r'\b(error|warning|sorryAx)\b',text)
    return {**row,'output_path':output.relative_to(SESSION).as_posix(),
            'output_sha256':digest(output)}

files=read_json(HERE/'files-before-check.json')
decls=read_json(HERE/'declarations.json')
before=read_json(PRE/'files-before-check.json')
assert len(files)==10 and len(decls)==56
rename=read_json(SESSION/'production-rename-receipt.json')
lookup={r['path']:r for r in rename['files']}
for row in files:
    path=REPO/row['path']
    assert digest(path)==row['sha256']==lookup[row['path']]['sha256']
    body=path.read_text(encoding='utf-8')
    assert len(body.splitlines())==row['lines']<=300
    code=re.sub(r'/-.*?-/', '', body, flags=re.DOTALL)
    code=re.sub(r'--[^\n]*', '', code)
    assert not re.search(r'\b(sorry|admit|axiom|unsafe|opaque)\b',code)
    assert not re.search(r'set_option\s+(linter|debug|compiler)',code)
    assert not re.search(r'(?m)[ \t]+$',body)
    assert '.ConservationLaw.' not in body and 'ShockContinuation' not in body
    if '/Source/' not in row['path']:
        assert not re.search(r'^import .*\.Source\.',body,re.MULTILINE)
old_focused=read_json(PRE/'focused-exits.json')
assert len(old_focused)==10
reused=[]
for old,new,rec in zip(before[:4],files[:4],old_focused[:4]):
    assert old==new
    reused.append(record(PRE,rec,'lake env lean '+new['path']))
post_focused=read_json(HERE/'focused-exits.json')
assert len(post_focused)==6
focused=[record(HERE,r,'lake env lean '+f['path']) for r,f in zip(post_focused,files[4:])]
build=record(HERE,read_json(HERE/'focused-build-exit.json'),
             'lake build ComputationalMathematics.Source.LeVeque.Chapter01.NonlinearShockFormation')
check=record(HERE,read_json(HERE/'declarations-exit.json'),
             'lake env lean gates/leveque-finite-volume/artifacts/session-20260908/shock-production/post-rename/Declarations.lean')
text=(HERE/'declarations-output.txt').read_text(encoding='utf-8-sig')
axioms={}
for m in re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",text):
    assert m.group(1) not in axioms
    axioms[m.group(1)]=[x.strip() for x in (m.group(2) or '').split(',') if x.strip()]
assert set(axioms)=={d['name'] for d in decls}
assert all(set(x)<=ALLOWED for x in axioms.values())
for d in decls:
    assert re.search(r'^'+re.escape(d['name'])+r'(?:\s|:)',text,re.MULTILINE)
mapping=read_json(HERE/'candidate-producer-map.json')
assert len(mapping)==54
assert all(x['producer'] in axioms for x in mapping.values())
assert set(axioms)-{x['producer'] for x in mapping.values()}=={
    'NumStability.huberFlux_not_affine',
    'NumStability.HuberShock.shockState_isRectangleConservationLawSolution'}
for path,sha in rename['existing_owners_unchanged'].items():
    assert digest(REPO/path)==sha
scratch=SESSION/'shock-continuation'
assert digest(scratch/'candidate.lean')=='ba18e8fc4caadc0d6e46128bb09d1e4a34cf873d59e25676241f4b5389854027'
assert digest(scratch/'final-verification.json')=='75b99985a415ab7b9e5cb15c319a1e138a856a2258ff41062611ae88ef7f1a57'
assert 'Verification is pending' not in (HERE/'extraction-review.md').read_text(encoding='utf-8')
evidence=['modules.json','candidate-producer-map.json','files-before-check.json','declarations.json',
          'Declarations.lean','focused-exits.json','focused-build-exit.json','declarations-exit.json',
          'extraction-review.md','prepare.py','run-focused.ps1','freeze.py']
receipt={
    'schema':'leveque-ch01-production-extraction-verification-2',
    'source_pdf_sha256':'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5',
    'workflow_tag':'formalization-workflow-v5.0.1','workflow_commit':'7d9cbf158607ace1c94d9ce13e26106c43e12a23',
    'stage':'leveque-chapter01-codex-20260908','files':files,'declarations':decls,'axioms':axioms,
    'build':build,'reused_unchanged_file_checks':reused,'post_rename_file_checks':focused,
    'declaration_check':check,'public_theorem_count':49,'definition_count':7,
    'evidence_sha256':{x:digest(HERE/x) for x in evidence},
    'pre_rename_evidence_sha256':{x:digest(PRE/x) for x in
       ['reuse-searches.json','piecewise-producer-search.json','pre-rename-parent-file-scan.json',
        'files-before-check.json','focused-exits.json','declarations-exit.json','declarations-output.txt']},
    'rename_receipt_sha256':digest(SESSION/'production-rename-receipt.json'),
    'shared_rectangle_source_sha256':digest(REPO/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean'),
    'lean_toolchain':(REPO/'lean-toolchain').read_text(encoding='utf-8').strip(),
    'lake_manifest_sha256':digest(REPO/'lake-manifest.json'),
    'frozen_scratch_and_existing_owners_unchanged':True,
    'source_faithfulness_audit':False,'gate_row_closure':False,
    'full_library_and_compatibility_build':False,'umbrella_and_tier_integration':False,
    'git_integration':False,'full_spacetime_entropy_inequality':False}
target=HERE/'final-verification.json'
target.write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n',encoding='utf-8')
print(json.dumps({'status':'PASS','sha256':digest(target),'receipt':str(target),
                  'theorems':49,'definitions':7},indent=2))
