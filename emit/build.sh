#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"
build-script-arg "$@"

PREFIX=${PREFIX:-/usr/local}

command -v shasum >/dev/null || err-fatal tool "shasum not found"

emit_a() {
  hex=$(LC_ALL=C tr -cd '0-9A-Fa-f')
  [ $((${#hex} % 2)) -eq 0 ] || hex="$hex"0
  while [ -n "$hex" ]; do
    printf %b "\\0$(printf %03o "0x${hex%"${hex#??}"}")"
    hex=${hex#??}
  done
}

emit_b() {
  hex=$(LC_ALL=C tr -cd '0-9A-Fa-f')
  [ $((${#hex} % 2)) -eq 0 ] || hex="$hex"0
  printf %s "$hex" | LC_ALL=C awk -v h=0123456789abcdef '{
    $0 = tolower($0)
    for (i = 1; i <= length; i += 2)
      printf "%c", 16 * index(h, substr($0, i, 1)) + index(h, substr($0, i + 1, 1)) - 17
  }'
}

checksum() {
  s=$(shasum -a 256 < "$2")
  [ "${s%% *}" = "$1" ]
}

SRC_SHA=90e2e861488177944f9b5492d311eed944a91a0c53109fd776d45265e51a324c
BIN_SHA=6e59c483efe2b3635404db391ed291c7c6da88ccf146afc902475cc3a175e022

case "${1:-}" in
  "")
    mkdir -p ./build/stages || err-fatal build directories
    info build ./build/stages/emit-stage-1-a
    emit_a < ./src/emit.hex > ./build/stages/emit-stage-1-a || err-fatal build stage 1-a
    chmod +x ./build/stages/emit-stage-1-a || err-fatal build stage 1-a
    info build ./build/stages/emit-stage-2-a
    ./build/stages/emit-stage-1-a < ./src/emit.hex > ./build/stages/emit-stage-2-a || err-fatal build stage 2-a
    chmod +x ./build/stages/emit-stage-2-a || err-fatal build stage 2-a
    info build ./build/stages/emit-stage-1-b
    emit_b < ./src/emit.hex > ./build/stages/emit-stage-1-b || err-fatal build stage 1-b
    chmod +x ./build/stages/emit-stage-1-b || err-fatal build stage 1-b
    info build ./build/stages/emit-stage-2-b
    ./build/stages/emit-stage-1-b < ./src/emit.hex > ./build/stages/emit-stage-2-b || err-fatal build stage 2-b
    chmod +x ./build/stages/emit-stage-2-b || err-fatal build stage 2-b
    pass build
    ;;
  deploy)
    [ -f ./build/stages/emit-stage-2-a ] || err-fatal deploy project is not built
    mkdir -p "$PREFIX/bin" || err-fatal deploy "$PREFIX/bin"
    info deploy emit
    cp ./build/stages/emit-stage-2-a "$PREFIX/bin/emit" || err-fatal deploy "$PREFIX/bin/emit"
    ;;
  check)
    [ -f ./build/stages/emit-stage-2-a ] || err-fatal check project is not built
    check-sh ./build.sh
    info check sha256 ./src/emit.hex
    checksum $SRC_SHA ./src/emit.hex || err-fatal check checksum
    info check sha256 ./build/stages/emit-stage-2-a
    checksum $BIN_SHA ./build/stages/emit-stage-2-a || err-fatal check checksum
    info check emit-stage-2-a == emit-stage-2-b
    cmp -s ./build/stages/emit-stage-2-a ./build/stages/emit-stage-2-b || err-fatal check emit-stage-2-a != emit-stage-2-b
    pass check
    ;;
  clean)
    info clean ./build
    rm -rf ./build || err-fatal clean ./build
    ;;
esac
