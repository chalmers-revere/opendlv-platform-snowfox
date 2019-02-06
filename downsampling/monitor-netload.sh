#!/bin/bash

RUNNING=1
trap 'cleanup' TERM

cleanup() {
    echo "Cleaning up..."
    RUNNING=0
}

FILENAME=$(date +%F_%R%S)-netload.csv
FILENAME=$(echo ${FILENAME} | sed -e 's/\://g')
:> ${FILENAME}

while [ "$RUNNING" == "1" ]; do
    netload=$(bmon -p $@ -o 'format:fmt=$(element:name)%RX:%$(attr:rxrate:bytes)%TX:%$(attr:txrate:bytes)\n;quitafter=2')
    ts=$(date +%s%N)
    echo "${netload}" | sed -e "s/enp/${ts};enp/" | sed -e "s/%/\;/g" | grep -v "RX:;0.00;TX:;0.00" | tee -a ${FILENAME}

    sleep 1
done

for i in $@ ; do
    MATCH="/.*;$i;.*/!d"
    cat ${FILENAME} | sed -e ${MATCH} > ${FILENAME}-${i}
    PROGRAM=$(cat ${FILENAME}-${i} |head -1|cut -f4 -d";")
    TITLE=$(echo ${FILENAME} | sed -e 's/_/-/')
cat <<EOF >netload.gnuplot
#set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400 
set terminal pdf
set output '${FILENAME}-${i}.pdf'
set style increment default
set title "${TITLE}/$i"
set title  font ",20" norotate
set xrange [ * : * ] noreverse writeback
set yrange [ 0 : * ] noreverse writeback
set datafile separator ";"
show style line
plot '${FILENAME}-${i}' using 0:4 with line lt 1 lc 3 title 'RX', \
     '${FILENAME}-${i}' using 0:6 with line lt 1 lc 4 title 'TX'
EOF
cat netload.gnuplot | gnuplot
rm -f ${FILENAME}-${i}
done

rm -f netload.gnuplot

