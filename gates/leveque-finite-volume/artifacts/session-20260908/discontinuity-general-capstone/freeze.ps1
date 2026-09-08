$ErrorActionPreference = 'Stop'
$taskDirectory = $PSScriptRoot
$utf8 = [System.Text.UTF8Encoding]::new($false)
function Get-Entry([string]$Path) {
  $resolved = (Resolve-Path -LiteralPath $Path).Path
  return [ordered]@{path=$resolved; sha256=(Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash.ToLowerInvariant(); bytes=(Get-Item -LiteralPath $resolved).Length}
}
$provenance = Get-Content -LiteralPath (Join-Path $taskDirectory 'input-provenance.json') -Raw | ConvertFrom-Json
$protectedInputs = @($provenance.source) + @($provenance.source_views) + @($provenance.production_receipt) + @($provenance.inputs)
foreach ($item in $protectedInputs) {
  if ((Get-Entry $item.path).sha256 -ne $item.sha256) { throw ('Input changed: ' + $item.path) }
}
$candidate = [System.IO.File]::ReadAllText((Join-Path $taskDirectory 'candidate.lean'))
$checks = [System.IO.File]::ReadAllText((Join-Path $taskDirectory 'declaration-checks.lean'))
if (-not $checks.StartsWith($candidate + "`n")) { throw 'Checks do not contain exact final candidate prefix' }
if ($candidate.Contains("`r")) { throw 'Final candidate must be LF' }
$checkReceipt = Get-Content -LiteralPath (Join-Path $taskDirectory 'final-declaration-checks.exit.json') -Raw | ConvertFrom-Json
if ($checkReceipt.exit_code -ne 0) { throw 'Final native check failed' }
if ((Get-Entry $checkReceipt.check_file).sha256 -ne $checkReceipt.check_file_sha256) { throw 'Final checked source hash changed' }
$outputPath = Join-Path $taskDirectory 'final-declaration-checks.stdout.txt'
if ((Get-Entry $outputPath).sha256 -ne $checkReceipt.stdout_sha256) { throw 'Final output changed' }
$output = [System.IO.File]::ReadAllText($outputPath)
if ($output -match '(?i)error:|warning:|sorryAx') { throw 'Unexpected error, warning, or sorry axiom in final output' }
$axiomMatches = [regex]::Matches($output, "'([^']+)' depends on axioms:\s*\[([^\]]*)\]")
if ($axiomMatches.Count -ne 12) { throw 'Expected twelve exact axiom reports' }
$axioms = @()
foreach ($match in $axiomMatches) {
  $names = @($match.Groups[2].Value.Split(',') | ForEach-Object { $_.Trim() })
  foreach ($name in $names) { if ($name -notin @('propext','Classical.choice','Quot.sound')) { throw ('Unexpected axiom: ' + $name) } }
  $axioms += [ordered]@{declaration=$match.Groups[1].Value; axioms=$names}
}
$first = Get-Content -LiteralPath (Join-Path $taskDirectory 'first-elaboration.exit.json') -Raw | ConvertFrom-Json
$second = Get-Content -LiteralPath (Join-Path $taskDirectory 'second-elaboration.exit.json') -Raw | ConvertFrom-Json
if ($first.exit_code -ne 1 -or $second.exit_code -ne 0) { throw 'Unexpected historical exits' }
if ((Get-Entry (Join-Path $taskDirectory 'failed-candidate-v1.lean')).sha256 -ne $first.check_file_sha256) { throw 'Failed snapshot does not match first run' }
if ((Get-Entry (Join-Path $taskDirectory 'checked-candidate-v2-with-warnings.lean')).sha256 -ne $second.check_file_sha256) { throw 'Second snapshot does not match second run' }
$oldImports = @(Get-Content -LiteralPath (Join-Path $taskDirectory 'checked-candidate-v2-with-warnings.lean') | Where-Object { $_.StartsWith('import ') })
$finalImports = @(Get-Content -LiteralPath (Join-Path $taskDirectory 'candidate.lean') | Where-Object { $_.StartsWith('import ') })
if (($oldImports -join "`n") -cne ($finalImports -join "`n")) { throw 'Imports changed since native --deps command' }
$dependencies = @(Get-Content -LiteralPath (Join-Path $taskDirectory 'candidate-dependencies.stdout.txt') | Where-Object { $_.Trim() } | ForEach-Object { Get-Entry $_ })
$excluded = @('final-receipt.json','freeze.stdout.txt','freeze.stderr.txt','freeze.exit.json')
$artifacts = @(Get-ChildItem -LiteralPath $taskDirectory -File | Where-Object { $_.Name -notin $excluded } | Sort-Object Name | ForEach-Object { Get-Entry $_.FullName })
$receipt = [ordered]@{
  kind='scratch general discontinuity comparison verification'
  source_audit_claim=$false
  final_candidate=(Get-Entry (Join-Path $taskDirectory 'candidate.lean'))
  final_candidate_lines=($candidate.Split("`n").Count - 1)
  final_candidate_exact_prefix_of_checked_file=$true
  final_check_actual_exit_code=$checkReceipt.exit_code
  historical_actual_exit_codes=@{first_elaboration=$first.exit_code; second_elaboration=$second.exit_code}
  all_protected_inputs_rehashed_unchanged=$true
  native_dependency_imports_unchanged=$true
  directly_loaded_olean_hashes=$dependencies
  declaration_axiom_checks=$axioms
  new_declarations=@($axioms | Where-Object { $_.declaration.StartsWith('NumStability.DiscontinuityComparisonDraft.') } | ForEach-Object { $_.declaration })
  artifacts=$artifacts
  limits='No production placement, source verdict, temporal-convention adoption, common null set over every interval, or full entropy claim'
}
[System.IO.File]::WriteAllText((Join-Path $taskDirectory 'final-receipt.json'), ($receipt | ConvertTo-Json -Depth 10) + "`n", $utf8)
@('candidate.lean','source-and-reuse-review.md','input-provenance.json','final-receipt.json') | ForEach-Object { Get-Entry (Join-Path $taskDirectory $_) } | ConvertTo-Json -Depth 4
exit 0
