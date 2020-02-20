#!/bin/bash

#ruta_db='/home/usuario/bases_de_datos.txt'
#rura_error='/home/usuario/error_copia.log'
#ruta_backup='/home/usuario/backup/'

ruta_db='/home/server/ult_bd/bases_de_datos.txt'
ruta_backup='/home/server/ult_bd/backup/'
ruta_error=$ruta_backup'error_copia.log'
tEsperaMax=60 #tiempo en segundos de espera

echo ''  > $ruta_error 

function stop_mysql(){
	timestamp=$(date +%s)
	# mientras el sistema mysql sigue actigo.
	while [[ $(ps -u mysql | grep mysql) != '' ]]; do
		#y el timestamp actual sea menor  el timestamp inicia+tEspera
		if [[ $(date +%s) -le $($timestamp + $tEsperaMax) ]];then
			systemctl stop mysql
			sleep 5
		else
			echo -e ' Se ha sobrepasado el tiempo máx. de espera al interntar cerrar MYSQL \n Asegurase de tener los privilegios necesarios'
			return 0
		fi
	done
	echo " Se ha detenido el servicio MYSQL correctamente"
	return 1
}



clear;
echo -e "Ejercicio 2. Copia de Seguridad en frio \n\n Iniciando ..."
#existe el fichero con las bd a copiar?
if [[ -s $ruta_db ]];then
	#detengo la SGBD
	stop_mysql #devuelve 1=OK, 0=error
	if [[ $? -eq 1 ]];then

		#por si no existe el directorio backup
		mkdir -p $ruta_backup

		#copiamos los ficheros de configuracion
                cp /var/lib/mysql/ib* $ruta_backup
                cp "/etc/mysql/mysql.conf.d/mysqld.cnf" $ruta_backup

		#leeemos el fichero con las databases a copiar
		while read database
		do
			#existe el directorio de la bd
			if [[ -d "/var/lib/mysql/$database/" ]];then
				sudo cp -R -f "/var/lib/mysql/$database/" "$ruta_backup$database/"

				#compruebo que se han copiado correctamente
				if [[ -z $(diff -rq "/var/lib/mysql/$database/" "$ruta_backup$database/") ]];then
					echo " Se ha copiado correctamente la base de datos: $database"
					aux=$(( $aux + 1 ))
				else
					echo " Error en el copiado del directorio $database" >> $ruta_error
				fi
			else
				echo " Error. No se ha encontrado el directorio de la db: $database"
				echo " Error! No se ha encontrado el directorio de la db: $database" >> $ruta_error
			fi
		done < $ruta_db

		echo  -e "\n Proceso de Backup en frío finalizado. \n Good Bye!"
	fi

else
	echo 'No existe el fichero que indica las databases a copiar'
	exit 3
fi

