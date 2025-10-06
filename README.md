🚀 # .htbmachines.sh

.htbmachines.sh es un script en Bash diseñado para facilitar la búsqueda y gestión de máquinas de Hack The Box desde la terminal. Este proyecto te permite buscar máquinas por nombre, IP, dificultad, sistema operativo o habilidades, descargar y actualizar datos automáticamente, y acceder a enlaces de YouTube para write-ups. Perfecto para pentesters, estudiantes de ciberseguridad y entusiastas de CTF en 2025, este script combina simplicidad con potencia, haciendo uso de herramientas modernas para una experiencia fluida. 🛠️

📋 Tabla de Contenidos

Introducción
Características
Tecnologías
Instalación
Uso
Despliegue
Licencia
Agradecimientos
Footer


📖 Introducción
En un mundo donde la ciberseguridad es clave, .htbmachines.sh resuelve el problema de buscar información detallada sobre máquinas de Hack The Box de forma rápida y eficiente desde la terminal. Este script es ideal para:

Pentesters que necesitan información específica sobre máquinas (IP, dificultad, SO, etc.).
Estudiantes de ciberseguridad que buscan aprender y practicar con máquinas de HTB.
Entusiastas de CTF que quieren automatizar la búsqueda de recursos y write-ups.

En 2025, con el auge de la automatización y la privacidad en ciberseguridad, este script destaca por su diseño ligero, uso de colores en la terminal para mejor legibilidad y soporte para múltiples filtros de búsqueda. ¡Explora máquinas de Hack The Box resueltas por S4vitar ! 🚀


✨ Características

 🔍 Búsqueda avanzada: Filtra máquinas por nombre, IP, dificultad, sistema operativo o habilidades específicas.
 📥 Actualización automática: Descarga y actualiza el archivo bundle.js desde la fuente oficial.
 📺 Enlaces de YouTube: Accede rápidamente a write-ups en video para cualquier máquina.
 🎨 Interfaz colorida: Salida en terminal con colores para una experiencia visual agradable.
 🛡️ Robusto y seguro: Manejo de errores y validación de dependencias para evitar fallos.
 🌐 Soporte offline (en desarrollo): Cache local para trabajar sin conexión.



🛠️ Tecnologías




<img width="79" height="28" alt="image" src="https://github.com/user-attachments/assets/d347d765-c637-4a44-8cad-07dbda01126f" />

Bash
Lenguaje principal para scripting



<img width="78" height="28" alt="image" src="https://github.com/user-attachments/assets/13d80f81-892a-4c4a-b85b-af143e4cdbfd" />

curl
Descarga de recursos externos


<img width="111" height="28" alt="image" src="https://github.com/user-attachments/assets/c5d0e0cd-e991-49e2-ad8d-121ac3338fd7" />

js-beautify
Formateo de archivos JavaScript


<img width="101" height="28" alt="image" src="https://github.com/user-attachments/assets/e97d4102-ef64-418b-843f-0dabeba67a51" />

moreutils
Utilidad sponge para manipulación de archivos


<img width="97" height="28" alt="image" src="https://github.com/user-attachments/assets/a04bc2e5-2c16-45df-a7b4-bde1fec4cf69" />

xdg-utils
Apertura de enlaces en el navegador




⚙️ Instalación Rápida

Clona el repositorio:
git clone https://github.com/OscarRondon-dev/.htbmachines.sh.git
cd .htbmachines.sh


Instala las dependencias (en Debian/Kali):
sudo apt-get install curl node-js-beautify moreutils xdg-utils


Dale permisos de ejecución al script:
chmod +x .htbmachines.sh


⚠️ Nota: Asegúrate de tener Node.js 18+ para js-beautify. Verifica con:
node -v


📚 Uso
Ejecuta el script con diferentes opciones para buscar máquinas de Hack The Box:
./.htbmachines.sh -m "NombreMáquina"  # Buscar por nombre
./.htbmachines.sh -i "10.10.10.10"   # Buscar por IP
./.htbmachines.sh -d "Fácil"         # Buscar por dificultad
./.htbmachines.sh -o "Linux"         # Buscar por sistema operativo
./.htbmachines.sh -s "Active Directory"  # Buscar por habilidades
./.htbmachines.sh -y "NombreMáquina"  # Abrir enlace de YouTube
./.htbmachines.sh -u                 # Actualizar bundle.js
./.htbmachines.sh -h                 # Mostrar ayuda

<img width="1457" height="440" alt="image" src="https://github.com/user-attachments/assets/05a31e0b-b1f4-4f49-8a83-d53ce0a58394" />


<img width="1895" height="387" alt="image" src="https://github.com/user-attachments/assets/4048981c-ea07-437d-bb65-f4fabdc25a61" />



🚀 Despliegue
El script es standalone y no requiere despliegue en servidores como Vercel o Netlify. Simplemente clona y ejecuta en tu máquina local. Para entornos personalizados:

Copia el script a tu sistema:cp .htbmachines.sh /usr/local/bin/htbmachines


Ejecútalo desde cualquier lugar:htbmachines -h



📜 Licencia
Este proyecto está licenciado bajo la Licencia MIT. Libre para uso comercial, modificación y distribución.Consulta el archivo LICENSE para más detalles.

🙌 Agradecimientos

A s4vitar
A la comunidad de Hack The Box por inspirar este proyecto.


🖼️ Footer
¿Encontraste un problema o tienes una idea? Abre un issue o participa en discussions.⭐ ¡Si te gusta, dale una estrella! ⭐Copyright © 2025 OscarRondon-dev. Todos los derechos reservados.
