"""Place already checked foundations without changing existing declaration owners."""
from pathlib import Path
import hashlib, json, re

SESSION = Path(__file__).resolve().parent
ROOT = SESSION.parents[3]
ANALYSIS = "ComputationalMathematics/Analysis/PartialDifferentialEquations/"
SOURCE = "ComputationalMathematics/Source/LeVeque/Chapter01/"
records = []

def candidate(name):
    path = SESSION / name
    text = path.read_text(encoding="utf-8").replace("\r\n", "\n")
    return text, hashlib.sha256(path.read_bytes()).hexdigest()

def core(text):
    text = re.sub(r"^#(?:check|print axioms) .*\n", "", text, flags=re.M)
    text = text.replace("namespace NumStability.Chapter01Scratch", "namespace NumStability")
    text = text.replace("end NumStability.Chapter01Scratch", "end NumStability")
    return text

def write(relative, imports, title, description, body, origin, digest):
    path = ROOT / relative
    header = "/-\nSPDX-License-Identifier: MIT\n-/\n\n"
    payload = header + "\n".join("import " + i for i in sorted(set(imports))) + "\n\n"
    payload += "/-!\n# " + title + "\n\n" + description + "\n-/\n\n" + body.strip() + "\n"
    if path.exists():
        raise ValueError(f"refuse to overwrite existing owner: {relative}")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(payload.encode())
    records.append({"path":relative, "sha256":hashlib.sha256(payload.encode()).hexdigest(),
                    "candidate":origin, "candidate_sha256":digest})

def split(text):
    imports = re.findall(r"^import (.*)$", text, re.M)
    body = text[text.index("namespace NumStability"):]
    opens = text[text.rfind("\nopen ",0,text.index("namespace NumStability")):text.index("namespace NumStability")]
    if "\nopen " in opens and "import " not in opens and "/-!" not in opens:
        body = opens.strip() + "\n\n" + body
    return imports, body

for name, leaf, title, description in [
    ("source-term-necessity-candidate.lean", "ConservationLaw/BalanceLaw",
     "Internal production and integral mass balance",
     "Classical balance equations and the mass rate after subtracting boundary transport.\nThe differentiation-under-the-integral premise is explicit."),
    ("flux-jacobian-classification-candidate.lean", "ConservationLaw/Hyperbolicity",
     "Hyperbolicity of a flux derivative",
     "Pointwise and domain criteria use the actual Fréchet derivative in standard coordinates.\nThe existing global hyperbolic-law structure supplies the pointwise criterion."),
    ("riemann-initial-configuration-candidate.lean", "InitialValue/Riemann",
     "Riemann initial configurations",
     "Two-state initial data is conjoined with an independently supplied evolution equation.\nProduct data describes a common material/state interface and leaves the origin value free."),
    ("similarity-ray-candidate.lean", "InitialValue/SelfSimilarity",
     "Positive-time self-similarity and ray values",
     "A selected self-similar field has a time-independent value along each positive-time ray.\nThis does not assert uniqueness between different selected fields or traces."),
]:
    text,digest = candidate(name)
    imports,body = split(core(text))
    write(ANALYSIS+leaf+".lean",imports,title,description,body,name,digest)

name = "second-order-classification-candidate.lean"
text,digest = candidate(name)
text = core(text)
imports,body = split(text)
marker = "/-- The positive-material sound speed in (1.7)"
generic, source = body.split(marker,1)
write(ANALYSIS+"SecondOrder/Classification.lean",
      ["Mathlib.Algebra.QuadraticDiscriminant","Mathlib.Tactic.Positivity"],
      "Classification of a two-variable second-order principal part",
      "The mixed coefficient is the full coefficient of the mixed derivative.\nHyperbolicity means a positive quadratic discriminant.",
      generic.rstrip()+"\n\nend NumStability",name,digest)
write(SOURCE+"SecondOrderHyperbolicity.lean",
      ["ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification",
       "Mathlib.Data.Real.Sqrt"],
      "LeVeque Chapter 1, second-order wave classification",
      "Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,\nprinted page 3 (raw PDF page 25), the classification following equation (1.7).\nPositive bulk modulus and density give a positive sound speed.",
      "namespace NumStability\n\n"+marker+source,name,digest)

name = "variable-coefficient-local-flux-candidate.lean"
text,digest = candidate(name)
imports,body = split(core(text))
marker = "/-- A positive smooth pointwise hyperbolic scalar transport coefficient"
generic,source = body.split(marker,1)
write(ANALYSIS+"ConservationLaw/VariableCoefficient.lean",
      ["Mathlib.Analysis.Calculus.MeanValue"],
      "Flux representation of scalar transport with a variable coefficient",
      "For the unchanged density, a local flux that represents the transport operator\non every differentiable profile forces the coefficient to be constant.\nExplicit spatial dependence of the proposed flux is allowed.",
      generic.rstrip()+"\n\nend NumStability",name,digest)
source = source.replace("theorem exists_positive_smooth_hyperbolic_transport_without_local_flux",
                        "theorem leveque01_exists_hyperbolic_variableCoefficient_without_localFlux")
write(SOURCE+"VariableCoefficientConservationForm.lean",
      ["ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.VariableCoefficient",
       "ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity",
       "Mathlib.Analysis.Calculus.ContDiff.Operations",
       "Mathlib.Tactic.FunProp","Mathlib.Tactic.NormNum","Mathlib.Tactic.Positivity"],
      "LeVeque Chapter 1, variable coefficients and conservation form",
      "Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,\nprinted page 8 (raw PDF page 30). A smooth positive scalar coefficient witnesses\nfailure of a local flux representation for the unchanged state variable.",
      "namespace NumStability\n\n"+marker+source,name,digest)

name = "equation-definitions-candidate.lean"
text,digest = candidate(name)
text = core(text)
_,body = split(text)
start = body.index("/-- Classical equation-form correspondence")
cut = body.index("/-- The classical rate formulation")
eq05 = body[start:cut]
eq10 = body[cut:body.rindex("end NumStability")]
for number,proof,page,description in [
    ("05",eq05,"2 (raw PDF page 24)",
     "The two displayed acoustic equations are exposed for independently supplied fields."),
    ("10",eq10,"4 (raw PDF page 26)",
     "This is the classical rate formulation on every oriented interval, with explicit\nintegrability. Its use at discontinuities requires a separate interpretation audit."),
]:
    write(SOURCE+"Equation"+number+"Definition.lean",
          ["ComputationalMathematics.Source.LeVeque.Chapter01.Equation"+number],
          "LeVeque Chapter 1, equation (1."+str(int(number))+") correspondence",
          "Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,\nprinted page "+page+". "+description,
          ("open MeasureTheory\n\n" if number=="10" else "")+
          "namespace NumStability\n\n"+proof.rstrip()+"\n\nend NumStability",name,digest)

name = "one-step-candidate.lean"
text,digest = candidate(name)
imports,body = split(core(text))
body = body.replace("/-- Candidate meaning of one-step dependence", "/-- One-step dependence")
write(SOURCE+"OneStepMethod.lean",imports,"LeVeque Chapter 1, one-step dependence",
      "Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,\nprinted page 10 (raw PDF page 32). At a fixed time level the next numerical field\ndepends only on the current field. The update may depend on the chosen time level.",
      body,name,digest)

receipt = SESSION / "production-placement-first.json"
if receipt.exists():
    raise ValueError("placement receipt already exists")
receipt.write_text(json.dumps({"schema":1,"files":records,"verification":"pending production build and audits"},indent=2)+"\n",encoding="utf-8")
print(json.dumps({"placed":len(records),"paths":[r["path"] for r in records]},indent=2))

