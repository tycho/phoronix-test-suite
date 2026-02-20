#!/bin/bash
tar -xf hypre-2.28.0.tar.gz
rm -rf hypre
mv hypre-2.28.0 hypre
cd hypre/src/
./configure --disable-fortran --enable-bigint --with-extra-CFLAGS="-std=c17 -Wno-implicit-function-declaration  -Wno-implicit-int"
make -j $NUM_CPU_CORES
cd ~
tar -xf metis-4.0.3.tar.gz
mv metis-4.0.3 metis-4.0
cd metis-4.0
sed -i 's/COPTIONS = /COPTIONS = -Wno-implicit-function-declaration  -Wno-implicit-int/g' Makefile.in
make
cd ~
tar -xf mfem-4.7.tar.gz
rm -rf mfem
mv mfem-4.7 mfem
cd mfem
make parallel -j
cd ~
unzip -o Remhos-c9c5e05736645ab72e88037df5428390a0ad5348.zip
cd Remhos-c9c5e05736645ab72e88037df5428390a0ad5348
sed -i '1s/^/#include <cstdint>\n/' tpl/googletest/googletest/src/gtest-death-test.cc
sed -i 's/OPTIM_OPTS = -O3/COPTIM_OPTS = -O3 std=c++11/g' makefile
make
echo $? > ~/install-exit-status
cd ~
cat>remhos<<EOT
#!/bin/sh
cd Remhos-c9c5e05736645ab72e88037df5428390a0ad5348
mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ./remhos \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x remhos
