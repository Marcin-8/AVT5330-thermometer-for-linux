# ========================================================================
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# ========================================================================
#
# Title		:	Thermometer AVT5330 C
# Purpose	: 	To measure temperature thorugh linux
# Params	:
#				0 - normal run
#				1 - debug
#				2
#
# Version	:	1.1
# Date		:	2023.02.09
# Author	:	MB
#
# History	:	2023.02.09 1.0 draft
#				2023.12.15 1.1 draft
#				2024.12.30 1.2 production
#
# Readme	:
#		on AVT5330 board set one of jumpers for automatic measure
#		install:
#		as root
#			apt install gnuplot
#			apt install gnuplot-x11
#			connect USB thermometer
#			chmod 744 /dev/ttyUSB0
#			chmod 744 ./measure_temp.sh
#		as user
#			terminal1 (run the script)
#				while true; do ./measure_temp.sh; date; sleep 60; done
#			terminal2 (for drawing)
#				gnuplot
#				copy/paste below to gnuplot
# 					while (1) {
# 					reset
# 					#set title "Temp"
# 					set key title "Sensors"
# 					set xlabel "Time"
# 					set ylabel "Temperature [Celsius]"
# 					set xdata time
# 					set ytics 1
# 					set mytics 2
# 					set mxtics 4
# 					set autoscale x
# 					set yrange[14:42]
# 					set format x "%m-%d\n%H:%M:%S"
# 					set timefmt "%Y-%m-%d %H:%M:%S"
# 					set style data lines
# 					set style line 100 lt 1 lc rgb "grey" lw 1
# 					set style line 101 lt 1 lc rgb "grey" lw 1
# 					set grid ytics ls 100 xtics ls 101 mxtics ls 101
# 					set key top
# 					#set samples 1000
# 					plot '/tmp/temp2.txt' using 1:9 title 'sensor #7', '/tmp/temp2.txt' using 1:10 title 'sensor #8'
# 					pause 60
# 					}
#
#				gnuplot tip: change plot line for more sensors
# 					plot '/tmp/temp2.txt' using 1:3 title 'T1', '/tmp/temp2.txt' using 1:4 title 'T2', '/tmp/temp2.txt' using 1:5 title 'T3', '/tmp/temp2.txt' using 1:6 title 'T4', '/tmp/temp2.txt' using 1:7 title 'T5', '/tmp/temp2.txt' using 1:8 title 'T6', '/tmp/temp2.txt' using 1:9 title 'T7', '/tmp/temp2.txt'
#
#		known issues:
#			"skipping write getting error" - some bug to ignore
#
# ========================================================================
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# ========================================================================

# set variables
OPTION=${1:-0}
TXTFILE=/tmp/temp.txt
TXTFILE2=/tmp/temp2.txt

# set /dev/USB0
function set_stty_dev {
stty -F /dev/ttyUSB0 19200 cs8 -cstopb -parenb -cooked
}

# set temporary files
function set_new_temp_files {
touch $TXTFILE;
#chmod 777 $TXTFILE;
touch $TXTFILE2;
#chmod 777 $TXTFILE2;
}

# remove old temporary files
function set_old_temp_files {
rm $TXTFILE;
}

# get current temp
function get_current_temp {
	if [ $OPTION = 0 ]; then
		timeout 2 cat /dev/ttyUSB0 > $TXTFILE
	elif [ $OPTION = 1 ]; then
		timeout 2 cat /dev/ttyUSB0 > $TXTFILE
		#debug echo
		date
		cat $TXTFILE
		echo `printf ''`
		echo `printf ''`
		echo `printf '^^^get_current_temp'`
		echo `printf ''`
	else
		echo "Wrong input parameter. Exiting."
	fi
}

# get current temp
function get_split_temp {
	if [ $OPTION = 0 ]; then	
		current_temp1=`cut -c 4-9 $TXTFILE`
		current_temp1=`echo $current_temp1 | sed 's/ *$//g'`
		current_temp2=`cut -c 17-22 $TXTFILE`
		current_temp2=`echo $current_temp2 | sed 's/ *$//g'`
		current_temp3=`cut -c 30-35 $TXTFILE`
		current_temp3=`echo $current_temp3 | sed 's/ *$//g'`
		current_temp4=`cut -c 43-48 $TXTFILE`
		current_temp4=`echo $current_temp4 | sed 's/ *$//g'`
		current_temp5=`cut -c 56-61 $TXTFILE`
		current_temp5=`echo $current_temp5 | sed 's/ *$//g'`
		current_temp6=`cut -c 69-74 $TXTFILE`
		current_temp6=`echo $current_temp6 | sed 's/ *$//g'`
		current_temp7=`cut -c 82-87 $TXTFILE`
		current_temp7=`echo $current_temp7 | sed 's/ *$//g'`
		current_temp8=`cut -c 95-100 $TXTFILE`
		current_temp8=`echo $current_temp8 | sed 's/ *$//g'`
	elif [ $OPTION = 1 ]; then
		current_temp1=`cut -c 4-9 $TXTFILE`
		current_temp1=`echo $current_temp1 | sed 's/ *$//g'`
		current_temp2=`cut -c 17-22 $TXTFILE`
		current_temp2=`echo $current_temp2 | sed 's/ *$//g'`
		current_temp3=`cut -c 30-35 $TXTFILE`
		current_temp3=`echo $current_temp3 | sed 's/ *$//g'`
		current_temp4=`cut -c 43-48 $TXTFILE`
		current_temp4=`echo $current_temp4 | sed 's/ *$//g'`
		current_temp5=`cut -c 56-61 $TXTFILE`
		current_temp5=`echo $current_temp5 | sed 's/ *$//g'`
		current_temp6=`cut -c 69-74 $TXTFILE`
		current_temp6=`echo $current_temp6 | sed 's/ *$//g'`
		current_temp7=`cut -c 82-87 $TXTFILE`
		current_temp7=`echo $current_temp7 | sed 's/ *$//g'`
		current_temp8=`cut -c 95-100 $TXTFILE`
		current_temp8=`echo $current_temp8 | sed 's/ *$//g'`
		
		#debug echo
		echo 'current_temp1=>'$current_temp1;
		echo 'current_temp2=>'$current_temp2;
		echo 'current_temp3=>'$current_temp3;
		echo 'current_temp4=>'$current_temp4;
		echo 'current_temp5=>'$current_temp5;
		echo 'current_temp6=>'$current_temp6;
		echo 'current_temp7=>'$current_temp7;
		echo 'current_temp8=>'$current_temp8;
		echo `printf ''`
		echo `printf '^^^get_split_temp'`
		echo `printf ''`
	else
		echo "Wrong input parameter. Exiting."
	fi
}

#set 0 when no temp
function set_norm_temp {
	if [ $OPTION = 0 ]; then
		re='^[+-]?[0-9]+([.][0-9]+)?$'
		if [[ "$current_temp1" =~ $re ]]; then current_temp1=$current_temp1
		elif [ "$current_temp1" = "___._" ]; then current_temp1="0.0"
		else current_temp1="err"
		fi
		if [[ "$current_temp2" =~ $re ]]; then current_temp2=$current_temp2
		elif [ "$current_temp2" = "___._" ]; then current_temp2="0.0"
		else current_temp2="err"
		fi
		if [[ "$current_temp3" =~ $re ]]; then current_temp3=$current_temp3
		elif [ "$current_temp3" = "___._" ]; then current_temp3="0.0"
		else current_temp3="err"
		fi
		if [[ "$current_temp4" =~ $re ]]; then current_temp4=$current_temp4
		elif [ "$current_temp4" = "___._" ]; then current_temp4="0.0"
		else current_temp4="err"
		fi
		if [[ "$current_temp5" =~ $re ]]; then current_temp5=$current_temp5
		elif [ "$current_temp5" = "___._" ]; then current_temp5="0.0"
		else current_temp5="err"
		fi
		if [[ "$current_temp6" =~ $re ]]; then current_temp6=$current_temp6
		elif [ "$current_temp6" = "___._" ]; then current_temp6="0.0"
		else current_temp6="err"
		fi
		if [[ "$current_temp7" =~ $re ]]; then current_temp7=$current_temp7
		elif [ "$current_temp7" = "___._" ]; then current_temp7="0.0"
		else current_temp7="err"
		fi
		if [[ "$current_temp8" =~ $re ]]; then current_temp8=$current_temp8
		elif [ "$current_temp8" = "___._" ]; then current_temp8="0.0" 
		else current_temp8="err"
		fi
	elif [ $OPTION = 1 ]; then
		re='^[+-]?[0-9]+([.][0-9]+)?$'
		if [[ "$current_temp1" =~ $re ]]; then current_temp1=$current_temp1
		elif [ "$current_temp1" = "___._" ]; then current_temp1="0.0"
		else current_temp1="err"
		fi
		if [[ "$current_temp2" =~ $re ]]; then current_temp2=$current_temp2
		elif [ "$current_temp2" = "___._" ]; then current_temp2="0.0"
		else current_temp2="err"
		fi
		if [[ "$current_temp3" =~ $re ]]; then current_temp3=$current_temp3
		elif [ "$current_temp3" = "___._" ]; then current_temp3="0.0"
		else current_temp3="err"
		fi
		if [[ "$current_temp4" =~ $re ]]; then current_temp4=$current_temp4
		elif [ "$current_temp4" = "___._" ]; then current_temp4="0.0"
		else current_temp4="err"
		fi
		if [[ "$current_temp5" =~ $re ]]; then current_temp5=$current_temp5
		elif [ "$current_temp5" = "___._" ]; then current_temp5="0.0"
		else current_temp5="err"
		fi
		if [[ "$current_temp6" =~ $re ]]; then current_temp6=$current_temp6
		elif [ "$current_temp6" = "___._" ]; then current_temp6="0.0"
		else current_temp6="err"
		fi
		if [[ "$current_temp7" =~ $re ]]; then current_temp7=$current_temp7
		elif [ "$current_temp7" = "___._" ]; then current_temp7="0.0"
		else current_temp7="err"
		fi
		if [[ "$current_temp8" =~ $re ]]; then current_temp8=$current_temp8
		elif [ "$current_temp8" = "___._" ]; then current_temp8="0.0" 
		else current_temp8="err"
		fi
		#debug echo
		echo 'current_temp1=>'$current_temp1;
		echo 'current_temp2=>'$current_temp2;
		echo 'current_temp3=>'$current_temp3;
		echo 'current_temp4=>'$current_temp4;
		echo 'current_temp5=>'$current_temp5;
		echo 'current_temp6=>'$current_temp6;
		echo 'current_temp7=>'$current_temp7;
		echo 'current_temp8=>'$current_temp8;
		echo `printf ''`
		echo `printf '^^^set_norm_temp'`
		echo `printf ''`
	else
		echo "Wrong input parameter. Exiting."
	fi
}

# set output file
function set_output_file {
echo `printf '%(%Y-%m-%d %H:%M:%S)T\n'` $current_temp1 $current_temp2 $current_temp3 $current_temp4 $current_temp5 $current_temp6 $current_temp7 $current_temp8 >> $TXTFILE2
}

# run gnuplot
function set_gnuplot {
gnuplot -persist <<- EOF
reset
set title "Temp for last 24 hours"
set key title "Sensors"
set xlabel "Time"
set ylabel "Temperature"
set xdata time
set ytics 1
set mytics 5
set timefmt "%Y-%m-%d"
set autoscale x
set yrange[-1:30]
set format x "%m-%d\n%H:%M"
set timefmt "%Y-%m-%d %H:%M"
set style data linespoints
set grid
set key bottom
set samples 1000
plot '/tmp/temp2.txt' using 1:3 title 'T1', '/tmp/temp2.txt' using 1:4 title 'T2', '/tmp/temp2.txt' using 1:5 title 'T3', '/tmp/temp2.txt' using 1:6 title 'T4', '/tmp/temp2.txt' using 1:7 title 'T5', '/tmp/temp2.txt' using 1:8 title 'T6', '/tmp/temp2.txt' using 1:9 title 'T7', '/tmp/temp2.txt' using 1:10 title 'T8'
EOF
}

# create output file
function set_file {
	set_norm_temp
	if [ "$current_temp1" = "err" ] || [ "$current_temp2" = "err" ] || [ "$current_temp3" = "err" ] || [ "$current_temp4" = "err" ] || [ "$current_temp5" = "err" ] || [ "$current_temp6" = "err" ] || [ "$current_temp7" = "err" ] || [ "$current_temp8" = "err" ]; then
		date
		echo `printf 'skipping write getting error'`
	else
		set_output_file
		date
	fi
}

# main function
function main {
	set_stty_dev
	set_new_temp_files
	get_current_temp
	get_split_temp
	set_file	
	set_old_temp_files
#	set_gnuplot # this function not in use require more development to run
}

main
