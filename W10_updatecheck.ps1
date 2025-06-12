# Windows Update-Modul importieren (falls nötig)
Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue

# Verfügbare Updates abfragen
$updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot

if ($updates) {
    Write-Output "Es sind Updates verfügbar:"
    $updates | Format-Table -Property KB, Title
} else {
    Write-Output "Keine Updates verfügbar."
}
