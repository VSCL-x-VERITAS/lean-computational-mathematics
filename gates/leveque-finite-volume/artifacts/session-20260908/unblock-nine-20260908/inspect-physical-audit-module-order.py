"""Read the unchanged preparer's actual local-module order; do not prepare an audit."""
from pathlib import Path
import hashlib,json,os,sys
assert os.name=='posix'
D=Path(__file__).resolve().parent;R=D.parent.parents[3]
tid='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908'
config_path=D/(tid+'.config.json')
os.environ['FAITHFULNESS_AUDIT_CONFIG']=str(config_path)
sys.path.insert(0,str(R/'.faithfulness-audit/scripts'))
import prepare_audit as p
config=p.load_config()
target=R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean'
order,graph,external=p.collect_local_imports(target.read_text(encoding='utf-8'),config)
result={'format':'actual-released-local-module-order-1',
 'config_sha256':hashlib.sha256(config_path.read_bytes()).hexdigest(),
 'prepare_script_sha256':hashlib.sha256((R/'.faithfulness-audit/scripts/prepare_audit.py').read_bytes()).hexdigest(),
 'ordered_modules':order,'direct_import_graph':graph,'external_modules':sorted(external),
 'compile_or_audit_runs':0,'source_or_gate_mutations':0}
out=D/'physical-failed-preparation-module-order.json'
with out.open('xb') as f:f.write((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
 'local_count':len(order),'mathlib_order':[x for x in order if x.startswith('Mathlib.')]}))

