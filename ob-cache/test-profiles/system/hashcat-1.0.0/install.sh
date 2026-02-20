#!/bin/sh
if which hashcat>/dev/null 2>&1 ;
then
	echo 0 > ~/install-exit-status
else
	echo "ERROR: Hashcat is not found on the system! This test profile needs a working hashcat binary in the PATH"
	echo 2 > ~/install-exit-status
fi
echo $? > ~/install-exit-status
echo "#!/bin/sh
hashcat -b \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
hashcat --version | head -n 1 | awk '{ print \$NF }' > ~/pts-test-version 2>/dev/null" > hashcat
chmod +x hashcat
