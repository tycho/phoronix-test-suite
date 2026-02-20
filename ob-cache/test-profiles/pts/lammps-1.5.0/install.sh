#!/bin/sh

rm -rf lammps-stable_22Jul2025_update2/
tar -xf lammps-stable_22Jul2025_update2.tar.gz
cd lammps-stable_22Jul2025_update2/
mkdir b
cd b
cmake ../cmake/ -DCMAKE_BUILD_TYPE=Release -DPKG_MOLECULE=1 -DPKG_KSPACE=1 -DPKG_RIGID=1 -DPKG_GRANULAR=1 -DPKG_MANYBODY=1 -DBUILD_OMP=OFF -DPKG_EXTRA-DUMP=ON
if [ "$OS_TYPE" = "BSD" ]
then
	gmake -j $NUM_CPU_CORES
else
	make -j $NUM_CPU_CORES
fi
echo $? > ~/install-exit-status

cd ~
tar -xf lammps-hecbiosim-1.tar.gz
mv lammps/20k-atoms/benchmark.data lammps-stable_22Jul2025_update2/bench/benchmark.data
mv lammps/20k-atoms/benchmark.in lammps-stable_22Jul2025_update2/bench/benchmark_20k_atoms.in
mv lammps/61k-atoms/benchmark.data lammps-stable_22Jul2025_update2/bench/benchmark61.data
mv lammps/61k-atoms/benchmark.in lammps-stable_22Jul2025_update2/bench/benchmark_61k_atoms.in
sed -i 's/read_data       benchmark.data/read_data       benchmark61.data/g' lammps-stable_22Jul2025_update2/bench/benchmark_61k_atoms.in
rm -rf lammps

cat>lammps<<EOT
#!/bin/sh
cd lammps-stable_22Jul2025_update2/bench/
mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ../b/lmp < \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x lammps

