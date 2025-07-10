$ComputerName = Read-Host "Voer computer naam in: "

Get-ADComputer $ComputerName -Property MemberOf | Select-Object -ExpandProperty MemberOf | ForEach-Object {
    ($_ -split ',')[0] -replace 'CN='
}
