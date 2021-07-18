#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #


URL_VIPER4LINUX_REPO="https://github.com/Audio4Linux/Viper4Linux.git"
URL_VIPER4LINUX_GUI_REPO="https://github.com/Audio4Linux/Viper4Linux-GUI"
URL_GST_REPO="https://github.com/Audio4Linux/gst-plugin-viperfx"
URL_VIPERFX_CORE_BINARY_REPO="https://github.com/vipersaudio/viperfx_core_binary.git"


PROGRAMAS_PARA_INSTALAR=(
  build-essential
  cmake
  git
  libgstreamer1.0-dev
  libgstreamer-plugins-base1.0-dev
  gstreamer1.0-tools
  curl
  libgstreamer-plugins-base1.0-dev
  libgstreamer1.0-dev
  gstreamer1.0-plugins-bad
  libgstreamer-plugins-bad1.0-dev
  qtbase5-dev
  qtmultimedia5-dev
  libqt5svg5-dev
  libqt5core5a
  libqt5dbus5
  libqt5gui5
  libqt5multimedia5
  libqt5svg5
  libqt5xml5
  libqt5network5
 )


# ----------------------------- REQUISITOS ----------------------------- #

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

cd ~

git clone "$URL_VIPER4LINUX_REPO"
git clone "$URL_GST_REPO"
git clone "$URL_VIPERFX_CORE_BINARY_REPO"


# ----------------------------- EXECUÇÃO ----------------------------- #

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
   sudo apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done


cd gst-plugin-viperfx
cmake .

make

sudo cp libgstviperfx.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/

cd ..

sudo cp viperfx_core_binary/libviperfx_x64_linux.so /lib/libviperfx.so

cd Viper4Linux
cp -r viper4linux ~/.config
sudo cp viper /usr/local/bin

cd ~

cd Viper4Linux-GUI
qmake V4L_Frontend.pro
make
./V4L_Frontend

sudo cp V4L_Frontend /usr/local/bin/viper-gui
sudo chmod 755 /usr/local/bin/viper-gui

sudo su
sudo cat <<EOT >> /usr/share/applications/viper-gui.desktop
[Desktop Entry]
Name=Viper4Linux
GenericName=Equalizer
Comment=User Interface for Viper4Linux
Keywords=equalizer
Categories=AudioVideo;Audio;
Exec=viper-gui
StartupNotify=false
Terminal=false
Type=Application
EOT
exit

sudo wget -O /usr/share/pixmaps/viper-gui.png https://raw.githubusercontent.com/Audio4Linux/Viper4Linux-GUI/master/viper.png -q --show-progress

cd ~
sudo rm -r gst-plugin-viperfx Viper4Linux viperfx_core_binary Viper4Linux-GUI

echo "Viper4Linux was installed succesfully!"
