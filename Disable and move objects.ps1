$pclist = Get-Content "C:\Path to File.txt.txt"
$targetOU = "Distiguished Name"
foreach ($pc in $pclist) {
   if ($pc.Trim()) {
      Get-ADComputer $pc | Disable-ADAccount -PassThru | Move-ADObject -TargetPath $targetOU
      Set-ADComputer $pc -Description "Spare system"
   } 
}
