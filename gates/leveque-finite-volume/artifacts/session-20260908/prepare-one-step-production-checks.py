from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
paths={'ComputationalMathematics/Logic/Function/RangeFactorization.lean':['NumStability.Function.factorsThrough_iff_rangeFactorization'],'ComputationalMathematics/Source/LeVeque/Chapter01/OneStepCurrentData.lean':['NumStability.leveque01_oneStepMethod_iff_attainableCurrentDataMap']}
files=[{'path':p,'sha256':sha(R/p),'declarations':names} for p,names in paths.items()]
check=S/'one-step-general-production-checks.lean';assert not check.exists()
text='import ComputationalMathematics.Logic.Function.RangeFactorization\nimport ComputationalMathematics.Source.LeVeque.Chapter01.OneStepCurrentData\n\n'
for f in files:
 for name in f['declarations']:text+='#check '+name+'\n#print axioms '+name+'\n'
check.write_text(text,encoding='utf-8',newline='\n')
inputs={'schema':1,'input_commit':subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip(),'files':files,'check_file_sha256':sha(check),'draft_sha256':sha(S/'one-step-general-domain-draft/candidate.lean'),'draft_receipt_sha256':sha(S/'one-step-general-domain-draft/final-receipt.json'),'reuse_review_sha256':sha(S/'one-step-general-domain-draft/source-and-reuse-review.md'),'disposition':'One new reusable range-factorization theorem composing existing Mathlib producers, one source wrapper; previous finite-field source declaration retained. No source-faithfulness acceptance claimed.'}
p=S/'one-step-general-production-inputs.json';assert not p.exists();p.write_text(json.dumps(inputs,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest_sha256':sha(p),'checks_sha256':sha(check),'files':files}))
