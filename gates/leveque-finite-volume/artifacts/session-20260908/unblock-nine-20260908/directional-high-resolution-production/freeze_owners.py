from pathlib import Path
import hashlib,json
G=Path(__file__).resolve().parent;R=G.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
inv=json.loads((G/'current-check-inventory.json').read_text());source=json.loads((G/'source-placement.json').read_text())
files=inv['files']+[source]
for f in files:assert sha(R/f['path'])==f['sha256']
checks=[]
for n in ('canonical01','joint01','sourcejoint01'):
    p=G/(n+'-receipt.json');j=json.loads(p.read_text());assert j['actual_exit_code']==0 and j['dependencies_unchanged'];assert sha(R/j['source']['path'])==j['source']['sha256'];assert sha(R/j['output']['path'])==j['output']['sha256'];checks.append(ref(p))
out=G/'production-files-frozen.json';assert not out.exists()
out.write_text(json.dumps({'status':'source-files-frozen-native-verified; placement comparison audit still running','files':files,'authored_declaration_count':sum(len(f['declarations']) for f in files),'native_receipts':checks,'joint_application':ref(G/'sourcejoint01-SourceJoint.lean'),'joint_example_is_artifact_only':True},indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(ref(out)))
