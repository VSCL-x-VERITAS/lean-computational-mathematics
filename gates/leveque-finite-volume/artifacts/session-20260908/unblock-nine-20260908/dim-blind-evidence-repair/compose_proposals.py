from pathlib import Path
import datetime, difflib, hashlib, json
HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'lean-toolchain').is_file())
OTHER=HERE.parent/'dim-smooth-regularity-repair'
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':p.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def write(p,b):
 if disk(p).exists():raise RuntimeError('Refusing overwrite: '+str(p))
 disk(p.parent).mkdir(parents=True,exist_ok=True);disk(p).write_bytes(b)
def jsonout(name,v):write(HERE/name,(json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode())
other_manifest=json.loads(read(OTHER/'manifest.json'))
assert ref(OTHER/'manifest.json')['sha256']=='9edfaea6e77b6fbd813028fb69992bfd254b7f74fa1354480f0248eb75b969c8'
assert ref(OTHER/'receipt.json')['sha256']=='d0e1173a6ebe4d59f262cbbe17434a283664ba82fecf002a391d67600083301d'
files=[]
for item in other_manifest['files']:
 marker='/proposed/ComputationalMathematics/'
 if marker not in item['path']:continue
 old=ROOT/item['path']; assert ref(old)['sha256']==item['sha256']
 target='ComputationalMathematics/'+item['path'].split(marker,1)[1]
 if target.endswith('/LocalRectangleReference.lean'):
  raw=read(old);needle=b'import Mathlib.Analysis.Calculus.ContDiff.Defs'
  assert raw.count(needle)==1
  newline=b'\r\n' if b'\r\n' in raw else b'\n'
  changed=raw.replace(needle,needle+newline+b'import Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries')
  proposal=HERE/'proposed/LocalRectangleReference.lean';write(proposal,changed)
  change='Two C-infinity regularity corrections from frozen prior copy plus one explicit genuine FTaylorSeries dependency import; prior copy untouched.'
 else:
  proposal=old;change='Exact unchanged frozen C-infinity proposal from independent regularity packet.'
 files.append({'target_path':target,'current':ref(ROOT/target),'proposal':ref(proposal),'prior_proposal':ref(old),'change':change})
target='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RefiningLineMethod.lean'
old=ROOT/target;assert ref(old)['sha256']=='8a7b5d3417d4f67426d5381f171da17996a538ce47480a85d5cf26dcd0cba05d'
raw=read(old);newline=b'\r\n' if b'\r\n' in raw else b'\n'
probe=read(HERE/'Probe.lean').decode()
body=probe.split('    (quality : family.HasControlledHighResolution) : ℝ :=\n',1)[1].split('\n\ntheorem explicitRate_eq',1)[0]
needle=': ℝ := Classical.choose quality.stability'.encode()
assert raw.count(needle)==1
changed=raw.replace(needle,': ℝ :=\n'.encode().replace(b'\n',newline)+body.encode().replace(b'\n',newline))
proposal=HERE/'proposed/RefiningLineMethod.lean';write(proposal,changed)
files.append({'target_path':target,'current':ref(old),'proposal':ref(proposal),
 'change':'Only the stabilityRate definition body changes: explicit indefiniteDescription predicate, definitionally identical chosen real rate.',
 'native_defeq_probe':ref(HERE/'Probe.lean'),'native_defeq_receipt':ref(HERE/'native-01-receipt.json'),
 'sealed_readable_receipt':ref(HERE/'sealed-printer-02-receipt.json')})
assert len(files)==5
diffs=[]
for item in files:
 diffs.extend(difflib.unified_diff(read(ROOT/item['target_path']).decode().splitlines(keepends=True),
  read(ROOT/item['proposal']['path']).decode().splitlines(keepends=True),fromfile=item['target_path'],tofile=item['proposal']['path']))
write(HERE/'five-owner-proposal.diff',''.join(diffs).encode())
source_context=HERE.parent/'dim-inherited-hyperbolicity-context/source-context-v3.json'
assert ref(source_context)['sha256']=='d7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'
jsonout('five-owner-proposal.json',{'format':'artifact-only-five-owner-repair-proposal-1','created_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'status':'ROOT REVIEW REQUIRED; no production mutation, final build, successor prepare, or audit acceptance',
 'files':files,'regularity_packet_manifest':ref(OTHER/'manifest.json'),'regularity_packet_receipt':ref(OTHER/'receipt.json'),
 'diff':ref(HERE/'five-owner-proposal.diff'),'future_source_context_only':ref(source_context),
 'blind_config_extension':{'lean.module_source_roots':['.',(HERE.relative_to(ROOT)/'m').as_posix()],
  'exact_upstream_mirrors':[ref(HERE/'m/Mathlib/Analysis/Calculus/ContDiff'/x) for x in ['Defs.lean','FTaylorSeries.lean']],
  'note':'Add to a fresh config only. The explicit FTaylorSeries import above makes both owners discoverable despite released public-import parser limitation. Bind original Mathlib sources/compiled owners separately; never edit mirror bytes.'},
 'application_order':['Wait for original audit completion','Root reviews and places the five explicit copies',
 'Root rebuilds affected consumers and declaration/axiom checks; compile fresh complete primary applicability',
 'Freeze new fingerprints, source context and fresh config/task','Released route, prepare and prepared validation',
 'Validate actual complete blind packet and stdin before fresh independent roles'],
 'limits':['The regularity repair changes semantic domain, unlike the definitionally identical stabilityRate rendering repair.',
 'No wrapper type or amplification quantifiers are changed by the stabilityRate body proposal.',
 'Current native two-owner preview intentionally still describes old regularity and old choose body; never launch it as a repaired target.',
 'Direct/roundtrip/adjudication payload sizes require independent final preflight; blind headroom is not a direct-size guarantee.']})
print(json.dumps(ref(HERE/'five-owner-proposal.json'),indent=2))
