#!/bin/sh
HOME=$DEBUG_REAL_HOME steam steam://install/730
unzip -o cs2-pts2.zip
mv pts2.dem $DEBUG_REAL_HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/game/csgo
echo "#!/bin/bash
cd \$DEBUG_REAL_HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/game/csgo
echo \"\" > Source2BenchV2.csv
HOME=\$DEBUG_REAL_HOME steam -applaunch 730 \$@
sleep 15
tail -f  Source2BenchV2.csv | sed '/pts2/ q'
sleep 1
cat Source2BenchV2.csv >> \$LOG_FILE" > cs2
chmod +x cs2
