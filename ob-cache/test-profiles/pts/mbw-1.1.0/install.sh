#!/bin/sh
tar -xf mbw-2.0.tar.gz
cd mbw-2.0
export CFLAGS="-O3 -march=native $CFLAGS"
cc $CFLAGS -o mbw mbw.c
echo $? > ~/install-exit-status
cd ~
echo "#!/bin/sh
cd mbw-2.0
./mbw \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > mbw
chmod +x mbw

