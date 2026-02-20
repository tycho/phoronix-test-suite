#!/bin/bash
rm -rf linux-6.15
tar -xf linux-6.15.tar.xz
cd linux-6.15
if [ -z "$@" ]
then
	# This is for old PTS clients not passing anything per older old test profile configs that may be in suite...
	export LINUX_MAKE_CONFIG="defconfig"
else
	export LINUX_MAKE_CONFIG="$1"
fi
echo "make $LINUX_MAKE_CONFIG"
make "$LINUX_MAKE_CONFIG"
make clean
echo "CONFIG_DRM_WERROR=n" >> .config
scripts/config --set-val CONFIG_WERROR n
