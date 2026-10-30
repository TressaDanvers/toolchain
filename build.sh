#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"
build-script-arg "$@"

export PREFIX="${PREFIX:-/usr/local}"

case "${1:-}" in
  "")
    sh ./emit/build.sh hex
    sh ./asm-core/build.sh
    sh ./emit/build.sh
    ;;
  deploy)
    sh ./emit/build.sh deploy
    sh ./asm-core/build.sh deploy
    ;;
  check)
    check-sh ./build.sh
    sh ./emit/build.sh check
    sh ./asm-core/build.sh check
    ;;
  clean)
    sh ./emit/build.sh clean
    sh ./asm-core/build.sh clean
    ;;
esac
