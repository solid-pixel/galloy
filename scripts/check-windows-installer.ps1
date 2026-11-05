# Run only on a disposable Windows CI runner. The fixture represents an existing Halloy install.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
if ($env:GITHUB_ACTIONS -ne "true") { throw "This registry fixture must run on a disposable GitHub Actions runner." }

$root = Split-Path $PSScriptRoot -Parent
$work = Join-Path ([IO.Path]::GetTempPath()) ("galloy-installer-" + [guid]::NewGuid())
$install = Join-Path $work "Galloy"
$upstream = "HKCU:\Software\Halloy\Capabilities"
$upstreamUninstall = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{47E965E7-FD7A-4BC4-9D75-9F4DE4A24E37}"
$schemes = @("halloy", "irc", "ircs")
$ownKeys = @("HKCU:\Software\Galloy", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{795C3E44-2945-4FBA-86C2-914F52EAB153}_is1")
foreach ($path in (@($upstream, $upstreamUninstall) + $ownKeys + @($schemes | ForEach-Object { "HKCU:\Software\Classes\$_" }))) {
    if (Test-Path $path) { throw "Refusing to replace an existing registry key: $path" }
}

function Assert-UpstreamUnchanged {
    foreach ($scheme in $schemes) {
        $path = "HKCU:\Software\Classes\$scheme"
        if ((Get-Item $path).GetValue("") -ne "Upstream $scheme handler") { throw "$scheme default changed" }
    }
    if ((Get-Item $upstream).GetValue("ApplicationName") -ne "Halloy") { throw "Halloy capabilities changed" }
    if ((Get-Item $upstreamUninstall).GetValue("DisplayName") -ne "Halloy") { throw "Halloy uninstall entry changed" }
    if (!(Test-Path (Join-Path $work "Halloy\halloy.exe"))) { throw "Halloy executable removed" }
}

function Invoke-Installer($file, $arguments) {
    $process = Start-Process -FilePath $file -ArgumentList $arguments -Wait -PassThru
    if ($process.ExitCode -ne 0) { throw "$file returned $($process.ExitCode)" }
}

try {
    New-Item -ItemType Directory -Force (Join-Path $work "Halloy") | Out-Null
    Set-Content (Join-Path $work "Halloy\halloy.exe") "Upstream binary fixture"
    foreach ($scheme in $schemes) {
        $path = "HKCU:\Software\Classes\$scheme"
        New-Item -Path $path -Force | Out-Null
        Set-Item -Path $path -Value "Upstream $scheme handler"
    }
    New-Item -Path $upstream -Force | Out-Null
    New-ItemProperty -Path $upstream -Name ApplicationName -Value Halloy | Out-Null
    New-Item -Path $upstreamUninstall -Force | Out-Null
    New-ItemProperty -Path $upstreamUninstall -Name DisplayName -Value Halloy | Out-Null
    New-ItemProperty -Path $upstreamUninstall -Name Publisher -Value Squidowl | Out-Null
    New-ItemProperty -Path $upstreamUninstall -Name WindowsInstaller -Value 1 -PropertyType DWord | Out-Null

    $installer = Join-Path $root "target\ci\galloy-installer.exe"
    Invoke-Installer $installer @("/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/CURRENTUSER", "/DIR=`"$install`"", "/LOG=`"$work\install.log`"")
    Assert-UpstreamUnchanged
    if (!(Test-Path (Join-Path $install "galloy.exe"))) { throw "Galloy executable missing" }
    if (Test-Path (Join-Path $install "halloy.exe")) { throw "Galloy installed under upstream executable name" }
    if ((Get-ItemProperty (Join-Path $install "galloy.exe")).VersionInfo.FileDescription -notlike "Galloy*") { throw "Executable description is not Galloy" }
    if ((Get-Item "HKCU:\Software\RegisteredApplications").GetValue("Galloy") -ne "Software\Galloy\Capabilities") { throw "Galloy capabilities missing" }
    foreach ($scheme in $schemes) {
        $progid = "Galloy.$($scheme.ToUpperInvariant())"
        if ((Get-Item "HKCU:\Software\Galloy\Capabilities\URLAssociations").GetValue($scheme) -ne $progid) { throw "Missing Galloy $scheme association" }
        $command = (Get-Item "HKCU:\Software\Classes\$progid\shell\open\command").GetValue("")
        if ($command -ne "`"$install\galloy.exe`" `"%1`"") { throw "Incorrect handler: $command" }
    }
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("Programs")) "Galloy\Galloy.lnk"))
    if ($shortcut.TargetPath -ne (Join-Path $install "galloy.exe")) { throw "Start menu target is not Galloy" }

    Invoke-Installer (Join-Path $install "unins000.exe") @("/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART")
    Assert-UpstreamUnchanged
    foreach ($scheme in $schemes) {
        if (Test-Path "HKCU:\Software\Classes\Galloy.$($scheme.ToUpperInvariant())") { throw "Galloy handler survived uninstall" }
    }
    if ((Get-Item "HKCU:\Software\RegisteredApplications").GetValue("Galloy")) { throw "Galloy registration survived uninstall" }
    if (Test-Path (Join-Path $install "galloy.exe")) { throw "Galloy executable survived uninstall" }
    Write-Output "Windows silent install, shortcuts, URL registration, uninstall, and Halloy coexistence checks passed."
} finally {
    foreach ($path in (@($upstream, $upstreamUninstall) + $ownKeys + @($schemes | ForEach-Object { "HKCU:\Software\Classes\$_" }) + @($schemes | ForEach-Object { "HKCU:\Software\Classes\Galloy.$($_.ToUpperInvariant())" }))) {
        if (Test-Path $path) { Remove-Item $path -Recurse -Force }
    }
    if (Test-Path $work) { Remove-Item $work -Recurse -Force }
}
