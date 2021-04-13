#!/usr/bin/env bash
#- Description: Bash script that generates a sequence of random numbers from 1 to 10

args=$@

#- Setting verbose to 0 will have additional info of when the message was printed or show the randomize approach
verbose=0

# Set to 0 if you want shell debugging turned on
debug=0


#- Will check the binaries and utilities required for each method
# Will accept an argument or empty (automatic decision)
# Tested arguments are: variable, dev, shuffle, self
check_bins() {

local _method=$1


#- Will check for all binaries
if [[ -z ${_method} ]];
	then
		_grep=$(which grep)
		_sed=$(which sed)
		_head=$(which head)
		_shuf=$(which shuf)
elif [[ "${_method,,}" == "variable" ]];
	then
		_random=$RANDOM
		if [[ -z ${_random} ]];
			then
				echo "The selected method is not supported. The system does not have the '$RANDOM' variable set"
				exit 2
		fi
elif [[ "${_method,,}" == "dev" ]];
	then
		if [[ ! -e /dev/urandom ]];
			then
				echo "The selected method is not supported. The file /dev/urandom does not exist on the system."
				exit 2
		fi
elif [[ "${_method,,}" == "shuffle" ]];
	then
		_shuf=$(which shuf)
		local random_nr=$(${_shuf} -i1-10 -n1)
		echo $random_nr
elif [[ "${_method,,}" == "self" ]];
	then


}


method_selector() {

#- Test if each tool for the generation is available
#- The function will decide which is to be used automatically if no argument is supplied in the order: Method 1, Method 2, Method 3, Method 4

# Method 1 for Linux -> $RANDOM variable if set (will generate a number from 0-32767)
# Value will be used to be parsed into a random 1-10. This method has certain security implications as the pattern can be detected eventually

if [[ -n $RANDOM ]];
    then
        echo "Random exists"
    else
        echo "Random does not exist"
fi

# there are 3 methods


random_method1
random_method2
random_method3 #which is in main


}

random_method1() {


if [[ -n $RANDOM ]];
    then
        echo "Random exists"
    else
        echo "Random does not exist"
fi

}

#- Using the /dev/urandom approach
random_method2() {


local random_nr=$(${_grep} -m1 -ao '[0-9]' /dev/urandom | ${_sed} s/0/10/ | ${head} -n1)
echo $random_nr

}

#- Using the shuf utility
random_method3() {

local random_nr=$(shuf -i1-10 -n1)
echo $random_nr


}

#- Self built method
random_method4() {

local sequence=$(date +%N )
local number=${sequence:0:1}
	
	#if [[ ${#number} -gt 1 ]];
	#	then
	#		if [[ $verbose -eq 0 ]]; then echo "$(date +%c) :Since the number has ${#number} digits, we will substract by 1"; fi	
	#		number=$((number - 1 ))
	if [[ $number -eq 0 ]];
		then
			if [[ $verbose -eq 0 ]]; then echo "$(date +%c) :Since the number is $number, we will add by 1"; fi
			number=$((number + 1 ))
	fi
	


}

if [[ $debug -eq 0 ]];
	then
		set -x
	else
		set +x; set +f; set +v
fi


usage() {

echo "Usage: $0 args"
echo "Available arguments:"
echo "-v | --verbose to print out timestamps along with the random  number"
echo "-i | -i=value | --interval=value to specify the loop interval. Specify the values in int+(s,m)"
echo "Default interval is 0.5s, and possible values are 1s, 2m"
echo "If another format is provided, the script will enforce the defaults"

}


#- Set the default interval or user input value
parse_interval() {

local value="$1"


if [[  "$value" =~ ^[0-9]{1,}[sSmM]{1} ]]; 
	then
		# Return the default 0.5s
		echo $interval
	else
		# Return the user input value
		echo $value
fi
		
}

#- If there are any args at exec time, parse them
parse_args() {



if [[ -z $@ ]];
	then
		interval=0.5s
	else
		# As long as there is at least one more argument, keep looping
		while [[ $# -gt 0 ]]; 
		do
			arg="$1"
			case "$arg" in
				# This is a flag type option. Will catch either -v or --verbose
				-v|--verbose)
				verbose=0
				;;
				# This is an arg=value type option. Will catch -o=value or --output-file=value
				-i=*|--interval=*)
				
				interval=$(parse_interval "${arg#*=}")
				if [[  "${arg#*=}" =~ ^[0-9]{1,}[sSmM]{1} ]]; 
					then 
						echo ""${arg#*=}" does not match the expected format. Setting the default value of $interval."
					else
						interval="${arg#*=}"
				fi

				;;
				# This is an arg value type option. Will catch -o value or --output-file value
				-i|--interval)
				shift
				interval="$1"
				;;
				*)
			echo "Unknown argument $arg provided"
			usage
			;;
			esac
			# Shift after checking all the cases to get the next option
			shift
		done
fi


}



main() {

echo "args are "$args" and in total are ${#args}"
#- Parse the arguments, no type checking
#parse_args $@

if [[ -z $args ]];
	then
		interval=0.5s
	else
		# As long as there is at least one more argument, keep looping
		while [[ $# -gt 0 ]]; 
		do
			arg="$1"
			case "$arg" in
				# This is a flag type option. Will catch either -v or --verbose
				-v|--verbose)
				verbose=0
				;;
				# This is a flag type option. Will catch either -v or --verbose
				-d|--demo)
				demo=0
				;;
				# This is an arg=value type option. Will catch -o=value or --output-file=value
				-i=*|--interval=*)
				
				interval=$(parse_interval "${arg#*=}")
				if [[  "${arg#*=}" =~ ^[0-9]{1,}[sSmM]{1} ]]; 
					then 
						echo ""${arg#*=}" does not match the expected format. Setting the default value of $interval."
					else
						interval="${arg#*=}"
				fi

				;;
				# This is an arg value type option. Will catch -o value or --output-file value
				-i|--interval)
				shift
				interval="$1"
				;;
				*)
			echo "Unknown argument $arg provided"
			usage
			;;
			esac
			# Shift after checking all the cases to get the next option
			shift
		done
		if [[ -z $interval ]]; then interval=0.5s; fi
fi

while true;
do
	sleep $interval
	local sequence=$(date +%N )
	local number=${sequence:0:1}
	
	#if [[ ${#number} -gt 1 ]];
	#	then
	#		if [[ $verbose -eq 0 ]]; then echo "$(date +%c) :Since the number has ${#number} digits, we will substract by 1"; fi	
	#		number=$((number - 1 ))
	if [[ $number -eq 0 ]];
		then
			if [[ $verbose -eq 0 ]]; then echo "$(date +%c) :Since the number is $number, we will add by 1"; fi
			number=$((number + 1 ))
	fi
	
	if [[ $verbose -eq 0 ]];
		then		
			
			echo "$(date +%c) : The random number from 1-10: $number from the sequence $sequence"
		else
			echo "The random number from 1-10 is: $number"
	fi
done

}


main