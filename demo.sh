#!/bin/bash

if [ -d "./.venv" ]; then
    make kill
else
    make venv
    make model
fi

echo "Booting up..."
ALFRED_LANGUAGE="ru" ALFRED_SOURCE_FILE="$(pwd)/samples/Pod.wav" make load
sleep 10 # wait for server to bootup
make run
echo "Generating... (takes about 10 seconds)"
