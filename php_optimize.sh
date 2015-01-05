#!/bin/bash

### This script wraps the AWK script and handles all the optimization.

SCRIPTNAME=${0##*/}

## Usage.
function print_usage() {
    echo "usage: $SCRIPTNAME -p|-d [-m <memory limit>] [php.ini]"
    echo "Example: $SCRIPTNAME -p -m 2G /etc/php5/fpm/php.ini"
}

## Check Num of args .
if [ $# -lt 1 ] || [ $# -gt 4 ]; then
    print_usage
    exit 1
fi

## The default php.ini file.
INPUT_FILE=php.ini

## Get the input file in the case is given as argument.
case $# in
    2)
        INPUT_FILE=$2
        ;;
    4)
        INPUT_FILE=$4
        ;;
esac

## Optimize script.
AWK_SCRIPT=$(dirname $0)/php_optimize.awk
[ -r $AWK_SCRIPT ] || exit 0

## Create the temporary file for output.
TEMP_FILE=$(mktemp)

## Validate the given memory value.
function validate_memory() {
    [ -n "$(echo $1 | awk '/^[[:digit:]]+[MG]$/ {print}')" ]
}

## Run the optimization of the php.ini file for a production environment.
while getopts dm:p OPT; do
    case $OPT in
        p|+p)  # In a production environment.
            $AWK_SCRIPT -v is_prod=1 $INPUT_FILE | uniq > $TEMP_FILE
            ;;
        d|+d)  # In a development environment.
            $AWK_SCRIPT $INPUT_FILE | uniq > $TEMP_FILE
            ;;
        m|+m)
            if validate_memory $OPTARG; then
                echo $TEMP_FILE
                $AWK_SCRIPT -v is_prod=1 -v memory=$OPTARG $INPUT_FILE | uniq > $TEMP_FILE
            else
                print_usage
                exit 4
            fi
            ;;
        *) # Otherwise print a usage message.
            print_usage
            exit 3
    esac
done
shift $(( OPTIND - 1 ))
OPTIND=1

## Move the temporary file to the original one.
mv $TEMP_FILE $INPUT_FILE