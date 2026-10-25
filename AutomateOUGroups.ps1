# VERIFY MODULE EXISTS
Import-Module ActiveDirectory

Write-Output "`n=== XyberTechnology Server Group Placement Automation Tool ===`n"
Start-Sleep -Seconds 2

# STORE RID IN VARIABLE TO CHANGE PRIMARY GROUP
$ID = Get-ADGroup -Identity "5. XT Servers" | Select-Object "SID"

$RID = $ID.SID.Value.Substring($ID.SID.Value.LastIndexOf("-") + 1)

$ServersList = @()
$ServersList = Get-ADComputer -Filter * -SearchBase "OU=XT-Servers,DC=xybertechnology,DC=local" # | Select-Object -ExpandProperty "Name"
$IndexCount = 0

ForEach ($Server in $ServersList) {
$Hostname = $Server.Name
Write-Output "Correcting $Hostname`'s Active Directory group placement...`n"
Start-Sleep -Seconds 2
Add-ADGroupMember -Identity "5. XT Servers" -Members $Server -ErrorAction SilentlyContinue
Set-ADComputer $Server.Name -Replace @{PrimaryGroupID= $RID} -ErrorAction SilentlyContinue
Remove-ADGroupMember -Identity "6. XT Workstations" -Members $Server -ErrorAction SilentlyContinue
$IndexCount++
}