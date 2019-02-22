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

FILENAME=$(date +%F_%R%S)-sysload.csv
FILENAME=$(echo ${FILENAME} | sed -e 's/\://g')
:> ${FILENAME}

while [ "$RUNNING" == "1" ]; do
    for i in $@ ; do
        ts=$(date +%s%N)
        sysload=$(ps -eo psr,pcpu,command | tr -s " " " " | grep "^ [$i]" | grep -v "\]" 2>&1 | sed -e "s/\ /\;/" | sed -e "s/\ /\;/" | sed -e "s/\ /\;/" | head -1)
        echo "${sysload}" | sed -e "s/^;/${ts}\;/" >> ${FILENAME}
    done

    sleep 1;
done

for i in $@ ; do
    MATCH="/.*;$i;.*/!d"
    cat ${FILENAME} | sed -e ${MATCH} > ${FILENAME}.core-${i}
    PROGRAM=$(cat ${FILENAME}.core-${i} |head -1|cut -f4 -d";")
    TITLE=$(echo ${FILENAME} | sed -e 's/_/-/')
cat <<EOF >sysload.gnuplot
set terminal pdf
set output '${FILENAME}.core-${i}.pdf'
set style increment default
set title "${TITLE}/core $i"
set title  font ",20" norotate
set xlabel "[s]"
set ylabel "[%]"
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

