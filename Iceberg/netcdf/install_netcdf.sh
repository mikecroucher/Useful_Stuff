module load compilers/gcc/5.2
module load mpi/gcc/openmpi/1.10.1

install_dir=$(pwd)/support_libs
export LD_LIBRARY_PATH=$install_dir/lib:$LD_LIBRARY_PATH

#Delete old build and install dirs
#rm -rf $build_dir
rm -rf $install_dir

#mkdir -p $build_dir
mkdir -p $install_dir

#cd $build_dir

#HDF5 Download
############################################################################
hdf_version=1.8.16
hdf_build_dir=$(pwd)/temp_hdf5_build
#Create a clean build dir
rm -rf $hdf_build_dir
mkdir -p $hdf_build_dir
cd $hdf_build_dir

filename=hdf5-$hdf_version.tar.gz
baseurl=http://www.hdfgroup.org/ftp/HDF5/current/src

# Download the source
if [ -e $filename ]                                               
then                                                                            
  echo "Install tarball exists. Download not required."                         
else                                                                            
  echo "Downloading source" 
  wget $baseurl/$filename
fi

##############################################################################
## SZIP
wget http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz
tar -xvf szip-2.1.tar.gz
cd szip-2.1
./configure --prefix=$install_dir
make
make install
cd ..

##############################################################################
#ZLIB
wget http://zlib.net/zlib-1.2.8.tar.gz
tar -xvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=$install_dir
make 
make install
cd ..

##############################################################################
#HDF5 build
tar -xvf $filename
cd hdf5-$hdf_version
echo config
CC=mpicc ./configure --prefix=$install_dir  --enable-shared --enable-parallel --with-zlib=$install_dir --with-szlib=$install_dir
make
make install
cd ..


##############################################################################
#NetCDF
wget https://github.com/Unidata/netcdf-c/archive/v4.4.0.tar.gz
tar -xvzf ./v4.4.0.tar.gz
cd netcdf-c-4.4.0
CPPFLAGS=-I$install_dir/include LDFLAGS=-L$install_dir/lib CC=mpicc ./configure --prefix=$install_dir
make 
make install
cd ..

###############################################################################
#NetCDF Fortran
wget https://github.com/Unidata/netcdf-fortran/archive/v4.4.3.tar.gz
tar -xzf v4.4.3.tar.gz
cd netcdf-fortran-4.4.3
./configure --prefix=$install_dir --enable-shared --enable-static
make
make install

