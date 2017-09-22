#!/bin/bash

# bash script for:
#                -adding a new user


case $1 in add_user)
	echo -e "unesite username \c"
	read name
	echo -e "unesite password \c"
	read -s password
	rabbitmqctl add_user $name $password
;;

#                -adding a new vhost
	

add_vhost)
	echo -e "unesite ime hosta \c"
	read vhost
	rabbitmqctl add_vhost $vhost
;;

#                -adding a user to the vhost
		
add_vhost_user)
        echo -e "unesite ime hosta \c"
       	read vhost
       	echo -e "unesite username \c"
       	read name
	echo -e "unesite konfiguraciju \c"
	read conf
	echo -e "unesite write pravo \c"
        read write
	echo -e "unesite read pravo \c"
	read citaj
	rabbitmqctl set_permissions -p $vhost $name "^$name-.$conf" ".$write" ".$citaj"
;;

#                -create fanout queue and connect it to exchange
add_queue)
        echo -e "unesite ime exchange \c"
        read exchange
        echo -e "unesite ime novog queue-a \c"
        read new_queue
		echo -e "unesite ime dolaznog queue-a \c"
        read in_queue
	echo -e "unesite ime hosta"
	read host
	echo -e "unesite routing key"
	read routing
/etc/rabbitmq/./rabbitmqadmin declare exchange --vhost=$host name=$exchange type=fanout
/etc/rabbitmq/./rabbitmqadmin declare queue --vhost=$host name=$new_queue durable=true
/etc/rabbitmq/./rabbitmqadmin --vhost="$host" declare binding source="$exchange" destination_type="$new_queue" destination="$in_queue" routing_key="$routing"

;;
*)
	echo "pogresna komanda"
;;
esac
