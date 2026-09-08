$ErrorActionPreference='Stop'
$taskDirectory=$PSScriptRoot
$utf8=[System.Text.UTF8Encoding]::new($false)
function Get-Entry([string]$Path){
 $resolved=(Resolve-Path -LiteralPath $Path).Path
 return [ordered]@{path=$resolved;sha256=(Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash.ToLowerInvariant();bytes=(Get-Item -LiteralPath $resolved).Length}
}
$provenance=Get-Content -LiteralPath (Join-Path $taskDirectory 'input-provenance.json') -Raw|ConvertFrom-Json
foreach($item in @($provenance.source)+@($provenance.source_view)+@($provenance.inputs)+@($provenance.candidate_at_dependency_check)){
 if((Get-Entry $item.path).sha256 -ne $item.sha256){throw ('Input changed: '+$item.path)}
}
$candidate=[System.IO.File]::ReadAllText((Join-Path $taskDirectory 'candidate.lean'))
$checks=[System.IO.File]::ReadAllText((Join-Path $taskDirectory 'declaration-checks.lean'))
if(-not $checks.StartsWith($candidate+"`n") -or $candidate.Contains("`r")){throw 'Check prefix/LF mismatch'}
$runs=@()
foreach($label in @('first','second','declarations')){
 $run=Get-Content -LiteralPath (Join-Path $taskDirectory ($label+'-exit.json')) -Raw|ConvertFrom-Json
 $snapshot=if($label -eq 'first'){'failed-candidate-v1.lean'}elseif($label -eq 'second'){'candidate.lean'}else{'declaration-checks.lean'}
 if((Get-Entry (Join-Path $taskDirectory $snapshot)).sha256 -ne $run.source_sha256){throw ('Source mismatch: '+$label)}
 if((Get-Entry (Join-Path $taskDirectory ($label+'-output.txt'))).sha256 -ne $run.output_sha256){throw ('Output mismatch: '+$label)}
 $expected=if($label -eq 'first'){1}else{0}
 if($run.exit_code -ne $expected){throw ('Unexpected actual exit: '+$label)}
 $runs+=$run
}
$output=[System.IO.File]::ReadAllText((Join-Path $taskDirectory 'declarations-output.txt'))
if($output -match '\berror:|\bwarning:|sorryAx'){throw 'Final check has an error/warning/sorry axiom'}
$axioms=@()
foreach($match in [regex]::Matches($output,"'([^']+)' depends on axioms:\s*\[([^\]]*)\]")){
 $names=@($match.Groups[2].Value.Split(',')|ForEach-Object{$_.Trim()})
 foreach($name in $names){if($name -notin @('propext','Classical.choice','Quot.sound')){throw ('Unexpected axiom: '+$name)}}
 $axioms+=[ordered]@{declaration=$match.Groups[1].Value;axioms=$names}
}
foreach($match in [regex]::Matches($output,"'([^']+)' does not depend on any axioms")){
 $axioms+=[ordered]@{declaration=$match.Groups[1].Value;axioms=@()}
}
if($axioms.Count -ne 10){throw 'Expected ten axiom reports'}
$dependencies=@(Get-Content -LiteralPath (Join-Path $taskDirectory 'candidate-dependencies.stdout.txt')|Where-Object{$_.Trim()}|ForEach-Object{Get-Entry $_})
$excluded=@('final-receipt.json','freeze-output.txt','freeze-exit.json')
$artifacts=@(Get-ChildItem -LiteralPath $taskDirectory -File|Where-Object{$_.Name -notin $excluded}|Sort-Object Name|ForEach-Object{Get-Entry $_.FullName})
$receipt=[ordered]@{kind='Scratch one-step general-domain foundation';candidate=(Get-Entry (Join-Path $taskDirectory 'candidate.lean'));candidate_lines=($candidate.Split("`n").Count-1);source_audit_verdict=$null;all_inputs_rehashed_unchanged=$true;exact_candidate_prefix_checked=$true;native_runs=$runs;axiom_checks=$axioms;direct_import_oleans=$dependencies;artifacts=$artifacts;limits='No canonical introduction or source acceptance; deterministic update on selected admissible histories and actual current-data range; classical choice, no computability claim'}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'final-receipt.json'),($receipt|ConvertTo-Json -Depth 10)+"`n",$utf8)
@('candidate.lean','source-and-reuse-review.md','input-provenance.json','final-receipt.json')|ForEach-Object{Get-Entry (Join-Path $taskDirectory $_)}|ConvertTo-Json -Depth 4
exit 0
