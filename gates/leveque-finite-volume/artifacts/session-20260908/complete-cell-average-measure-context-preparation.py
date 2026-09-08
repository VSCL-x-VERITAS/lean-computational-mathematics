"""Complete receipt assembly with an AST check, preserving both prior coordinator attempts."""
from pathlib import Path
import ast
recovery=Path(__file__).with_name('recover-cell-average-measure-context-images.py')
original=recovery.read_text(encoding='utf-8')
prefix=original.split("writej(T/'coordinator-image-recovery.json'")[0]
exec(compile(prefix,str(recovery),'exec'),globals())
writej(T/'coordinator-image-recovery-v2.json',{'recorded_at_utc':datetime.now(timezone.utc).isoformat(),'prior_recovery_sha256':sha(recovery),'prior_recovery_exit_code':1,'cause':'Overbroad text guard matched the literal subprocess.run in the blind-preflight prohibition, before any source copy or role invocation.','correction':'AST check rejects executable subprocess.run calls in the continuation; all original hash assertions remain.','prepare_repeated':False,'roles_invoked':False})
code=(S/'prepare-cell-average-measure-context.py').read_text(encoding='utf-8')
suffix=code[code.index('image_hashes='):].replace("R.parent/'workflow-v5.0.1-local/chapter01-source-review'","S/'audits'/OLD/'faithfulness/orchestration'")
tree=ast.parse(suffix)
assert not any(isinstance(n,ast.Call) and isinstance(n.func,ast.Attribute) and isinstance(n.func.value,ast.Name) and n.func.value.id=='subprocess' and n.func.attr=='run' for n in ast.walk(tree))
exec(compile(suffix,'recovered_source_images_and_blind_preflight','exec'),globals())
