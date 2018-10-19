#!/bin/bash

if [ "$1" != "" ]; then
    if [ -d "$1" ]; then
        cd "$1"
        tmpDir=`pwd`
        if [ -z "$(ls -A $tmpDir)" ]; then
            echo "Empty Dir"
            exit 1
        fi
    else
        echo "Dir not found"
        exit 1 
    fi
else
    echo "No cli arguments"
    exit 1
fi

SRCDIR=$tmpDir
echo "Source Dir: $SRCDIR"

regexp="^Partition[0-1]{1}\.[0-9]{8}T[0-9]{6}\.verified\.gz$"

FILEDATE=""
FILE1=""
FILEDATE1=0
FILE2=""
FILEDATE2=0

rm -f "$SRCDIR"/.*

for file in "$SRCDIR"/*
do
#    echo "$file"
    tmpFile=`basename "$file"`

    if [ -d "$file" ]; then
        rm -rf $file
        continue
    fi

    if [[ "$tmpFile" =~ $regexp ]]; then 
        FILEDATE=`echo $tmpFile | awk -F'.' '{print $2}' | awk -F'T' '{print $1$2}'`
        if [ "$FILE1" == "" ]; then
            FILE1=$file
            FILEDATE1=$FILEDATE
            continue
        elif [ "$FILE2" == "" ]; then
            FILE2=$file
            FILEDATE2=$FILEDATE
            if [ $FILEDATE -gt $FILEDATE1 ]; then
                FILEDATE2=$FILEDATE1
                FILE2=$FILE1
                FILEDATE1=$FILEDATE
                FILE1=$file
                continue
           fi
        fi

        if [ $FILEDATE -gt $FILEDATE2 ]; then
            if [ $FILEDATE -gt $FILEDATE1 ]; then
                echo "Remove File: $FILE2"
                rm $FILE2
                FILE2=$FILE1
                FILEDATE2=$FILEDATE1
                FILE1=$file
                FILEDATE1=$FILEDATE
            else
               FILE2=$file
               FILEDATE2=$FILEDATE
            fi
        else
            echo "Remove File: $file"
            rm $file
        fi
    else
        echo "Remove File: $file"
        rm $file 
   fi
   echo

done


echo
echo "File1: $FILE1"
echo "File1Date: $FILEDATE1"
echo "File2: $FILE2"
echo "File2Date: $FILEDATE2"

