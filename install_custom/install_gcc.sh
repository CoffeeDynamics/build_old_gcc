#!/bin/bash

function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi
}

if [ $# -ne 1 ]; then
   echo "Please give GCC version in the form A.B.C, e.g., 13.2.0."
   exit 0
fi

v="$1"
_src="gcc-${v}"

# Try .bz2 format
ext=bz2
tarflag=j
tarball="${_src}.tar.${ext}"
url=https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball}
if [ ! `validate_url ${url}` ]; then
   echo "The file ${url} does not exist."

   # Try .gz format
   ext=gz
   tarflag=z
   tarball="${_src}.tar.${ext}"
   url=https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball}
   if [ ! `validate_url ${url}` ]; then
      echo "The file ${url} does not exist."
 
      # Try .xz format
      ext=xz
      tarflag=J
      tarball="${_src}.tar.${ext}"
      url=https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball}
      if [ ! `validate_url ${url}` ]; then
         echo "The file ${url} does not exist."

         # Fail
         echo "ERROR: No downloadable archive found for GCC version ${v}."
         exit 0
      fi
   fi
fi

_bld="${_src}_build"
_ins="${_src}_install"
mkdir ${_bld} ${_ins}
bld=`readlink -e ${_bld}`
ins=`readlink -e ${_ins}`

# Leave one core free to do something else...
np=$(( `grep processor /proc/cpuinfo | wc -l` - 1 ))

# Download archive and extract files
wget -O- https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball} | tar -xv${tarflag}f -

# Patch old versions
case "${v}" in

   "4.7.0" | \
   "4.7.1" | \
   "4.7.2")
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      patch -u gcc-${v}/gcc/cp/cfns.gperf -i patches/gcc-${v}/gcc/cp/cfns.gperf.diff
      patch -u gcc-${v}/gcc/cp/cfns.h -i patches/gcc-${v}/gcc/cp/cfns.h.diff
      patch -u gcc-${v}/gcc/doc/cppopts.texi -i patches/gcc-${v}/gcc/doc/cppopts.texi.diff
      patch -u gcc-${v}/gcc/doc/generic.texi -i patches/gcc-${v}/gcc/doc/generic.texi.diff
      patch -u gcc-${v}/gcc/doc/invoke.texi -i patches/gcc-${v}/gcc/doc/invoke.texi.diff
      patch -u gcc-${v}/gcc/doc/gcc.texi -i patches/gcc-${v}/gcc/doc/gcc.texi.diff
      ;;

   "4.7.3" | \
   "4.7.4")
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      patch -u gcc-${v}/gcc/cp/cfns.gperf -i patches/gcc-${v}/gcc/cp/cfns.gperf.diff
      patch -u gcc-${v}/gcc/cp/cfns.h -i patches/gcc-${v}/gcc/cp/cfns.h.diff
      patch -u gcc-${v}/gcc/doc/invoke.texi -i patches/gcc-${v}/gcc/doc/invoke.texi.diff
      patch -u gcc-${v}/gcc/doc/gcc.texi -i patches/gcc-${v}/gcc/doc/gcc.texi.diff
      ;;

   "4.8.0" | \
   "4.8.1" | \
   "4.8.2" | \
   "4.8.3" | \
   "4.8.4" | \
   "4.8.5")
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      patch -u gcc-${v}/gcc/doc/gcc.texi -i patches/gcc-${v}/gcc/doc/gcc.texi.diff
      patch -u gcc-${v}/gcc/cp/ChangeLog -i patches/gcc-${v}/gcc/cp/ChangeLog.diff
      patch -u gcc-${v}/gcc/cp/Make-lang.in -i patches/gcc-${v}/gcc/cp/Make-lang.in.diff
      patch -u gcc-${v}/gcc/cp/cfns.gperf -i patches/gcc-${v}/gcc/cp/cfns.gperf.diff
      patch -u gcc-${v}/gcc/cp/cfns.h -i patches/gcc-${v}/gcc/cp/cfns.h.diff
      patch -u gcc-${v}/gcc/cp/except.c -i patches/gcc-${v}/gcc/cp/except.c.diff
      ;;
   
   "4.9.4")
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      ;;

   "4.9.0" | \
   "4.9.1" | \
   "4.9.2" | \
   "4.9.3" | \
   "5.1.0" | \
   "5.2.0" | \
   "5.3.0")
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      patch -u gcc-${v}/gcc/cp/ChangeLog -i patches/gcc-${v}/gcc/cp/ChangeLog.diff
      patch -u gcc-${v}/gcc/cp/Make-lang.in -i patches/gcc-${v}/gcc/cp/Make-lang.in.diff
      patch -u gcc-${v}/gcc/cp/cfns.gperf -i patches/gcc-${v}/gcc/cp/cfns.gperf.diff
      patch -u gcc-${v}/gcc/cp/cfns.h -i patches/gcc-${v}/gcc/cp/cfns.h.diff
      patch -u gcc-${v}/gcc/cp/except.c -i patches/gcc-${v}/gcc/cp/except.c.diff
      ;;

   "6.1.0" | \
   "6.2.0" | \
   "6.3.0")
      patch -u gcc-${v}/gcc/ubsan.c -i patches/gcc-${v}/gcc/ubsan.c.diff
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      ;;

   "5.4.0" | \
   "6.4.0" | \
   "7.1.0")
      patch -u gcc-${v}/libgcc/config/i386/linux-unwind.h -i patches/gcc-${v}/libgcc/config/i386/linux-unwind.h.diff
      ;;

esac

src=`readlink -e ${_src}`

# Download prerequisites
cd ${src} && ./contrib/download_prerequisites

# configure using environment variable CC if set
configure_opts='--disable-bootstrap --disable-multilib --disable-nls --enable-languages=c,c++,fortran --disable-libsanitizer'
cd ${bld} && \
if [ ! -z "${CC}" ]; then
   ${src}/configure ${configure_opts} CC="`readlink -e ${CC}`" 2>&1 | tee configure.log
else
   ${src}/configure ${configure_opts} 2>&1 | tee configure.log
fi

# make
make -j${np} 2>&1 | tee make.log && \
make -j${np} check 2>&1 | tee make_check.log && \
\
# install
make DESTDIR=${ins} install-strip 2>&1 | tee make_install-strip.log && \
libtool --finish ${ins}/usr/local/lib64 2>&1 | tee libtool.log && \
\
# check install
${ins}/usr/local/bin/gcc --version && \
${ins}/usr/local/bin/g++ --version && \
${ins}/usr/local/bin/gfortran --version

# clean
#make clean
