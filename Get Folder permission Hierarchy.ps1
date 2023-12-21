Get-ChildItem -Directory -Depth 0 | ForEach-Object {Get-Acl $_.FullName} |
     Select-Object `
        @{n='Path';e={$_.Path}},
        @{n='IdentityReference';e={$_.Access.IdentityReference | Format-Table | Out-String}},
        @{n='AccessControlType';e={$_.Access.AccessControlType | Format-Table | Out-String}},
     Export-Excel -Path 'C:\Users\saiels-adm\Desktop\perms.xlsx' -AutoSize -FreezeTopRow
