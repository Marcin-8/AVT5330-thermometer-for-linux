# ========================================================================
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# ========================================================================
#
# Title		:	Thermometer AVT5330 C
# Purpose	: 	To measure temperature thorugh linux
# Params	:
#				0 - normal mode (temp measure every 5 minutes)
#				1 - debug mode (temp measure every 4 seconds, more output)
#				2 - development mode (temp measure every 4 seconds)
#
# Version	:	2.0
# Date		:	2023.02.09
# Author	:	MB
#
# History	:	2023.02.09 1.0 draft
#				2023.12.15 1.1 prototype
#				2024.12.30 1.2 production
#				2025.01.04 1.3 rewriting with a fresh turbo skills in bash
#				2025.01.04 1.4 author found out arrays in bash
#				2025.01.05 1.5 adding expected min/max temperature check
#				2025.01.05 2.0 production 2.0 tested
#
# Known issues:
#			"Getting read error... skipping..." - some bug to ignore.
#			Also probably due to bad soldering skills getting wrong
#			temp measurements from time to time (like -220^C). Ignoring
#			some extremly bad results by setting expected min/max.
# ========================================================================
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# ========================================================================

# set variables
OPTION=${1:-0}
OUTPUTFILE=/tmp/temp_main_output.txt
OUTPUTFILE_ERROR=/tmp/temp_main_error.txt
MIN_TEMP=0
MAX_TEMP=40

# set /dev/USB0
function set_stty_dev() {
stty -F /dev/ttyUSB0 19200 cs8 -cstopb -parenb -cooked
}

# create temporary files
function create_files() {
touch $OUTPUTFILE;
touch $OUTPUTFILE_ERROR
}

# remove old files if exist
function clear_old_files() {
if [[ -f $OUTPUTFILE ]]; then
	mv $OUTPUTFILE $OUTPUTFILE"_"`date "+%Y%m%d%H%M%S"`
fi
if [[ -f $OUTPUTFILE_ERROR ]]; then
	rm $OUTPUTFILE_ERROR
fi
}

# check input parameter
function parse_input_params() {
	if [ $OPTION = 0 ]; then
		printf 'NORMAL MODE\n';
		export SLEEP_TIME="5m";
	elif [ $OPTION = 1 ]; then
		printf 'DEBUG MODE\n';
		export SLEEP_TIME="4s";
	elif [ $OPTION = 2 ]; then
		printf 'DEV MODE\n';
		export SLEEP_TIME="4s";
	else
		printf 'Wrong input parameter (func: parse_input_params). Exiting.\n';
		exit 1;
	fi
}

# get current temp
function get_current_temp() {
current_temp_array=(`timeout 2 cat /dev/ttyUSB0`)
if [ $OPTION = 1 ]; then
	printf '%s ' "${current_temp_array[@]}"
	printf '\n'
	printf '^^^get_current_temp\n'
fi
}

# temperature from each sensor to one variable
function split_temp(){
unset $current_temp1
unset $current_temp2
unset $current_temp3
unset $current_temp4
unset $current_temp5
unset $current_temp6
unset $current_temp7
unset $current_temp8

current_temp1=`echo ${current_temp_array[2]}|tr -d "'C"`
current_temp2=`echo ${current_temp_array[4]}|tr -d "'C"`
current_temp3=`echo ${current_temp_array[6]}|tr -d "'C"`
current_temp4=`echo ${current_temp_array[8]}|tr -d "'C"`
current_temp5=`echo ${current_temp_array[10]}|tr -d "'C"`
current_temp6=`echo ${current_temp_array[12]}|tr -d "'C"`
current_temp7=`echo ${current_temp_array[14]}|tr -d "'C"`
current_temp8=`echo ${current_temp_array[16]}|tr -d "'C"`
if [ $OPTION = 1 ]; then
	printf 'current_temp1=>'$current_temp1'\n';
	printf 'current_temp2=>'$current_temp2'\n';
	printf 'current_temp3=>'$current_temp3'\n';
	printf 'current_temp4=>'$current_temp4'\n';
	printf 'current_temp5=>'$current_temp5'\n';
	printf 'current_temp6=>'$current_temp6'\n';
	printf 'current_temp7=>'$current_temp7'\n';
	printf 'current_temp8=>'$current_temp8'\n';
	printf '^^^split_temp\n'
fi
}

#set 0 when no temp
function norm_temp() {
re='^[+-]?[0-9]+([.][0-9]+)?$'
if [[ "$current_temp1" =~ $re ]]; then current_temp1=$current_temp1
	elif [ "$current_temp1" = "___._" ]; then current_temp1="0.0"
	else
	current_temp1="err"
	return
fi
if [[ "$current_temp2" =~ $re ]]; then current_temp2=$current_temp2
	elif [ "$current_temp2" = "___._" ]; then current_temp2="0.0"
	else
	current_temp2="err"
	return
fi
if [[ "$current_temp3" =~ $re ]]; then current_temp3=$current_temp3
	elif [ "$current_temp3" = "___._" ]; then current_temp3="0.0"
	else
	current_temp3="err"
	return
fi
if [[ "$current_temp4" =~ $re ]]; then current_temp4=$current_temp4
	elif [ "$current_temp4" = "___._" ]; then current_temp4="0.0"
	else
	current_temp4="err"
	return
fi
if [[ "$current_temp5" =~ $re ]]; then current_temp5=$current_temp5
	elif [ "$current_temp5" = "___._" ]; then current_temp5="0.0"
	else
	current_temp5="err"
	return
fi
if [[ "$current_temp6" =~ $re ]]; then current_temp6=$current_temp6
	elif [ "$current_temp6" = "___._" ]; then current_temp6="0.0"
	else
	current_temp6="err"
	return
fi
if [[ "$current_temp7" =~ $re ]]; then current_temp7=$current_temp7
	elif [ "$current_temp7" = "___._" ]; then current_temp7="0.0"
	else
	current_temp7="err"
	return
fi
if [[ "$current_temp8" =~ $re ]]; then current_temp8=$current_temp8
	elif [ "$current_temp8" = "___._" ]; then current_temp8="0.0"
	else
	current_temp8="err"
	return
fi

if [ $OPTION = 1 ]; then
	printf 'current_temp1=>'$current_temp1'\n';
	printf 'current_temp2=>'$current_temp2'\n';
	printf 'current_temp3=>'$current_temp3'\n';
	printf 'current_temp4=>'$current_temp4'\n';
	printf 'current_temp5=>'$current_temp5'\n';
	printf 'current_temp6=>'$current_temp6'\n';
	printf 'current_temp7=>'$current_temp7'\n';
	printf 'current_temp8=>'$current_temp8'\n';
	printf '^^^norm_temp\n'
fi
}

function check_temp_between_min_max() {
re='^[+-]?[0-9]+([.][0-9]+)?$'
if [[ "$current_temp1" =~ $re ]]; then
	current_temp1_int=${current_temp1%.*}
	if (( $current_temp1_int>=$MIN_TEMP )) && (( $current_temp1_int<=$MAX_TEMP )); then
	current_temp1_int="OK";
	else
	current_temp1_int="err";
	current_temp1="err";
	fi
else
	current_temp1_int="err";
	current_temp1="err";
fi
if [[ "$current_temp2" =~ $re ]]; then
	current_temp2_int=${current_temp2%.*}
	if (( $current_temp2_int>=$MIN_TEMP )) && (( $current_temp2_int<=$MAX_TEMP )); then
	current_temp2_int="OK";
	else
	current_temp2_int="err";
	current_temp2="err";
	fi
else
	current_temp2_int="err";
	current_temp2="err";
fi
if [[ "$current_temp3" =~ $re ]]; then
	current_temp3_int=${current_temp3%.*}
	if (( $current_temp3_int>=$MIN_TEMP )) && (( $current_temp3_int<=$MAX_TEMP )); then
	current_temp3_int="OK";
	else
	current_temp3_int="err";
	current_temp3="err";
	fi
else
	current_temp3_int="err";
	current_temp3="err";
fi
if [[ "$current_temp4" =~ $re ]]; then
	current_temp4_int=${current_temp4%.*}
	if (( $current_temp4_int>=$MIN_TEMP )) && (( $current_temp4_int<=$MAX_TEMP )); then
	current_temp4_int="OK";
	else
	current_temp4_int="err";
	current_temp4="err";
	fi
else
	current_temp4_int="err";
	current_temp4="err";
fi
if [[ "$current_temp5" =~ $re ]]; then
	current_temp5_int=${current_temp5%.*}
	if (( $current_temp5_int>=$MIN_TEMP )) && (( $current_temp5_int<=$MAX_TEMP )); then
	current_temp5_int="OK";
	else
	current_temp5_int="err";
	current_temp5="err";
	fi
else
	current_temp5_int="err";
	current_temp5="err";
fi
if [[ "$current_temp6" =~ $re ]]; then
	current_temp6_int=${current_temp6%.*}
	if (( $current_temp6_int>=$MIN_TEMP )) && (( $current_temp6_int<=$MAX_TEMP )); then
	current_temp6_int="OK";
	else
	current_temp6_int="err";
	current_temp6="err";
	fi
else
	current_temp6_int="err";
	current_temp6="err";
fi
if [[ "$current_temp7" =~ $re ]]; then
	current_temp7_int=${current_temp7%.*}
	if (( $current_temp7_int>=$MIN_TEMP )) && (( $current_temp7_int<=$MAX_TEMP )); then
	current_temp7_int="OK";
	else
	current_temp7_int="err";
	current_temp7="err";
	fi
else
	current_temp7_int="err";
	current_temp7="err";
fi
if [[ "$current_temp8" =~ $re ]]; then
	current_temp8_int=${current_temp8%.*}
	if (( $current_temp8_int>=$MIN_TEMP )) && (( $current_temp8_int<=$MAX_TEMP )); then
	current_temp8_int="OK";
	else
	current_temp8_int="err";
	current_temp8="err";
	fi
else
	current_temp8_int="err";
	current_temp8="err";
fi

if [ $OPTION = 1 ]; then
	printf 'current_temp1_int=>'$current_temp1_int'\n';
	printf 'current_temp2_int=>'$current_temp2_int'\n';
	printf 'current_temp3_int=>'$current_temp3_int'\n';
	printf 'current_temp4_int=>'$current_temp4_int'\n';
	printf 'current_temp5_int=>'$current_temp5_int'\n';
	printf 'current_temp6_int=>'$current_temp6_int'\n';
	printf 'current_temp7_int=>'$current_temp7_int'\n';
	printf 'current_temp8_int=>'$current_temp8_int'\n';
	printf '^^^temp_min_max\n'
fi
}

# run gnuplot
function set_gnuplot() {
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

# write output to file
function write_output() {
printf '%(%Y-%m-%d %H:%M:%S)T' >> $1
printf ' ' >> $1
printf "%s" $current_temp1' '$current_temp2' '$current_temp3' '$current_temp4' '$current_temp5' '$current_temp6' '$current_temp7' '$current_temp8 >> $1
printf '\n' >> $1
}

# main function
function main {
	parse_input_params
	clear_old_files
	set_stty_dev
	create_files
	while true; do
		date;
		get_current_temp;
		split_temp;
		norm_temp;
		check_temp_between_min_max;
		if [ "$current_temp1" = "err" ] || \
			[ "$current_temp2" = "err" ] || \
			[ "$current_temp3" = "err" ] || \
			[ "$current_temp4" = "err" ] || \
			[ "$current_temp5" = "err" ] || \
			[ "$current_temp6" = "err" ] || \
			[ "$current_temp7" = "err" ] || \
			[ "$current_temp8" = "err" ]; then
			printf 'Getting read error... skipping...\n';
			write_output $OUTPUTFILE_ERROR;
			sleep 1;
			continue;
		fi
		write_output $OUTPUTFILE;
#		set_gnuplot #not in use
		sleep $SLEEP_TIME;
	done
}

main
