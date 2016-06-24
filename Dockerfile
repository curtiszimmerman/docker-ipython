

FROM ubuntu:14.04
MAINTAINER curtiszimmerman <software@curtisz.com>

# get the things we need
RUN apt-get update -y && \
	apt-get install -y \
		curl \
		python-qt4 && \
	rm -rf /var/cache/apt/archive/*

# get more things we need (and do it on one layer so our unionfs doesn't store the 400mb file in one of its layers)
WORKDIR /tmp
RUN curl -o /tmp/Anaconda2-4.0.0-Linux-x86_64.sh http://repo.continuum.io/archive/Anaconda2-4.0.0-Linux-x86_64.sh && \
	chmod +x ./Anaconda2-4.0.0-Linux-x86_64.sh && \
	./Anaconda2-4.0.0-Linux-x86_64.sh -b && \
	rm ./Anaconda2-4.0.0-Linux-x86_64.sh
# make the anaconda stuff available
ENV PATH=${PATH}:/root/anaconda2/bin

## do some amazing anaconda things 
# create conda environment with python 2.7.x 
RUN conda create -n conda-env python=2.7 anaconda
# activate conda environment
RUN ["/bin/bash", "-c", ". activate conda-env"]
# ensure pip version >= 7
RUN conda update pip

## install ipython and ipython notebook
RUN conda install ipython-notebook

# and set our container's run command
CMD jupyter notebook
