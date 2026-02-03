#!/bin/sh
rm -rf minion-5c9f347c864bc2b64684b1df9d366294c21aac49
unzip -o minion-5c9f347c864bc2b64684b1df9d366294c21aac49.zip
cd minion-5c9f347c864bc2b64684b1df9d366294c21aac49
mkdir bin
cd bin
python3 ../configure.py
make -j $NUM_CPU_JOBS
echo $? > ~/install-exit-status
cd ~/
echo "#!/bin/sh
cd minion-5c9f347c864bc2b64684b1df9d366294c21aac49
./bin/minion \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > minion
chmod +x minion
