# Build old GCC versions

**This project provides scripts and patches to build old versions of GCC.**

Currently enables building GCC from version 14.2.0 back to version **4.7.0**. Works at least on Lubuntu 22.04.5 LTS x86_64.

Install the prerequisites:
```
sudo ./install_apt_prerequisites.sh
```

Run the installation script:
```
./install_gcc.sh 14.2.0 [/opt/gcc]
```

The script will download GCC from the [official GNU repository](https://ftp.gnu.org/gnu/gcc/) and apply some patches depending on the GCC version. Then it will build GCC in `./gcc-A.B.C_build` and install it in the installation directory (by default, `/opt/gcc/gcc-A.B.C_install`).

To use versions older than 4.7.2, you will probably need to add the following lines to your `~/.bash_aliases` file or equivalent:
```
### For GCC 4.7.2 and older versions ###
# 64-bit
CPATH=/usr/include/x86_64-linux-gnu:${CPATH}
LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:${LIBRARY_PATH}

# 32-bit (not tested)
#LIBRARY_PATH=/usr/lib32:${LIBRARY_PATH}

export CPATH
export LIBRARY_PATH
``` 
