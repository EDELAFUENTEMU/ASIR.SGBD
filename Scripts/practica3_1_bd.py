##### Ejercicio  3.1 Con BD MYSQL#####

import MySQLdb

db = MySQLdb.connect(host="localhost", user="root",passwd="Server01%", db="Hoteles")
cursor = db.cursor()
cursor.execute("SELECT Nombre, COUNT(Fecha) AS NVeces FROM conexiones GROUP BY Nombre ORDER BY NVeces")
result = cursor.fetchall()

#creo el encabezado del archivo 
msg = '\n\n********************************************************************** \n' 
msg += 'Los tres usuarios que mas se han conectado, y el numero de veces, son: \n' 
msg += '********************************************************************** \n\n' 

#creo un bucle para leer el resutado
for row in result:
    msg += ('\tUsuario: {0:20} Numero: {1:3d}\n'.format(row[0],row[1]))
    
#muestro por pantalla
print(msg)

#guardo en un fichero
inform = open('informe_3_1.text','w')
inform.write(msg)
inform.close() 

