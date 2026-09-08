"""Expose the new reusable leaves through the established Analysis aggregate."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent; R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
assert read(S/'definition-rebind-preparation/definition-intro-rebind-28/summary.json')['exit_code']==0
assert read(S/'definition-architecture-graph-capture-exit.json')['exit_code']==0
failure=read(S/'definition-organized-layout-exit.json')
assert failure['exit_code']==1
assert sha(S/'definition-organized-layout-output.txt')=='9a3753117bf09f239b7a9c8542e0493a4b5cb93918fbd53ca058270da96dad1c'
p=R/'ComputationalMathematics/Analysis.lean'; before=p.read_bytes(); text=p.read_text(encoding='utf-8')
imports=re.findall(r'^import (\S+)$',text,re.M)
added=['ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation',
       'ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann']
assert not set(added)&set(imports)
start=text.index('import '); end=text.rindex('import ')+len('import '+imports[-1])
new=text[:start]+'\n'.join('import '+name for name in sorted(imports+added,key=str.casefold))+text[end:]
snapshot=S/('definition-analysis-before-'+hashlib.sha256(before).hexdigest()+'.bin'); assert not snapshot.exists(); snapshot.write_bytes(before)
p.write_text(new,encoding='utf-8',newline='\n')
record={'schema':1,'path':p.relative_to(R).as_posix(),'before_sha256':hashlib.sha256(before).hexdigest(),'after_sha256':sha(p),
 'added_imports':added,'reason':'Current layout scan requires every canonical Analysis descendant reachable from the public entry point.',
 'compatibility':'The unchanged NumStability.Analysis forwarder inherits the corrected canonical entry point.',
 'prior_native_build':'Passed for both full roots; repeated build and new graph required for this import correction.',
 'prior_layout_failure_preserved':True}
dest=S/'definition-analysis-import-correction.json'; assert not dest.exists(); dest.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record))
