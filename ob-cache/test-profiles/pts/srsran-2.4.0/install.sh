#!/bin/sh
tar -xf srsRAN_Project-release_24_10.tar.gz
cd srsRAN_Project-release_24_10
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -Wno-error" -DENABLE_WERROR=OFF ..
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
echo "#!/bin/sh
cd srsRAN_Project-release_24_10/build/
./\$@ 2>&1 > \$LOG_FILE
echo \$? > ~/test-exit-status" > srsran
chmod +x srsran
