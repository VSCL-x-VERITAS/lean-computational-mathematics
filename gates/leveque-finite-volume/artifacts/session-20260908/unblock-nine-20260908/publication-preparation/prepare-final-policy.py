"""Derive the additive final path policy from actual read-only discovery."""
from pathlib import Path
import copy
import hashlib
import importlib.util
import json

P = Path(__file__).resolve().parent
R = P.parents[5]
S = 'gates/leveque-finite-volume/artifacts/session-20260908/'
D = S+'unblock-nine-20260908/'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
pin = lambda p: {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(name,obj):
    with (P/name).open('x',encoding='utf-8',newline='\n') as f:
        f.write(json.dumps(obj,indent=2,ensure_ascii=True)+'\n')

def main():
    checker = P/'check-publication-allowlist-v3.py'
    assert sha(checker) == '8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7'
    spec = importlib.util.spec_from_file_location('reviewed_checker',checker)
    m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    old = read(P/'policy.json'); p = copy.deepcopy(old)
    pathfile = P/'discovery-final-policy-01/paths.json'
    snap = read(pathfile)
    assert snap['head'] == snap['head_after'] and snap['index_sha256_before'] == snap['index_sha256_after']
    records = snap['records']; paths = [x['path'] for x in records]
    source = sorted(x for x in paths if x.startswith('ComputationalMathematics/') and x.endswith('.lean'))
    staged_source = sorted(x for x in snap['staged_paths'] if x.endswith('.lean'))
    assert source == staged_source and len(source) == 46
    assert sorted(snap['staged_paths']) == sorted(source+['docs/architecture/tiers.json'])
    audits = sorted({S+'audits/'+x[len(S+'audits/'):].split('/')[0]+'/' for x in paths if x.startswith(S+'audits/')})
    declared = [S+'audits/LEV-CH01-'+x+'-PRODUCTION-20260908/' for x in
        ('CERTIFIED-RIEMANN-ROUTINE-INTERFACE','COORDINATE-HIGH-RESOLUTION-METHODS')]
    assert set(declared) <= set(audits) and len(audits) == 21
    session_receipts = sorted(x for x in paths if x.startswith(S+'unblock-nine-') and '/' not in x[len(S):])
    graph_paths = [S+'architecture-graphs/unblock-nine-final-source'+ext for ext in ('.json','.md')]
    fixed = ['docs/architecture/tiers.json','gates/leveque-finite-volume/chapter-01.json',
        'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md',
        'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md']
    p['snapshot_head'] = snap['head']; p['path_discovery'] = pin(pathfile)
    p['allow_exact'] = sorted(set(old['allow_exact']+source+fixed+session_receipts+graph_paths))
    p['allow_prefixes'] = sorted(set(old['allow_prefixes']+[D]+audits+declared))
    archives = copy.deepcopy(old['archives'])
    for name in ('riemann-routine-fingerprints','dim-high-resolution-fingerprints','riemann-certified-fingerprints'):
        final_path = R/(D+name+'/final-receipt.json')
        record = read(final_path); a = record['archive']; receipt = record['fingerprint_receipt']
        assert sha(R/receipt['path']) == receipt['sha256']
        entry = {'receipt':receipt,'archive':{k:a[k] for k in ('path','sha256','bytes')},
            'raw':{'path':a['path'][:-3],'sha256':a['uncompressed_sha256'],'bytes':a['uncompressed_bytes']}}
        archives.append(entry)
    assert len(archives) == 5
    archive_observations = []
    for entry in archives:
        assert sha(R/entry['receipt']['path']) == entry['receipt']['sha256']
        assert sha(R/entry['archive']['path']) == entry['archive']['sha256']
        assert (R/entry['archive']['path']).stat().st_size == entry['archive']['bytes']
        assert (R/entry['raw']['path']).stat().st_size == entry['raw']['bytes']
        p['exclude_exact'][entry['raw']['path']] = 'Generated raw expression stream; retain locally and publish the exact receipt-bound gzip instead.'
        archive_observations.append({'receipt':entry['receipt'],'archive':entry['archive'],
            'raw_size_matches':True,'gzip_sha256_checked':True,
            'decompression_here':False,'decompression_required_by_final_v3_screen':True})
    p['archives'] = archives
    for record in records:
        path = record['path']
        if path.endswith('.jsonl') and record.get('bytes_observed',0) >= p['size_limit_bytes']:
            p['exclude_exact'][path] = 'Large raw JSONL stream; preserve locally, publish exact verified archive only.'
        if path.endswith('.lock'):
            p['exclude_exact'][path] = 'Operational lock; preserve locally and exclude from publication.'
    p['notes'] = old['notes'] + [
        'Additive final-policy preparation: 46 exact Lean paths, tiers, gate, selected two issue ledgers, 21 exact owned repair audit roots.',
        'Exactly observed session-root unblock-nine receipt paths are allowed; future receipts require explicit hash-pinned extension.',
        'The graph basename unblock-nine-final-source is explicitly authorized; final bytes/receipt and current-source applicability remain root responsibilities.',
        'All five raw expression streams stay excluded; all five complete exact gzip archives are required by reviewed checker v3.',
        'Ordinary authorized fast-forward HEAD:main publication is separate from protected campaign admission/stable promotion.',
        'This policy does not certify audits, final global checks, final staging bytes, publication completeness or source acceptance.'
    ]
    m.verify_policy(p)
    for path in source+fixed+graph_paths: assert m.disposition(path,p)[0] == 'select'
    for a in archives:
        assert m.disposition(a['archive']['path'],p)[0] == 'select'
        assert m.disposition(a['raw']['path'],p)[0] == 'exclude'
    held_staged = [x for x in snap['staged_paths'] if m.disposition(x,p)[0] != 'select']
    assert not held_staged
    sourcepins = [pin(R/x) for x in source]
    dispositions = [{'path':x,'disposition':m.disposition(x,p)[0],'reason':m.disposition(x,p)[1]} for x in paths]
    unknown = [x for x in dispositions if x['reason']=='unowned or newly unreviewed path']
    put('policy-final-01.json',p)
    put('policy-final-01-derivation.json', {'schema':1,'status':'PREPARED_POLICY_ROOT_REVIEW_REQUIRED',
        'base_policy':pin(P/'policy.json'),'checker':pin(checker),'path_discovery':pin(pathfile),
        'policy':pin(P/'policy-final-01.json'),'source_pins_at_preparation':sourcepins,
        'exact_source_count':len(source),'staged_count_observed':len(snap['staged_paths']),
        'audit_directories':audits,'declared_audit_directories':declared,
        'session_receipt_count_observed':len(session_receipts),'session_receipts_observed':session_receipts,
        'graph_paths_declared':graph_paths,'archive_observations':archive_observations,
        'added_exact':sorted(set(p['allow_exact'])-set(old['allow_exact'])),
        'added_prefixes':sorted(set(p['allow_prefixes'])-set(old['allow_prefixes'])),
        'added_exclusions':sorted(set(p['exclude_exact'])-set(old['exclude_exact'])),
        'unknown_exclusions_requiring_final_review':unknown,
        'all_historical_attempts_within_owned_evidence_prefixes_retained':True,
        'git_mutations_invoked':0,'operational_screen_run':False,'publication_complete':False})
    put('remaining-final-policy-inputs.json', {'status':'ROOT_FINAL_REVIEW_AND_SNAPSHOT_REQUIRED',
        'policy':pin(P/'policy-final-01.json'),'all_five_archives_frozen':True,
        'pending_archive':None,
        'remaining':['Any exact session-root receipts created after discovery must be explicitly appended.',
            'Root must inspect unknown exclusions and cache/lock dispositions in the final live checker output.',
            'Complete all live audit roles and global checks before final source/gate evidence snapshot.',
            'Run reviewed v3 against the exact final policy; require review of issues/holds and actual unchanged HEAD/index.',
            'Snapshot outputs and extension files created during final scan need explicit final staged-byte review.',
            'Verify final index bytes and diff, then perform already-authorized ordinary commit/push; do not claim protected integration.']})
    print(json.dumps({'policy':pin(P/'policy-final-01.json'),'source_files':len(source),
        'audit_directories':len(audits),'session_receipts':len(session_receipts),'archives':len(archives),
        'unknown_exclusions':unknown,'publication_complete':False},indent=2))

if __name__ == '__main__': main()
