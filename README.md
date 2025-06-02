# Pasos para instalar Ruby y Ejecutar App desde Subsistma Linux
#Estos comandos se ejecutan desde PowerShell como administrador

1. Instalar WSL
     "wsl --install"
2. Verificar que Ubuntu esté instalado
     "wsl.exe --list --verbose"
3. Si no está, instalarlo
     "wsl.exe --install Ubuntu-20.04"
   
//Estos pasos se ejecutan desde la consola de WSL

5. Actualizar paquetes
     "sudo apt update && sudo apt upgrade -y"
6. Instalar Dependencias
     "sudo apt install -y curl gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev sqlite3 git libpq-dev"
   
//Instalar Ruby con RVM

7. Instalar GPG
     "sudo apt install -y gnupg2"
8. Importar las llaves GPG requeridas por RVM
     "gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
      409B6B1796C275462A1703113804BB82D39DC0E3 \
      7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
9. Instalar RVM con soporte para Ruby
     "\curl -sSL https://get.rvm.io | bash -s stable --ruby"
10. Cargar RVM en la terminal
      "source ~/.rvm/scripts/rvm"
11. Instalar una versión específica de Ruby
      "rvm install 3.2.0"   (Version del Proyecto)
12. Utilizar por defecto la version instalada
      "rvm use 3.2.0 --default"
13. Instalar Bundler
      "gem install bundler"
14. Instalar Rails
      "gem install rails -v 7.1.3"
    
//Clonar el repositorio de GitHub

16. Usar los siguientes comandos 1 por 1
      "cd ~"
    
      "git clone https://github.com/EmilioAlonzo4587/proyectofinalprogra.git"
    
      "cd proyectofinalprogra"
17. Instalar dependencias del proyecto
      "bundle install"
18. Ejecutar el servidor Rails
      "rails server"
19. Ingresar al link
    http://127.0.0.1:3000
    

