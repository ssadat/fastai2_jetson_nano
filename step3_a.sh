#!/bin/bash
# Install Fastai2 on Nvidia Jetson Nano running Jetpack 4.4
# Authored by Streicher Louw, April 2020, based on previous work by
# Bharat Kunwar https://github.com/brtknr (installation of fastai) 
# and Jeffrey Antony https://github.com/jeffreyantony (use of TMUX)

# With a fast SD card, this process takes around 12-16 hours.

# As this script will take many hours to execute, the script first needs to
# cache your sudo credentials if they are not supplied on the command line

if [ "$1" != "" ]; then
  PW=$1
else
  echo "Please enter the sudo password"
  read -sp 'Password: ' PW
fi

now=`date`
echo "Start Installation of fastai2 on jetson nano at: $now"

# Update the nano's software
echo $PW | sudo -k --stdin apt -y update
echo $PW | sudo -k --stdin apt -y upgrade
echo $PW | sudo -k --stdin apt -y autoremove

# Create a virtual environment and activate it
echo $PW | sudo -k --stdin apt install -y python3-venv
cd ~/
python3 -m venv ~/python-envs/fastai
source ~/python-envs/fastai/bin/activate

echo $PW | sudo -k --stdin apt install -y python3-pip
pip3 install wheel

# Install MAGMA from source
# Since fastai requires pytorch to be compiled MAGMA, MAGMA needs to be installed first
# The authors of MAGMA does not offer binary builds, so it needs to be compiled from source
now=`date`
echo "Start installation of MAGMA at: $now"
# echo $PW | sudo -k --stdin apt remove -y libblas3
# echo $PW | sudo -k --stdin apt remove -y liblapack3
echo $PW | sudo -k --stdin apt install -y libopenblas-dev
echo $PW | sudo -k --stdin apt install -y gfortran
echo $PW | sudo -k --stdin apt install -y cmake
echo $PW | sudo -k --stdin apt install -y libnuma-dev #Used for pytorch later
