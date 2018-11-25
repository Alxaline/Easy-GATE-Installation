# Easy GATE Installation
[![Easy GATE](https://img.shields.io/badge/Easy%20GATE-v1.0-brightgreen.svg)](https://github.com/Alxaline/Easy-GATE-Installation)
![platform](https://img.shields.io/badge/plateform-Ubuntu-lightgrey.svg)
![APMLicense](https://img.shields.io/badge/licence-MIT-green.svg)
[![Donwload](https://img.shields.io/github/downloads/Alxaline/Easy-GATE-Installation/total.svg)]()

<p align="center"> <b>
  You want to install GATE and you don't know how to do it ? You are in the right place !!!
</b></p>

<p align="center">
  <img width="477" height="369" src="https://github.com/Alxaline/Easy-GATE-Installation/blob/master/images/logo_EG.png">
</p>
<p align="justify">
GATE is an advanced opensource software developed by the international OpenGATE collaboration and dedicated to numerical simulations in medical imaging and radiotherapy. It currently supports simulations of Emission Tomography (Positron Emission Tomography - PET and Single Photon Emission Computed Tomography - SPECT), Computed Tomography (CT), Optical Imaging (Bioluminescence and Fluorescence) and Radiotherapy experiments. Using an easy-to-learn macro mechanism to configurate simple or highly sophisticated experimental settings, GATE now plays a key role in the design of new medical imaging devices, in the optimization of acquisition protocols and in the development and assessment of image reconstruction algorithms and correction techniques. It can also be used for dose calculation in radiotherapy experiments.

The installation of GATE is tedious, time consuming and may seem complicated for a novice user. In order not to discourage a novice user to apprehend the formidable tool that is GATE. You can use the script provided here which will install absolutely all the necessary files. All you have to do is comply the following instructions. The compilation is long, so don't be afraid !
For more advance users, the script also allows you to install cluster tools with HTcondor.
</p>

The script has been tested on : 
- Ubuntu 18.04
- Ubuntu 16.04 </br>
*The script is supposed to work on Ubuntu versions from 14 to 18.*

Some informations : 
- If you want to know more about GATE, please refer to [the official webpage of GATE](http://www.opengatecollaboration.org/).<br/>
- GATE User's Guide is available on [Wiki OpenGATE](http://wiki.opengatecollaboration.org/index.php/Users_Guide).<br/>
- Before use this tool on your system maybe you want to know about the possibility to use an image of the vGATE 8.1, virtual machine equipped with all the necessary software for running GATE simulations, please refer to [the official vGate 8.1 webpage](http://www.opengatecollaboration.org/node/84)<br/>

Report bugs to the author [Alexandre CARRE](mailto:alexandre.carre@gustaveroussy.fr)<br/>
NB : use this script at your own risk.


# Requirements
- an internet connection.
- 13 GB of free hard disk space 
- sudo privilege.

# Installation & Instruction

<p align="center">
  <img width="401" height="293" src="https://github.com/Alxaline/Easy-GATE-Installation/blob/master/images/terminal_EG.png">
</p>

## First method
Open a terminal:
```
git clone https://github.com/Alxaline/Easy-GATE-Installation.git
cd Easy-GATE-Installation
source easy_gate.sh
```
## Second method
Download ZIP directly from [the github repo](https://github.com/Alxaline/Easy-GATE-Installation)
then open a terminal:
```
unzip Downloads/Easy-GATE-Installation.zip
cd Easy-GATE-Installation
source easy_gate.sh
```

# Cluster tools (optional)
For information on How to use Gate on a Cluster, please refer to [the official users guide](http://wiki.opengatecollaboration.org/index.php/Users_Guide:How_to_use_Gate_on_a_Cluster)
## Installation
After the installation of GATE the script will ask you if you want to install cluster tools. In this case, respond "Yes". The script will then install cluster tools (jobsplitter, filemerge) and HTcondor. For non expert users, we recommand you to answer "yes" for the HTcondor prompt GUI.
## How to use HTcondor ?
For information about HTcondor, please refer to [the official documentation of HTcondor](http://research.cs.wisc.edu/htcondor/manual/v8.6/index.html).<br/>
### First step:
You need to export two environment variables:
```
export GC_DOT_GATE_DIR=/somedir/
```
if default path installation:
```
export GC_GATE_EXE_DIR=/usr/local/GATE/gate_v8.1.p01-install/bin
```
if personnalize path installation:
```
export GC_GATE_EXE_DIR=/somedir/GATE/gate_v8.1.p01-install/bin
```
The first variable indicates the location of a hidden directory called .Gate. The directory will contain the split macros for each part of the simulation. Even when splitting the same macro several times, a new directory will be created for each instance (with an incremental number).
The second environment variable indicates the location of the job splitter executable. (you don't have to modify it)
### Second step:
Execute from your macro path this command:
```
../somedir/GATE/gate_v8.1.p01/cluster_tools/jobsplitter/gjs  -numberofsplits N -clusterplatform condor -condorscript ../somedir/GATE/gate_v8.1.p01/cluster_tools/jobsplitter/script/condor.script  your_file.mac
```
The job splitter will subdivide the simulation macro into fully resolved, non-parameterized macros. In this case there are N such macros. Remplace N by the number of macros that you want. They are located in the .Gate directory, as specified by the GC_DOT_GATE_DIR environment variable.
### Third step:
Execute the main submit files create in your_file.mac folder to start clustering:
```
condor_submit your_file.submit
```
### optional step:
If you want to merge your file after simulation, please refer to [the official users guide](http://wiki.opengatecollaboration.org/index.php/Users_Guide:How_to_use_Gate_on_a_Cluster)

# How to run GATE after installation? 
Just type in your terminal
```
Gate
```
# Information
## Where is installed GATE?
If you use default path installation, GATE is installed in:
```
/usr/local
```
## What this script will install ?
- Package Requirements 
- ROOT 6.14/04
- Geant4 10.4.p02 
- InsightToolkit 4.13.1
- Gate V8.1 
- Cluster tools / HTcondor (optional)

## Doubt about quality of the installation ?
if you have any doubt about the quality of the installation and want to remove it.
### First remove the installation folder
```
cd /usr/local (default path) or cd /somedir (personalize path)
sudo rm -R GATE
```
### Second remove the environnement variable
The script will add the environnement variable to your .bashrc:
```
gedit ~/.bashrc
```
Remove the line at the end:
```
source /usr/local/GATE/gate_env.sh (default path) or source /somedir/GATE/gate_env.sh (personalize path)
```

