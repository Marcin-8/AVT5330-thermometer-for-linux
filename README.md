# AVT5330-thermometer-for-linux
Thermometer "AVT5330 C" is a piece of hardware bought for temperature measurement
This project is a piece of software for "AVT5330 C" made for linux
	measure_temp.sh writes data from sensors to /tmp/temp2.txt file
I'm using gnuplot to see the trend

How to install:
  on AVT5330 set one of jumpers for automatic measure
		as root
			apt install gnuplot
			apt install gnuplot-x11
			connect USB thermometer
			chmod 744 /dev/ttyUSB0
			chmod 744 ./measure_temp.sh
		as user
			terminal1 (run the script)
				while true; do ./measure_temp.sh; date; sleep 60; done
			terminal2 (for drawing)
				gnuplot
				copy/paste below to gnuplot
					while (1) {
					reset
					#set title "Temp"
					set key title "Sensors"
					set xlabel "Time"
					set ylabel "Temperature [Celsius]"
					set xdata time
					set ytics 1
					set mytics 2
					set mxtics 4
					set autoscale x
					set yrange[14:42]
					set format x "%m-%d\n%H:%M:%S"
					set timefmt "%Y-%m-%d %H:%M:%S"
					set style data lines
					set style line 100 lt 1 lc rgb "grey" lw 1
					set style line 101 lt 1 lc rgb "grey" lw 1
					set grid ytics ls 100 xtics ls 101 mxtics ls 101
					set key top
					#set samples 1000
					plot '/tmp/temp2.txt' using 1:9 title 'sensor #7', '/tmp/temp2.txt' using 1:10 title 'sensor #8'
					pause 60
					}

				gnuplot tip: change plot line for more sensors
					plot '/tmp/temp2.txt' using 1:3 title 'T1', '/tmp/temp2.txt' using 1:4 title 'T2', '/tmp/temp2.txt' using 1:5 title 'T3', '/tmp/temp2.txt' using 1:6 title 'T4', '/tmp/temp2.txt' using 1:7 title 'T5', '/tmp/temp2.txt' using 1:8 title 'T6', '/tmp/temp2.txt' using 1:9 title 'T7', '/tmp/temp2.txt'

		known issues:
			"skipping write getting error" - some bug to ignore
