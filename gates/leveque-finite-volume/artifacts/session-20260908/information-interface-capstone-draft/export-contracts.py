"""Extract actual theorem headers and the transparent execution predicate."""
from pathlib import Path
from hashlib import sha256
import json,re
here=Path(__file__).resolve().parent
source=here/'Candidate.lean';text=source.read_text(encoding='utf-8')
out=here/'contracts.proof-free.md';receipt=here/'contract-extraction.json'
assert not out.exists() and not receipt.exists()
matches=list(re.finditer(r'^(?:noncomputable )?(def|theorem) (\w+)',text,re.M))
blocks=[]
for i,match in enumerate(matches):
 name=match.group(2)
 if match.group(1)=='def' and name not in ['PureInterfaceContract','initialState']:continue
 end=matches[i+1].start() if i+1<len(matches) else len(text)
 chunk=text[match.start():end]
 if match.group(1)=='theorem':
  markers=[x for x in [chunk.find(' := by\n'),chunk.find(' :=\n')] if x>=0]
  assert markers,name
  chunk=chunk[:min(markers)]
 elif name=='initialState':chunk=chunk.splitlines()[0]
 else:chunk=chunk.split('\n\ntheorem')[0].rstrip()
 blocks.append(dict(name=name,kind=match.group(1),signature=chunk.rstrip()))
intro='''# Prospective information-interface contracts (proof-free)

This file mechanically extracts actual theorem headers from the bound Candidate.lean.
It preserves every premise and conclusion, including dependent result domains.
The transparent PureInterfaceContract body is included. No source-faithfulness
decision or accuracy interpretation is supplied by extraction.

The generic declarations live in NumStability.InformationInterfaceDraft;
the concrete unit-grid declarations live in its Witness namespace. Generic
implicit variables are `{m : ℕ}`, `{law : OneDimensionalHyperbolicConservationLaw (Fin m)}`,
`{Result : HyperbolicRiemannProblem law → Type*}` and `{Information : Type*}`.
The unit grid has cellLeft(i)=i and cellRight(i)=i+1, with checked positivity
and adjacency; no geometry assumption is hidden in a source predicate.

Normalization uses the existing definition
`cellVolumeAverage μ region field = (μ region).toReal⁻¹ • ∫ x in region, field x ∂μ`.
The checked Mathlib theorem Real.volume_Ioc gives
`volume (Set.Ioc a b) = ENNReal.ofReal (b-a)`.
Positive cell width and positive step length give ordinary spatial/time division
by length. Initialization includes interval integrability, and physical comparison
gets trace integrability from its explicit premises and the independent rectangle law.
The bridge alone is a total-operator identity and does not imply integrability.

Pure execution does not certify physical solutionhood. Finite-step error bounds
are additional hypotheses, not a definition of good approximation. The mass-rate
conclusion is almost everywhere in time for each fixed spatial interval; its
exceptional set can depend on that interval. The fixture restriction `0 < dt < 1`
is not a general method requirement or an adopted accuracy convention.

'''
body=intro+'\n\n'.join('```lean\n'+x['signature']+'\n```' for x in blocks)+'\n'
out.write_text(body,encoding='utf-8',newline='\n')
bind=lambda p:dict(path=str(p),sha256=sha256(p.read_bytes()).hexdigest())
receipt.write_text(json.dumps(dict(candidate=bind(source),contracts=bind(out),blocks=blocks,
 theorem_headers=sum(x['kind']=='theorem' for x in blocks),source_acceptance=False),indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(contracts=bind(out),receipt=bind(receipt))))
