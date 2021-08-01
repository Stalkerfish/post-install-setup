#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
PPA_LUTRIS="ppa:lutris-team/lutris"
PPA_ULAUNCHER="ppa:agornostal/ulauncher"


URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.9.2-1_amd64.deb"
URL_GITHUB_DESKTOP="https://github.com/shiftkey/desktop/releases/download/release-2.9.0-linux3/GitHubDesktop-linux-2.9.0-linux3.deb"
URL_WEB_TORRENT_DESKTOP="https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.24.0/webtorrent-desktop_0.24.0_amd64.deb"
URL_APPIMAGELAUNCHER="https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb"
URL_YOUTUBE_MUSIC="https://github.com/th-ch/youtube-music/releases/download/v1.12.1/youtube-music_1.12.1_amd64.deb"


DIRETORIO_DOWNLOADS="~/Downloads/pacotes deb"

PROGRAMAS_PARA_INSTALAR=(
  arduino
  curl
  wget
  jq
  zip
  unzip
  rar
  unrar
  gnome-tweak-tool
  flatpak
  gnome-software-plugin-flatpak
  simulide
  extensions
  dconf-editor
  grub-customizer
  gparted
  gnome-clocks
  gnome-weather
  plank
  gimp
  qbittorrent
  vlc
  telegram-desktop
  ulauncher
  pavucontrol
  virtualbox
  steam-installer
  steam-devices
  steam:i386
  lutris
  playonlinux
  libvulkan1
  libvulkan1:i386
  libgnutls30:i386
  libldap-2.4-2:i386
  libgpg-error0:i386
  libxml2:i386
  libasound2-plugins:i386
  libsdl2-2.0-0:i386
  libfreetype6:i386
  libdbus-1-3:i386
  libsqlite3-0:i386
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros (Lutris, Wine e Viper)##
sudo add-apt-repository "$PPA_LUTRIS" -y
sudo add-apt-repository "$PPA_ULAUNCHER" -y

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GITHUB_DESKTOP"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_WEB_TORRENT_DESKTOP"  -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_4K_VIDEO_DOWNLOADER"  -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_APPIMAGELAUNCHER"     -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done


## Instalando pacotes Flatpak ##
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub com.rafaelmardojai.Blanket -y

## Instalando pacotes Snap ##
sudo snap install discord
sudo snap install whatsapp-for-linux
sudo snap install code --classic

# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
sudo flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #
