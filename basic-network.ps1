$Hosts = @("google.com", "microsoft.com", "192.168.1.1", "nonexistent.host") # add your hosts here

foreach ($HostName in $Hosts) {
    try {
        $Result = Test-Connection -ComputerName $HostName -Count 1 -ErrorAction Stop
        Write-Host "Ping to $HostName successful (IPv4: $($Result.IPV4Address.IPAddressToString))" -ForegroundColor Green
    }
    catch {
        Write-Host "Ping to $HostName failed: $($_.Exception.Message)" -ForegroundColor Red
    }
