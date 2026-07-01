#Requires -Version 5.1
<#
.SYNOPSIS
  Create a Laghaim game login account in MySQL (bg_user).

.DESCRIPTION
  Inserts rows into kor_ndev_neogeo_user (bg_user, t_users, bg_user_game) so the account
  can log in via Game.exe. All three are required — Connector auto-insert fails on MySQL
  5.7 strict mode (zero-date defaults in t_users).

.EXAMPLE
  .\create-account.ps1 -User myuser -Password mypass
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$User,

    [Parameter(Mandatory = $true)]
    [string]$Password,

    [string]$Email = '',

    [string]$DockerDir = (Join-Path $PSScriptRoot '..\docker')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Escape-SqlString([string]$s) {
    return $s.Replace("'", "''")
}

function Fail([string]$msg) {
    Write-Error $msg
    exit 1
}

$User = $User.Trim().ToLower()
if ($User.Length -lt 3 -or $User.Length -gt 30) {
    Fail "Username must be 3-30 characters."
}
if ($User.IndexOf("'") -ge 0 -or $User -match '\s') {
    Fail "Username cannot contain spaces or single quotes."
}
if ($Password.Length -lt 4 -or $Password.Length -gt 20) {
    Fail "Password must be 4-20 characters."
}
if ($Password.IndexOf("'") -ge 0) {
    Fail "Password cannot contain single quotes."
}

if (-not (Test-Path -LiteralPath $DockerDir)) {
    Fail "Docker directory not found: $DockerDir"
}

$email = if ([string]::IsNullOrWhiteSpace($Email)) { "$User@local" } else { $Email.Trim() }
$sqlUser = Escape-SqlString $User
$sqlPass = Escape-SqlString $Password
$sqlEmail = Escape-SqlString $email

Push-Location $DockerDir
try {
    $names = @(docker compose ps --status running --format '{{.Name}}' 2>$null)
    if ($names -notcontains 'laghaim-mysql') {
        Fail "laghaim-mysql is not running. Start: cd docker; docker compose up -d"
    }

    $exists = docker compose exec -T mysql mysql -uroot -plaghaimofficial -N -e `
        "SELECT COUNT(*) FROM kor_ndev_neogeo_user.bg_user WHERE user_id='$sqlUser';"
    if (($exists | Out-String).Trim() -ne '0') {
        Fail "Account already exists: $User"
    }

    $insertSql = @"
INSERT INTO bg_user (user_id, name, passwd, pw_gubun, email, chk_service, site_id, chk_lag_turn, enc_jumin1, enc_jumin3, regdate, regmail, regip)
VALUES ('$sqlUser', '$sqlUser', PASSWORD('$sqlPass'), 1, '$sqlEmail', 'Y', 'BG', 'Y', '700101', 1, NOW(), '$sqlEmail', '127.0.0.1');
SET @code = LAST_INSERT_ID();
INSERT INTO t_users (
  a_2p4p_user_code, a_2p4p_user_id, a_turn, a_connect, a_regi_date, a_partner_id,
  a_enable, a_sub_num, a_timestamp, a_jumin, a_birthday, a_birthday_type, a_sex,
  a_visit_count, a_visit_recent, a_mail_flag, a_sms_flag, a_accept_parent, a_pre_world, a_mpass, a_grade, a_stash_pwd
) VALUES (
  @code, '$sqlUser', 'Y', -1, NOW(), 'LH',
  1, 660, 0, '000000-0000000', '1970-01-01', 'P', 'M',
  1, '1970-01-01 00:00:00', 'Y', 1, 'Y', -1, 'N', 2, '0'
);
INSERT INTO bg_user_game (ugame_game_code, ugame_user_code, ugame_join_date, ugame_login_date)
VALUES ('LH', @code, CURDATE(), CURDATE());
"@

    docker compose exec -T mysql mysql -uroot -plaghaimofficial kor_ndev_neogeo_user -e $insertSql | Out-Null

    Write-Host "Account created: $User" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Launch Game.exe (SvrList.dta -> 127.0.0.1:4005)"
    Write-Host "  2. Log in with $User / your password"
    Write-Host "  3. Create a character at character select"
    Write-Host ""
    Write-Host "Verify:"
    docker compose exec -T mysql mysql -uroot -plaghaimofficial -e `
        "SELECT user_code, user_id, pw_gubun, chk_service FROM kor_ndev_neogeo_user.bg_user WHERE user_id='$sqlUser';"
}
finally {
    Pop-Location
}
