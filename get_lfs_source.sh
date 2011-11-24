#!/bin/bash
# create by Raiden Awkward <raiden.ht@gmail.com>
# on 20111124
# for downloading sources from wget-list


DOWNLOADER=wget
LOGFILE="./log"


##

function usage_print {
	echo usage : SCRIPT [wget-list] [target path]
}

function peel_file_name {
	echo ${1##*/}
}

if [ -z $1 ] || [ -z $2 ]
then
	usage_print
	exit 1
fi

URL_LIST=$1
TARGET_PATH=$2

if ! [ -f $URL_LIST ]
then
	echo file $URL_LIST not exits
	exit 1
fi

if ! [ -d $TARGET_PATH ]
then
	mkdir -p $TARGET_PATH
	if ! [ $? -eq 0 ]
	then
		exit 1
	fi
fi

echo "this is a log from $0" > $LOGFILE
echo `date` >> $LOGFILE
echo >> $LOGFILE

cat $URL_LIST |  while read line
do
	file=`peel_file_name $line`
	echo $TARGET_PATH/$file
	if [ -f $TARGET_PATH/$file ]
	then
		echo skipped existed file $file
		echo "[skipped]		$line >>" $LOGFILE
		continue
	fi

	$DOWNLOADER -O $TARGET_PATH/$file $line

	if ! [ $? -eq 0 ]
	then
		echo failed downloading $line
		echo "[failed]		$line" >> $LOGFILE
	else
		echo "[succeed]		$line" >> $LOGFILE
	fi
done

echo all done
