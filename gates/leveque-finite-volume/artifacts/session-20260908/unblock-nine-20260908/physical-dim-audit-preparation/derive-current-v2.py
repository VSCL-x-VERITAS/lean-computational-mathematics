"""Additive current-capture successors; exact probe commands stay unchanged."""
from pathlib import Path
import ast, hashlib, json
P=Path(__file__).resolve().parent;R=P.parent.parents[4]
disk=lambda p:Path('\\\\?\\'+str(p.resolve()))
raw=lambda p:disk(p).read_bytes()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(raw(p)).hexdigest()}
records=[]
def derive(old,new,changes):
 text=raw(P/old).decode()
 for a,b in changes:
  assert a in text,(old,a)
  text=text.replace(a,b)
 ast.parse(text)
 assert not disk(P/new).exists()
 disk(P/new).write_text(text,encoding='utf-8',newline='\n')
 records.append({'parent':ref(P/old),'successor':ref(P/new),'exact_replacements':changes})

addition="""repair_path=D/'physical-production-promotion/layout-rhs-parentheses-01/receipt.json'
assert ref(repair_path)['sha256']=='43f3b06844b9d3c79f5189015c839575f4dcb5b15fc47f796f6f183574c09ab9'
repair=json.loads(read(repair_path));notation_deltas=[]
"""
owner_repair=""" if path.name=='PhysicalRefinementQuality.lean':
  before=read(R/repair['snapshots'][0]['path']);after=read(R/repair['snapshots'][1]['path'])
  assert hashlib.sha256(before).hexdigest()==repair['repair']['before_sha256']
  assert hashlib.sha256(after).hexdigest()==repair['repair']['after_sha256']
  needle=b'      constant * dt * family.mesh n ^ p\\n'
  replacement=b'      (constant * dt * family.mesh n ^ p)\\n'
  assert before.count(needle)==1 and before.replace(needle,replacement)==after and actual==after
  notation_deltas.append({'owner':ref(path),'repair_receipt':ref(repair_path),
   'before_sha256':repair['repair']['before_sha256'],'after_sha256':repair['repair']['after_sha256'],
   'exact_before':needle.decode(),'exact_after':replacement.decode()})
  actual=before
"""
derive('prepare-probes.py','prepare-probes-v2.py',[
 ("mapping=json.loads(read(mapping_path))\n","mapping=json.loads(read(mapping_path))\n"+addition),
 (" if actual!=old:\n",owner_repair+" if actual!=old:\n"),
 ("'import_only_placement_deltas':deltas,","'import_only_placement_deltas':deltas,'notation_only_placement_deltas':notation_deltas,"),
 ("P/'prepare-probes.py'","P/'prepare-probes-v2.py'")])
derive('run-prepare.py','run-prepare-v2.py',[("prepare-probes.py","prepare-probes-v2.py")])
derive('run-probes.py','run-probes-v2.py',[
 ("assert len(args)==2\nsource_tag,tag=args","assert len(args)==4\nsource_tag,tag,build_name,build_sha=args\nassert re.fullmatch(r'owners-native-[0-9]+-receipt.json',build_name) and re.fullmatch(r'[a-f0-9]{64}',build_sha)"),
 ("build=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-production-promotion/owners-native-03-receipt.json'\nassert ref(build)['sha256']=='662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb'","build=P.parent/'physical-production-promotion'/build_name\nassert ref(build)['sha256']==build_sha"),
 ("'run-probes.py'","'run-probes-v2.py'"),
 ("'--child',source_tag,tag]","'--child',source_tag,tag,build_name,build_sha]")])
derive('prepare-spec.py','prepare-spec-v2.py',[
 ("probe-sources-01","probe-sources-02"),("native-01","native-02"),
 ("P/'run-probes.py'","P/'run-probes-v2.py'"),
 ("P/'prepare-probes.py'","P/'prepare-probes-v2.py'"),
 ("'native_receipt':ref(native_path),'native_groups':counts", "'native_receipt':ref(native_path),'notation_only_placement_deltas':inventory['notation_only_placement_deltas'],'native_groups':counts")])
path=P/'current-v2-derivation.json';assert not disk(path).exists()
disk(path).write_text(json.dumps({'generator':ref(Path(__file__)),'derivations':records,
 'prior_native':ref(P/'native-01/receipt.json'),
 'probe_commands_changed':False,'old_files_changed':False,'native_run':False,
 'spec_prepared':False,'roles_run':False},indent=2)+'\n',encoding='utf-8')
print(json.dumps(ref(path),indent=2))
