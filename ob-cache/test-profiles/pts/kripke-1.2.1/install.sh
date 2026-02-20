#!/bin/sh
tar -xf kripke-v1.2.6-1-g0d24be5.tar.gz
cd kripke-v1.2.6-1-g0d24be5
sed -i '1s/^/#include <cstdint>\n/' tpl/googletest/googletest/src/gtest-death-test.cc
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_MPI=TRUE -DENABLE_OPENMP=TRUE -DBUILD_GMOCK=OFF -DINSTALL_GTEST=OFF -DCMAKE_CXX_FLAGS="-O3 -Wno-template-body" ..
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
echo "#!/bin/sh
cd kripke-v1.2.6-1-g0d24be5/build/
OMP_NUM_THREADS=\$CPU_THREADS_PER_CORE mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ./bin/kripke.exe --procs 1,1,\$NUM_CPU_PHYSICAL_CORES \$@ > \$LOG_FILE
echo \$? > ~/test-exit-status
" > kripke
chmod +x kripke
