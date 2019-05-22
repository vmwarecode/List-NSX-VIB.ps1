#Usage - lists NSX related VIBs. (Can be used to list any VIB)
#
#
#Prior to NSX 6.2.0, the vxlan.zip contains 3 VIBs, esx-vxlan, esx-vsip and esx-dvfilter-switch-security. 
#In NSX 6.3.2 or earlier, there are 2 VIBs, esx-vxlan and esx-vsip. 
#In NSX 6.3.3 and later, there is one VIB, esx-nsxv.
#
#You must change the match criteria on line 23 to match the NSX release level  
#(Where {$_.Name -match "vxlan|vsip"}) - 6.3.2 and prior 
#(Where {$_.Name -match “nsxv"}) - 6.3.3 and later
#(Where {$_.Name -match “nsxv|vxlan|vsip"}) - yields all versions of VIBs
#
#Output in created in C:\temp\PowerCLI\reports in CSV form
#

connect-viserver
$List = @()
$AllHosts = Get-VMHost | Where-Object {$_.ConnectionState -eq “Connected”}
foreach ($VMHost in $AllHosts) {
    $VMHostName = $VMhost.Name
    $esxcli = $VMHost | Get-EsxCli -V2
    $List += $esxcli.software.vib.list.invoke() | Select-Object @{N="VMHostName"; E={$VMHostName}}, * | Select-Object VMHostName,AcceptanceLevel,ID,InstallDate,Name,CreationDate,Vendor,Version | Where-Object {$_.Name -match "nsxv|vxlan|vsip"}
}
$List | Export-Csv "C:\Temp\PowerCLI\Reports\List-NSX-VIB-$(get-date -f yyy-MM-dd-hh-mm).csv" -NoTypeInformation