function Write-Log {
    param(
        [string]$message,
        [string]$color,
        [int]$level
    )

    $tab = "`t" * $level
    $timestamp = Get-Date -Format "[MM/dd/yyyy HH:mm:ss]"

    Write-Host "$timestamp$($tab) - $message" -ForegroundColor $color
}