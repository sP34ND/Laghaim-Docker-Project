# Export mob / zone drop tables from the running Docker MySQL stack to CSV.
# Usage: .\tools\export-mob-drops.ps1
# Requires: laghaim-mysql container up (docker compose in docker/)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$DockerDir = Join-Path $Root "docker"
$OutDir = $PSScriptRoot
$Pw = "laghaimofficial"
if (Test-Path (Join-Path $DockerDir ".env")) {
    foreach ($line in Get-Content (Join-Path $DockerDir ".env")) {
        if ($line -match '^\s*MYSQL_ROOT_PASSWORD=(.+)$') { $Pw = $Matches[1].Trim() }
    }
}

function Export-QueryCsv {
    param(
        [string]$SqlFile,
        [string]$OutFile
    )
    $sqlPath = Join-Path $OutDir $SqlFile
    if (-not (Test-Path $sqlPath)) { throw "Missing $sqlPath" }

    $headers = @{
        "export-mob-drops.sql"  = "drop_type,mob_vnum,mob_name,mob_level,mob_exp,drop_slot,item_vnum,item_name,drop_rate,rate_scale,group_num,group_type"
        "export-zone-drops.sql" = "item_vnum,item_name,item_count,item_plus,level_cap,rate_profile,rate_profile_id,a_zone0,a_zone1,a_zone2,a_zone3,a_zone4,a_zone5,a_zone6,a_zone7,a_zone8,a_zone9,a_zone10,a_zone11,a_zone12,a_zone13,a_zone14,a_zone15,a_zone16,a_zone17,a_zone18,a_zone19,a_zone20,a_zone21,a_zone22,a_zone23,a_zone24,a_zone25"
        "export-mob-summary.sql"  = "mob_vnum,mob_name,mob_level,mob_exp,base_exp,direct_item_slots,direct_rate_slots,has_group_drop_table,spawns_in_world"
    }
    $header = $headers[$SqlFile]

    $sql = Get-Content $sqlPath -Raw -Encoding UTF8
    $raw = $sql | docker compose -f (Join-Path $DockerDir "docker-compose.yml") exec -T -e "MYSQL_PWD=$Pw" mysql `
        mysql -uroot --batch --raw --skip-column-names kor_ndev_neogeo_data
    if ($LASTEXITCODE -ne 0) { throw "MySQL export failed for $SqlFile (exit $LASTEXITCODE)" }
    $lines = @($raw)
    $csv = @($header)
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $fields = $line -split "`t"
        $escaped = foreach ($f in $fields) {
            $s = [string]$f
            if ($s -match '[",\r\n]') { '"' + ($s -replace '"', '""') + '"' } else { $s }
        }
        $csv += ($escaped -join ",")
    }
    Set-Content -Path $OutFile -Value $csv -Encoding UTF8
    Write-Host "Wrote $($csv.Count - 1) data rows -> $OutFile"
}

Push-Location $DockerDir
try {
    Export-QueryCsv "export-mob-drops.sql" (Join-Path $OutDir "mob-drop-list.csv")
    Export-QueryCsv "export-zone-drops.sql" (Join-Path $OutDir "zone-drop-list.csv")
    Export-QueryCsv "export-mob-summary.sql" (Join-Path $OutDir "mob-drop-summary.csv")
}
finally {
    Pop-Location
}

Write-Host "Done:"
Write-Host "  tools/mob-drop-list.csv   - every per-mob drop row (direct + group tables)"
Write-Host "  tools/zone-drop-list.csv  - zone-wide drops (any kill in that world)"
Write-Host "  tools/mob-drop-summary.csv - all 871 mobs with drop counts"
