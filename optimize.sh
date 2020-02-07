#!/bin/bash

while getopts "b:u:p: " opt
do
        case $opt in
                 b) db=$OPTARG ;;
                 u) user=$OPTARG ;;
                 p) pw=$OPTARG ;;
                \?) echo "Opcion invalida" ;;
        esac
done

if [[ -n $db  || -n $user || -n $pw ]];then
        #recupera todas las tablas  mysiam en esa base da datos
        rutas=$(sudo find /var/lib/mysql/$db -name "*.MYI")

        if [[ $rutas != '' ]]; then
                echo '' > temp.sql      #vacio el fichero

                for i in ${rutas};
                do
                  tabla=$(echo $i | cut -d"/" -f6 )
                  tabla=${tabla:0: -4}
                  echo "OPTIMIZE TABLE $tabla" >> temp.sql
                done

                mysql -u $user -p$pw -D $db  < temp.sql
                rm -y temp.sql
        else
                echo 'No se ha encontrado tablas MyIsam'
        fi
else
        echo 'No se ha pasado ningun parametro'
        exit 2
fi
