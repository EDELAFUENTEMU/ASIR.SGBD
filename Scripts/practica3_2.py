import os 
import re #modulo de expresiones regulares
from datetime import datetime, timedelta

day=(datetime.today() - timedelta(days=1))
#recojo los eventos de ayer, filtro por logeo, selecciono las columnas fecha,nombre y ordeno por la columan nombre
os.system("ausearch -ts " + day.strftime('%d/%m/%y') + " 00:00:00 -te " + day.strftime('%d/%m/%y') + " | grep 'USER_ACCT' | cut -d ' ' -f 2,8 | sort -k 2 > e.txt")

#creo el encabezado del archivo
msg = '\n\n********************************************* \n'
msg += 'Los usuarios conectados y el momento de conexion \n'
msg += '************************************************ \n\n'

#abro el fichero, y leo linea por linea. 
with open ('/home/server/e.txt','r') as fichero:
	for linea in fichero:
		#limpio la linea usando expresiones regulares (Elimino "msg=audit(", ":12: acct=", '"')
		linea=re.sub(r'(msg\=audit\()|(:[0-9]+\): acct=)|(\")','',linea)
                ts= float(linea[0:13])
		datef= datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
		msg += 'Usuario: '+ linea[14:-1]+'\t\t Fecha: '+ datef+'\n'


#muestro por pantalla
print(msg)

#guardo en un fichero
inform = open('informe_3_2.text','w')
inform.write(msg)
inform.close()

#borro el archivo intermedio
os.system('rm -f /home/server/e.txt')
