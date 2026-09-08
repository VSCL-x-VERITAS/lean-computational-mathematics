from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
target=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CartesianCoordinateUpdate.lean'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
before=sha(target);text=target.read_text(encoding='utf-8')
text=re.sub(r'CartesianGrid\.(\w+) axes',r'(CartesianGrid.\1 axes)',text)
text=text.replace(', line,',',').replace('[line, ','[')
old='  simp only [Function.update_self, Function.update_idem]\n  rfl\n'
assert old in text;text=text.replace(old,'  simp only [Function.update_self, Function.update_idem]\n',1)
target.write_bytes(text.encode())
out=P/'consumer-repair-02.json';assert not out.exists();out.write_bytes((json.dumps(dict(path=target.relative_to(R).as_posix(),before_sha256=before,after_sha256=sha(target),changes=['Parenthesize axis-family applications formerly atomic TensorGrid projections.','Remove obsolete scratch-line unfold from simp, and final rfl after explicit-lambda simplification already closes the goal.'],failed_snapshot='build-01-sources/CartesianCoordinateUpdate.lean'),indent=2)+'\n').encode());print(sha(target))
