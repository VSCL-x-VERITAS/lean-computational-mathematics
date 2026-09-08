$ErrorActionPreference = 'Stop'
$taskDirectory = $PSScriptRoot
$repoDirectory = (Resolve-Path (Join-Path $taskDirectory '../../../../..')).Path
$workspaceDirectory = Split-Path $repoDirectory -Parent
$sessionDirectory = Split-Path $taskDirectory -Parent
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
  $entry = [ordered]@{label=$Label; executable=$Executable; arguments=$Arguments; working_directory=$repoDirectory; exit_code=$process.ExitCode; stdout=(Get-Entry $stdout); stderr=(Get-Entry $stderr)}
  [System.IO.File]::WriteAllText((Join-Path $taskDirectory ($Label + '.exit.json')), ($entry | ConvertTo-Json -Depth 7) + "`n", $utf8)
  return $entry
}
$rgExecutable = (Get-Command rg).Source
$lakeExecutable = (Get-Command lake).Source
$runs = @()
$runs += Invoke-Recorded 'search-project' $rgExecutable @('-n','IsQuasilinearConservationLawSolutionAt|hasDerivAt_mass_ae|not_continuousAt_zero|timeShiftedStep_no_classical|riemannData_intervalIntegrable','ComputationalMathematics/Analysis/PartialDifferentialEquations','-g','*.lean')
$runs += Invoke-Recorded 'search-mathlib-derivative' $rgExecutable @('-n','theorem HasDerivAt.continuousAt|theorem DifferentiableAt.continuousAt','.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Basic.lean','.lake/packages/mathlib/Mathlib/Analysis/Calculus/FDeriv/Basic.lean')
$runs += Invoke-Recorded 'search-mathlib-composition' $rgExecutable @('-n','theorem ContinuousAt.comp','.lake/packages/mathlib/Mathlib/Topology/Continuous.lean')
$runs += Invoke-Recorded 'native-version' $lakeExecutable @('env','lean','--version')
$runs += Invoke-Recorded 'candidate-dependencies' $lakeExecutable @('env','lean','--deps',(Join-Path $taskDirectory 'candidate.lean'))
if (@($runs | Where-Object { $_.exit_code -ne 0 }).Count -ne 0) { throw 'A recorded command failed; inspect its retained output.' }
$inputRelative = @(
  'AGENTS.md', 'lean-toolchain', 'lake-manifest.json',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAdvection.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TemporalDerivative.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/MovingStep.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean',
  'ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiation.lean',
  '.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Basic.lean',
  '.lake/packages/mathlib/Mathlib/Analysis/Calculus/FDeriv/Basic.lean',
  '.lake/packages/mathlib/Mathlib/Topology/Continuous.lean',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiationThm.lean',
  '.lake/packages/mathlib/Mathlib/MeasureTheory/SpecificCodomains/Pi.lean'
)
$inputs = @($inputRelative | ForEach-Object { Get-Entry (Join-Path $repoDirectory $_) })
$source = Get-Entry (Join-Path $sessionDirectory 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf')
if ($source.sha256 -ne 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5') { throw 'Pinned source hash mismatch' }
$productionReceipt = Get-Entry (Join-Path $sessionDirectory 'interpreted-transport-production-verification.json')
if ($productionReceipt.sha256 -ne '1d29d6ff7cc0f87ba18075b5e0c184873466335eb7569f6886549455f7dccc32') { throw 'Production receipt hash mismatch' }
$auditDirectory = Join-Path $sessionDirectory 'audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness'
$inputs += Get-Entry (Join-Path $auditDirectory 'decision.json')
$inputs += Get-Entry (Join-Path $auditDirectory 'agent_outputs/adjudicator.json')
$views = @(26,27 | ForEach-Object {
  $entry = Get-Entry (Join-Path $workspaceDirectory ('workflow-v5.0.1-local/chapter01-source-review/page-{0:D3}.png' -f $_))
  $entry.raw_pdf_page_one_based = $_
  $entry.printed_page = $_ - 22
  $entry.actually_viewed = $true
  $entry
})
$record = [ordered]@{kind='scratch proof and source-scope provenance, not source audit'; source=$source; source_views=$views; production_receipt=$productionReceipt; inputs=$inputs; commands=$runs; mathlib_revision='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'; source_scope='LeVeque printed 4-5/raw26-27; no inferred temporal convention'; writes='Only new discontinuity-general-capstone directory'}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'input-provenance.json'), ($record | ConvertTo-Json -Depth 10) + "`n", $utf8)
$record.commands | Select-Object label,exit_code | Format-Table
