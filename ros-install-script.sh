#!/usr/bin/env bash

## Script de Instalação do ROS Melodic para sistemas Ubuntu-based
## Autor: Allison Silva (@Stalkerfish)
## Licença: GPL 3.0

echo "Esse script irá instalar o ROS Melodic no seu computador!"

## Aguarda um momento para o usuário perceber o que ele está prestes a fazer
sleep 5

PROGRAMAS_PARA_INSTALAR=(
  curl
  python-pip
  ros-melodic-desktop-full
  python-rosdep
  python-rosinstall
  python-rosinstall-generator
  python-wstool
  build-essential
)

## Removendo travas eventuais do APT
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Atualiza os repositórios do Ubuntu e Aplica as Atualizações
sudo apt update -y

sudo apt upgrade -y

## Configurando o Ubuntu para aceitar softwares do repositório do ROS
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt install curl -y ## Necesário para continuar o pré-instalação

## Adiciona a chave de acesso aos repositórios
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - 

# Atualiza os repositórios do Ubuntu novamente
sudo apt update -y

## Instalando programas da lista
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    sudo apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

## Resolvendo possíveis dependências quebradas
sudo apt install -f

##Atualizando o pip
sudo pip install --upgrade setuptools

## Instalando módulos python do ROS via pip
sudo pip install -U rosdep rosinstall_generator vcstool rosinstall

## Configurando o Ambiente ROS no computador
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

## Inicializando o rosdep
sudo rosdep init

rosdep update

echo "ROS Melodic foi instalado com sucesso"
