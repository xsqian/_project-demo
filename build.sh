#!/bin/sh
python --version
pip --version
pip list | grep mlrun
echo "Using API key: $API_KEY"
mlrun project -n myproj -u "git://github.com/mlrun/project-demo.git" ./project
mlrun project -r main -w ./project