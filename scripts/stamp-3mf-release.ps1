param(
  [switch]$CheckOnly
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$release = Get-Content -LiteralPath (Join-Path $repoRoot 'release\current.json') -Raw | ConvertFrom-Json
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Escape-Xml([string]$value) {
  return [System.Security.SecurityElement]::Escape($value)
}

function Set-Metadata([string]$xml, [string]$name, [string]$value) {
  $escapedName = [regex]::Escape($name)
  $element = '<metadata name="' + $name + '" preserve="1">' + (Escape-Xml $value) + '</metadata>'
  $pattern = '<metadata\s+name="' + $escapedName + '"[^>]*>.*?</metadata>'
  if ([regex]::IsMatch($xml, $pattern, [Text.RegularExpressions.RegexOptions]::Singleline)) {
    return [regex]::Replace($xml, $pattern, $element, [Text.RegularExpressions.RegexOptions]::Singleline)
  }
  return [regex]::Replace($xml, '(<model\b[^>]*>)', '$1' + [Environment]::NewLine + ' ' + $element, 1)
}

foreach ($artifact in $release.artifacts | Where-Object { $_.type -eq '3mf-project' }) {
  $sourcePath = Join-Path $repoRoot ($artifact.source -replace '/', '\')
  $archive = [IO.Compression.ZipFile]::Open($sourcePath, [IO.Compression.ZipArchiveMode]::Update)
  try {
    $entry = $archive.GetEntry('3D/3dmodel.model')
    if ($null -eq $entry) { throw "3D/3dmodel.model is missing from $($artifact.source)" }
    $reader = New-Object IO.StreamReader($entry.Open(), [Text.Encoding]::UTF8)
    try { $xml = $reader.ReadToEnd() } finally { $reader.Dispose() }

    $description = $artifact.description + ' Changes: ' + ($release.changes -join ' ')
    $expected = @{
      'Title' = $artifact.title
      'Designer' = 'Double Take Frames'
      'Description' = $description
      'ModificationDate' = $release.releaseDate
      'dtf:ReleaseVersion' = $release.version
      'dtf:VersionStandard' = $release.versionStandard
    }

    if ($CheckOnly) {
      foreach ($pair in $expected.GetEnumerator()) {
        $pattern = '<metadata\s+name="' + [regex]::Escape($pair.Key) + '"[^>]*>' + [regex]::Escape((Escape-Xml $pair.Value)) + '</metadata>'
        if (-not [regex]::IsMatch($xml, $pattern, [Text.RegularExpressions.RegexOptions]::Singleline)) {
          throw "$($artifact.source) has missing or stale 3MF metadata: $($pair.Key)"
        }
      }
      continue
    }

    if ($xml -notmatch 'xmlns:dtf=') {
      $xml = [regex]::Replace($xml, '<model\b', '<model xmlns:dtf="https://doubletakeframes.com/3mf/metadata/2026/08"', 1)
    }
    $updated = $xml
    foreach ($pair in $expected.GetEnumerator()) {
      $updated = Set-Metadata $updated $pair.Key $pair.Value
    }
    if ($updated -eq $xml) { continue }

    $entry.Delete()
    $newEntry = $archive.CreateEntry('3D/3dmodel.model', [IO.Compression.CompressionLevel]::Optimal)
    $writer = New-Object IO.StreamWriter($newEntry.Open(), (New-Object Text.UTF8Encoding($false)))
    try { $writer.Write($updated) } finally { $writer.Dispose() }
  }
  finally {
    $archive.Dispose()
  }
}

if ($CheckOnly) {
  Write-Host "Verified embedded 3MF metadata for release $($release.version)."
} else {
  Write-Host "Stamped embedded 3MF metadata for release $($release.version)."
}
