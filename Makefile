all:

update-ob-cache:
	env PTS_USER_PATH_OVERRIDE="$(PWD)/ob-cache/" ./phoronix-test-suite make-openbenchmarking-cache
