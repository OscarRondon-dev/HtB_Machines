#!/bin/bash

# Colores para la salida en terminal
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[1;34m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Función para manejar Ctrl+C
function ctrl_c() {

  echo -e "\n\n ${redColour}[!] Saliendo por Ctrl+C...${endColour}\n"
  tput cnorm && exit 1
}

# Captura la señal Ctrl+C
trap ctrl_c INT

# Variables
doUpdate=false
showHelp=false
bundleFile=false
machineName=""
hasIP=false
ipSearch=""
youtubeLink=false
youtubeMachineName=""
byDifficult=false
machinesByDifficult=""
bySo=false
machinesBySo=""
bySkills=false
machinesBySkills=""
main_url="https://htbmachines.github.io/bundle.js"

# Función para normalizar dificultades
function normalize_difficulty() {
  input="$1"
  case $(echo "$input" | tr '[:upper:]' '[:lower:]' | tr 'áéíóú' 'aeiou') in
  facil | afacil | ffacil | facill) echo "Fácil" ;;
  medio | amedio | meddio) echo "Medio" ;;
  dificil | adificil | difficil | dificill) echo "Difícil" ;;
  insano | ainsano | inssano) echo "Insano" ;;
  *) echo "$input" ;;
  esac
}

# Función para mostrar el panel de ayuda
function helpPanel() {
  echo -e "\n 🆒${yellowColour}[+] Uso: ./htbmachines.sh -m <machineName>${endColour}\n"
  echo -e "\t 🔄${purpleColour}-u${endColour}${grayColour} Descargar o Actualizar los Archivos necesarios${endColour}\n"
  echo -e "\t 💻${purpleColour}-m${endColour}${grayColour} Buscar Por Nombre de la Máquina Hack The Box${endColour}"
  echo -e "\t 🛠️${purpleColour}-i${endColour}${grayColour} Buscar Máquinas Por Dirección IP${endColour}"
  echo -e "\t 📡${purpleColour}-d${endColour}${grayColour} Buscar Máquinas Por Dificultad${endColour}"
  echo -e "\t 🖥️${purpleColour}-o${endColour}${grayColour} Buscar Máquinas Por Sistema Operativo${endColour}"
  echo -e "\t 🖥️${purpleColour}-s${endColour}${grayColour} Buscar Maquina Por Skills${endColour}"
  echo -e "\t 📺${purpleColour}-y${endColour}${grayColour} Buscar el Enlace de YouTube de una máquina${endColour}"
  echo -e "\t ❓${purpleColour}-h${endColour}${grayColour} Muestra este Panel de Ayuda${endColour}"
  echo -e "\n 🧐${greenColour}[+] Usa las opciones -d [Dificultad] y -o [Sistema operativo] para buscar por dificultad y sistema operativo ${endColour}\n"
  echo -e "\n ${redColour}[!] Dependencias requeridas: ${endColour} ${grayColour}curl, js-beautify, moreutils (para sponge), xdg-open${endColour}"
  echo -e "    Instala en Debian/Kali con: sudo apt-get install curl node-js-beautify moreutils xdg-utils\n"
}

# Función para verificar si bundle.js existe y no está vacío
function checkBundle() {
  if [ ! -f bundle.js ]; then
    echo -e "\n ${redColour}[!] No se encontraron los archivos necesarios, por favor ejecuta el script con la opción -u para descargar los archivos necesarios${endColour}\n"
    exit 1
  elif [ ! -s bundle.js ]; then
    echo -e "\n ${redColour}[!] El archivo bundle.js está vacío, por favor ejecuta el script con la opción -u para descargarlo${endColour}\n"
    exit 1
  fi

}

# Función para descargar o actualizar bundle.js
function updateFiles() {
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n ${yellowColour}[!] No se encontraron los archivos necesarios...${endColour}\n"
    sleep 2
    echo -e "\n ${greenColour}[+] Descargando archivos necesarios...${endColour}\n"
    sleep 2
    curl -s "$main_url" >bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n ${blueColour}[+] El archivo bundle.js descargado con éxito...${endColour}\n"
    bundleFile=true
    tput cnorm
  else
    echo -e "\n ${yellowColour}[!] Buscando actualizaciones...${endColour}\n"
    sleep 2
    curl -s "$main_url" >bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    if [ "$(md5sum bundle.js | awk '{print $1}')" != "$(md5sum bundle_temp.js | awk '{print $1}')" ]; then
      mv bundle_temp.js bundle.js
      echo -e "\n ${blueColour}[+] Hay actualizaciones pendientes, descargando...${endColour}\n"
      sleep 2
      echo -e "\n ${greenColour}[+] Archivos actualizados correctamente${endColour}\n"
      bundleFile=true
    else
      rm bundle_temp.js
      echo -e "\n ${greenColour}[+] bundle.js está actualizado${endColour}\n"
    fi
  fi
}

# Función para buscar propiedades de una máquina
function searchMAchine() {
  machineName="$1"
  block=$(awk 'BEGIN {IGNORECASE=1} /name: "'"$machineName"'"/,/resuelta:/' bundle.js)
  if [ -z "$block" ]; then
    echo -e "\n ${redColour}[!] La máquina '$machineName' no existe.${endColour}\n"
    exit 1
  fi
  echo -e "\n ${greenColour}[+] Propiedades de la máquina:${endColour} ${blueColour}$machineName${endColour}\n"
  awk 'BEGIN {IGNORECASE=1} /name: "'"$machineName"'"/,/resuelta:/' bundle.js | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' |
    while IFS=: read -r key value; do
      key=$(echo "$key" | sed 's/^ *//;s/ *$//')
      value=$(echo "$value" | sed 's/^ *//;s/ *$//')
      case "$key" in
      name) echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$value${endColour}" ;;
      dificultad) echo -e "${purpleColour}Dificultad:${endColour} ${greenColour}$value${endColour}" ;;
      so) echo -e "${turquoiseColour}Sistema:${endColour} ${grayColour}$value${endColour}" ;;
      ip) echo -e "${redColour}IP:${endColour} ${grayColour}$value${endColour}" ;;
      skills) echo -e "${blueColour}Skills:${endColour} ${grayColour}$value${endColour}" ;;
      youtube) echo -e "${greenColour}Youtube:${endColour} ${redColour}$value${endColour}" ;;
      *) echo -e "${yellowColour}$key:${endColour} $value" ;;
      esac
    done
  echo -e "${yellowColour}[?] ¿Quieres abrir el enlace de YouTube para la máquina '$machineName'? (y/n): ${endColour}"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    searchLinkYoutube "$machineName"
  fi
  echo -e "\n 🔥 Ready To The Death 🔥\n"

}

# Función para buscar máquinas por IP
function searchByIP() {
  ipSearch="$1"
  echo -e "\n ${greenColour}[+] Buscando máquinas con la IP:${endColour} ${blueColour}$ipSearch${endColour}\n"
  sleep 2
  machineName=$(grep -B 5 "ip: \"$ipSearch\"" bundle.js | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')
  if [ -z "$machineName" ]; then
    echo -e "\n ${redColour}[!] No se encontraron máquinas con la IP:${endColour} ${blueColour}$ipSearch${endColour}\n"
    exit 1
  fi
  echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$machineName${endColour}"
  sleep 2
  echo -e "\n ${greenColour}[+] Buscando las propiedades de la máquina${endColour}\n"
  sleep 2
  searchMAchine "$machineName"
}

# Función para abrir enlace de YouTube
function searchLinkYoutube() {
  youtubeMachineName="$1"
  echo -e "\n ${greenColour}[+] Buscando el enlace de YouTube para la máquina:${endColour} ${blueColour}$youtubeMachineName${endColour}\n"
  sleep 2
  youtubeLink=$(awk 'BEGIN {IGNORECASE=1} /name: "'"$youtubeMachineName"'"/,/resuelta:/' bundle.js | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "youtube:" | awk 'NF{print $NF}')
  if [ -z "$youtubeLink" ]; then
    echo -e "\n ${redColour}[!] No se encontró un enlace de YouTube para la máquina:${endColour} ${blueColour}$youtubeMachineName${endColour}\n"
    exit 1
  fi
  echo -e "\n ${blueColour}[+] Abriendo el enlace de YouTube para la máquina:${endColour} ${blueColour}$youtubeMachineName${endColour}\n"
  sleep 2
  xdg-open "$youtubeLink" &>/dev/null
  echo -e "\n ${blueColour}[+] Enlace abierto correctamente${endColour}\n"
  echo -e "\n 🔥 Ready To The Death 🔥\n"
}

# Función para listar nombres de máquinas con dificultad específica
function listMachinesByDifficult() {
  machinesByDifficult="$1"
  normalized_diff=$(normalize_difficulty "$machinesByDifficult")
  echo -e "\n ${greenColour}[+] Listando máquinas con dificultad:${endColour} ${blueColour}$normalized_diff${endColour}\n"
  names=$(grep -i -B 5 "dificultad: \"$normalized_diff\"" bundle.js | grep "name:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/^name: *//')
  if [ -z "$names" ]; then
    echo -e "\n ${redColour}[!] No se encontraron máquinas con dificultad:${endColour} ${blueColour}$normalized_diff${endColour}\n"
    exit 1
  fi
  echo "$names" | while read -r line; do
    echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$line${endColour}"
  done
  echo -e "\n ${greenColour}[+] Quieres ver las propiedades de alguna${endColour}\n${yellowColour}[?] Escribe 'y' para sí o 'n' para no: ${endColour}"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    echo -e "\n ${greenColour}[+] Escribe el nombre de la máquina:${endColour}\n"
    read -r youtubeMachineName
    searchMAchine "$youtubeMachineName"
  fi
  echo -e "\n 🔥 Ready To The Death 🔥\n"
}
# Función para listar nombres de máquinas con sistema operativo específico
function listMachinesBySo() {
  machinesBySo="$1"
  echo -e "\n ${greenColour}[+] Listando máquinas con sistema operativo:${endColour} ${blueColour}$normalized_so${endColour}\n"
  names=$(grep -i -B 5 "so: \"$machinesBySo\"" bundle.js | grep "name:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/^name: *//')
  if [ -z "$names" ]; then
    echo -e "\n ${redColour}[!] No se encontraron máquinas con este sistema operativo:${endColour} ${blueColour}$normalized_so${endColour}\n"
    exit 1
  fi
  echo "$names" | while read -r line; do
    case "$machinesBySo" in
    Linux | linux) echo -e "${yellowColour}Nombre:${endColour} ${redColour}$line${endColour}" ;;
    Windows | windows) echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$line${endColour}" ;;
    *) echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$line${endColour}" ;;
    esac
  done
  echo -e "\n ${greenColour}[+] Quieres ver las propiedades de alguna${endColour}\n${yellowColour}[?] Escribe 'y' para sí o 'n' para no: ${endColour}"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    echo -e "\n ${greenColour}[+] Escribe el nombre de la máquina:${endColour}\n"
    read -r youtubeMachineName
    searchMAchine "$youtubeMachineName"
  fi
  echo -e "\n 🔥 Ready To The Death 🔥\n"
}
# Función para listar nombres de máquinas con sistema operativo y dificultad específicos
listMachinesBySoAndDifficult() {
  machinesBySo="$1"
  machinesByDifficult="$2"
  normalized_diff=$(normalize_difficulty "$machinesByDifficult")
  echo -e "\n ${greenColour}[+] Listando máquinas con sistema operativo:${endColour} ${blueColour}$machinesBySo${endColour} ${greenColour}y dificultad:${endColour} ${blueColour}$normalized_diff${endColour}\n"
  name=$(grep -i -B 5 "dificultad: \"$normalized_diff\"" bundle.js | grep -i -B 5 "so: \"$machinesBySo\"" | tr -d '"' | tr -d ',' | grep "name:" | sed 's/^ *//' | sed 's/^name: *//')
  if [ -z "$name" ]; then
    echo -e "\n ${redColour}[!] No se encontraron máquinas con este sistema operativo y dificultad:${endColour} ${blueColour}$machinesBySo y $normalized_diff${endColour}\n"
    exit 1
  fi
  echo "$name" | while read -r line; do
    case "$machinesBySo" in
    Linux | linux) echo -e "${yellowColour}Nombre:${endColour} ${grayColour}$line${endColour}" ;;
    Windows | windows) echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$line${endColour}" ;;
    *) echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$line${endColour}" ;;
    esac
  done
  echo -e "\n ${greenColour}[+] Quieres ver las propiedades de alguna${endColour}\n${yellowColour}[?] Escribe 'y' para sí o 'n' para no: ${endColour}"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    echo -e "\n ${greenColour}[+] Escribe el nombre de la máquina:${endColour}\n"
    read -r youtubeMachineName
    searchMAchine "$youtubeMachineName"
  fi
  echo -e "\n 🔥 Ready To The Death 🔥\n"
}

# Funcion para listar nombres de máquinas por skills
function listMachinesBySkills() {
  machinesBySkills="$1"
  echo -e "\n ${greenColour}[+] Listando máquinas con la skill:${endColour} ${blueColour}$machinesBySkills${endColour}\n"
  names=$(grep -i -B 6 "skills: .*${machinesBySkills}.*" bundle.js | grep "name:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/^name: *//')
  if [ -z "$names" ]; then
    echo -e "\n ${redColour}[!] No se encontraron máquinas con esta skill:${endColour} ${blueColour}$machinesBySkills${endColour}\n"
    exit 1
  fi
  echo "$names" | while read -r line; do
    echo -e "${yellowColour}Nombre:${endColour} ${blueColour}$line${endColour}"
  done
  echo -e "\n ${greenColour}[+] Quieres ver las propiedades de alguna${endColour}\n${yellowColour}[?] Escribe 'y' para sí o 'n' para no: ${endColour}"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    echo -e "\n ${greenColour}[+] Escribe el nombre de la máquina:${endColour}\n"
    read -r youtubeMachineName
    searchMAchine "$youtubeMachineName"
  fi
  echo -e "\n 🔥 Ready To The Death 🔥\n"
}
# Procesar argumentos
while getopts ":m:ui:d:y:o:s:h" arg; do
  case $arg in
  m) machineName="$OPTARG" ;;
  u) doUpdate=true ;;
  h) showHelp=true ;;
  i)
    ipSearch="$OPTARG"
    hasIP=true
    ;;
  y)
    youtubeMachineName="$OPTARG"
    youtubeLink=true
    ;;
  d)
    machinesByDifficult="$OPTARG"
    byDifficult=true
    ;;
  o)
    machinesBySo="$OPTARG"
    bySo=true
    ;;
  s)
    machinesBySkills="$OPTARG"
    bySkills=true
    ;;
  \?)
    echo "Error: Opción inválida: -$OPTARG, utiliza -h para ayuda" >&2
    exit 1
    ;;
  :)
    echo "Error: La opción -$OPTARG requiere un argumento." >&2
    exit 1
    ;;
  *)
    echo "Error: Ocurrió un error inesperado." >&2
    exit 1
    ;;
  esac
done

# Verificar bundle.js para opciones que lo requieren
if $hasIP || $youtubeLink || [ -n "$machineName" ] || $byDifficult || $bySo; then
  checkBundle
fi
# Ejecutar la acción correspondiente
if $showHelp; then
  helpPanel
  exit 0
elif $doUpdate; then
  updateFiles
  exit 0
elif $bySo && $byDifficult; then
  listMachinesBySoAndDifficult "$machinesBySo" "$machinesByDifficult"
  exit 1
elif $byDifficult; then
  listMachinesByDifficult "$machinesByDifficult"
  exit 0
elif $bySo; then
  listMachinesBySo "$machinesBySo"
  exit 0

elif $hasIP; then
  searchByIP "$ipSearch"
  exit 0
elif $youtubeLink; then
  searchLinkYoutube "$youtubeMachineName"
  exit 0
elif $bySkills; then
  listMachinesBySkills "$machinesBySkills"
  exit 0
elif [ -n "$machineName" ]; then
  searchMAchine "$machineName"
  exit 0
else
  helpPanel
  exit 1
fi
