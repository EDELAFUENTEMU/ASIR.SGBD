import os
#Uso el comando ausearch buscando los acontecimiento del mes anterior, solo los que son de inicio de sesion (acct), y me quedo con la columana donde esta el nombre de usuario. #Limpio el resultado sustituyendo acct= por ''. y todo eso lo guardo en un fichero temperoal llamado i
os.system('ausearch -ts this-month | grep "USER_ACCT" | cut -d " " -f 8 | sed "s/acct=//g" > i.txt')

#abro el fichero temporal, lo leo y lo guardo en una variable.
#tengo como resultado algo similar a esto: #log = '"pedro_director" "server" "root" "server" "root" "server" "server" "server" "root"'
f = open ('/home/server/i.txt','r')
log = f.read()
f.close()

#crea un array de todos los inicios de sesion (los usuarios)
listaUsuarios = log.split()

#creo una variable donde guardare la frecuencias de inicio de sesion
frecuenciaInicio = []

#itero una a una por cada campo del array, anadiendo al array frecuenciaInicio las veces que aparece (count) en listaUsuarios
for w in listaUsuarios:
        frecuenciaInicio.append(listaUsuarios.count(w))

#relaciona con zip la lista de usuarias con la frecuencia de Inicio
arr= zip(frecuenciaInicio,listaUsuarios)

#eliminamos los valores repetidos con set y lo hacemos iterable list
arr = (list(set(arr)))

#creo el encabezado del archivo de salida
msg = '\n\n********************************************************************** \n'
msg += 'Los tres usuarios que mas se han conectado, y el numero de veces, son: \n'
msg += '********************************************************************** \n\n'

#creo un bucle para leer los primeros 3 puestos y muestro el resultado del array zip (frecuenciaInicio,listaUsuarios)
vuelta = 0
while vuelta<3:
    msg += '\t:'+str(arr[vuelta][1])+'\t\t\t\tNumero:'+str(arr[vuelta][0])+'\n'
    vuelta=vuelta+1

#muestro por pantalla
print(msg)

#guardo el fichero de salida
inform = open('informe_3_1.text','w')
inform.write(msg)
inform.close()

