#!/bin/bash

cmd='install'
if [[ $1 == '--remove' ]]; then
   cmd='autoremove --purge'
fi

if [[ ${cmd} == 'install' ]]; then
   sudo apt update && \
   sudo apt upgrade
fi

sudo apt ${cmd} \
   autoconf \
   autogen \
   automake \
   bison \
   cmake \
   flex \
   g++ \
   gcc \
   gettext \
   gfortran \
   gperf \
   help2man \
   libtool \
   libtool-bin \
   m4 \
   pkg-config \
   texinfo
