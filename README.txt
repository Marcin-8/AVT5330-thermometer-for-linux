AVT5330-thermometer-for-linux
"AVT5330" is a piece of hardware bought for temperature measurement
This project is a piece of software for "AVT5330" made for linux (tested on Debians: antiX, Ubuntu)
measure_temp.sh writes data from sensors to /tmp/temp2.txt file, using gnuplot to see the trend
 
How to install:
1. on AVT5330 board set one of jumpers for automatic measure (add at least one sensor), connect AVT5330 to USB of pc/laptop
2. on pc/laptop:
    sudo apt install gnuplot
    sudo apt install gnuplot-x11
    sudo chmod 664 /dev/ttyUSB0
    chmod 700 ./measure_temp.sh
    terminal1 (run the script)
        ./measure_temp.sh
    terminal2 (run gnuplot for drawing)
        gnuplot
    copy/paste below to gnuplot editor
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

gnuplot tip: change plot line for more sensors, e.g.
    plot '/tmp/temp2.txt' using 1:3 title 'T1', '/tmp/temp2.txt' using 1:4 title 'T2', [...]'/tmp/temp2.txt' using 1:9 title 'T7', '/tmp/temp2.txt'
-----------------
special thanks to karkad
https://eko.one.pl/forum/viewtopic.php?id=4203&p=2
