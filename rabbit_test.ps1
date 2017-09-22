[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)]
[string]$komanda
)
#RabbitMQ Environment
$rabbit_putanja = 'C:\Program Files\RabbitMQ Server\rabbitmq_server-3.6.9\sbin'
$rabbit_admin_putanja = 'c:\python27\python'
$python_putanja = 'c:\python27'

switch ($komanda)
#adding a new user
{
add_user {
$user = Read-Host 'unesite username'

$password = Read-Host -assecurestring 'unestite password novog user-a'

$add_user = @'
cmd.exe /C $rabbit_putanja\rabbitmqctl add_user $user $password
'@
Invoke-Expression -Command:$add_user
}
#adding a new vhost
add_vhost {
$vhost = Read-Host 'unesite ime hosta'

$add_vhost = @'
cmd.exe /C $rabbit_putanja\rabbitmqctl add_vhost $vhost
'@
Invoke-Expression -Command:$add_vhost
}
#adding a user to the vhost
add_vhost_user {
$vhost = Read-Host 'unesite ime hosta'

$name = Read-Host 'unesite username'

$conf = Read-Host 'unesite konfiguraciju'

$write = Read-Host 'unesite pravo upisa'

$citaj = Read-Host 'unesite pravo citanja'

$add_vhost_user = @'
cmd.exe /C $rabbit_putanja\rabbitmqctl set_permissions -p $vhost $name "^$name-.$conf" ".$write" ".$citaj"
'@
Invoke-Expression -Command:$add_vhost_user
}
#create fanout queue and connect it to exchange
add_queue {
$vhost = Read-Host 'unesite ime hosta'

$exchange = Read-Host 'unesite exchange'

$new_queue = Read-Host 'unesite novi queue'

$in_queue = Read-Host 'unesite dolazni queue'

$citaj = Read-Host 'unesite pravo citanja'

#Kreiranje exchange-a:

$add_exchange = @'
cmd.exe /C $python_putanja\python.exe $rabbit_admin_putanja\rabbitmqadmin declare exchange --vhost=$vhost name=$exchange type=fanout
'@
Invoke-Expression -Command:$add_exchange

#Kreiranje queue-a:

$add_queue = @'
cmd.exe /C $python_putanja\python.exe $rabbit_admin_putanja\rabbitmqadmin declare queue name=$new_queue durable=true
'@
Invoke-Expression -Command:$add_queue

#kreiranje binding-a:
$add_binding = @'
cmd.exe /C $python_putanja\python.exe $rabbit_admin_putanja\rabbitmqadmin --vhost="$vhost" declare binding source="$exchange" destination_type="$new_queue" destination="$in_queue" routing_key="$routing"
'@
Invoke-Expression -Command:$add_binding
}
default {"Pogresna komanda. Unesite jednu od sledecih parametara: add_user add_vhost add_vhost_user ili add_queue"}
}