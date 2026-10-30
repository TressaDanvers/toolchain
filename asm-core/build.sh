#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"
build-script-arg "$@"

emit() { ../emit/build/stages/emit-stage-2-a; }

case "${1:-}" in
  "")
    [ -f ../emit/build/stages/emit-stage-2-a ] || err-fatal tool "emit stage 2 not found, build before continuing"
    mkdir -p ./build/stages || err-fatal build ./build/stages
    info build ./build/stages/asm-core-stage-1
    emit < ./src/asm-core.hex > ./build/stages/asm-core-stage-1 || err-fatal build ./build/stages/asm-core-stage-1
    chmod +x ./build/stages/asm-core-stage-1 || err-fatal build ./build/stages/asm-core-stage-1
    pass build asm-core
    ;;
  deploy)
    err-fatal deploy n/a
    ;;
  check)
    check-sh ./build.sh
    [ -f ../emit/build/stages/emit-stage-2-a ] || err-fatal tool "emit stage 2 not found, build before continuing"
    [ -f ./build/stages/asm-core-stage-1 ] || err-fatal check project is not built
    check-sh ./tests/stage-1.sh
    info check stage 1 byte tests
    sh ./tests/stage-1.sh || err-fatal check ./tests/stage-1.sh
    mkdir -p ./build/tests || err-fatal check ./build/tests
    info build ./build/tests/stage-1-tests
    ./build/stages/asm-core-stage-1 < ./tests/stage-1.asm | emit > ./build/tests/stage-1-tests || err-fatal build ./build/tests/stage-1-tests
    chmod +x ./build/tests/stage-1-tests || err-fatal build ./build/tests/stage-1-tests
    info check stage 1 runtime tests
    ./build/tests/stage-1-tests || err-fatal check stage 1 runtime tests $?
    pass check asm-core
    ;;
  clean)
    info clean asm-core
    rm -rf ./build || err-fatal clean ./build
    ;;
esac
