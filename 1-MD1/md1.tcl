########
#	Analysis of D/D/1 queues using ns2
#	
#	@authors: vsubhashini
#######

#Creating a new simulator object
set ns [new Simulator]

#defining colors for dataflow in Nam
$ns color 1 Green

#packet sizes vary - 100B, 400B, 700B, 1000B, 1200B, 1300B
set pktsiz [lindex $argv 0]
#get argument simulation duration 
set simTime [lindex $argv 1]
if {$simTime < 1} {
	set simTime 3
}

#opening NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#open a file to keep track of the average queue length
set avgf [open avgql.out w]

#defining a finish procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	#close the nam trace file
	close $nf
	#execute the nam file in background
#	exec nam out.nam &
	exit 0
}

#create the 2 nodes S and D
set S [$ns node]
set D [$ns node]

#creating the link between the nodes (simplex sufficient?)
$ns duplex-link $S $D 12Mb 75ms DropTail
#queue-limit is infinite so no need to define that
$ns queue-limit $S $D 10000

#give positions in nam
$ns duplex-link-op $S $D orient right

#setup the udp connection
set udp [new Agent/UDP]
$ns attach-agent $S $udp
set null [new Agent/Null]
$ns attach-agent $D $null
$ns connect $udp $null
$udp set fid_ 1

#setup a cbr over the udp connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ $pktsiz
#lambda needs to be 1200pkts/s in megabits, so compute accordingly
set a 1200.0
set lambda_ [expr [expr [$cbr set packet_size_] * 8] * $a]
set lambdaMbps_ [expr $lambda_ / 1000000]
puts "packet size: [$cbr set packet_size_] lambda: $lambdaMbps_ Mbps"
#continue with cbr parameters
$cbr set rate_ [expr $lambdaMbps_]mb
$cbr set random_ false

#schedule the cbr procedure
set stopTime [expr $simTime]
$ns at 0.0 "$cbr start"
$ns at $stopTime "$cbr stop"

#monitor queue for nam
$ns duplex-link-op $S $D queuePos 0.5

#monitor the queue
#wouldn't use the queue for the given values.
#Will use queue only when data sent is greater than link capacity.
#set monitor [$ns monitor-queue $S $D stdout]
set qmonitor [$ns monitor-queue $S $D [open qm.out w] ];
[$ns link $S $D] queue-sample-timeout; 
#set monitor [$ns monitor-queue $S $D stdout]

#procedure to compute average queue length
proc queueLength {sum number file} {
    global ns monitor qmonitor
    set time 0.1
 #   set len [$monitor set pkts_]
    set len [$qmonitor set pkts_]
    #set len [$monitor set size_]
    set now [$ns now]
    set sum [expr $sum+$len]
    set number [expr $number+1]
    #incr number may have worked equally well?
#    puts "time: [expr $now+$time] lgth: [expr 1.0*$sum/$number]"
    #write the average queue length in to a file
    puts $file "[expr $now+$time] [expr 1.0*$sum/$number]"
    $ns at [expr $now+$time] "queueLength $sum $number $file"
}
$ns at 0 "queueLength 0 0 $avgf"

#call the finish procedure
$ns at $simTime "finish"

#print cbr size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"
puts "Average Queue length is saved in avgql.out"

#run simulation
$ns run
