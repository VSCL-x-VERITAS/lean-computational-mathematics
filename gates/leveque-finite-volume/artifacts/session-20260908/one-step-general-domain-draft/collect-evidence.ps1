$ErrorActionPreference = 'Stop'
$taskDirectory = $PSScriptRoot
$repoDirectory = (Resolve-Path (Join-Path $taskDirectory '../../../../..')).Path
$sessionDirectory = Split-Path $taskDirectory -Parent
$workspaceDirectory = Split-Path $repoDirectory -Parent
$utf8 = [System.Text.UTF8Encoding]::new($false)
function Get-Entry([string]$Path) {
  $resolved = (Resolve-Path -LiteralPath $Path).Path
  return [ordered]@{path=$resolved; sha256=(Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash.ToLowerInvariant(); bytes=(Get-Item -LiteralPath $resolved).Length}
}
function Invoke-Recorded([string]$Label, [string]$Executable, [string[]]$Arguments) {
  $stdout = Join-Path $taskDirectory ($Label + '.stdout.txt')
  $stderr = Join-Path $taskDirectory ($Label + '.stderr.txt')
  $quoted = @($Arguments | ForEach-Object { '"' + $_ + '"' })
  $process = Start-Process -FilePath $Executable -ArgumentList $quoted -WorkingDirectory $repoDirectory -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
  if ($process.ExitCode -notin @(0,1)) { throw ('Command error: ' + $Label) }
  return [ordered]@{label=$Label; executable=$Executable; arguments=$Arguments; working_directory=$repoDirectory; exit_code=$process.ExitCode; stdout=(Get-Entry $stdout); stderr=(Get-Entry $stderr)}
}
$rgExecutable=(Get-Command rg).Source
$lakeExecutable=(Get-Command lake).Source
$runs=@()
$runs+=Invoke-Recorded 'project-search' $rgExecutable @('-n','FactorsThrough|rangeFactorization|oneStep','ComputationalMathematics','-g','*.lean')
$runs+=Invoke-Recorded 'mathlib-factorization-search' $rgExecutable @('-n','FactorsThrough.*(range|[Ss]urject)|[Ss]urject.*[Ff]actorsThrough|Surjective\.(lift|hasRightInverse)','.lake/packages/mathlib/Mathlib','-g','*.lean')
$runs+=Invoke-Recorded 'mathlib-exact-producers' $rgExecutable @('-n','def FactorsThrough|lemma factorsThrough_iff|theorem Surjective.hasRightInverse|def rangeFactorization|rangeFactorization_surjective','.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean','.lake/packages/mathlib/Mathlib/Data/Set/Operations.lean')
$runs+=Invoke-Recorded 'native-version' $lakeExecutable @('env','lean','--version')
$runs+=Invoke-Recorded 'candidate-dependencies' $lakeExecutable @('env','lean','--deps',(Join-Path $taskDirectory 'candidate.lean'))
$auditDirectory=Join-Path $sessionDirectory 'audits/LEV-CH01-ONE-STEP-METHOD-DEFINITION-PRODUCTION-20260908'
$paths=@(
  (Join-Path $repoDirectory 'AGENTS.md'),
  (Join-Path $repoDirectory 'lean-toolchain'),
  (Join-Path $repoDirectory 'lake-manifest.json'),
  (Join-Path $repoDirectory 'ComputationalMathematics/Source/LeVeque/Chapter01/OneStepMethod.lean'),
  (Join-Path $repoDirectory '.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean'),
  (Join-Path $repoDirectory '.lake/packages/mathlib/Mathlib/Data/Set/Operations.lean'),
  (Join-Path $auditDirectory 'audit-task.json'),
  (Join-Path $auditDirectory 'faithfulness/inputs/source_locator.json'),
  (Join-Path $auditDirectory 'faithfulness/decision.json'),
  (Join-Path $auditDirectory 'faithfulness/report.md')
)
$inputs=@($paths|ForEach-Object{Get-Entry $_})
$decision=Get-Entry (Join-Path $auditDirectory 'faithfulness/decision.json')
if($decision.sha256 -ne '407f81e19b77273538f53bce5cb3894398d0615ca932a6e87ca02f37071b80d7'){throw 'Decision hash mismatch'}
$report=Get-Entry (Join-Path $auditDirectory 'faithfulness/report.md')
if($report.sha256 -ne '976369574b1dc976e7e2bd0113ce9526751096eea1eccf9bce74db1369914bb7'){throw 'Report hash mismatch'}
$source=Get-Entry (Join-Path $sessionDirectory 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf')
if($source.sha256 -ne 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'){throw 'Source hash mismatch'}
$view=Get-Entry (Join-Path $workspaceDirectory 'workflow-v5.0.1-local/chapter01-source-review/page-032.png')
$view.printed_page=10
$view.raw_pdf_page_one_based=32
$view.actually_viewed=$true
$record=[ordered]@{kind='Scratch general current-data factorization foundation';source=$source;source_view=$view;inputs=$inputs;commands=$runs;mathlib_revision='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b';candidate_at_dependency_check=(Get-Entry (Join-Path $taskDirectory 'candidate.lean'));source_audit_verdict=$null;writes='Only one-step-general-domain-draft'}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'input-provenance.json'),($record|ConvertTo-Json -Depth 10)+"`n",$utf8)
Write-Output 'Recorded source/input hashes, scoped search replay, native version and exact candidate imports.'
exit 0
