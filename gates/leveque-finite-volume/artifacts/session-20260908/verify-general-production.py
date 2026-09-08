"""Verify actual native output and exact seven-file proof inputs without assigning source acceptance."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
m=json.loads((S/'general-propagation-discontinuity-production-inputs.json').read_text())
assert len(m['files'])==7
out=(S/'general-propagation-discontinuity-checks-output.txt').read_text(encoding='utf-8')
checks=[]
for label in ['general-propagation-discontinuity-build','general-propagation-discontinuity-checks']:
 e=json.loads((S/(label+'-exit.json')).read_text())
 assert e['exit_code']==0 and e['output_sha256']==sha((S/(label+'-output.txt')).read_bytes())
 checks.append({'label':label,'exit_code':0,'command':e['command'],'output_sha256':e['output_sha256'],'exit_sha256':sha((S/(label+'-exit.json')).read_bytes())})
for f in m['files']:
 assert sha((R/f['path']).read_bytes())==f['sha256']
 for d in f['declarations']:
  ax=re.search(re.escape("'"+d+"' depends on axioms:")+r'\s*\[([^\]]*)\]',out);assert ax
  assert {x.strip() for x in ax.group(1).split(',')}<={'propext','Classical.choice','Quot.sound'}
assert 'sorryAx' not in out and 'error:' not in out
assert sha((S/'general-propagation-discontinuity-checks.lean').read_bytes())==m['check_file_sha256']
r={**m,'canonical_validation':'native build and declaration/axiom checks passed','checks':checks,'source_acceptance':'Not asserted by proof success. The two new correspondences require fresh independent audits. The discontinuity comparison uses the separately recorded user interpretation; the full propagation target has explicit joint differentiability.'}
p=S/'general-propagation-discontinuity-verification.json';assert not p.exists();p.write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'verification_sha256':sha(p.read_bytes()),'files':len(m['files']),'declarations':sum(len(f['declarations']) for f in m['files'])}))
