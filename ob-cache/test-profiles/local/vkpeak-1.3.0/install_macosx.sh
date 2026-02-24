#!/bin/sh
VERSION=20260112
unzip -o vkpeak-${VERSION}-macos.zip
cat>vkpeak<<EOT
#!/bin/sh
cd vkpeak-${VERSION}-macos
./vkpeak 0 > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status
EOT
chmod +x vkpeak
