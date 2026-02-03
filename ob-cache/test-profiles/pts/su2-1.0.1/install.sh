#!/bin/bash
rm -rf SU2-8.3.0
tar -xf SU2-8.3.0.tar.gz
cd SU2-8.3.0
sed -i '1s/^/#include <cstdint>\n/' externals/CLI11/CLI11.hpp
./meson.py setup build -Denable-openblas=true
./ninja -C build
echo $? > ~/install-exit-status
cd ~

unzip -o VandV-22a332493b996666039ceef537bbd520399eb427.zip
rm -rf VandV
mv VandV-22a332493b996666039ceef537bbd520399eb427 VandV

cat>su2<<EOT
#!/bin/bash
cd \$1
mpirun --allow-run-as-root -np \$NUM_CPU_PHYSICAL_CORES ~/SU2-8.3.0/build/SU2_CFD/src/SU2_CFD \$2 > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x su2
