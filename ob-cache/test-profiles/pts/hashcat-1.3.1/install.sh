#!/bin/sh
7z x hashcat-7.1.2.7z -aoa
echo $? > ~/install-exit-status
echo "#!/bin/sh
cd hashcat-7.1.2
./hashcat.bin -b --benchmark-min=30 \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status

sed -i 's/ H\/s / singleH\/s /g' \$LOG_FILE" > hashcat
chmod +x hashcat
