param (
    [Parameter(Mandatory=$true)]
    [string]$VersionName
)

$changelogPath = ".\CHANGELOG.md"
if (-Not (Test-Path -Path $changelogPath)) {
    Write-Host "Error: Changelog file '$changelogPath' not found." -ForegroundColor Red
    exit 1
}


$changelogContent = Get-Content -Path $changelogPath
$pattern = "(## \[$VersionName.*?\](.*?))(?=## \[|\Z)"

$match = [regex]::Matches($changelogContent -join "`n", $pattern, 'SingleLine') | Select-Object -First 1

if ($match -ne $null) {
    $releaseNotes = $match.Groups[1].Value.Trim() -replace "`r`n", "`n"
    Write-Host $releaseNotes
} else {
    Write-Host "Error: Release notes for version '$VersionName' not found." -ForegroundColor Red
    exit 1
}
