$userList = Get-Content "C:\Path to File.txt" -Encoding UTF8
$exportpath = "C:\Path to Outputfile.csv"
$outArray = @()    
    foreach ($user in $userlist) {
        Write-Output "***********************            $user            ***********************"
        Write-Output ""
        try {
            $grplist = (Get-ADUser $user -Properties MemberOf -ErrorAction Stop ).MemberOf
        $outArray += $user
        foreach ($group in $grplist) {
            (Get-ADGroup $group).name 
        }
        }
        catch {
            Write-Output "$user does not exist"
        }
        
        Write-Output "***********************"
    }
    $outarray | export-csv $exportpath
