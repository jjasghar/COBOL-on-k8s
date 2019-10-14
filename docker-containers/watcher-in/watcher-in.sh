#!/bin/bash

NUMBERS_IN_LOCATION=/mnt/cobol/in
PROCESSDIRECTORY=/mnt/cobol/
FILENAME=numbers.txt
URL=https://s3.sjc04.cloud-object-storage.appdomain.cloud/asgharlabs-in

while true; do
  if test -f "${NUMBERS_IN_LOCATION}/${FILENAME}"; then
    cd ${NUMBERS_IN_LOCATION}
    mv ${FILENAME} ${PROCESSDIRECTORY}
    echo -e "#"
    echo -e "#"
    echo -e "Moved the ${FILENAME} to the processing directory..."
    echo -e "#"
    echo -e "#"
    sleep 90
  else
    echo -e "Waiting on ${URL} to have the ${FILENAME} move it..."
    cd ${NUMBERS_IN_LOCATION}
    wget ${URL}/${FILENAME}
  fi
  sleep 5
done
