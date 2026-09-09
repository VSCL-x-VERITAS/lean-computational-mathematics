from pathlib import Path
import re
P=Path(__file__).resolve().parent
for name in ('Candidate.lean','Check.lean'):
    path=P/name;s=path.read_text(encoding='utf-8')
    a=s.index('namespace BiasedPhysicalInterval');b=s.index('end BiasedPhysicalInterval',a)
    part=s[a:b]
    part=part.replace('local notation "Cell" => Fin 1 → ℤ\n','').replace('local notation "State" => Fin 1 → ℝ\n','')
    part=re.sub(r'\bCell\b','(Fin 1 → ℤ)',part)
    part=re.sub(r'\bState\b','(Fin 1 → ℝ)',part)
    path.write_text(s[:a]+part+s[b:],encoding='utf-8',newline='\n')
