#!/bin/bash
tar -xf llama.cpp-b4397.tar.gz
rm -rf llama.cpp-BLAS
cp -va llama.cpp-b4397 llama.cpp-BLAS
cd llama.cpp-BLAS
cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
cmake --build build --config Release -j $NUM_CPU_CORES
echo $? > ~/install-exit-status

rm -rf llama.cpp-b4397
echo "#!/bin/sh
LLAMA_BENCH_ARGS=\`echo \"\$@\" | sed \"s/\$1/ /g\"\`
cd llama.cpp-\$1
./build/bin/llama-bench -t \$NUM_CPU_PHYSICAL_CORES \$LLAMA_BENCH_ARGS > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > ~/llama-cpp
chmod +x ~/llama-cpp
