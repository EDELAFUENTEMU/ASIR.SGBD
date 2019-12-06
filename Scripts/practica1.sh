#!/bin/bash
#Primer ejercicio BD
##Creo la tabla si no existe y lo guardo en un fichero q sera nuestro script sql
echo 'CREATE TABLE IF NOT EXISTS `Hoteles`.`Directores` (`id` INT NOT NULL, `nombresystem` VARCHAR(15) NOT NULL,`nombre` VARCHAR(45) NULL,`apellido1` VARCHAR(45) NULL,`apellido2` VARCHAR(45) NULL,`habitacion` INT NULL,`tlf_trabajo` INT NULL, `tlf_casa` INT NULL, `otros` VARCHAR(255) NULL, PRIMARY KEY (`ID`)); ' > /home/server/sql_1.sql

#Filtro las filas q  tienen la palabra director y a su vez saca el campo que contiene nombreSystem, uid, info separados por una coma
grep 'director' /etc/passwd | cut -d ":" -f 1,3,5 --output-delimiter=',' > /home/server/directores.txt

#hacemos un bucle para leer linea a linea el archivo creado
while read line;
do
        #convierto la linea en un array usando como separador las comas (nombreSystem, uid, nombre completo, room, tlf_trab, tlf_home, otros)
        IFS=',' read -a arr <<< $line

        #convierto el campo nombre completo del array anterior en otro array, usando como separador los espacios en blanco (nombre, apellido1, apellido2)
        nombreCompleto=$(echo ${arr[2]})
        IFS=' ' read -a nams <<< $nombreCompleto

        #guardo esas posiciones en variables mas legibles
        id=${arr[1]}
        nombreSystem=${arr[0]}
        nombre=${nams[0]}
        apellido1=${nams[1]}
        apellido2=${nams[2]}
        habitacion=${arr[3]}
        tlf_trabajo=${arr[4]}
        tlf_casa=${arr[5]}
        otros=${arr[6]}

        #genero la sentencia sql de insercion y la guardo en nuestro script sql_1.sql
        echo "INSERT INTO Directores VALUES ('$id','$nombreSystem','$nombre','$apellido1','$apellido2','$habitacion','$tlf_trabajo','$tlf_casa','$otros') ;" >> /home/server/sql_1.sql
done < /home/server/directores.txt

#mando el script sql generado (sql_1.sql) a mysql para que se ejecute
mysql -u root -p -D Hoteles < /home/server/sql_1.sql


#elimino los archivos intermedios creados (directores/sql)
rm -f /home/server/directores.txt
rm -f /home/server/sql_1.sql






