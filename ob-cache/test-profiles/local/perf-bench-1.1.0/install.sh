#!/bin/sh
KVER=6.18.12
tar -xf linux-${KVER}.tar.xz
pushd "linux-${KVER}/tools/perf"
NO_LIBTRACEEVENT=1 make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cp perf ../../../
popd
rm -rf linux-${KVER}
echo "#!/bin/sh
./perf bench \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > perf-bench
chmod +x perf-bench
