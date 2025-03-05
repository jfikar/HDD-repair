#!/bin/sh
DISK=/dev/sdd
START=6465970816
 STOP=6465972816

ERR=0
START=$(($START / 8))
START=$(($START * 8))
TMP_FILE=$(mktemp)
for i in $(seq $START 8 $STOP)
do
        echo -n ${i} ": "
        echo /dev/null > ${TMP_FILE}
        sudo hdparm --read-sector ${i} ${DISK} > /dev/null 2>${TMP_FILE}
        if [ -s  ${TMP_FILE} ]; then
                echo -n "ERROR"
                echo -n "."
                sudo hdparm --yes-i-know-what-i-am-doing --write-sector ${i} ${DISK} > /dev/null 2> /dev/null
                k=$((${i} + 1))
                l=$((${i} + 7))
                for j in $(seq ${k} 1 ${l})
                do
                        echo -n "."
                        echo /dev/null > ${TMP_FILE}
                        sudo hdparm --read-sector ${j} ${DISK} > /dev/null 2>${TMP_FILE}
                        if [ -s  ${TMP_FILE} ]; then
                                sudo hdparm --yes-i-know-what-i-am-doing --write-sector ${j} ${DISK} > /dev/null 2> /dev/null
                        fi
                done
                echo " "
                ERR=$(($ERR + 1))
        else
                echo "OK"
        fi
done
rm ${TMP_FILE}
echo "TOTAL ERRORS " ${ERR}
