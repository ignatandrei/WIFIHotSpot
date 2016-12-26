function CanEnableHotspot(){
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "netsh"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = "WLAN show drivers"
    $pinfo.CreateNoWindow=$true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()
    $lines = $stdout.Split("`r`n") 
    Write-Host $lines.count
    for ($i=0; $i -lt $lines.length; $i++) {
        #Write-Host $i + "----"+ $lines[$i]
        if($lines[$i] -Match "Hosted network supported"){
            return $lines[$i] -Match "Yes";
    }
     
}
return $false
}

function CreateHotspot($name, $password ){

    $argument = "WLAN set hostednetwork mode=allow ssid=" + $name +" key=" + $password
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "netsh"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $argument

    $pinfo.CreateNoWindow=$true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()
    Write-Host $stdout

}
function StopHotspot( ){

    $argument = "WLAN stop hostednetwork"
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "netsh.exe"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $argument

    $pinfo.CreateNoWindow=$true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()
    
}

function StartHotspot( ){

    $argument = "WLAN start hostednetwork"
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "netsh.exe"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $argument

    $pinfo.CreateNoWindow=$true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()
    Write-Host $stdout
}



$enableHotspot=CanEnableHotspot

if(-Not ($enableHotspot)){
    Write-Host " can not enable hotspot - do not support it"
    return
}
Write-Host "Hotspot can be enabled"
StopHotspot
$nameHotSpot= Read-Host "Enter the name of the hotspot"
$passwordHostSpot = Read-Host "Enter password( 8 to 63 chars)"

CreateHotspot $nameHotSpot $passwordHostSpot
StartHotspot
Write-Host " do not forget to run adapter to share its Internet access using the Internet Connection Sharing (ICS) feature of Windows"
Start-Process "control.exe" "ncpa.cpl"