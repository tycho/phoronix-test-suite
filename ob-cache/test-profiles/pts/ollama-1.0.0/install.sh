#!/bin/sh
if [ $OS_ARCH = "aarch64" ]
then
	tar -xf ollama-0.13.5-linux-arm64.tgz
else
	tar -xf ollama-0.13.5-linux-amd64.tgz
fi

echo $? > ~/install-exit-status

echo "#!/bin/sh
cd bin
export NO_COLOR=1
./ollama serve > llama-serve.log 2>&1 &
OLLAMA_PID=\$!
sleep 3
rm -f llama-benchmark.log

echo \"Tell me about Linux?\" | ./ollama run \$1 --verbose >> llama-benchmark.log 2>&1
echo \"Tell me interesting facts about Oktoberfest?\" | ./ollama run \$1 --verbose >> llama-benchmark.log 2>&1
echo \"What is the capital of Germany? What is its population?\" | ./ollama run \$1 --verbose >> llama-benchmark.log 2>&1
echo \"Write a short story about a knight. Now, describe the castle he lives in.\" | ./ollama run \$1 --verbose >> llama-benchmark.log 2>&1
echo \"How many times does the digit 9 appear in page numbers 1 to 200?\" | ./ollama run \$1 --verbose >> llama-benchmark.log 2>&1
echo \$? > ~/test-exit-status

cat llama-benchmark.log | grep -v \"prompt eval\" | grep \"eval rate\" > \$LOG_FILE

kill -9 \$OLLAMA_PID
sleep 1" > ollama
chmod +x ollama
