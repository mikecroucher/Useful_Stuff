#Test PGI Compilers
#Designed to be run on Iceberg
version=15.7

#Where am I?
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

printf "Version under test is $version\n"

printf "Getting examples from github\n"
git clone https://github.com/mikecroucher/HPC_Examples.git --quiet
printf "Loading module"
module load compilers/pgi/$version

printf "Displaying versions"
pgcc --version
pgc++ --version
pgf90 --version

printf "\nCompiling and running Hello Worlds\n"
cd $DIR/HPC_Examples/languages/C
pgcc 01-hello_world.c -o hello
./hello

cd $DIR/HPC_Examples/languages/Fortran
pgf90 01-hello_world.f90 -o hello
./hello

cd $DIR/HPC_Examples/languages/C++
pgc++ 01-hello_world.cpp -o hello
./hello
