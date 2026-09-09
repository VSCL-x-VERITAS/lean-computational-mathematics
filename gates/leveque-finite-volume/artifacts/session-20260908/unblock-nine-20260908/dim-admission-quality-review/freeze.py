from pathlib import Path
import datetime, hashlib, json
h = Path(__file__).resolve().parent
r = next(p for p in h.parents if (p/'lean-toolchain').is_file())
d = h.parent
def read(p): return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
    b=read(p); return {'path':str(p.relative_to(r)), 'sha256':hashlib.sha256(b).hexdigest(), 'bytes':len(b)}
def write(name,obj):
    p=h/name
    if p.exists(): raise SystemExit('Refusing overwrite: '+str(p))
    p.write_text(json.dumps(obj,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
f=d.parent/'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness'
evidence=[f/'agent_outputs/direct_judge.json', f/'agent_outputs/roundtrip_judge.json',
 d/'user-high-resolution-interpretation-20260908.json',
 d/'physical-capacity-line-bridge/manifest.json',d/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean',
 d/'dim-blind-evidence-repair/final-receipt.json',d/'dim-two-direction-joint-witness/final-receipt.json']
for name in ['RefiningLineMethod','CoordinateLineMethodEstimates','CoordinateLineMethod','HighResolutionCoordinateSweep']:
 evidence.append(r/f'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/{name}.lean')
evidence.append(r/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean')
assert ref(d/'user-high-resolution-interpretation-20260908.json')['sha256']=='5acb2c9f38bdbb4eda50c8495c51d600f4a007caec1a17b43339f81271cd3f0a'
assert ref(d/'physical-capacity-line-bridge/manifest.json')['sha256']=='39a08aa44e0241d08a6c85c7ae57f10ee3f88623d062906554c0d3f184dc7c62'
write('evidence.json',{'captured_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'references':[ref(p) for p in evidence], 'adjudication_present_at_freeze':(f/'agent_outputs/adjudication.json').is_file(),
 'status':'Proposal based on completed direct/roundtrip records, not a replacement final audit judgment.',
 'next_authorized_slice':'Artifact-only time-step-dependent inputwise availability and CFL-one instance; no production placement.'})
write('manifest.json',{'format':'admission-quality-review-manifest-1','files':[ref(p) for p in sorted(h.iterdir()) if p.is_file()]})
write('receipt.json',{'format':'admission-quality-review-receipt-1','created_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'status':'FROZEN implementation proposal, no native proof or source acceptance claimed',
 'manifest':ref(h/'manifest.json'),'review':ref(h/'REVIEW.md'),'source_doc_proposal':ref(h/'SOURCE-DOC-PROPOSAL.md'),
 'evidence':ref(h/'evidence.json'),'production_changes':False,'gate_changes':False,'audit_launched':False})
print(json.dumps({'receipt':ref(h/'receipt.json'),'manifest':ref(h/'manifest.json'),'review':ref(h/'REVIEW.md')},indent=2))
