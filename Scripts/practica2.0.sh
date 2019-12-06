#!/bin/bash
#obtenemos el día anterior en formato dd/mm/aa
DiaAnterior=$(date +%x --date='-1 day')

#selecciono los eventos del dia anterior y filtro por User_Acct y usuario, divido el  string por espacios y selecciona la columana 2 y 8. Y lo guardo en un fichero
ausearch -ts $DiaAnterior 00:00:00 -te $DiaAnterior 23:59:59 | grep 'USER_ACCT' | grep "director" | cut -d " " -f 2,8 > /home/server/intermedio.txt

#Sentencia de creacion de la tabla si no esta creada. Lo guardo en un script sql 
echo ' CREATE TABLE IF NOT EXISTS `Hoteles`.`conexiones` (`Hash` VARCHAR(32) NOT NULL, `Fecha` TIMESTAMP(6) NULL, `Nombre` VARCHAR(45) NULL, PRIMARY KEY (`Hash`));' > /home/server/sql2.sql

#recorro el fichero creado linea por linea
while read line;
do 
	#selecciono el nombre, la fecha y creo el hast
	AuxNombre=$(echo $line | egrep -o '\"[a-z]+\"')
	length=$((${#AuxNombre}-2))
	nombre=${AuxNombre:1:$length}
	fecha=${line:10:10}
	hash5=$(echo $nombre $fecha | md5sum)

	#creo la sentencia de insercion con la adv IGNORE para en caso de que pK se repita. Lo guardo en el script sql
	echo "INSERT IGNORE INTO conexiones VALUES ('${hash5:0:32}',FROM_UNIXTIME($fecha),'$nombre'); " >> /home/server/sql2.sql
done <  /home/server/intermedio.txt

#mando el script sql al mysql dB. Hoteles
mysql -u root -p -D Hoteles < /home/server/sql2.sql


#Elimino los archivos intermedios
rm -f /home/server/intermedio.txt
rm -f /home/server/sql2.sql
