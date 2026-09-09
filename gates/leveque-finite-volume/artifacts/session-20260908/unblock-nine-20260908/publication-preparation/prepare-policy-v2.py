"""Derive a reviewable path policy from the observed scope; no Git or staging."""
from pathlib import Path
import hashlib
import json

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SESSION = 'gates/leveque-finite-volume/artifacts/session-20260908/'
OWNED = SESSION + 'unblock-nine-20260908/'
snapshot = HERE / 'discovery-01/paths.json'
paths = [x['path'] for x in json.loads(snapshot.read_text())['records']]
source = [p for p in paths if p.startswith('ComputationalMathematics/') and p.endswith('.lean')]
assert len(source) == 22
audit_prefixes = sorted({SESSION + 'audits/' + p[len(SESSION + 'audits/'):].split('/')[0] + '/'
                        for p in paths if p.startswith(SESSION + 'audits/')})
assert audit_prefixes == sorted(SESSION + 'audits/LEV-CH01-' + name + '-PRODUCTION-20260908/' for name in ['COORDINATE-DIRECTIONAL-METHODS-INTERPRETED', 'COORDINATE-SPLITTING-INTERPRETED', 'EIGENVALUES-INTERPRETED-PROPAGATION', 'FINITE-VOLUME-FLUX-UPDATE-INTERPRETED', 'FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED', 'LEFT-MODE-INTERPRETED-DOMAINS', 'LOCAL-RIEMANN-INFORMATION-INTERFACE-INTERPRETED', 'MATERIAL-AVERAGING-INTERPRETED', 'MATERIAL-AVG-OPERATORS', 'MATERIAL-INTERFACE-INTERPRETED', 'MATERIAL-INTERFACE-TOPOLOGY-INTERPRETED', 'RIEMANN-DEFINITION-INTERPRETED', 'RIEMANN-INFORMATION-INTERFACE-INTERPRETED', 'RIEMANN-MODEL-REFINED', 'SOURCE-SLICES-REFINED', 'SOURCE-TERMS-INTERPRETED'])
session_receipts = sorted(p for p in paths if p.startswith(SESSION + 'unblock-nine-') and '/' not in p[len(SESSION):])
fixed = source + ['docs/architecture/tiers.json', 'gates/leveque-finite-volume/chapter-01.json',
    'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md',
    'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md']
first = json.loads((ROOT / (OWNED + 'final-fingerprints/raw-stream-archive-receipt.json')).read_text())
second = json.loads((ROOT / (OWNED + 'local-replacement-fingerprints/fingerprint-receipt.json')).read_text())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
policy = {'schema': 1, 'scope': 'UNBLOCK_NINE_CURRENT_GOAL_ONLY_REVIEWED_PATH_POLICY',
    'snapshot_head': json.loads(snapshot.read_text())['head'],
    'path_discovery': {'path': snapshot.relative_to(ROOT).as_posix(), 'sha256': sha(snapshot)},
    'allow_exact': sorted(set(fixed + session_receipts)), 'allow_prefixes': [OWNED, *audit_prefixes],
    'exclude_exact': {
        OWNED + 'final-fingerprints/native-expression-stream.jsonl': 'Generated raw fingerprint stream; publish exact verified gzip instead.',
        OWNED + 'local-replacement-fingerprints/native-expression-stream13.jsonl': 'Generated raw fingerprint stream; publish exact verified gzip instead.',
        SESSION + 'blocked-gate-installation.lock': 'Preexisting operational lock outside this publication.',
        SESSION + 'root-final-blocked-80f5-pathspec.bin': 'Preexisting prior publication pathspec outside this goal.',
        '.faithfulness-audit/VERSION': 'Parent-identified phantom metadata change; preserve and exclude.'},
    'exclude_prefixes': ['ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-prepare-v5-0-1-20260908/'],
    'generated_cache_suffixes': ['.olean', '.ilean', '.pyc', '.pyo'],
    'generated_cache_parts': ['__pycache__'],
    'size_limit_bytes': 90000000,
    'archives': [
        {'receipt': {'path': OWNED + 'final-fingerprints/raw-stream-archive-receipt.json',
                     'sha256': sha(ROOT / (OWNED + 'final-fingerprints/raw-stream-archive-receipt.json'))},
         'archive': first['archive'], 'raw': first['raw_stream']},
        {'receipt': {'path': OWNED + 'local-replacement-fingerprints/fingerprint-receipt.json',
                     'sha256': sha(ROOT / (OWNED + 'local-replacement-fingerprints/fingerprint-receipt.json'))},
         'archive': {k: second['archive'][k] for k in ('path', 'sha256', 'bytes')},
         'raw': {'path': OWNED + 'local-replacement-fingerprints/native-expression-stream13.jsonl',
                 'sha256': second['archive']['uncompressed_sha256'],
                 'bytes': second['archive']['uncompressed_bytes']}}],
    'notes': ['No blanket session or ledger inclusion.',
              'Future audit directories and session-level receipts require explicit policy extension.',
              'All failed attempts and superseded source drafts within allowed evidence roots are retained as history.',
              'No source acceptance, complete publication, or stage authorization is asserted.']}
with (HERE / 'policy.json').open('xb') as handle:
    handle.write((json.dumps(policy, indent=2) + '\n').encode())
print(json.dumps({'policy_sha256': sha(HERE / 'policy.json'), 'production_and_aggregate_files': len(source),
                  'audit_directories': len(audit_prefixes), 'session_receipts': len(session_receipts)}))
