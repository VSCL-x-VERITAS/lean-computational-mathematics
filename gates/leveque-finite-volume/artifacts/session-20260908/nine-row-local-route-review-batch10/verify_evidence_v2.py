"""Read-only byte verification of bounded nine-row evidence. Writes only this new packet."""
from pathlib import Path
import hashlib,json,datetime,re,sys
HERE=Path(__file__).resolve().parent
SESSION=HERE.parent
ROOT=SESSION.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
seeds={
 'prospective-source-choice-boundaries-batch10-v2.json':'99fb785787ccfe7906b95ff0dc1d4d774bcd664673cc3c7c9323e9d29ae2c0c3',
 'root-information-interface-capstone-verification.json':'e79470bf889dc1b0e3382c9fbef278b997eee463ffc943664677621ab2654dcb',
 'root-information-coordinate-sweep-verification.json':'19755c0bac4ac2ffa0d5b81ed02023ad1239a8a1ba63a5eea6e802f438e5fb8f',
 'prospective-source-choice-boundaries-batch10.json':'29454cddf004123bf48c1262d1cc55a7e5a88ed51fc85249c26f7ee2e426db7f',
 'information-coordinate-sweep-draft/manifest.json':'f97788bf1565c46bd16b1a6a961f4ea2c417d1568192be96373a771acb45148f',
 'information-coordinate-sweep-draft/final-receipt.json':'9874960cb0e89b2445ab9a52f1950631a03e3736a7c264da3a7cf58394395229',
 'information-interface-capstone-draft/manifest.json':'ed0061a2dd7da789aa3185c343ad30666611f435b3e11350a2ce060912d3db8c',
 'information-interface-capstone-draft/final-receipt.json':'9ccb09671a50823c688a436bfbd3da4903e8c634d40c82697d75037ef159e65a',
 'current-thread-question-provenance-v2-batch10/projection.json':'15f55c43d5d3c50134b1861d82231e953c6644db4cd30561d0644640b3e11acc',
 'prospective-density-material-riemann-capstones-draft/evidence-manifest.json':None,
 'prospective-density-material-riemann-capstones-draft/capstones-final-03.receipt.json':None,
 'prospective-density-material-riemann-capstones-draft/measure-final-02.receipt.json':None,
 'prospective-eigen-fv-qualification-review/inputs.json':None,
 'prospective-eigen-fv-qualification-review/verification.json':None,
 'fv-update-capstone-draft/final-receipt.json':None,
 'left-mode-domain-draft/final-receipt.json':None,
 'cell-volume-average-production/final-receipt.json':None,
 'information-coordinate-sweep-draft/full04-exit.json':None,
 'information-interface-capstone-draft/native-05.receipt.json':None,
}
refs={}
def resolve(value):
 value=value.replace('\\','/')
 if value.startswith('/c/'):value='C:/'+value[3:]
 p=Path(value)
 return p if p.is_absolute() else ROOT/p

def add(value,expected,origin):
 if not isinstance(value,str) or not isinstance(expected,str) or not re.fullmatch('[0-9a-f]{64}',expected):return
 local_origins={'prospective-eigen-fv-qualification-review/verification.json','prospective-density-material-riemann-capstones-draft/capstones-final-03.receipt.json','prospective-density-material-riemann-capstones-draft/measure-final-02.receipt.json'}
 p=(SESSION/origin).parent/value if origin in local_origins and '/' not in value and '\\' not in value else resolve(value)
 refs.setdefault((str(p),expected),set()).add(origin)

def collect(value,origin):
 if isinstance(value,dict):
  if 'path' in value and 'sha256' in value:add(value['path'],value['sha256'],origin)
  for key,item in value.items():
   if key in {'historical_candidate_resolutions','attempts'}:continue
   if key.endswith('_sha256'):
    sibling=value.get(key[:-7])
    if isinstance(sibling,str) and any(sibling.endswith(ext) for ext in ('.lean','.txt','.olean','.json','.pdf','.fragment')):add(sibling,item,origin)
   if ('/' in key or '\\' in key) and isinstance(item,str):add(key,item,origin)
   collect(item,origin)
 elif isinstance(value,list):
  for item in value:collect(item,origin)

seed_rows=[]
for name,expected in seeds.items():
 p=SESSION/name;actual=sha(p)
 assert expected is None or expected==actual,(name,'seed mismatch')
 seed_rows.append({'path':p.relative_to(ROOT).as_posix(),'sha256':actual})
 add(str(p),actual,'review seed')
 collect(json.loads(p.read_text(encoding='utf-8')),name)
# Explicit current contracts read by the reviewer; these are observations, not historical run inputs.
for name in ['left-mode-domain-draft/candidate.lean','fv-update-capstone-draft/Candidate.lean','prospective-density-material-riemann-capstones-draft/Capstones.lean','prospective-density-material-riemann-capstones-draft/MeasureSupplement.lean','prospective-density-material-riemann-capstones-draft/REVIEW.md','prospective-eigen-fv-qualification-review/QUALIFICATION.md','fv-update-capstone-draft/REVIEW.md','cell-volume-average-production/REVIEW.md','cell-volume-average-production/CheckDeclarations.lean','information-coordinate-sweep-draft/REVIEW.md','information-coordinate-sweep-draft/PLACEMENT-PLAN.md','information-coordinate-sweep-draft/Core.lean.fragment','information-coordinate-sweep-draft/Cartesian.lean.fragment','information-coordinate-sweep-draft/Witness.lean.fragment','information-interface-capstone-draft/REVIEW.md','information-interface-capstone-draft/Candidate.lean','information-interface-capstone-draft/ComparisonWitness.lean.fragment']:
 p=SESSION/name;add(str(p),sha(p),'reviewed source/contract')
for name in ['ComputationalMathematics/Source/LeVeque/Chapter01/EigenvaluePropagation.lean','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellVolumeAverage.lean']:
 p=ROOT/name;add(str(p),sha(p),'reviewed canonical source')
results=[]
for (value,expected),origins in sorted(refs.items()):
 p=Path(value);actual=sha(p) if p.is_file() else None
 results.append({'path':p.relative_to(ROOT).as_posix() if p.is_relative_to(ROOT) else str(p),'expected_sha256':expected,'actual_sha256':actual,'matches':actual==expected,'kind':'compiled-import' if p.suffix=='.olean' else 'source-or-evidence','origins':sorted(origins)})
# A second byte read detects concurrent changes of the same bounded set.
concurrent=[]
for item in results:
 p=resolve(item['path']);current=sha(p) if p.is_file() else None
 if current!=item['actual_sha256']:concurrent.append(item['path'])
report={'kind':'read-only-nine-row-evidence-byte-check','checked_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat().replace('+00:00','Z'),'seeds':seed_rows,'bindings':results,'binding_count':len(results),'mismatches':[x for x in results if not x['matches']],'concurrent_changes':concurrent,'new_lean_or_released_checks':'NOT_RUN; existing raw receipts are retained as historical execution evidence','faithfulness_or_exhaustion':'not assessed by this byte check','operational_writes':[]}
out=HERE/'evidence-verification-v2.json'
assert not out.exists()
out.write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'binding_count':len(results),'mismatches':report['mismatches'],'concurrent_changes':concurrent,'output_sha256':sha(out)},indent=2))
