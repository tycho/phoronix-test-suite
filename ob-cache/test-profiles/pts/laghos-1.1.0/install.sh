#!/bin/bash
tar -xf hypre-2.33.0.tar.gz
rm -rf hypre
mv hypre-2.33.0 hypre
cd hypre/src/
./configure --disable-fortran --enable-bigint
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
unzip -o Laghos-a6bd5cad0c589a1dcd1135737e429e6098e4a94f.zip
cd Laghos-a6bd5cad0c589a1dcd1135737e429e6098e4a94f
make
echo $? > ~/install-exit-status
cd ~
cat>laghos<<EOT
#!/bin/sh
cd Laghos-a6bd5cad0c589a1dcd1135737e429e6098e4a94f
mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ./laghos \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x laghos

