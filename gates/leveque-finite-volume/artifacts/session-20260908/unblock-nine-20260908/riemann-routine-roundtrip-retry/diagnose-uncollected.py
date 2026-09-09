"""Apply unchanged released schema and roundtrip guards to an uncollected native final."""
from pathlib import Path
import ast,hashlib,importlib.util,json,os,sys
assert os.name!='nt','Use the prepared POSIX launcher.'
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent;R=S.parents[3]
TASK='LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908'
stem=sys.argv[1];assert stem in ('r','r2')
os.environ['FAITHFULNESS_AUDIT_CONFIG']=str(D/(TASK+'.config.json'))
scripts=R/'.faithfulness-audit/scripts';sys.path.insert(0,str(scripts))
import validate_agent_output as released
code=scripts/'validate_agent_output.py';raw=code.read_bytes()
tree=ast.parse(raw);function=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='validate_role')
branch=next(n for n in ast.walk(function) if isinstance(n,ast.If) and
 isinstance(n.test,ast.Compare) and isinstance(n.test.left,ast.Name) and n.test.left.id=='role' and
 len(n.test.comparators)==1 and isinstance(n.test.comparators[0],ast.Constant) and n.test.comparators[0].value=='roundtrip-judge')
config=released.load_config();task=released.load_task(TASK,config);audit_dir=task['_output_path']
manifest=released.load_json(audit_dir/'manifest.json')
assert manifest['schema_version']==released.AUDIT_SCHEMA_VERSION and manifest['task_id']==TASK
output_path=audit_dir/'orchestration'/(stem+'_final.json')
output=released.load_json(output_path)
schema=released.load_json(released.AUDIT_ROOT/'schemas/roundtrip_judge.schema.json')
errors=released.validate_schema(output,schema,label='roundtrip-judge')
namespace=dict(vars(released),role='roundtrip-judge',output=output,task_id=TASK,
 source_hash=manifest['source']['sha256'],audit_dir=audit_dir,
 semantic_ids=released.expected_ids(manifest,'semantic_checks'),errors=errors)
exec(compile(ast.Module(body=branch.body,type_ignores=[]),str(code),'exec'),namespace)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
result={'mode':'released-schema-and-exact-roundtrip-branch-on-uncollected-output',
 'task_id':TASK,'stem':stem,'output_path':str(output_path),'output_sha256':sha(output_path),
 'released_validator_sha256':sha(code),'released_schema_sha256':sha(released.AUDIT_ROOT/'schemas/roundtrip_judge.schema.json'),
 'source_sha256_actual':output.get('source_sha256'),'source_sha256_expected':manifest['source']['sha256'],
 'errors':errors,'valid':not errors,'canonical_output_written':False,
 'branch_ast_sha256':hashlib.sha256(ast.dump(branch).encode()).hexdigest()}
print(json.dumps(result,indent=2));raise SystemExit(2 if errors else 0)
