$ErrorActionPreference = 'Stop'
$taskDirectory = $PSScriptRoot
$utf8 = [System.Text.UTF8Encoding]::new($false)
function Get-Entry([string]$Path) {
  $resolved = (Resolve-Path -LiteralPath $Path).Path
  return [ordered]@{path=$resolved; sha256=(Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash.ToLowerInvariant(); bytes=(Get-Item -LiteralPath $resolved).Length}
}
$provenance = Get-Content -LiteralPath (Join-Path $taskDirectory 'input-provenance.json') -Raw | ConvertFrom-Json
foreach ($item in @($provenance.source) + @($provenance.source_view) + @($provenance.inputs) + @($provenance.observed_gate.exact_snapshot)) {
  if ((Get-Entry $item.path).sha256 -ne $item.sha256) { throw ('Input changed: ' + $item.path) }
}
$collectorExit = Get-Content -LiteralPath (Join-Path $taskDirectory 'collector.exit.json') -Raw | ConvertFrom-Json
if ($collectorExit.exit_code -ne 0) { throw 'Evidence collection failed' }
foreach ($run in $provenance.searches) {
  if ($run.exit_code -notin @(0,1)) { throw 'Search execution error' }
  foreach ($stream in @($run.stdout,$run.stderr)) {
    if ((Get-Entry $stream.path).sha256 -ne $stream.sha256) { throw 'Search output changed' }
  }
}
$sessionDirectory = Split-Path $taskDirectory -Parent
$auditDirectory = Join-Path $sessionDirectory 'audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908'
$auditFiles = @(Get-ChildItem -LiteralPath $auditDirectory -Recurse -File | Sort-Object FullName | ForEach-Object { Get-Entry $_.FullName })
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'preserved-rejected-audit-file-hashes.json'), ($auditFiles | ConvertTo-Json -Depth 5) + "`n", $utf8)
$excluded = @('final-receipt.json','freeze.stdout.txt','freeze.stderr.txt','freeze.exit.json')
$artifacts = @(Get-ChildItem -LiteralPath $taskDirectory -File | Where-Object { $_.Name -notin $excluded } | Sort-Object Name | ForEach-Object { Get-Entry $_.FullName })
$receipt = [ordered]@{
  kind='additive source-locator scope review'
  source_faithfulness_verdict=$null
  recommendation='Fresh sentence-scoped audit of unchanged advection inventory row; retain source-term row separately and retain whole primary page as context'
  previous_rejection_preserved=$true
  previous_rejected_audit_file_count=$auditFiles.Count
  all_recorded_inputs_rehashed_unchanged=$true
  evidence_collector_exit_code=$collectorExit.exit_code
  search_exit_codes=@($provenance.searches | Select-Object label,exit_code)
  new_wrapper_needed_for_recommended_route=$false
  new_lean_declarations=@()
  native_lean_executed=$false
  artifacts=$artifacts
}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'final-receipt.json'), ($receipt | ConvertTo-Json -Depth 9) + "`n", $utf8)
@('review.md','locator-proposal.md','input-provenance.json','final-receipt.json') | ForEach-Object { Get-Entry (Join-Path $taskDirectory $_) } | ConvertTo-Json -Depth 4
exit 0
