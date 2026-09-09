from pathlib import Path
import hashlib,os,runpy,sys
F=Path(__file__).resolve().parent
helper=F.parent/'fv-local-domain-review/native-long-path-io.py'
assert hashlib.sha256(helper.read_bytes()).hexdigest()=='63339ebabc35f3c9127ddd687bc68fa53524b5ff9c75e31d7914dfd7c7e03e6e'
exec(compile(helper.read_bytes(),str(helper),'exec'),globals())
sys.argv=[str(F/'run-native.py'),'CompleteTypesReadable.lean','native-01']
runpy.run_path(str(F/'run-native.py'),run_name='__main__')
