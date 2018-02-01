#!/bin/bash
#Variables de entorno
# dias a partir del cual se borrará el home de un usuario si no lo ha modificado (sin contar su tamaño)
diasborrar=40
# dias a partir del cual se borrará el home de un usuario si no lo ha modificado y hay mas de dos usuarios en el turno
diasmasdeuno=15
# número de megas totales de una cuenta. Si la cuenta ocupa menos no se tendrá en cuenta para borrarla en diasmasdeuno
megas=1024
# grupo sobre el que actua
grupo=students
# fichero del log
lognormal=/var/log/cuentasborradas.log
# nota para los usuarios que ocupan menos de la variable megas
notamenosmegas=Por favor usa tu PC, si este es tu PC habitual habla con el tutor que hay dos usuarios usandolo en el mismo turno
nombreficheronota=/Escritorio/`date +%y_%m_%d`_nota_del_administrador.txt

#########################
#   empieza el script   #
#########################
# contador de lineas de la tarde (no tocar)
lineat=0
lineatmenos=0
# contador de lineas de la manyana (no tocar)
lineam=0
lineammenos=0
# contador total (no tocar)
linea=0 
# pasamos a kb
kbytes=$(($megas * 1024))

# borramos las cuentas que no se han usuado en mas de diasborrar
find /home/ -maxdepth 1 -mindepth 1 -group $grupo -type d -mtime +$diasborrar -exec echo `date` borrando cuenta {} \; &> $log
find /home/ -maxdepth 1 -mindepth 1 -group $grupo -type d -mtime +$diasborrar -exec rm -R {} \; &> $log


for directorio in $(find /home/ -maxdepth 1 -mindepth 1 -group $grupo -type d)
do
	linea=$(($linea + 1))
        usuario=$(echo $directorio | cut -c7-)
        fecha=$(stat -c%y $directorio | cut -c1-10)
        hora=$(stat -c%y $directorio | cut -c12-13)
        minutos=$(stat -c%y $directorio | cut -c15-16)	
        diasdesdeultimoinicio=$((($(date +%s) - $(stat -c%Y $directorio)) / 86400))
        espacioh=$(du -h -s $directorio | cut -d"/" -f1 2> /dev/null)
	espaciokb=$(du -s $directorio | cut -d"/" -f1 2> /dev/null)
        if [ $hora -ge 15 ]; then
                horario=vesprada
		if [ $espaciokb -gt $kbytes ]; then
			lineat=$(($lineat + 1))
                	usuariosvesp=$(echo -e "$horario $diasdesde $usuario $fecha $hora:$minutos $espaciokb $espacioh\n$usuariosvesp")
		else 
			lineatmenos=$(($lineatmenos + 1))
			usuariosvesp_menosmegas=$(echo -e "$horario $diasdesde $usuario $fecha $hora:$minutos $espaciokb $espacioh\n$usuariosvesp_menosmegas")
		fi
        else
		horario=mati
		if [ $espaciokb -gt $kbytes ]; then
                	lineam=$(($lineam + 1))      	
                	usuariosmat=$(echo -e "$horario $diasdesde $usuario $fecha $hora:$minutos $espaciokb $espacioh\n$usuariosmat")
		else
			lineammenos=$(($lineammenos + 1))  
			usuariosmat_menosmegas=$(echo -e "$horario $diasdesde $usuario $fecha $hora:$minutos $espaciokb $espacioh\n$usuariosmat_menosmegas")
		fi
        fi
done
# lo que falta terminar

# ver si en el fichero de tardes y manyanas no hay mas de una fila y si la hay
# borrar todas las cuentas que superen los 15 días y los megas de la variable establecida
# las cuentas que no superen los 15 días se les dejará una nota en el escritorio avisandoles 
# que dos usuarios usan el equipo para que se pongan en su sitio o hablen con el tutor 

# dejar una nota a los usuarios de la tarde si hay mas de uno
# la nota seria: echo $notamenosmegas  ($horario) > $directorio$nombreficheronota 
# o algo parecido a la anterior




