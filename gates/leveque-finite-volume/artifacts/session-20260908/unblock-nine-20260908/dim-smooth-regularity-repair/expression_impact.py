"""Exact explicit type/body edges from the already verified native archive."""
import gzip,hashlib,json,re
from pathlib import Path
P=Path(__file__).resolve().parent;D=P.parent;R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
def sha(b):return hashlib.sha256(b).hexdigest()
fp=D/'dim-high-resolution-fingerprints/additional-expression-fingerprints.json';data=json.loads(fp.read_bytes());archive=data['native_raw_archive'];p=R/archive['path']
assert sha(p.read_bytes())==archive['sha256'];known={r['name'] for r in data['records']};edges={};h=hashlib.sha256();size=0
with gzip.open(p,'rb') as f:
 for line in f:
  h.update(line);size+=len(line)
  if not line.strip():continue
  row=json.loads(line);name=row['name'];assert name in known and name not in edges
  text=str(row['type'])+' '+str(row['value'])+' '+str(row['recursor_values'])
  edges[name]=sorted(set(re.findall(r'Lean\.Expr\.const `([^\s]+)',text))&known)
assert set(edges)==known and h.hexdigest()==archive['uncompressed_sha256'] and size==archive['uncompressed_bytes']
old=json.loads((P/'impact.json').read_bytes());seeds=set(old['native_expression_direct_seeds']);seeds.add('NumStability.DirectionalLine.LineFamily.HasControlledHighResolution')
assert seeds<=known;affected=set(seeds)
while True:
 new=affected|{n for n,deps in edges.items() if set(deps)&affected}
 if new==affected:break
 affected=new
v={'status':'READ_ONLY_DEPENDENCY_DIAGNOSIS','native_inventory':{'path':fp.relative_to(R).as_posix(),'sha256':sha(fp.read_bytes())},'exact_archive':archive,
 'checked_uncompressed_sha256':h.hexdigest(),'records':len(edges),'direct_or_structural_seeds':sorted(seeds),
 'structural_seed_reason':'HasControlledHighResolution is an inductive proposition: changing its order constructor field changes its effective meaning even when its own sort-valued native type mentions no smooth-reference constant.',
 'affected_constants':sorted(affected),'edges':{n:edges[n] for n in sorted(affected)},
 'preliminary_correction':'impact.json had only the 23 type-expression closure because the fingerprint inventory stores value hashes, not bodies. Its mention of optional value/recursor expressions does not supply body coverage. This successor reads the actual archived complete native stream and is authoritative for explicit type/body edges.',
 'limits':'Within the 293 frozen DIM constants only; external consumers and imported-definition semantics also require the nine-owner import closure/current native rebuild. Dependency is not an assertion that each alpha-structural fingerprint changes.'}
with (P/'expression-impact-v2.json').open('xb') as f:f.write((json.dumps(v,indent=2)+'\n').encode())
print(json.dumps({'raw_bytes_checked':size,'raw_sha256':h.hexdigest(),'native_records':len(edges),'affected_constants':len(affected),'output_sha256':sha((P/'expression-impact-v2.json').read_bytes())}))
