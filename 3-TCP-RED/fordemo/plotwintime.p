#Gnuplot file to plot congestion window vs time for different queues
# Data being read from timewinDropTail or timewinRED

set term png small
set xlabel "Time (s)"
set ylabel "TCP Congestion Window size"
set autoscale
#set xtics 0.03
set title "Variation of TCP window with time in RED"
set out "REDwinTime.png"
#set title "Variation of TCP window with time in DropTail"
#set out "DropTailwinTime.png"

#plot "timewinDropTail" using 1:2 title 'tcpsrc1' with lines, \
#"timewinDropTail" using 1:3 title 'tcpsrc2' with lines, \
#"timewinDropTail" using 1:4 title 'tcpsrc3' with lines, \
#"timewinDropTail" using 1:5 title 'tcpsrc4' with lines

plot "timewinRED" using 1:2 title 'tcpsrc1' with lines, \
"timewinRED" using 1:3 title 'tcpsrc2' with lines, \
"timewinRED" using 1:4 title 'tcpsrc3' with lines, \
"timewinRED" using 1:5 title 'tcpsrc4' with lines
