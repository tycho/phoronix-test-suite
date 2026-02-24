#!/bin/sh
unzip -o vkpeak-20250531-ubuntu.zip
cat>vkpeak<<EOT
#!/bin/sh
cd vkpeak-20250531-ubuntu
./vkpeak 0 > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x vkpeak
