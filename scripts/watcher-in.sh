#!/bin/bash

[[ -n ${DEBUG} ]] && set -eox

NUMBERS_IN_LOCATION=/mnt/cobol/in
PROCESSDIRECTORY=/mnt/cobol/
FILENAME=${S3FILENAME:-"numbers.txt"}
URL=${S3URL:-"https://s3.sjc04.cloud-object-storage.appdomain.cloud/asgharlabs-in"}

while true; do
  test $? -gt 128 && break
  if test -f "${NUMBERS_IN_LOCATION}/numbers.txt"; then
    mv ${NUMBERS_IN_LOCATION}/numbers.txt ${PROCESSDIRECTORY}/
    echo -e "#"
    echo -e "#"
    echo -e "Moved the ${FILENAME} to the processing directory..."
    echo -e "#"
    echo -e "#"
    sleep 90
  else
    echo -e "Waiting on ${URL} to have the ${FILENAME} move it..."
    # todo switch to use s3 get binary
    wget -O ${NUMBERS_IN_LOCATION}/numbers.txt ${URL}/${FILENAME}
  fi
  sleep 5
done
