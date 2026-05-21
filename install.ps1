# system-design-coach installer (Windows PowerShell 5+ / PowerShell 7+)
#
# One-liner:
#   iwr https://raw.githubusercontent.com/sayanmndl/system-design-coach/main/install.ps1 -UseBasicParsing | iex
#
# Environment overrides:
#   $env:SDC_REPO   GitHub owner/repo to fetch from (default: sayanmndl/system-design-coach)
#   $env:SDC_REF    Branch or tag                   (default: main)
#   $env:SDC_DEST   Install path                    (default: $HOME\.claude\skills\system-design-coach)

$ErrorActionPreference = 'Stop'

$Repo = if ($env:SDC_REPO) { $env:SDC_REPO } else { 'sayanmndl/system-design-coach' }
$Ref  = if ($env:SDC_REF)  { $env:SDC_REF  } else { 'main' }
$Dest = if ($env:SDC_DEST) { $env:SDC_DEST } else { Join-Path $HOME '.claude\skills\system-design-coach' }

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

try {
    Write-Host "==> Fetching $Repo@$Ref"
    $zipUrl  = "https://codeload.github.com/$Repo/zip/refs/heads/$Ref"
    $zipPath = Join-Path $tmp 'src.zip'
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    Expand-Archive -Path $zipPath -DestinationPath $tmp -Force
    Remove-Item -Path $zipPath -Force

    $extracted = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
    if (-not $extracted) { throw "extraction failed" }

    $src = Join-Path $extracted.FullName 'skills\system-design-coach'
    if (-not (Test-Path $src)) {
        throw "skills\system-design-coach not found in $Repo@$Ref"
    }

    $parent = Split-Path $Dest -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }

    if (Test-Path $Dest) {
        $backup = "$Dest.bak.$([int][double]::Parse((Get-Date -UFormat %s)))"
        Write-Host "==> Existing install found, backing up to $backup"
        Move-Item -Path $Dest -Destination $backup
    }

    Move-Item -Path $src -Destination $Dest

    Write-Host "==> Installed to $Dest"
    Write-Host ""
    Write-Host "Open a new Claude Code session and try:"
    Write-Host "  `"design Twitter timeline`""
    Write-Host "  `"design a feature store`""
    Write-Host "  `"LLD a parking lot`""
}
finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
