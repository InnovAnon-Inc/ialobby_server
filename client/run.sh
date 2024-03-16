#! /usr/bin/env bash
set -euxo nounset -o pipefail

docker build -t my-npm-app .
docker run -p 8080:8080 my-npm-app

