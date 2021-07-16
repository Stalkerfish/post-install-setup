#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #


URL_VIPER4LINUX="https://github.com/ThePBone/PPA-Repository/blob/master/viper4linux-gui_2.2-43.deb"

URL_VIPER4LINUX_REPO="https://github.com/noahbliss/Viper4Linux.git"
URL_GST_REPO="https://github.com/noahbliss/gst-plugin-viperfx"
URL_VIPERFX_CORE_BINARY_REPO="https://github.com/vipersaudio/viperfx_core_binary.git"


PROGRAMAS_PARA_INSTALAR=(
  build-essential
  git
  autoconf
  automake
  autopoint
  libgstreamer1.0-dev
  libgstreamer-plugins-base1.0-dev
  gstreamer1.0-tools
  curl
 )


# ----------------------------- REQUISITOS ----------------------------- #

cd ~

wget -c "$URL_VIPER4LINUX" 

git clone "$URL_VIPER4LINUX_REPO"
git clone "$URL_GST_REPO"
git clone "$URL_VIPERFX_CORE_BINARY_REPO"


# ----------------------------- EXECUÇÃO ----------------------------- #

sudo apt update -y

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done


cd gst-plugin-viperfx
./autogen.sh

make

cd src/.libs
sudo cp libgstviperfx.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/

cd ../../..
sudo cp viperfx_core_binary/libviperfx_x64_linux.so /lib/libviperfx.so

cd Viper4Linux
cp -r viper4linux ~/.config
sudo cp viper /usr/local/bin

cd ..
sudo apt update -y

cd ~

sudo dpkg -i viper4linux-gui_2.2-43.deb

sudo apt install qtbase5-dev libgstreamer-plugins-bad1.0-dev libgstreamer-opencv1.0-0 libgstreamer-plugins-good1.0-dev gir1.2-gst-plugins-bad-1.0 libopencv-dev libglu1-mesa-dev libqt5concurrent5 libqt5sql5 libqt5test5 libvulkan-dev libxext-dev qt5-qmake qtbase5-dev-tools qtchooser libqt5opengl5-dev

sudo apt --fix-broken install
