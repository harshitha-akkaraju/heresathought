$repoRoot = "C:\Users\hakkaraj\Workspace\heresathought"
$nodeServerPath = "$repoRoot\app_server\server.js"

function Write-Message {
    param (
        [string]$Message,
        [string]$Color = "White",
        [switch]$Stop
    )

    Write-Host -Object $Message -ForegroundColor $Color

    if ($Stop) {
        exit 1
    }
}

if (-Not $repoRoot) {
    Write-Message -Message "Variable `$repoRoot is not set. Please set the repo root path." -Color "Red" -Stop
}

$webAppBuild = "$repoRoot/app/build/web"
$webAppBuildTmp = "$repoRoot/app_server/"

function Copy-WebApp {
    param (
        [string]$Src,
        [string]$Dst
    )

    Write-Message -Message "Copying app artifacts..." -Color "Green"

    # Ensure the destination directory exists
    if (-Not (Test-Path -Path $Dst)) {
        New-Item -ItemType Directory -Path $Dst
    }

    Copy-Item -Path $Src -Destination $Dst -Recurse
}

function Cleanup {
    param (
        [string]$Tgt
    )

    Write-Message -Message "Cleaning up target directory: {$Tgt} ..." -Color "Green"

    Remove-Item -Path $Tgt -Recurse -Force
}

function Deploy-App {
    Write-Message -Message "Deploying app..."

    Copy-WebApp -Src $webAppBuild -Dst $webAppBuildTmp

    node $nodeServerPath

    Cleanup -Tgt $webAppBuildTmp
}

Deploy-App