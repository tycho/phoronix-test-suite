#!/bin/sh
cd bin
./ollama serve &
OLLAMA_PID=$!
sleep 2

./ollama pull $1

kill -9 $OLLAMA_PID
sleep 1
