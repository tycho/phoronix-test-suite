#!/bin/sh
tar -xf hmmer-3.4.tar.gz
cd hmmer-3.4
./configure --enable-mpi
if [ $OS_TYPE = "BSD" ]
then
	gmake -j $NUM_CPU_CORES
else
	make -j $NUM_CPU_CORES
fi
echo $? > ~/install-exit-status
cd ~
gunzip Pfam_ls.gz -c > hmmer-3.4/tutorial/Pfam_ls

cat>hmmer<<EOT
#!/bin/sh
cd hmmer-3.4/tutorial
OMP_NUM_THREADS=1 mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ../src/hmmsearch Pfam_ls 7LESS_DROME > /dev/null 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x hmmer
