"""Record actual checked repair work without closing an unaudited source row."""
from pathlib import Path
import hashlib, json, os
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def immutable(p,obj):
    with p.open('xb') as stream:stream.write((json.dumps(obj,indent=2,ensure_ascii=False)+'\n').encode())
pins={
 'physical-refinement-quality-draft/receipt.json':'a5c1d551824c655a666bb1a710ea7672b4f375373daee1546b3482f053b47ee1',
 'physical-zero-quality-draft/receipt.json':'e889b24fa890869d4e550ed10bdd87e7938b775d676db5a9c256261a4a9a8736',
 'physical-admitted-high-resolution-sweep/receipt.json':'4a85f2ba726e00008c29783f55b3d87005754cf813b77f340948309d78caf153',
 'physical-zero-refinement-witness/receipt.json':'5511d3fed5c9f656080fea03040b0a3eb95b5a20d502c103b08d098722b7139d',
 'physical-refinement-joint-primary/receipt.json':'dd91c1d55da7dda077e61244131d1ff29832c5e5a08c8f11ebd0f4ec4f0ce6e7',
 'physical-production-promotion/five-owner-placement/receipt.json':'2227c1f334d0afe41a2522e4fd1e58715004558a3c8a621a9592933170e505d8',
 'physical-dim-promotion-review/mapping.json':'37d6e19cca93d27e70267ed2702ea11a6e53af907256f8c418b7299cf0b20a4b'}
for name,digest in pins.items():assert sha(D/name)==digest,name
buildpath=D/'physical-production-promotion/five-owner-native-01-receipt.json'
build=read(buildpath)
assert build['actual_exit_code']==0 and build['sources_unchanged']
for item in build['input_sources']:assert sha(R/item['path'])==item['sha256']
assert sha(R/build['output']['path'])==build['output']['sha256']
admitted=read(D/'physical-admitted-high-resolution-sweep/receipt.json')
assert admitted['actual_exit_code']==0 and admitted['total_axiom_reports']==61
joint=read(D/'physical-refinement-joint-primary/receipt.json')
assert joint['status']=='FROZEN_NATIVE_VERIFIED' and joint['allowed_report_count']==77
assert not joint['source_acceptance']
book=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
assert sha(book)=='c3211cde643c9152ddc5027ca4615b8b3345697ea229a3e4818f840f2177a042'
assert sha(process)=='aa7c04f5c385b08aeaabe0966ae551fd5a28cacc568dc2a588d5c1fb807d6283'
gatepath=R/'gates/leveque-finite-volume/chapter-01.json'
assert sha(gatepath)=='3fa3457bc44edeb8f3e6e3c3f8075cf5c1bcb6a7377edb5d1e7bc02172d5dcf8'
before=gatepath.read_bytes()
gate=json.loads(before)
oldrows=json.loads(json.dumps(gate['rows']))
out=D/'physical-quality-and-primary-milestone'
out.mkdir()
diagnosis={'format':'physical-quality-and-primary-milestone-1',
 'checked_receipts':[ref(D/name) for name in pins], 'actual_five_owner_build':ref(buildpath),
 'generic_quality':'Fixed measured family, actual refining mesh diameters, nonempty inputwise admitted positive steps, shared all-level accuracy certificates, genuine C-infinity references and quantitative once-edge variation; stability separate.',
 'source_primary':'Actual selected positive within-horizon admitted substeps are required; total construction and conditional stability/error analysis remain separate.',
 'joint_applicability':'Entire admitted primary applied at every growing Cartesian level to the complete zero-flux quality family, with nonconstant smooth physical reference, measured boundary data and same-data Cartesian identification.',
 'geometry_scope':'Supplied measured directional balance systems under Q10; no independent continuum-PDE equivalence inferred from tensor/normal data.',
 'canonical_change':'Exactly five reviewed C-infinity/choice copies placed and genuinely rebuilt; new physical owner placement and canonical comparison checks are next.',
 'source_acceptance':False,'newly_closed_rows':0,
 'pending_riemann_interpretation':'Unanswered representative/certificate question preserved; no answer inferred.'}
immutable(out/'diagnosis.json',diagnosis)
loc=(out/'diagnosis.json').relative_to(R).as_posix()+' SHA256 '+sha(out/'diagnosis.json')
entries={
book:'| LEV-C1-PHYSICAL-QUALITY-ADMITTED-PRIMARY-113 | LEV-CH01-DIMENSIONAL-SPLITTING | Checked replacement physical-reference contract | The original accepted convention needs explicit whole-family accuracy, discontinuity admission and valid executed substeps; the old source audit remains unaccepted | The replacement core quality and admitted source primary compile, and the entire primary has a joint growing Cartesian-family application with a nonconstant smooth reference and measured boundary data | IN_PROGRESS; source acceptance still pending | '+loc+' | Generic references describe the supplied measured directional balances. Stability is separate; no continuum reconstruction or new interpretation is inferred. Promote checked owners and run a fresh independent audit. |',
process:'| LEV-SKILL-PHYSICAL-PRIMARY-AND-REGULARITY-PLACEMENT-098 | codex-start-1-v5-0-1-20260908 | Native repair and guarded canonical placement | Nominal scratch interfaces and actual current library consumers must be distinguished | Preserve the 61-report admitted-primary and 77-report joint native evidence; place exactly the five reviewed regularity/choice copies and run the actual native build | Native checks COMPLETE; canonical physical promotion and audit ACTIVE | '+loc+' | Old frozen packets retain their historical source pins. New current source hashes are recorded separately; native success is not source acceptance and no failed attempt is relabeled. |'}
receipt={'diagnosis':ref(out/'diagnosis.json'),'ledgers':[]}
for path,entry in entries.items():
    data=path.read_bytes()
    assert data.endswith(b'\n') and entry.split('|')[1].strip().encode() not in data
    with path.open('ab') as stream:stream.write((entry+'\n').encode())
    assert path.read_bytes().startswith(data)
    receipt['ledgers'].append({'before_sha256':hashlib.sha256(data).hexdigest(),'after':ref(path)})
for row in gate['rows']:
    if row['id']=='LEV-CH01-DIMENSIONAL-SPLITTING':
        assert row['status']=='IN_PROGRESS'
        row['current_target']='Promote the checked admitted physical high-resolution source primary and its complete joint refining Cartesian-family consumer.'
        row['next_action']='Place reusable capacity, mesh, boundary, quality and sweep owners; preserve lookup API compatibility; rebuild and compare canonical contracts, freeze current fingerprints and context, then run a fresh complete independent source audit.'
assert sum(row['status'] in {'PROVED','REUSED'} for row in gate['rows'])==39
for old,new in zip(oldrows,gate['rows']):
    if old['id']!='LEV-CH01-DIMENSIONAL-SPLITTING':assert old==new
    else:assert {k:v for k,v in old.items() if k not in {'current_target','next_action'}}=={k:v for k,v in new.items() if k not in {'current_target','next_action'}}
immutable(out/'gate-before.json',json.loads(before))
after=(json.dumps(gate,indent=2,ensure_ascii=False)+'\n').encode()
with (out/'gate-after.json').open('xb') as stream:stream.write(after)
assert gatepath.read_bytes()==before
temp=gatepath.with_name('chapter-01.physical-primary.tmp')
with temp.open('xb') as stream:stream.write(after)
os.replace(temp,gatepath)
receipt['gate']={'before_sha256':hashlib.sha256(before).hexdigest(),'after':ref(gatepath),
 'changed_rows':['LEV-CH01-DIMENSIONAL-SPLITTING'],'closed_rows_preserved':39,'newly_closed_rows':0}
immutable(out/'receipt.json',receipt)
print(json.dumps(receipt,indent=2))
