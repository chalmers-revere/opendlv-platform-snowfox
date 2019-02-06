#!/bin/bash

RUNNING=1
trap 'cleanup' TERM

cleanup() {
    echo "Cleaning up..."
    RUNNING=0
}

FILENAME=$(date +%F_%R%S)-sysload.csv
FILENAME=$(echo ${FILENAME} | sed -e 's/\://g')
:> ${FILENAME}

while [ "$RUNNING" == "1" ]; do
    for i in $@ ; do
        ts=$(date +%s%N)
        sysload=$(ps -eo psr,pcpu,command | tr -s " " " " | grep "^ [$i]" | grep -v "\]" 2>&1 | sed -e "s/\ /\;/" | sed -e "s/\ /\;/" | sed -e "s/\ /\;/" | head -1)
        echo "${sysload}" | sed -e "s/^;/${ts}\;/" | tee -a ${FILENAME}
    done

    sleep 1;
done

for i in $@ ; do
    MATCH="/.*;$i;.*/!d"
    cat ${FILENAME} | sed -e ${MATCH} > ${FILENAME}.core-${i}
    PROGRAM=$(cat ${FILENAME}.core-${i} |head -1|cut -f4 -d";")
    TITLE=$(echo ${FILENAME} | sed -e 's/_/-/')
cat <<EOF >sysload.gnuplot
#set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400 
set terminal pdf
set output '${FILENAME}.core-${i}.pdf'
set style increment default
set title "${TITLE}/core $i"
set title  font ",20" norotate
set xrange [ * : * ] noreverse writeback
set yrange [ 0 : 100 ] noreverse writeback
set datafile separator ";"
show style line
plot '${FILENAME}.core-${i}' using 0:3 with line lt 1 lc 3 title '${PROGRAM}'
EOF
cat sysload.gnuplot | gnuplot
rm -f ${FILENAME}.core-${i}
done

rm -f sysload.gnuplot

