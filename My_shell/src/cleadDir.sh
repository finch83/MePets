#!/bin/bash


regexp=".*/Partition[0-1]{1}\.[0-9]{8}T[0-9]{6}\.verified\.gz$"
FILEDATE=""
FILE1=""
FILEDATE1=0
FILE2=""
FILEDATE2=0
SRCDIR=""
REMOVEDFILES=()
REMOVEDIRS=()
# ToDo Add check for second paramenter
LEFTFILES=$2
declare -A MAPFILEDATE


#------------
check_args()
{
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
#    echo $tmpDir
    eval "$2=$tmpDir"
}


#------------
remove_file()
{
    if [ -d $1 ]; then
        REMOVEDIRS+=($1)
    else
        REMOVEDFILES+=($1)
    fi
}


#------------
check_args $1 SRCDIR

main()
{
    find $SRCDIR -regextype egrep ! -regex $regexp -delete

    for file in "$SRCDIR"/*
    do
        tmpFile=`basename "$file"`

        if [ -d "$file" ]; then
            remove_file $file
            continue
        fi
    
        FILEDATE=`echo $tmpFile | awk -F'.' '{print $2}' | awk -F'T' '{print $1$2}'`
        MAPFILEDATE[$file]=$FILEDATE

    done

    sortedString=`for key in ${!MAPFILEDATE[@]};
    do
        echo ${key} ${MAPFILEDATE[${key}]}
    done | sort -k2rn | awk '{ print $1}'`

    sortedArray=($(echo $sortedString | tr "\n" " "))
    for (( i = $LEFTFILES; i < ${#sortedArray[@]}; i++ )); do
        remove_file ${sortedArray[i]}
    done
    
    echo "*----------Removed Dirs----------*"
    for (( i = 0; i < ${#REMOVEDIRS[@]}; i++ )); do
        rm -rf ${REMOVEDIRS[i]}
        echo "${REMOVEDIRS[i]}"
    done
    
    echo "*----------Removed Files----------*"
    for (( i = 0; i < ${#REMOVEDFILES[@]}; i++ )); do
        rm -f ${REMOVEDFILES[i]}
        echo "${REMOVEDFILES[i]}"
    done
    
    echo "*----------Left files----------*"
    for (( i = 0; i < $LEFTFILES; i++ )); do
        echo ${sortedArray[i]}
    done
}

main
