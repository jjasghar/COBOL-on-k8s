#!/bin/bash

NUMBERS_PROCESS_LOCATION=/mnt/cobol/
NUMBERS_OUT_LOCATION=/mnt/cobol/out
FILENAME=numbers.txt
OUTPUTFILENAME=newNumbers.txt
APP=plus5numbers-exe

while true; do
  if test -f "${NUMBERS_PROCESS_LOCATION}/${FILENAME}"; then
    cp /src/cobol/${APP} /mnt/cobol/
    cd /mnt/cobol
    touch newNumbers.txt && ./${APP}
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "Processed the ${FILENAME} with the above numbers written to ${OUTPUTFILENAME}..."
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "#"
    echo -e "#"
    mv /mnt/cobol/${OUTPUTFILENAME} ${NUMBERS_OUT_LOCATION}/${OUTPUTFILENAME}
    sleep 90
  else
    echo -e "Waiting on the ${FILENAME} to be there to process it..."
  fi
  sleep 5
done
