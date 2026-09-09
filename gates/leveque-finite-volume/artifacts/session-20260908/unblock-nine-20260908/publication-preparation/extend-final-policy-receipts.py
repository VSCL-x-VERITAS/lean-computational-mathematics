"""Append explicitly pinned session receipts; never discover paths or invoke Git."""
from pathlib import Path
import argparse
import copy
import hashlib
import importlib.util
import json
import re

P = Path(__file__).resolve().parent
R = P.parents[5]
SESSION = 'gates/leveque-finite-volume/artifacts/session-20260908/'
CHECKER_SHA = '8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'

def sha(data): return hashlib.sha256(data).hexdigest()

def checker():
    path = P/'check-publication-allowlist-v3.py'
    assert sha(path.read_bytes()) == CHECKER_SHA
    spec = importlib.util.spec_from_file_location('reviewed_v3',path)
    m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    return m

def validate_ref(ref,m):
    assert set(ref) == {'path','sha256'} and m.safe_name(ref['path'])
    assert re.fullmatch('[0-9a-f]{64}',ref['sha256'])

def derive(base,addition,m):
    assert set(addition) == {'schema','status','base_policy','add_exact_files','rationale'}
    assert addition['schema'] == 1 and addition['status'] == 'EXPLICIT_RECEIPTS_ROOT_REVIEW_REQUIRED'
    validate_ref(addition['base_policy'],m)
    assert isinstance(addition['rationale'],str) and addition['rationale'].strip()
    assert isinstance(addition['add_exact_files'],list) and addition['add_exact_files']
    added = []
    for item in addition['add_exact_files']:
        validate_ref(item,m); path = item['path']
        assert path.startswith(SESSION+'unblock-nine-') and '/' not in path[len(SESSION):]
        assert path.endswith(('.json','.txt')) and path not in base['exclude_exact']
        assert m.disposition(path,base)[0] != 'hold'
        assert path not in base['allow_exact'], 'Already allowed; no extension required'
        added.append(path)
    assert len(added) == len(set(added))
    result = copy.deepcopy(base)
    result['allow_exact'] = sorted(set(base['allow_exact']+added))
    result['notes'].append('Explicit receipt-only extension: '+addition['rationale'])
    m.verify_policy(result)
    for key in set(base)-{'allow_exact','notes'}: assert result[key] == base[key]
    return result

def bind(ref,m):
    validate_ref(ref,m); path = R/ref['path']
    assert path.resolve().is_relative_to(R)
    assert not any(x.is_symlink() for x in (path,*path.parents) if x.is_relative_to(R))
    assert path.is_file() and path.stat().st_size < 90000000
    data = path.read_bytes(); assert sha(data) == ref['sha256']
    return data

def main():
    a = argparse.ArgumentParser(description=__doc__)
    a.add_argument('--additions',type=Path,required=True)
    a.add_argument('--additions-sha256',required=True)
    a.add_argument('--output-name',required=True)
    args = a.parse_args()
    assert re.fullmatch(r'policy-final-[A-Za-z0-9-]+\.json',args.output_name)
    output = P/args.output_name
    provenance = P/(output.stem+'-extension.json')
    assert not output.exists() and not provenance.exists()
    additions_path = args.additions.resolve()
    assert additions_path.is_relative_to(P)
    raw = additions_path.read_bytes(); assert sha(raw) == args.additions_sha256
    additions = json.loads(raw); m = checker()
    base_ref = additions['base_policy']
    assert (R/base_ref['path']).resolve().is_relative_to(P)
    base_raw = bind(base_ref,m); base = json.loads(base_raw); m.verify_policy(base)
    result = derive(base,additions,m)
    observed = [(ref,bind(ref,m)) for ref in additions['add_exact_files']]
    assert additions_path.read_bytes() == raw and bind(base_ref,m) == base_raw
    for ref,data in observed: assert bind(ref,m) == data
    rendered = (json.dumps(result,indent=2,ensure_ascii=True)+'\n').encode()
    with output.open('xb') as f: f.write(rendered)
    record = {'status':'PREPARED_POLICY_ROOT_REVIEW_REQUIRED','base_policy':base_ref,
        'additions':{'path':additions_path.relative_to(R).as_posix(),'sha256':sha(raw)},
        'new_policy':{'path':output.relative_to(R).as_posix(),'sha256':sha(rendered)},
        'checked_files':additions['add_exact_files'],'only_exact_receipts_added':True,
        'checker_sha256':CHECKER_SHA,'git_invocations':0,'publication_complete':False}
    with provenance.open('x',encoding='utf-8',newline='\n') as f:
        f.write(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record,indent=2))

if __name__ == '__main__': main()
