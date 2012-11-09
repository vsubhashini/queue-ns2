#! /usr/bin/perl
#Perl script to automate the various trials and plot graphs
#comparison of with and without RED
#@author: vsubhashini

$simT = 13.8;
$winsize = 4000;

#foreach $i (100, 400, 700, 1000, 1300)
foreach $i (DropTail, RED)
{
	print "\nQueue Type: $i\n";
	#run the command
	@red1out = `ns red.tcl $i $simT $winsize`;
	
	foreach $j (@red1out) {
		print "$j"
	}

	#create the plot files
	$plotqsize = "QSizeVsTime".$i.$simT.$winsize.".png";
	$plotq2size = "Q2SizeVsTime".$i.$simT.$winsize.".png";
	$plotcwind = "cwindVsTime".$i.$simT.$winsize.".png";
	$datfile = "timewin".$i.$simT.$winsize;

	#Now try to plot the graph from file data
	# open pipe for Gnuplot
	open(PLOT, "| gnuplot")
		or die "Unable to launch gnuplot\n";

	print PLOT qq{set term png small\n};
	print PLOT qq{set xlabel "Time (s)"\n};
	print PLOT qq{set ylabel "Queue Size"\n};
	print PLOT qq{set autoscale\n};
	print PLOT qq{set title "Variation of Queue Size using $i"\n};
	print PLOT qq{set out "$plotqsize"\n};
	$clr = 1;
	if( $i eq "DropTail") {
		$clr = 3;
	}
	print PLOT qq{plot "redq.tr" using 1:5 title 'queue size' lt $clr with lines \n};

	print PLOT qq{reset\n};

#	print PLOT qq{set term png small\n};
#	print PLOT qq{set xlabel "Time (s)"\n};
#	print PLOT qq{set ylabel "Queue Size"\n};
#	print PLOT qq{set autoscale\n};
#	print PLOT qq{set title "Variation of Queue2's Size using $i"\n};
#	print PLOT qq{set out "$plotq2size"\n};
#	$clr = 1;
#	if( $i eq "DropTail") {
#		$clr = 2;
#	}
#	print PLOT qq{plot "redq2.tr" using 1:5 title 'queue size' lt $clr with lines \n};
#
#	print PLOT qq{reset\n};

	print PLOT qq{set term png small\n};
	print PLOT qq{set xlabel "Time (s)"\n};
	print PLOT qq{set ylabel "TCP Congestion Window size"\n};
	print PLOT qq{set autoscale\n};
	print PLOT qq{set title "Variation of TCP window with time in $i"\n};
	print PLOT qq{set out "$plotcwind"\n};

	print PLOT qq{plot "$datfile" using 1:2 title 'tcpsrc1' with lines, \\\n};
	print PLOT qq{"$datfile" using 1:3 title 'tcpsrc2' with lines, \\\n};
	print PLOT qq{"$datfile" using 1:4 title 'tcpsrc3' with lines, \\\n};
	print PLOT qq{"$datfile" using 1:5 title 'tcpsrc4' with lines \n};

	print PLOT qq{reset\n};

	# close the pipe to Gnuplot
	close(PLOT)
		or die "Unable to close the pipe -> gnuplot";

	print " Graph saved as $plotqsize\n";
}
