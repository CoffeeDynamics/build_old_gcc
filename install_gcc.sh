#!/bin/bash

function check_url(){
   #-----------
   url="$1"
   #-----------
   if [[ `wget -S --spider "${url}"  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi
}

function download(){
   #-----------
   v="$1"
   #-----------
   # Try .bz2 format
   tarflag=j
   download_tarbz2 "${v}" "${tarflag}"
   if [ $? -ne 0 ]; then 
   
      # Try .gz format
      tarflag=z
      download_targz "${v}" "${tarflag}"
      if [ $? -ne 0 ]; then 
    
         # Try .xz format
         tarflag=J
         download_tarxz "${v}" "${tarflag}"
         if [ $? -ne 0 ]; then 
   
            # Fail
            echo "ERROR: No downloadable archive found for GCC version ${v}."
            exit 0
         fi
      fi
   fi
}

function download_tarbz2(){
   #-----------
   v="$1"
   tarflag="$2"
   #-----------
   ext=bz2
   download_archive ${v} ${ext} ${tarflag}
}

function download_targz(){
   #-----------
   v="$1"
   tarflag="$2"
   #-----------
   ext=gz
   download_archive ${v} ${ext} ${tarflag}
}

function download_tarxz(){
   #-----------
   v="$1"
   tarflag="$2"
   #-----------
   ext=xz
   download_archive ${v} ${ext} ${tarflag}
}

function download_archive(){
   #-----------
   v="$1"
   ext="$2"
   tarflag="$3"
   #-----------
   src="gcc-${v}"
   tarball="${src}.tar.${ext}"
   url="https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball}"
   if [ `check_url "${url}"` ]; then
      
      # on-the-fly download and extraction
      #wget -O- https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball} | tar -xv${tarflag}f -
      
      # keep archive
      wget https://ftp.gnu.org/gnu/gcc/gcc-${v}/${tarball} && \
      tar -xv${tarflag}f ${tarball}

      ret=0
   else
      ret=1
   fi
   return ${ret}
}

function patchme(){
   #-----------
   sourcefile="$1"
   patchfile="$2"
   #-----------
   patch -u "${sourcefile}" -i "${patchfile}"
}

function apply_patches(){
   #-----------
   v="$1"
   #-----------
   # Patch old versions
   gccroot="gcc-${v}"
   patchroot="patches/gcc-${v}"
   case "${v}" in
   
      "4.7.0" | \
      "4.7.1" | \
      "4.7.2")
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h ${patchroot}/libgcc/config/i386/linux-unwind.h.diff && \
         patchme ${gccroot}/libjava/include/x86_64-signal.h ${patchroot}/libjava/include/x86_64-signal.h.diff && \
         patchme ${gccroot}/gcc/cp/cfns.gperf ${patchroot}/gcc/cp/cfns.gperf.diff && \
         patchme ${gccroot}/gcc/cp/cfns.h ${patchroot}/gcc/cp/cfns.h.diff && \
         patchme ${gccroot}/gcc/doc/cppopts.texi ${patchroot}/gcc/doc/cppopts.texi.diff && \
         patchme ${gccroot}/gcc/doc/generic.texi ${patchroot}/gcc/doc/generic.texi.diff && \
         patchme ${gccroot}/gcc/doc/invoke.texi ${patchroot}/gcc/doc/invoke.texi.diff && \
         patchme ${gccroot}/gcc/doc/gcc.texi ${patchroot}/gcc/doc/gcc.texi.diff
         ;;
   
      "4.7.3" | \
      "4.7.4")
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h -i ${patchroot}/libgcc/config/i386/linux-unwind.h.diff && \
         patchme ${gccroot}/gcc/cp/cfns.gperf -i ${patchroot}/gcc/cp/cfns.gperf.diff && \
         patchme ${gccroot}/gcc/cp/cfns.h -i ${patchroot}/gcc/cp/cfns.h.diff && \
         patchme ${gccroot}/gcc/doc/invoke.texi -i ${patchroot}/gcc/doc/invoke.texi.diff && \
         patchme ${gccroot}/gcc/doc/gcc.texi -i ${patchroot}/gcc/doc/gcc.texi.diff
         ;;
   
      "4.8.0" | \
      "4.8.1" | \
      "4.8.2" | \
      "4.8.3" | \
      "4.8.4" | \
      "4.8.5")
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h -i ${patchroot}/libgcc/config/i386/linux-unwind.h.diff && \
         patchme ${gccroot}/gcc/doc/gcc.texi -i ${patchroot}/gcc/doc/gcc.texi.diff && \
         patchme ${gccroot}/gcc/cp/ChangeLog -i ${patchroot}/gcc/cp/ChangeLog.diff && \
         patchme ${gccroot}/gcc/cp/Make-lang.in -i ${patchroot}/gcc/cp/Make-lang.in.diff && \
         patchme ${gccroot}/gcc/cp/cfns.gperf -i ${patchroot}/gcc/cp/cfns.gperf.diff && \
         patchme ${gccroot}/gcc/cp/cfns.h -i ${patchroot}/gcc/cp/cfns.h.diff && \
         patchme ${gccroot}/gcc/cp/except.c -i ${patchroot}/gcc/cp/except.c.diff
         ;;
      
      "4.9.4")
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h -i ${patchroot}/libgcc/config/i386/linux-unwind.h.diff
         ;;
   
      "4.9.0" | \
      "4.9.1" | \
      "4.9.2" | \
      "4.9.3" | \
      "5.1.0" | \
      "5.2.0" | \
      "5.3.0")
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h -i ${patchroot}/libgcc/config/i386/linux-unwind.h.diff && \
         patchme ${gccroot}/gcc/cp/ChangeLog -i ${patchroot}/gcc/cp/ChangeLog.diff && \
         patchme ${gccroot}/gcc/cp/Make-lang.in -i ${patchroot}/gcc/cp/Make-lang.in.diff && \
         patchme ${gccroot}/gcc/cp/cfns.gperf -i ${patchroot}/gcc/cp/cfns.gperf.diff && \
         patchme ${gccroot}/gcc/cp/cfns.h -i ${patchroot}/gcc/cp/cfns.h.diff && \
         patchme ${gccroot}/gcc/cp/except.c -i ${patchroot}/gcc/cp/except.c.diff
         ;;
   
      "6.1.0" | \
      "6.2.0" | \
      "6.3.0")
         patchme ${gccroot}/gcc/ubsan.c -i ${patchroot}/gcc/ubsan.c.diff && \
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h -i ${patchroot}/libgcc/config/i386/linux-unwind.h.diff
         ;;
   
      "5.4.0" | \
      "6.4.0" | \
      "7.1.0")
         patchme ${gccroot}/libgcc/config/i386/linux-unwind.h -i ${patchroot}/libgcc/config/i386/linux-unwind.h.diff
         ;;
   
   esac
}

function install(){
   #-----------
   v="$1"
   install_directory="$2"
   #-----------

   # Source file directory
   _src="gcc-${v}"
  
   # Installation directory
   if [ ! -d "${install_directory}" ]; then
      mkdir -p "${install_directory}"
   fi
   abs_install_directory=`readlink -e "${install_directory}"`
   if [ -z "${abs_install_directory}" ]; then
      echo "ERROR: Empty installation path."
      exit 0
   fi
  
   # Log file extension 
   logext="tmp-log"

   # Download GCC 
   download "${v}"

   # Apply patches to old versions
   apply_patches "${v}"
   
   # Get absolute paths
   src=`readlink -e ${_src}`
   _bld="${_src}_build"
   _ins="${_src}_install"
   mkdir ${_bld}
   bld=`readlink -e ${_bld}`
   abs_install_directory+="/${_ins}"
   mkdir "${abs_install_directory}"
   
   # Download prerequisites
   cd ${src} && ./contrib/download_prerequisites
   
   # Leave one core free to do something else...
   np=$(( `grep processor /proc/cpuinfo | wc -l` - 1 ))
   
   # Configure options: see https://gcc.gnu.org/install/configure.html for details
   configure_opts='--disable-bootstrap'
   configure_opts+=' --disable-multilib'
   configure_opts+=' --disable-nls'
   configure_opts+=' --enable-languages=all'  # all, default, ada, c, c++, d, fortran, go, jit, lto, m2, objc, obj-c++
   configure_opts+=' --enable-host-shared'
   configure_opts+=' --disable-libsanitizer'

   # Configure using $CC if set
   cd ${bld} && \
   if [ ! -z "${CC}" ]; then
      ${src}/configure ${configure_opts} CC="`readlink -e ${CC}`" 2>&1 | tee "configure.${logext}"
   else
      ${src}/configure ${configure_opts} 2>&1 | tee "configure.${logext}"
   fi && \
   \
   # Make
   make -j${np} 2>&1 | tee "make.${logext}" && \
   make -j${np} check 2>&1 | tee "make_check.${logext}" && \
   \
   # Install
   make DESTDIR=${abs_install_directory} install-strip 2>&1 | tee "make_install-strip.${logext}" && \
   libtool --finish ${abs_install_directory}/usr/local/lib64 2>&1 | tee "libtool.${logext}" && \
   \
   # Check install
   ${abs_install_directory}/usr/local/bin/gcc --version && \
   ${abs_install_directory}/usr/local/bin/g++ --version && \
   ${abs_install_directory}/usr/local/bin/gfortran --version && \
   \
   # Clean build directory
   make clean 2>&1 | tee "make_clean.${logext}" && \
   \
   # Check errors in the build process
   echo "Trying to detect errors in the build process:" && \
   grep -in "error:" `find . -type f -name "*.${logext}"` && \
   \
   # Show installed versions again for convenience
   echo "Installed versions:" && \
   ${abs_install_directory}/usr/local/bin/gcc --version && \
   ${abs_install_directory}/usr/local/bin/g++ --version && \
   ${abs_install_directory}/usr/local/bin/gfortran --version
}

default_install_directory="/opt/gcc"

if [ $# -lt 1 ]; then
   echo "Please give the GCC version in the form A.B.C, e.g., 13.2.0, and, optionally, the installation directory (default value: ${default_install_directory})."
   exit 0
fi

v="$1"

install_directory="${default_install_directory}"
if [ $# -eq 2 ]; then
   install_directory="$2"
fi

## Compiled with latest gcc version available

# 13.2.0

## Compiled with gcc 13.2.0

# 13.1.0
# 12.3.0
# 12.2.0
# 12.1.0
# 11.4.0
# 11.3.0
# 11.2.0
# 11.1.0
# 10.5.0
# 10.4.0
# 10.3.0
# 10.2.0
# 10.1.0
# 9.5.0
# 9.4.0
# 9.3.0
# 9.2.0
# 9.1.0
# 8.5.0
# 8.4.0
# 8.3.0
# 8.2.0
# 8.1.0
# 7.5.0
# 7.4.0
# 7.3.0
# 7.2.0
# 7.1.0
# 6.5.0
# 6.4.0
# 6.3.0
# 6.2.0
# 6.1.0

## Compiled with gcc 6.5.0

# 5.5.0
# 5.4.0
# 5.3.0
# 5.2.0
# 5.1.0
# 4.9.4
# 4.9.3
# 4.9.2
# 4.9.1
# 4.9.0
# 4.8.5
# 4.8.4
# 4.8.3
# 4.8.2
# 4.8.1
# 4.8.0

## Compiled with gcc 13.2.0

# 4.7.4
# 4.7.3
# 4.7.2
# 4.7.1
# 4.7.0
install "${v}" "${install_directory}"

