#!/bin/sh
steam steam://install/730
unzip -o cs2-pts2.zip
mv pts2.dem "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo"
echo "#!/bin/sh
cd \"C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\"
rm -f ../../csgo/Source2BenchV2.csv
./cs2.exe -game csgo \$@ +con_logfile log.log
cat  ../../csgo/Source2BenchV2.csv >> \$LOG_FILE" > cs2
chmod +x cs2
