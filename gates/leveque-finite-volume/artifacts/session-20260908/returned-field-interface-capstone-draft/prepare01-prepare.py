"""Read-only source/dependency preparation for an unselected scratch capstone."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,fitz
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
task=S/'audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/audit-task.json'
t=json.loads(task.read_bytes());pdf=R/t['source']['path'];assert sha(pdf)==t['source']['sha256']
mp=S/'returned-field-production/placement-map.json';m=json.loads(mp.read_bytes())
assert sha(S/'returned-field-production/final-receipt.json')=='8e9aa4b4c6f2eb47ffdc237ddadc637bc8247c8ddbe3ba88a953f87778b10605'
for p,h in m['source_files'].items():assert sha(R/p)==h,p
searches=[['rg','-n','ReturnedFieldInterfaceDraft|pure_interface_execution|returned_field_comparison_contract','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean'],['rg','-n','RiemannFieldFluxMethod|adjacentCellRiemannProblem|rectangleRiemannInterfaceFlux|riemannFiniteVolumeUpdate_error_le','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume','-g','*.lean']]
sr=[]
for i,cmd in enumerate(searches):
 r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 assert r.returncode==(1 if i==0 else 0)
 p=P/f'search-{i+1}.txt';assert not p.exists();p.write_bytes(r.stdout)
 sr.append(dict(command=cmd,exit_code=r.returncode,output=bind(p)))
pages=[]
doc=fitz.open(pdf)
for raw in [26,27,28]:
 page=doc[raw-1];text=P/f'page-{raw:03}.txt';png=P/f'page-{raw:03}.png'
 assert not text.exists() and not png.exists()
 text.write_bytes(page.get_text().encode('utf-8'))
 page.get_pixmap(matrix=fitz.Matrix(1.4,1.4),alpha=False).save(png)
 pages.append(dict(raw_page=raw,printed_page=raw-22,text=bind(text),render=bind(png)))
context=[task,pdf,S/'current-thread-clarification-provenance-batch8.json',mp,S/'returned-field-production/final-receipt.json',S/'returned-field-production/REVIEW.md',task.parent/'faithfulness/decision.json',task.parent/'faithfulness/report.md']
sources=[R/p for p in m['source_files']]
for n in ['RectangleRiemannInterface','RiemannInterface','CellAverage','FluxUpdateErrorBounds','PhysicalFluxAverage']:
 sources.append(R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'/f'{n}.lean')
v=dict(schema=1,created_at_utc=datetime.now(timezone.utc).isoformat(),status='prospective_unselected',source_acceptance=False,context=[bind(p) for p in context],canonical_sources=[bind(p) for p in sources],primary_source_pages=pages,searches=sr,render_engine=fitz.VersionBind)
p=P/'preparation.json';assert not p.exists();p.write_bytes((json.dumps(v,indent=2)+'\n').encode())
print(json.dumps(dict(preparation_sha256=sha(p),source_sha256=sha(pdf),raw_pages=[26,27,28])))
