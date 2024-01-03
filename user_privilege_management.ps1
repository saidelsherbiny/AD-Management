#Groupname can be Administrator or Administrateur so we use regex for both options
$GroupName = Get-Localgroup "Administr*" | Select-Object Name -ExpandProperty Name

#Add accounts to exclude
$AllowedAdminAccounts ="xyz", "xyz"

#clean up bad admin accounts created from migration
$administrators = @(
([ADSI]"WinNT://./$GroupName").psbase.Invoke('Members') |
% { 
 $_.GetType().InvokeMember('AdsPath','GetProperty',$null,$($_),$null) 
}
) -match '^WinNT';

$administrators = $administrators -replace "WinNT://",""
$administrators
foreach ($administrator in $administrators)
{
if ($administrator -like "$env:COMPUTERNAME/*" -or $administrator -like "domain/*")
{
    continue;
}
Remove-LocalGroupMember -group "administrators" -member $administrator
}


#remove only local accounts
$LocalAdminList = Get-LocalGroupMember $GroupName | Where-Object { $_.PrincipalSource -ne "ActiveDirectory" } | Select-Object sid | ForEach-Object { Get-LocalUser $_.sid | Select-Object name }
#Disabling the accounts                    
foreach ($user in $LocalAdminList) {
    #Disable account in administrator group
    Get-LocalUser -Name $user.Name | Where-Object { $AllowedAdminAccounts -notcontains $_.Name } | Disable-LocalUser
    #Remove account from Administrators group 
    Get-LocalUser -Name $user.Name | Where-Object { $AllowedAdminAccounts -notcontains $_.Name } | Remove-LocalGroupMember $GroupName -ErrorAction SilentlyContinue
}
#Disable Administrator/Administrateur account
Disable-LocalUser "Administrator" -ErrorAction SilentlyContinue
Disable-LocalUser "Administrateur" -ErrorAction SilentlyContinue


#removing Domain accounts:
$AdmingroupsSID = "SID", "SID"
$domainAdminList = Get-LocalGroupMember $GroupName | Where-Object { $_.PrincipalSource -eq "ActiveDirectory" } | Where-Object { $AdmingroupsSID -notcontains $_.SID } | ForEach-Object {Get-ADUser $_.sid | Select-Object name -ExpandProperty Name}
Remove-LocalGroupMember $GroupName -Member $domainAdminList
