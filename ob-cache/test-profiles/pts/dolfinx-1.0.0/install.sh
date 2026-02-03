#!/bin/bash
tar -xf dolfinx-0.10.0.post5.tar.gz
cd dolfinx-0.10.0.post5/cpp
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/dolfinx_ ..
make -j $NUM_CPU_CORES
make install

cd ~
unzip -o performance-test-1331728e17b5585976121be5676af18255e38a7e.zip
cd performance-test-1331728e17b5585976121be5676af18255e38a7e/src
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/dolfinx_ .
make
echo $? > ~/install-exit-status
cd ~

cat>dolfinx<<EOT
#!/bin/bash
cd performance-test-1331728e17b5585976121be5676af18255e38a7e/src
mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ./dolfinx-scaling-test --output false \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x dolfinx
