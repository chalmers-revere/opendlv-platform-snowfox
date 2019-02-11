#!/bin/bash
# Copyright (C) 2019  Christian Berger
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

RUNNING=1
trap 'cleanup' SIGINT
trap 'cleanup' SIGTERM

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

NICS=$(echo $@ | sed -e 's/,/\ /g')
for i in $NICS ; do
    MATCH="/.*;$i;.*/!d"
    cat ${FILENAME} | sed -e ${MATCH} > ${FILENAME}-${i}
    PROGRAM=$(cat ${FILENAME}-${i} |head -1|cut -f4 -d";")
    TITLE=$(echo ${FILENAME} | sed -e 's/_/-/')
cat <<EOF >netload.gnuplot
set terminal pdf
set output '${FILENAME}-${i}.pdf'
set style increment default
set title "${TITLE}/$i"
set title  font ",20" norotate
set xlabel "[s]"
set ylabel "[bytes/s]"
set xrange [ * : * ] noreverse writeback
set yrange [ 0 : * ] noreverse writeback
set datafile separator ";"
show style line
plot '${FILENAME}-${i}' using 0:4 with line lt 1 lc 3 title 'RX rate', \
     '${FILENAME}-${i}' using 0:6 with line lt 1 lc 4 title 'TX rate'
EOF
cat netload.gnuplot | gnuplot
rm -f ${FILENAME}-${i}
done

rm -f netload.gnuplot

