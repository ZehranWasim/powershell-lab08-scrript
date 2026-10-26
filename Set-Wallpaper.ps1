<#
.SYNOPSIS
    Automated Wallpaper Changer with IP Filtering for SNA Lab Clients.
#>

# Define allowed client IP addresses in your lab network
$AllowedIPs = @("192.168.1.10", "192.168.1.11", "192.168.1.12", "192.168.1.13", "10.228.221.193")

# Get the local machine's active IPv4 address
$CurrentIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*", "Wi-Fi*" | Where-Object {$_.IPAddress -notlike "169.254.*" -and $_.IPAddress -notlike "127.*"} | Select-Object -ExpandProperty IPAddress | Select-Object -First 1)

Write-Host "Detected Client IP: $CurrentIP"

# Check if current IP is allowed
if ($AllowedIPs -contains $CurrentIP) {
    Write-Host "[+] IP verified. Applying automated wallpaper..."
    
    # Replace with your raw GitHub image link or direct online wallpaper URL
    $ImageUrl = "https://raw.githubusercontent.com/ZehranWasim/powershell-lab08-scrript/main/wallpaper.jpg"
    $SavePath = "$env:TEMP\lab_wallpaper.jpg"
    
    try {
        Invoke-WebRequest -Uri $ImageUrl -OutFile $SavePath -UseBasicParsing -ErrorAction Stop
        
        # Single-line string definition to avoid any heredoc whitespace/formatting errors
        Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WallpaperSetter { [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'
        
        [WallpaperSetter]::SystemParametersInfo(20, 0, $SavePath, 3)
        Write-Host "[+] Wallpaper updated successfully!" -ForegroundColor Green
    }
    catch {
        Write-Error "[-] Failed to download or set wallpaper: $_"
    }
} else {
    Write-Warning "[-] This IP ($CurrentIP) is not authorized to change wallpaper."
}
