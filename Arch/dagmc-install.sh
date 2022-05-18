################################################################################
#dagmc source install
################################################################################
#!/bin/bash
set -ex

#double-down compile & install
./double_down-install.sh
echo "Compiled & installed double-down, proceeding..."

WD=`pwd`
name=`basename $0`
package_name='dagmc'

install_prefix="/usr/local"
if [ "x" != "x$LOCAL_INSTALL_PREFIX" ]; then
  install_prefix=$LOCAL_INSTALL_PREFIX
fi
build_prefix="$HOME/openmc"

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  pacman -Qi python > /dev/null
  if [[ $? != 0 ]]; then
     sudo pacman -Sy python
  fi

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p $HOME/openmc/DAGMC
  cd $HOME/openmc/DAGMC
  if [ ! -e DAGMC ]; then
    git clone --single-branch --branch develop --depth 1 https://github.com/svalinn/DAGMC.git
  fi

  mkdir -p build
  cd build
  cmake ../DAGMC -DBUILD_TALLY=ON \
               -DMOAB_DIR=${install_prefix}\
               -DDOUBLE_DOWN=ON\
               -DBUILD_STATIC_EXE=OFF\
               -DBUILD_STATIC_LIBS=OFF\
               -DCMAKE_BUILD_TYPE=Debug\
               -DCMAKE_INSTALL_PREFIX=${install_prefix}\
               -DDOUBLE_DOWN_DIR=${install_prefix}\
               -DCMAKE_BUILD_TYPE=Debug
  make -j $ccores
  make install

  cd ${WD}
  touch ${name}.done
else
  echo DAGMC appears already to be installed \(lock file ${name}.done exists\) - skipping.
fi
