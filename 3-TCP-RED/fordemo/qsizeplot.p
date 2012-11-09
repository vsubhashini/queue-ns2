#Gnuplot file to plot congestion window vs time for different queues
# Data being read from timewinDRR or timewinFQ or timewinRED

set term png small
set xlabel "Time (s)"
set ylabel "Queue Size"
set autoscale
#set xtics 0.5
#set title "Variation of Queue Size with RED"
#set out "QSizeRED.png"
set title "Variation of Queue Size without RED"
set out "QSizeDropTail.png"

plot "redq.tr" using 1:5 title 'queue size' with lines
