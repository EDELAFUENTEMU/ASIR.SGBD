##### Ejercicio  3.1 #####

import os
from datetime import datetime, timedelta

fInicio=(datetime.today() - timedelta(days=30))
os.system("ausearch -ts "+ fInicio.strftime('%d/%m/%y') +"  | grep 'USER_ACCT' | cut -d ' ' -f 8 | sed 's/acct=//g' > i.txt")

#abro el fichero, lo leo y lo guardo en una variable. 
f = open ('/home/server/i.txt','r')
log = f.read()
f.close()

#log = '"pedro_director" "server" "root" "server" "root" "server" "server" "server" "root"' 

#crea un array de los usuarios
listaUsuarios = log.split()

#creo una variable donde guardare la frecuencias
frecuenciaInicio = []

#itero una a una por cada campo del array, anadiendo al array las veces que aparece
for w in listaUsuarios:
        frecuenciaInicio.append(listaUsuarios.count(w))

#relaciona con zip la lista de usuarias con la frecuencia de Inicio
arr= zip(frecuenciaInicio,listaUsuarios)

#eliminamos los valores repetidos y lo hacemos iterable
arr = (list(set(arr)))
arr.sort(reverse=True)

#creo el encabezado del archivo 
msg = '\n\n********************************************************************** \n' 
msg += 'Los tres usuarios que mas se han conectado, y el numero de veces, son: \n' 
msg += '********************************************************************** \n\n' 

#creo un bucle para leer los primeros 3 puestos
vuelta = 0
while vuelta<3:
    msg += ('\tUsuario: {0:20} Numero: {1:3d}\n'.format(arr[vuelta][1].replace('"',''),arr[vuelta][0]))
    vuelta=vuelta+1

#muestro por pantalla
print(msg)

#guardo en un fichero
inform = open('informe_3_1.text','w')
inform.write(msg)
inform.close() 

#borro el fichero intermedio
os.system('rm -f /home/server/i.txt')
