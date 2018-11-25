#!/bin/sh

# Easy GATE Installation 
# Simplify the Installation of the GATE monte-carlo simulation toolkit
# Version 1.0
# Created on: Nov 25, 2018
# Author: Alexandre CARRE (alexandre.carre@gustaveroussy.fr)
# NB : Use this script at your own Risk

echo "       *     ,MMM8&&&.            *       "
echo "            MMMM88&&&&&    .              "
echo "           MMMM88&&&&&&&                  "
echo "  *        M Easy GATE &          *       "
echo "           MMM V1.0 &&&&                  "
echo "           'MMM88&&&&&&'             .    "
echo "             'MMM8&&&'      *             "
echo "    |\___/|                               "
echo "    )     (           installation :      "
echo "   =\     /=      - Package Requirements  "
echo "     )===(        - ROOT 6.14/04          "
echo "    /     \       - Geant4 10.4.p02       "
echo "    |     |       - InsightToolkit 4.13.1 "
echo "   /       \      - Gate V8.1             "
echo "   \       /      - Cluster tools (opt)   "
echo "  _/\__  _/_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\ "
echo "  |  |( (  |  |Author : Alexandre CARRE  |"  
echo "  |  | ) ) |  |  |  |  |  |  |  |  |  |  |"
echo "  |  |(_(alexandre.carre@gustaveroussy.fr|"
echo " "

## The script has only been tested on Ubuntu
is_centos() {
[[ $(lsb_release -d) =~ "CentOS" ]]
return $?
}
is_debian() {
[[ $(lsb_release -d) =~ "Debian" ]]
return $?
}
is_ubuntu() {
[[ $(lsb_release -d) =~ "Ubuntu" ]]
return $?
}
if ! is_ubuntu; then
	echo "Distribution is not Ubuntu, the script has been done for Ubuntu Distribution"
	return
fi

## Check free space on Disk (require 13 GBs)
FREE=`df -k --output=avail "$PWD" | tail -n1`   # df -k not df -h
if [[ $FREE -lt 13631488 ]]; then               # 13G = 13*1024*1024k
     echo "You need at least 13 GBs of free space to install GATE !"
     echo "less than 13 GBs free!"
     return
fi

## Check internet connection
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
    echo "Your internet connection has been successfully tested"
else
    echo "Please check your internet connection & restart the script"
    return
fi

## Installation of GATE or not ?
while true; do
    read -p "Do you wish to install GATE and its dependencies [y/n]?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) return;;
        * ) echo "Please answer yes or no.";;
    esac
done

## Installation of GATE require sudo password
if [[ "$EUID" = 0 ]]; then
    echo "You are logged as root"
    echo "The installation can't be processed as root"
    return
else
    sudo -k # make sure to ask for password on next sudo
    if sudo true; then
        echo "correct password"
    else
        echo "wrong password"
	return
    fi
fi

# keep sudo alive
while true; do
  sleep 300
  sudo -n true
  kill -0 "$$" 2>/dev/null || exit
done &

## Verify if there is a version of GATE already installed ?
if hash Gate 2>/dev/null
	then
		echo "'Gate' seems to be already installed."
    		while true; do
    		read -p "Are you sure you want to proceed with the installation [y/n]?" yn
    		case $yn in
        	[Yy]* ) break;;
        	[Nn]* ) return;;
        	* ) echo "Please answer yes or no.";;
    	esac
   done
fi

## Personalize the GATE installation path.
while true; do
    read -p "Do you want to personalize the installation path [y/n]? (default : usr/local)" yn
    case $yn in
        [Yy]* ) read -p "Enter path: " GPTH
	if [ -d "$GPTH" ] 
	then
    		echo "$GPTH is valide."
		break
	else
    		echo "$GPTH is not valide. Please check the path enter !"
	fi;;
        [Nn]* ) GPTH='/usr/local'; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

## Go to the installation directory
cd $GPTH 	
sudo mkdir GATE
sudo chmod -R 777 GATE
cd $GPTH/GATE

## Download all the files for Gate installation
#root
#check for version of ubuntu
version=$(lsb_release -sr)
version=${version%.*}
if (($version==18))
	then 
		url_root="https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu18-x86_64-gcc7.3.tar.gz"
			if wget $url_root --spider >/dev/null 2>&1 ; then
				echo "Url : $url_root exists..."
				wget https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu18-x86_64-gcc7.3.tar.gz
				tar -xvzf root_v6.14.04.Linux-ubuntu18-x86_64-gcc7.3.tar.gz
				mv root root_v6.14.04
				rm root_v6.14.04.Linux-ubuntu18-x86_64-gcc7.3.tar.gz
			else
				echo "Url : $url_root doesn't exists.."
				echo "The link seems to be broken, please contact the author to update the script"
				return
			fi
elif (($version==17))
	then 
		url_root="https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu17-x86_64-gcc7.2.tar.gz"
			if wget $url_root --spider >/dev/null 2>&1 ; then
				echo "Url : $url_root exists..."
				wget https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu17-x86_64-gcc7.2.tar.gz
				tar -xvzf root_v6.14.04.Linux-ubuntu17-x86_64-gcc7.2.tar.gz
				mv root root_v6.14.04
				rm root_v6.14.04.Linux-ubuntu17-x86_64-gcc7.2.tar.gz
			else
				echo "Url : $url_root doesn't exists.."
				echo "The link seems to be broken, please contact the author to update the script"
				return
			fi
elif (($version==16))
	then 
		url_root="https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz"
			if wget $url_root --spider >/dev/null 2>&1 ; then
				echo "Url : $url_root exists..."
				wget https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz
				tar -xvzf root_v6.14.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz
				mv root root_v6.14.04
				rm root_v6.14.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz
			else
				echo "Url : $url_root doesn't exists.."
				echo "The link seems to be broken, please contact the author to update the script"
				return
			fi
elif (($version==14))
	then 
		url_root="https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu14-x86_64-gcc4.8.tar.gz"
			if wget $url_root --spider >/dev/null 2>&1 ; then
				echo "Url : $url_root exists..."
				wget https://root.cern.ch/download/root_v6.14.04.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
				tar -xvzf root_v6.14.04.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
				mv root root_v6.14.04
				rm root_v6.14.04.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
			else
				echo "Url : $url_root doesn't exists.."
				echo "The link seems to be broken, please contact the author to update the script"
				return
			fi
else
	echo "Your Ubuntu distribution is not compatible"
	return
fi
#itk
url_itk="https://sourceforge.net/projects/itk/files/itk/4.13/InsightToolkit-4.13.1.tar.gz"
if wget $url_itk --spider >/dev/null 2>&1 ; then
	echo "Url : $url_itk exists..."
	wget https://sourceforge.net/projects/itk/files/itk/4.13/InsightToolkit-4.13.1.tar.gz
	tar -xvzf InsightToolkit-4.13.1.tar.gz
	rm InsightToolkit-4.13.1.tar.gz
else
	echo "Url : $url_itk doesn't exists.."
	echo "The link seems to be broken, please contact the author to update the script"
	return
fi
#geant4
url_geant="http://cern.ch/geant4-data/releases/geant4.10.04.p02.tar.gz"
if wget $url_geant --spider >/dev/null 2>&1 ; then
	echo "Url : $url_itk exists..."
	wget http://cern.ch/geant4-data/releases/geant4.10.04.p02.tar.gz
	tar -xvzf geant4.10.04.p02.tar.gz
	rm geant4.10.04.p02.tar.gz
else
	echo "Url : $url_geant doesn't exists.."
	echo "The link seems to be broken, please contact the author to update the script"
	return
fi
#gate
url_gate="http://www.opengatecollaboration.org/sites/default/files/gate_v8.1.p01.tar.gz"
if wget $url_gate --spider >/dev/null 2>&1 ; then
	echo "Url : $url_itk exists..."
	wget http://www.opengatecollaboration.org/sites/default/files/gate_v8.1.p01.tar.gz
	tar -xvzf gate_v8.1.p01.tar.gz
	rm gate_v8.1.p01.tar.gz
else
	echo "Url : $url_geant doesn't exists.."
	echo "The link seems to be broken, please contact the author to update the script"
	return
fi

## Installation of package requirements
echo "Installing the nice-to-have pre-requisites"
sudo apt-get update  # To get the latest package lists
# To get Required packages
sudo apt-get install git cmake build-essential libqt4-opengl-dev qt4-qmake libqt4-dev libx11-dev libxmu-dev libxpm-dev libxft-dev libtbb-dev libnet-dev -y
# To get optional packages
sudo apt-get install gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev libgsl0-dev -y
echo -e "\n"
echo 'Installation of pre-requisites done.'
echo -e "\n"
## Installation of ROOT
echo "Source ROOT 6.14/04"
source $GPTH/GATE/root_v6.14.04/bin/thisroot.sh
echo -e "\n"
## Installation of Geant4
echo "Installation of Geant4 10.4.p02"
mkdir geant4.10.04.p02-build
mkdir geant4.10.04.p02-install
cd $GPTH/GATE/geant4.10.04.p02-build
cmake -DCMAKE_INSTALL_PREFIX=$GPTH/GATE/geant4.10.04.p02-install -DCMAKE_BUILD_TYPE=RELEASE -DGEANT4_BUILD_MULTITHREADED=OFF -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_G3TOG4=OFF -DGEANT4_USE_GDML=OFF -DGEANT4_USE_INVENTOR=OFF -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_QT=ON -DGEANT4_USE_RAYTRACER_X11=OFF -DGEANT4_USE_SYSTEM_EXPAT=ON -DGEANT4_USE_SYSTEM_ZLIB=OFF -DGEANT4_USE_XM=OFF $GPTH/GATE/geant4.10.04.p02
make -j$(nproc)
make install 
source $GPTH/GATE/geant4.10.04.p02-install/bin/geant4.sh
cd ..
echo "Installation of Geant4 10.4.p02 done."
echo -e "\n"
## Installation of ITK
echo "Installation of ITK 4.13.1 "
cd $GPTH/GATE/InsightToolkit-4.13.1
mkdir bin
cd bin
cmake DITK_USE_REVIEW=ON -DBUILD_EXAMPLES=ON -DBUILD_TESTING=ON -DINSTALL_GTEST=ON -DITKV3_COMPATIBILITY=OFF -DITK_BUILD_DEFAULT_MODULES=ON -DITK_WRAP_PYTHON=OFF ..
make -j$(nproc)
sudo make install
cd ../..
echo "Installation of ITK 4.13.1 done."
echo -e "\n"
## Installation of GATE
echo "Installation of Gate V8.1"
mkdir gate_v8.1.p01-build
mkdir gate_v8.1.p01-install
cd gate_v8.1.p01-build
cmake -DCMAKE_INSTALL_PREFIX=$GPTH/GATE/gate_v8.1.p01-install -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=RELEASE -DGATE_DOWNLOAD_BENCHMARKS_DATA=OFF -DGATE_USE_DAVIS=OFF -DGATE_USE_ECAT7=OFF -DGATE_USE_GEANT4_UIVIS=ON -DGATE_USE_GPU=OFF -DGATE_USE_ITK=ON -DGATE_USE_LMF=OFF -DGATE_USE_OPTICAL=ON -DGATE_USE_RTK=OFF -DGATE_USE_STDC11=ON -DGATE_USE_SYSTEM_CLHEP=OFF -DGATE_USE_XRAYLIB=OFF -DGeant4_DIR=$GPTH/GATE/geant4.10.04.p02-install/lib/Geant4-10.4.2 -DITK_DIR=/usr/local/lib/cmake/ITK-4.13 -DROOTCINT_EXECUTABLE=$GPTH/GATE/root_v6.14.04/bin/rootcint -DROOT_CONFIG_EXECUTABLE=$GPTH/GATE/root_v6.14.04/bin/root-config $GPTH/GATE/gate_v8.1.p01
make -j$(nproc)
make install
echo "Installation of Gate V8.1 done."
cd ..

## Export GATE environnment (path variable)
touch gate_env.sh
echo 'source' $GPTH'/GATE/root_v6.14.04/bin/thisroot.sh' >> gate_env.sh
echo 'source' $GPTH'/GATE/geant4.10.04.p02-install/bin/geant4.sh' >> gate_env.sh
echo 'export PATH=$PATH:'$GPTH'/GATE/gate_v8.1.p01-install/bin' >> gate_env.sh
echo '# export path variable for GATE' >> ~/.bashrc
echo 'source' $GPTH'/GATE/gate_env.sh' >> ~/.bashrc 
source ~/.bashrc 

## verify if Gate is installed and present in $GPTH/GATE/gate_v8.1.p01-install/bin
if ! hash Gate 2>/dev/null
then
    echo "'Gate' was not found in PATH, a problem seems to be appeared during installation."
    echo "Maybe check error message during installation."
    return
else
    echo "'Gate' was successfully installed"
fi

## Installation of Cluster tools or not ?
while true; do
    read -p "Do you wish to install the Cluster tools (HTcondor) [y/n]?
Advice if you are not an advanced user : Always answer yes for HTcondor prompt GUI  " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) return;;
        * ) echo "Please answer yes or no.";;
    esac
done
## Installation of Cluster tools
#jobsplitter
cd $GPTH/GATE/gate_v8.1.p01/cluster_tools/jobsplitter
make
cp $GPTH/GATE/gate_v8.1.p01/cluster_tools/jobsplitter/gjs $GPTH/GATE/gate_v8.1.p01-install/bin
#filemerger
cd $GPTH/GATE/gate_v8.1.p01/cluster_tools/filemerger
make
cp $GPTH/GATE/gate_v8.1.p01/cluster_tools/filemerger/gjm $GPTH/GATE/gate_v8.1.p01-install/bin
#HTcondor for multicore processing (clustering) (always anwser yes to gui prompt for easy use)
sudo apt-get install htcondor -y
sudo condor_master
if ! hash condor_status 2>/dev/null
then
    echo "'HTcondor' was not found, a problem seems to be appeared during installation."
    echo "Maybe check error message during installation." 
else
    echo "HTcondor was successfully installed"
fi
cd
return


