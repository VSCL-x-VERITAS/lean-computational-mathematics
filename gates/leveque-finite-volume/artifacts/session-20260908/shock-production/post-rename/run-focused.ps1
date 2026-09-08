$ErrorActionPreference = 'Stop'
$repoPath = (Get-Location).Path
$directory = 'gates/leveque-finite-volume/artifacts/session-20260908/shock-production/post-rename'
$modules = Get-Content -LiteralPath "$directory/modules.json" -Raw | ConvertFrom-Json
$items = for ($index = 4; $index -lt $modules.Count; $index++) {
  [pscustomobject]@{index=($index + 1);module=$modules[$index]}
}
$results = $items | ForEach-Object -ThrottleLimit 2 -Parallel {
  Set-Location -LiteralPath $using:repoPath
  $directory = $using:directory
  $item = $_
  $path = $item.module.Replace('.', '/') + '.lean'
  $outputName = 'module-' + $item.index.ToString('00') + '-elaboration.txt'
  [System.IO.File]::WriteAllText((Join-Path $using:repoPath "$directory/$outputName"), '')
  & lake env lean $path 2>&1 | Set-Content -LiteralPath "$directory/$outputName" -Encoding utf8
  $compileExit = $LASTEXITCODE
  $record = [ordered]@{index=$item.index;command="lake env lean $path";exit_code=$compileExit;output=$outputName}
  $record | ConvertTo-Json | Set-Content -LiteralPath "$directory/module-$($item.index)-exit.json" -Encoding utf8
  Write-Host "Post-rename module $($item.index) exited $compileExit"
  [pscustomobject]$record
}
$results | Sort-Object index | ConvertTo-Json -Depth 4 |
  Set-Content -LiteralPath "$directory/focused-exits.json" -Encoding utf8
if (@($results | Where-Object { $_.exit_code -ne 0 }).Count -gt 0) { exit 1 }
$path = "$directory/Declarations.lean"
& lake env lean $path 2>&1 | Tee-Object -FilePath "$directory/declarations-output.txt"
$compileExit = $LASTEXITCODE
[ordered]@{command="lake env lean $path";exit_code=$compileExit;output='declarations-output.txt'} |
  ConvertTo-Json | Set-Content -LiteralPath "$directory/declarations-exit.json" -Encoding utf8
exit $compileExit
