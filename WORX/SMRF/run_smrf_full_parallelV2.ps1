$ErrorActionPreference = "Stop"

$threads = 6

$inputFolder  = "E:/TRANSFER/SERRA1/idk/filtered_tiles"
$outputFolder = "E:/TRANSFER/SERRA1/idk/filtered_tiles/smrf_classified"
$logFolder    = "E:/TRANSFER/SERRA1/idk/filtered_tiles/smrf_classified/logs"
$pdal = "C:/Users/TEMP/anaconda3/envs/pdal_env/Library/bin/pdal.exe"

New-Item -ItemType Directory -Force -Path $outputFolder | Out-Null
New-Item -ItemType Directory -Force -Path $logFolder    | Out-Null

$lazFiles = Get-ChildItem -Path $inputFolder -Filter *.laz
Write-Host "Found $($lazFiles.Count) LAZ tiles. Starting SMRF classification (keeping all points)..."

$jobs = New-Object System.Collections.Generic.List[System.Management.Automation.Job]

foreach ($file in $lazFiles) {

    while ($jobs.Count -ge $threads) {
        $finished = $jobs | Where-Object { $_.State -ne 'Running' }
        foreach ($j in $finished) {
            $jobs.Remove($j) | Out-Null
        }
        Start-Sleep -Seconds 1
    }

    $tile = $file.FullName -replace '\\','/'
    $name = $file.BaseName
    $outFile = "$outputFolder/$name`_smrf.laz"
    $logFile = "$logFolder/$name.log"
	$outFile = $outFile -replace '\\','/'
	$logFile = $logFile -replace '\\','/'


    # *** IMPORTANT: filters.range removed. ALL points preserved ***
    $pipeline = @"
{
  "pipeline": [
    "$tile",
    {
      "type": "filters.smrf",
      "slope": 0.25,
      "window": 20,
      "threshold": 0.45,
      "scalar": 1.1
    },
    {
      "type": "writers.las",
      "filename": "$outFile",
      "compression": "laszip"
    }
  ]
}
"@

	$job = Start-Job -ScriptBlock {
		param($json, $log, $pdalPath)
		$json | & $pdalPath pipeline --stdin --verbose 5 *> $log
	} -ArgumentList $pipeline, $logFile, "$pdal"

    $jobs.Add($job) | Out-Null
}

Write-Host "Waiting for all jobs to finish..."
Wait-Job -Job $jobs | Out-Null

Write-Host "======================================"
Write-Host "   ALL TILES FINISHED PROCESSING"
Write-Host "   Full SMRF classified tiles created"
Write-Host "   Output: $outputFolder"
Write-Host "   Logs:   $logFolder"
Write-Host "======================================"
