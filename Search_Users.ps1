$userList = Get-Content "C:\File Path" -Encoding UTF8
foreach($user in $userlist){
   Try{
      $userT=$user.Trim()
      #remove comment if user account names in list are not exact
      #$temp= get-aduser -filter 'anr -eq $userT' -Properties * | Select-Object Email -ExpandProperty Email |Select-Object -first 1
      $temp = get-aduser -Filter {DisplayName -like $userT} -Properties * |Select-Object Email -ExpandProperty Email
      if ($null -eq $temp) {
          Write-Host "n/a"
        }
        else {
          Write-Host $temp
        }
   } 
   Catch{
      Write-Host "n/a"
   }
    }
   
    
   
