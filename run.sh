#! /usr/bin/env bash
set -euxo nounset -o pipefail

docker build -t my-flask-app .
docker run -p 5000:5000 my-flask-app
