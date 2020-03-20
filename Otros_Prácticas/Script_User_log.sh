#!/bin/bash
#Script devuelve el número de conexiones por usuario a la base de datos mysql.

clear
ruta_log='/var/log/mysql/mysql.log'
if [[ -f $ruta_log ]];then
	sudo cat /var/log/mysql/mysql.log | grep Connect | sed 's/[[:blank:]]\+/ /g' | cut -d ' ' -f 4 > tmp.log
	declare -A arr
	while read -r user;
	do
		if [[ -z ${arr[$user]} ]];then
			arr[$user]=1
		else
			arr[$user]=$(( ${arr[$user]} + 1 ))
		fi
	done < tmp.log
	rm tmp.log

	echo -e "\n\033[34;47m  Número de conexiones por usuario  \033[0m\n"
	for user in "${!arr[@]}"
	do
	   echo "$user se conecto ${arr[$user]} veces"
	done

else
	echo  "No se ha encontrado el fichero log. Compruebe la configuración"
fi
