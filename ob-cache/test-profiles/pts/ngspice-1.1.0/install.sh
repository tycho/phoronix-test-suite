#!/bin/sh
tar -xf ngspice-45.2.tar.gz
tar -xf iscas85Circuits-1.tar.xz
cd ngspice-45.2
./autogen.sh
./configure --enable-openmp
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
echo "#!/bin/sh
cd ngspice-45.2
./src/ngspice \$@ > \$LOG_FILE" > ngspice
chmod +x ngspice
