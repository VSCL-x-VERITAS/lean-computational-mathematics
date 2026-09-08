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
function Invoke-Search([string]$Label, [string[]]$Arguments) {
  $executable = (Get-Command rg).Source
  $stdout = Join-Path $taskDirectory ($Label + '.stdout.txt')
  $stderr = Join-Path $taskDirectory ($Label + '.stderr.txt')
  $quoted = @($Arguments | ForEach-Object { '"' + $_ + '"' })
  $process = Start-Process -FilePath $executable -ArgumentList $quoted -WorkingDirectory $repoDirectory -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
  if ($process.ExitCode -notin @(0,1)) { throw ('Search error: ' + $Label) }
  return [ordered]@{label=$Label; executable=$executable; arguments=$Arguments; cwd=$repoDirectory; exit_code=$process.ExitCode; stdout=(Get-Entry $stdout); stderr=(Get-Entry $stderr)}
}
$searches = @()
$searches += Invoke-Search 'project-reuse' @('-n','source.?term|SourceTerm|BalanceLaw|advection.*Flux|nonconservation','ComputationalMathematics/Source/LeVeque/Chapter01','ComputationalMathematics/Analysis/PartialDifferentialEquations','-g','*.lean')
$searches += Invoke-Search 'mathlib-reuse' @('-n','nonconservation|source.?term|balance.?law','.lake/packages/mathlib/Mathlib/Analysis/Calculus','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral','-g','*.lean')
$searches += Invoke-Search 'inventory-navigation' @('-n','ADVECTION-LINEAR-FLUX|NONCONSERVATION-SOURCE-TERMS','gates/leveque-finite-volume/chapter-01.json','gates/leveque-finite-volume/artifacts/session-20260908/independent-inventory-review-final.md')
$gatePath = Join-Path $repoDirectory 'gates/leveque-finite-volume/chapter-01.json'
$gateSnapshot = Join-Path $taskDirectory 'chapter-01-observed.json'
[System.IO.File]::WriteAllBytes($gateSnapshot, [System.IO.File]::ReadAllBytes($gatePath))
$gate = [System.IO.File]::ReadAllText($gateSnapshot) | ConvertFrom-Json
$rows = @($gate.rows | Where-Object { $_.id -in @('LEV-CH01-ADVECTION-LINEAR-FLUX','LEV-CH01-NONCONSERVATION-SOURCE-TERMS') })
if ($rows.Count -ne 2) { throw 'Expected both independently tracked rows' }
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'observed-inventory-rows.json'), ($rows | ConvertTo-Json -Depth 10) + "`n", $utf8)
$auditDirectory = Join-Path $sessionDirectory 'audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908'
$inputs = @(
  (Join-Path $auditDirectory 'audit-task.json'),
  (Join-Path $auditDirectory 'faithfulness/decision.json'),
  (Join-Path $auditDirectory 'faithfulness/inputs/source_locator.json'),
  (Join-Path $auditDirectory 'faithfulness/agent_outputs/source_contract.json'),
  (Join-Path $auditDirectory 'faithfulness/agent_outputs/adjudicator.json'),
  (Join-Path $sessionDirectory 'independent-inventory-review-final.md'),
  (Join-Path $repoDirectory 'ComputationalMathematics/Source/LeVeque/Chapter01/AdvectionLinearFlux.lean'),
  (Join-Path $repoDirectory 'ComputationalMathematics/Source/LeVeque/Chapter01/NonconservationSourceTerms.lean'),
  (Join-Path $repoDirectory 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/BalanceLaw.lean'),
  (Join-Path $repoDirectory 'lean-toolchain'),
  (Join-Path $repoDirectory 'lake-manifest.json')
)
$inputEntries = @($inputs | ForEach-Object { Get-Entry $_ })
$decision = Get-Entry (Join-Path $auditDirectory 'faithfulness/decision.json')
if ($decision.sha256 -ne '82c70fc8aae81f9790650f4e5ed6410008c1bb222dd908a5f89691b4db94c329') { throw 'Frozen decision hash mismatch' }
$source = Get-Entry (Join-Path $sessionDirectory 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf')
if ($source.sha256 -ne 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5') { throw 'Pinned source hash mismatch' }
$view = Get-Entry (Join-Path $workspaceDirectory 'workflow-v5.0.1-local/chapter01-source-review/page-026.png')
$view.printed_page=4
$view.raw_pdf_page_one_based=26
$view.actually_viewed=$true
$record = [ordered]@{kind='Read-only inventory/source-locator scope review, not a source audit'; source=$source; source_view=$view; inputs=$inputEntries; observed_gate=@{original_path=$gatePath; exact_snapshot=(Get-Entry $gateSnapshot); caveat='Other rows may evolve concurrently; this is an observed snapshot, not a gate edit or audit authority'}; searches=$searches; new_lean_draft=$false; native_lean_executed=$false; reason='Minimal remedy is row-aligned source selection; no combined wrapper or new producer required'; writes='Only new advection-flux-scope-review directory'}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'input-provenance.json'), ($record | ConvertTo-Json -Depth 10) + "`n", $utf8)
$record | ConvertTo-Json -Depth 2
exit 0
