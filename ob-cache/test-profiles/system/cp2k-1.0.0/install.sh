#!/bin/bash
if which cp2k.psmp>/dev/null 2>&1 ;
then
	echo 0 > ~/install-exit-status
else
	echo "ERROR: cp2k.psmp is not found on the system! This test profile needs a working cp2k installation in the PATH"
	echo 2 > ~/install-exit-status
	exit 2
fi
if which mpirun>/dev/null 2>&1 ;
then
	echo 0 > ~/install-exit-status
else
	echo "ERROR: mpirun is not found in the system PATH"
	echo 2 > ~/install-exit-status
	exit 2
fi

tar -xjf cp2k-2026.1.tar.bz2
cd ~
echo "#!/bin/bash
cd cp2k-2026.1
OMP_NUM_THREADS=1 mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES cp2k.psmp \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
cp2k.psmp --version | grep \"CP2K version\" > ~/pts-footnote 2>&1 " > cp2k
chmod +x cp2k
