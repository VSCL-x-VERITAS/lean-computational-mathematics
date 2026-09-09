from pathlib import Path
import json,os,subprocess
assert os.name!='nt'
R=next(p for p in Path(__file__).resolve().parents if (p/'lean-toolchain').exists())
git=lambda *a:subprocess.check_output(['git','--no-replace-objects',*a],cwd=R).decode().strip()
head=git('rev-parse','HEAD');print(json.dumps(dict(head=head,tree=git('rev-parse',head+'^{tree}'))))
