# Vraag de oude en nieuwe computernaam op
$OldComputerName = Read-Host "Voer de oude computernaam in: "
$NewComputerName = Read-Host "Voer de nieuwe computernaam in: "

# Haal de AD computerobjecten op
$OldComputer = Get-ADComputer -Identity $OldComputerName -Properties MemberOf
$NewComputer = Get-ADComputer -Identity $NewComputerName

if ($OldComputer -and $NewComputer) {
    # Doorloop de groepen van de oude computer en voeg de nieuwe toe
    foreach ($GroupDN in $OldComputer.MemberOf) {
        Add-ADGroupMember -Identity $GroupDN -Members $NewComputer
        Write-Host "Toegevoegd aan groep: $GroupDN"
    }
    Write-Host "Alle groepen zijn succesvol gekopieerd."
} else {
    Write-Host "Een van de computerobjecten kon niet gevonden worden. Controleer de ingevoerde namen."
    }
