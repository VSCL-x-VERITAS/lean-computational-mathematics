"""Extract rectangle and eigenbasis foundations; preserve checked candidate bytes."""
from pathlib import Path
import hashlib, json, re
SESSION=Path(__file__).resolve().parent
ROOT=SESSION.parents[3]
A="ComputationalMathematics/Analysis/PartialDifferentialEquations/"
S="ComputationalMathematics/Source/LeVeque/Chapter01/"
records=[]
def read(name):
    p=SESSION/name
    return p.read_text(encoding="utf-8"),hashlib.sha256(p.read_bytes()).hexdigest()
def body(text):
    text=re.sub(r"^#(?:check|print axioms) .*\n","",text,flags=re.M)
    text=text.replace("NumStability.Chapter01Scratch","NumStability")
    return text[text.index("namespace NumStability"):]
def write(path, imports, title, description, text, origin, sha):
    target=ROOT/path
    if target.exists(): raise ValueError(f"existing owner {target}")
    content="/-\nSPDX-License-Identifier: MIT\n-/\n\n"
    content+="\n".join("import "+i for i in sorted(set(imports)))+"\n\n"
    content+="/-!\n# "+title+"\n\n"+description+"\n-/\n\n"+text.strip()+"\n"
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_bytes(content.encode())
    records.append({"path":path,"sha256":hashlib.sha256(content.encode()).hexdigest(),
                    "candidate":origin,"candidate_sha256":sha})
name="transport-rectangle-candidate.lean"
text,sha=read(name)
write(A+"ConservationLaw/Rectangle.lean",
      ["ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection",
       "Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic"],
      "Conservation on oriented space-time rectangles",
      "Time-integrated conservation records spatial and boundary-flux integrability.\nLocally integrable translated profiles satisfy this balance, including discontinuous profiles.",
      "open MeasureTheory\n\n"+body(text),name,sha)

name="riemann-foundation/candidate.lean"
text,sha=read(name)
text=body(text)
tail=text[text.index("open scoped BigOperators"):]
write(A+"FiniteVolume/LinearRiemannSolution.lean",
      ["ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Rectangle",
       "ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves",
       "ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData",
       "ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity"],
      "Explicit Riemann solutions for real hyperbolic matrices",
      "A finite sum of translated scalar steps satisfies rectangle conservation,\nthe exact initial data with a freely selected origin value, and positive-time self-similarity.",
      "open MeasureTheory\n\nnamespace NumStability\n\n"+
      "variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n"+tail,name,sha)

name="eigenbasis-decoupling-candidate.lean"
text,sha=read(name)
text=body(text)
marker="/-- Candidate for the general scalar-equation decomposition"
generic,source=text.split(marker,1)
write(A+"Hyperbolicity/EigenbasisCoordinates.lean",
      ["ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem",
       "ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity",
       "ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection",
       "Mathlib.Analysis.Calculus.FDeriv.Linear","Mathlib.Analysis.Normed.Module.FiniteDimension"],
      "Diagonalization of a constant-coefficient PDE in eigenbasis coordinates",
      "The eigenbasis transforms the actual time and space derivatives in both directions.\nThe criterion applies to independently supplied fields at every point.",
      generic.rstrip()+"\n\nend NumStability",name,sha)
source=("/-- General scalar-equation decomposition"+source).replace(
    "on printed page 3.\nOne eigenbasis","on printed page 3.\nOne eigenbasis")
write(S+"EigenbasisDecoupling.lean",
      ["ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity.EigenbasisCoordinates"],
      "LeVeque Chapter 1, decomposition into scalar wave equations",
      "Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,\nprinted page 3 (raw PDF page 25). A single real eigenbasis supplies all scalar equations.",
      "namespace NumStability\n\n"+source,name,sha)

receipt=SESSION/"production-placement-rectangle.json"
if receipt.exists(): raise ValueError("receipt exists")
receipt.write_text(json.dumps({"schema":1,"files":records,"verification":"pending production build and audits"},indent=2)+"\n",encoding="utf-8")
print(json.dumps({"placed":len(records),"paths":[r["path"] for r in records]},indent=2))

