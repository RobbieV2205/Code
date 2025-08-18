#service
$printers = @('LCVPR0069', 'LCVPR1010', 'LCVPR1009', 'LCVPR0055')
#inbound
#$printers = @('LCVPR1039', 'LCVPR1064', 'LCVPR1063', 'LCVPR1001')



foreach ($printer in $printers){
    Add-Printer -ConnectionName \\lcvsr0018\$printer
    $message = 'printer' + $printer
    write-host $message
}
