#!/bin/sh
tar -xf oidn-2.4.0.arm64.macos.tar.gz
echo "#!/bin/sh
cd oidn-2.4.0.arm64.macos/bin/
./oidnBenchmark \$@ --threads \$NUM_CPU_CORES  > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > oidn
chmod +x oidn
