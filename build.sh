#!/bin/sh
python --version
pip --version
pip list | grep mlrun
echo "Using API key: $API_KEY"