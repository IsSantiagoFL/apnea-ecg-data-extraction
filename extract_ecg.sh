#!/bin/bash

# Este es un script para extraer datos ECG del archivo c06 (binarios) en un .csv para intervalos de 5 minutos, este script fue diseñado exclusivamente para la base de datos Apnea-ECG Database, https://physionet.org/content/apnea-ecg/1.0.0/

# creado por Santiago Ismael Flores @issantiagofl en 13/03/2023

echo "¿Cuántas horas de datos desea extraer?"
read horas

# Crear el directorio para guardar los archivos
mkdir -p archivos_ecg

# Calcular la cantidad de minutos
minutos=$((horas*60))

# Calcular la cantidad de archivos que se generarán
archivos=$((minutos/5))

for i in $(seq 0 $((archivos-1))); do
  start=$((i*5*60)) # calcular el inicio del intervalo
  end=$(((i+1)*5*60)) # calcular el fin del intervalo
  
  # extraer los datos del intervalo y escribirlos en un archivo CSV separado
  rdsamp -r 1.0.0/c06 -c -H -f $start -t $end -v -Pm -s 0 | tail -n +3 | sed 's/,/, /g' > "archivos_ecg/ecg_$i.csv"
  
  # "| tail -n +3" Elimina las 2 primeras del archivo, las cuales petenecen a los encabezados, se debe saber que la primera columna pertenece al tiempo transcurrido en formato 'hh:mm:ss.mmm' y la segunda columna pertenece a la señal de ECG en unidades de 'mV'. los encabezados fueron quitados para dejar el archivo .csv son solo valores numericos para facilitar su graficación usando herramientas de terminal
  
  # "| sed 's/,/, /g'" Remplaza los valores separados con "," por ", " para dividir las dos columnas de datos con "," y un espacio para solucionar los problemas de lectura al momento de graficar con herramientas por terminal como 'gnuplot' o 'xmgrace'
done
