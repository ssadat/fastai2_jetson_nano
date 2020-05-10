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
echo $PW | sudo -k --stdin apt install -y python3-pip
pip3 install wheel

# Create a virtual environment and activate it
# echo $PW | sudo -k --stdin apt install -y python3-venv
# cd ~/
# python3 -m venv ~/python-envs/fastai
# source ~/python-envs/fastai/bin/activate


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
wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.5.3.tar.gz
tar -xf magma-2.5.3.tar.gz
# Magma needs a make.inc file to tell it which Nvidia architectures to compile for and where to find the blas libraries
# This file is based on the openblas example in MAGMA, with mior tweaks for the jetson nano architecture (Maxwell) and openblas library location
cp ~/magma-2.5.3/make.inc-examples/make.inc.openblas ~/magma-2.5.3/make.inc
cd magma-2.5.3
export GPU_TARGET=Maxwell
export OPENBLASDIR=/usr/lib/aarch64-linux-gnu/openblas
export CUDADIR=/usr/local/cuda
export PATH=$PATH:/usr/local/cuda-10.2/bin
make
echo $PW | sudo -k --stdin --preserve-env make install prefix=/usr/local/magma
cd ~/
