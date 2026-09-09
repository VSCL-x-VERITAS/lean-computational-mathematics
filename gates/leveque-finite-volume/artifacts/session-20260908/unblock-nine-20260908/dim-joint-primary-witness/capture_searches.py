"""Bounded read-only reuse search capture; no semantic audit or Git."""
from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
specs=[
 ['rg','-n','LineRealization|coordinate_highResolution_sourceContract|CartesianIdentification|family_quality',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'],
 ['rg','-n','integrable_const|integrable_zero|isFiniteMeasure_iff',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Typeclasses/Finite.lean',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Function/L1Space/Integrable.lean']]
records=[]
for index,argv in enumerate(specs,1):
 out=P/('reuse-search-%02d.txt'%index)
 with out.open('xb') as stream:r=subprocess.run(argv,cwd=R,stdout=stream,stderr=subprocess.STDOUT)
 records.append({'argv':argv,'exit_code':r.returncode,'output':{'path':out.relative_to(R).as_posix(),
  'sha256':hashlib.sha256(out.read_bytes()).hexdigest()}})
with (P/'reuse-searches.json').open('x',encoding='utf-8',newline='\n') as stream:
 stream.write(json.dumps({'schema':1,'searches':records,'scope':'Listed paths only; no exhaustive absence claim',
  'selection':'Immutable core-final02/Cartesian/family snapshots; current canonical placement remains separate',
  'rejections':['Separate family and geometry inhabitants do not prove joint applicability',
                'Do not assume the chosen stability rate is the zero existential witness',
                'Do not import concurrently mutable newly placed canonical owners']},indent=2)+'\n')
