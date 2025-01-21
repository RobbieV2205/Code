$UserName = Read-Host "Voer gebruikers naam in: "

Get-ADUser $UserName -Property MemberOf | Select-Object -ExpandProperty MemberOf | ForEach-Object {
    ($_ -split ',')[0] -replace 'CN='
}
