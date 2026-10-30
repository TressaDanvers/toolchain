#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"
build-script-arg "$@"

export PREFIX=${PREFIX:-/usr/local}

case "${1:-}" in
  "")
    sh ./emit/build.sh
    ;;
  deploy)
    sh ./emit/build.sh deploy
    ;;
  check)
    sh ./emit/build.sh check
    ;;
  clean)
    sh ./emit/build.sh clean
    ;;
esac
