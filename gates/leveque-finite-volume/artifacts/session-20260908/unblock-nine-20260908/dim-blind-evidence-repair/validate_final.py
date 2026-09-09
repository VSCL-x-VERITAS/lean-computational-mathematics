from pathlib import Path
import hashlib,json,sys
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
k=r.parent/'formalization-collaboration-v5.0.1/skills/formalization-faithfulness-audit/kit'
sys.path.insert(0,str(k/'scripts'))
import prepare_audit as sealed
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
g=json.loads((h/'guard-results.json').read_text(encoding='utf-8'))
assert len(g['tests'])==27 and all(t['result']=='PASS' for t in g['tests'])
semantic=sealed.parse_lean_report((h/'primary-two-owner-04-output.txt').read_text(encoding='utf-8'))
assert sealed.make_blind_dossier(semantic).encode()==(h/'promoted-primary-blind-preview.md').read_bytes()
assert all(not d['body_readable'] for d in semantic['dependencies'] if d['kind']=='theorem')
for name in ['Defs.lean','FTaylorSeries.lean']:
 assert (h/'m/Mathlib/Analysis/Calculus/ContDiff'/name).read_bytes()==(r/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff'/name).read_bytes()
p=json.loads((h/'five-owner-proposal.json').read_text(encoding='utf-8'))
for f in p['files']:assert sha(r/f['current']['path'])==f['current']['sha256']
for name in ['LocalRectangleReference.lean','RefiningLineMethod.lean']:
 f=next(f for f in p['files'] if f['target_path'].endswith('/'+name))
 assert sha(h/'proposed'/name)==f['proposal']['sha256']
for name in ['native-01','compile-02','sealed-printer-02','primary-promoted-03','primary-two-owner-04']:
 rec=json.loads((h/(name+'-receipt.json')).read_text(encoding='utf-8'));assert rec['actual_exit_code']==0
 if 'inputs_unchanged' in rec:assert rec['inputs_unchanged']
print(json.dumps({'status':'PASS artifact-only final replay','guard_checks':27,'dependency_count':len(semantic['dependencies']),
 'source_owners_unchanged':5,'proposal_sha256':sha(h/'five-owner-proposal.json'),
 'blind_preview_sha256':sha(h/'promoted-primary-blind-preview.md'),'remaining':'No audit launch; original completion and actual repaired successor preparation remain root work.'},indent=2))
