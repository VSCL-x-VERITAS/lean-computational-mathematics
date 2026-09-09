"""Install byte-exact reviewed NEW helper paths only; no operational invocation."""
from pathlib import Path
from datetime import datetime, timezone
import argparse
import hashlib
import json
import os
P=Path(__file__).resolve().parent
D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
def io(path):
    return Path('\\\\?\\'+str(path)) if os.name=='nt' else path
def raw(path): return io(path).read_bytes()
def sha(path): return hashlib.sha256(raw(path)).hexdigest()
def ref(path): return {'path':path.relative_to(R).as_posix(),'sha256':sha(path)}
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--manifest-sha256',required=True)
args=parser.parse_args()
manifest=P/'suite/actual-render-01/manifest.json'
assert args.manifest_sha256=='8906052ebcd027fc8f473825f780e98f7647e22b4c68681b439e8014b913e5cb'==sha(manifest)
data=json.loads(raw(manifest))
assert data['status']=='REVIEW_COPIES_ONLY_NOT_INSTALLED'
records=[*data['derivations'],data['dependency_derivation']]
assert len(records)==8
expected={'prepare-successor-audit-with-package-command-v1.py',
          'gate-helpers/qualified_row_support_package_command_v1.py',
          'gate-helpers/bind-qualified-row-package-command-v1.py',
          'gate-helpers/validate-closed-row-audits-package-command-v1.py',
          'gate-helpers/validate-closed-row-audits-rebind-package-command-v1.py',
          'gate-helpers/rebind-accepted-row-batch-package-command-v1.py',
          'gate-helpers/bind-final-global-evidence-package-command-v1.py',
          'gate-helpers/source-context-package-command-v1-validator-dependencies.json'}
payloads=[]
for item in records:
    source=(R/item['staged_file']['path']).resolve()
    dest=(R/item['proposed_installed_ref']['path']).resolve()
    assert source.is_relative_to((P/'suite/actual-render-01/prospective').resolve())
    assert dest.is_relative_to(D.resolve()) and dest.relative_to(D).as_posix() in expected
    assert not io(dest).exists(), 'Never overwrite a previously installed helper'
    assert ref(source)==item['staged_file'] and sha(source)==item['proposed_installed_ref']['sha256']
    parent=R/item['parent']['path']
    assert ref(parent)==item['parent']
    payloads.append((source,dest,raw(source)))
assert {dest.relative_to(D).as_posix() for _,dest,_ in payloads}==expected
out=P/'installation-01'
assert not out.exists()
out.mkdir()
for source,dest,content in payloads:
    with io(dest).open('xb') as stream: stream.write(content)
    assert sha(dest)==sha(source)
receipt={'status':'REVIEWED_NEW_HELPERS_INSTALLED_BYTE_EXACT_NO_OPERATIONAL_RUN',
         'utc':datetime.now(timezone.utc).isoformat(),'manifest':ref(manifest),
         'installed':[ref(dest) for _,dest,_ in payloads], 'preparations':0,'semantic_roles':0,'gate_mutations':0}
with io(out/'receipt.json').open('x',encoding='utf-8') as stream:
    stream.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(ref(out/'receipt.json')))
