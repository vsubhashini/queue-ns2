#Gnuplot file to plot congestion QueueSize vs time
# 2 parts: 1. for average queue length from avgql.out 2. Current queue length from qm.out

set term png small
set xlabel "Time (s)"
set ylabel "Queue Size"
set autoscale
set title "Variation of Queue Size  with Time"
set out "QlengthVsTime.png"

plot "qm.out" using 1:5 title 'queue size' with lines

reset

set term png small
set xlabel "Time (s)"
set ylabel "Average Queue length"
set autoscale
set title "Average Queue length Vs  Time"
set out "AvgQlengthVsTime.png"

plot "avgql.out" using 1:2 title 'avg queue length' lt 2 with lines

reset
