#!/bin/sh
rm -rf cockroach-build
if [ $OS_ARCH = "aarch64" ]
then
	tar -xvf cockroach-v25.3.6.linux-arm64.tgz
	mv cockroach-v25.3.6.linux-arm64 cockroach-build
else
	tar -xf cockroach-v25.3.6.linux-amd64.tgz
	mv cockroach-v25.3.6.linux-amd64 cockroach-build
fi
echo "#!/bin/sh
cd cockroach-build
./cockroach start-single-node --cache .25 --insecure > \$LOG_FILE 2>&1 &
COCKROACH_PID=\$!
sleep 5

# Run test
./cockroach workload run \$@ >> \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status

kill \$COCKROACH_PID
sleep 1
rm -rf cockroach-data/" > cockroach
chmod +x cockroach
