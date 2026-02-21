#!/bin/sh
tar -xzf fio-fio-3.40.tar.gz
cd fio-fio-3.40
./configure --extra-cflags="-O3 -fcommon"
if [ "$OS_TYPE" = "BSD" ]
then
	gmake -j $NUM_CPU_CORES
else
	make -j $NUM_CPU_CORES
fi
echo $? > ~/install-exit-status
cd ~

cat > fio-run <<"EOF"
#!/bin/sh
cd fio-fio-3.40

FIO_RW=$1
FIO_IO_ENGINE=$2
FIO_DIRECT=$3
FIO_QDEPTH=$4
FIO_NUM_JOBS=1

# 128k sequential, 4k random
case $FIO_RW in
rand*)
	FIO_BS=4k
	;;
*)
	FIO_BS=128k
	;;
esac

if [ "${FIO_IO_ENGINE}" = "sync" ]; then
	FIO_NUM_JOBS=${FIO_QDEPTH}
	FIO_QDEPTH=1
fi

DIRECTORY_TO_TEST="fiofile"

cat > test.fio <<-FIO_EOF
[global]
# Timing configuration
clocksource=clock_gettime
startdelay=1
ramp_time=1
runtime=5
group_reporting=1
time_based

# I/O configuration
rw=${FIO_RW}
ioengine=${FIO_IO_ENGINE}
iodepth=${FIO_QDEPTH}
numjobs=${FIO_NUM_JOBS}
size=1g
direct=${FIO_DIRECT}
filename=${DIRECTORY_TO_TEST}

# Increase numeric precision of IOPS or BW
significant_figures=10

# Disable latency measurement
lat_percentiles=0
clat_percentiles=0
slat_percentiles=0
disable_lat=1
disable_clat=1
disable_slat=1

[test]
name=test
bs=${FIO_BS}
stonewall
FIO_EOF

./fio test.fio 2>&1 > "${LOG_FILE}"
echo $? > ~/test-exit-status
EOF

chmod +x fio-run
