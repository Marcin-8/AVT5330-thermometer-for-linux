This project is a shell script for "AVT5330", tested on Debians: antiX, Ubuntu.
"AVT5330" is a piece of hardware bought for temperature measurements (up to 8 sensors).
Script measure_temp.sh writes data from sensors to $OUTPUTFILE file, gnuplot can be used to see a trend.

How to install:
1. on AVT5330 board set one of jumpers to trigger automatic measure, add at least one sensor and connect AVT5330 to USB of a pc/laptop
2. on pc/laptop:

    sudo chmod 664 /dev/ttyUSB0
    chmod 700 ./measure_temp.sh
    terminal1 (run the script)
        ./measure_temp.sh
    
    Example output:
        $ tail -10 /tmp/temp_main_output.txt 
        2025-01-09 18:08:47 0.0 0.0 0.0 0.0 0.0 5.4 9.4 11.6
        2025-01-09 18:13:49 0.0 0.0 0.0 0.0 0.0 3.6 8.7 11.3
        2025-01-09 18:18:51 0.0 0.0 0.0 0.0 0.0 3.0 8.2 10.9
        2025-01-09 18:23:53 0.0 0.0 0.0 0.0 0.0 4.5 8.1 10.6
        2025-01-09 18:28:55 0.0 0.0 0.0 0.0 0.0 6.1 8.5 10.3
        2025-01-09 18:33:57 0.0 0.0 0.0 0.0 0.0 7.2 8.9 10.2
        2025-01-09 18:38:59 0.0 0.0 0.0 0.0 0.0 8.0 9.2 10.0
        2025-01-09 18:44:01 0.0 0.0 0.0 0.0 0.0 8.6 9.5 9.9
        2025-01-09 18:49:07 0.0 0.0 0.0 0.0 0.0 8.9 9.7 9.8
        2025-01-09 18:54:09 0.0 0.0 0.0 0.0 0.0 6.9 9.4 9.6

    If drawing required:
    sudo apt install gnuplot
    sudo apt install gnuplot-x11
    terminal2 (run gnuplot for drawing)
        gnuplot
    copy/paste below to gnuplot editor and hit enter
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
        plot '/tmp/temp_main_output.txt' using 1:8 title 'sensor #6', '/tmp/temp_main_output.txt' using 1:9 title 'sensor #7', '/tmp/temp_main_output.txt' using 1:10 title 'sensor #8'
        pause 60
        }


-----------------
special virtual thanks to karkad for help to kick this off
https://eko.one.pl/forum/viewtopic.php?id=4203&p=2
