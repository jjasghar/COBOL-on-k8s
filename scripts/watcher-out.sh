#!/bin/bash

[[ -n ${DEBUG} ]] && set -eox

NUMBERS_OUT_LOCATION=/mnt/cobol/out
FILENAME=newNumbers.txt

while true; do
  test $? -gt 128 && break
  if test -f "${NUMBERS_OUT_LOCATION}/${FILENAME}"; then
    echo -e "#"
    echo -e "#"
    echo -e "These are the new numbers, you can ship this wherever you need..."
    echo -e "#"
    echo -e "#"
    cat ${NUMBERS_OUT_LOCATION}/${FILENAME}
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "#"
    sleep 90
  else
    echo -e "Waiting on ${FILENAME} to appear..."
  fi
  sleep 5
done
