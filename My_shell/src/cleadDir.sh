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
LEFTFILES=$2
declare -A MAPFILEDATE


#------------
# Check input arguments
# ToDo Add check for second paramenter
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
# Push first argument to Array depends on type
# REMOVEDIRS	-	Array of dirs for remove
# REMOVEDFILES	-	Array of files for remove
remove_element()
{
    if [ -d $1 ]; then
    	if [ $1 != $SRCDIR ]; then
    		for ((j = 0; j < ${#REMOVEDIRS[@]}; j++));
    		do
    			if [ $1 == ${REMOVEDIRS[j]} ]; then
                    return
                fi
            done
            REMOVEDIRS+=($1)
        fi
    else
        REMOVEDFILES+=($1)
    fi
}


#------------
# Main function
main()
{
check_args $1 SRCDIR

# Get array of elements which do not match with pattern	
	regexString=`find $SRCDIR -regextype egrep ! -regex $regexp`
    findarr=($(echo $regexString))
    for ((i = 0; i < ${#findarr[@]}; i++));
    do
        remove_element ${findarr[i]}
    done

# Clear dir from dirs which matches with pattern
# Create associative array MAPFILEDATE with values
# Key	= File Name
# Value	= File Date 
    for file in "$SRCDIR"/*
    do
        tmpFile=`basename "$file"`

        if [ -d "$file" ]; then
            remove_element $file
            continue
        fi
    
        FLAG=0
        for ((i = 0; i < ${#REMOVEDFILES[@]}; i++));
        do
            if [ $file == ${REMOVEDFILES[i]} ];then
            	FLAG=1
                break
        	fi
        done
        
        if [ $FLAG -eq 0 ]; then
            FILEDATE=`echo $tmpFile | awk -F'.' '{print $2}' | awk -F'T' '{print $1$2}'`
            MAPFILEDATE[$file]=$FILEDATE
        else
        	FLAG=0
        fi
        
    done

# Sort MAPFILEDATE by value
# and get a String with file names as result
    sortedString=`for key in ${!MAPFILEDATE[@]};
    do
        echo ${key} ${MAPFILEDATE[${key}]}
    done | sort -k2rn | awk '{ print $1}'`

# Get an Array from String by replacing '\n' with ' '
    sortedArray=($(echo $sortedString | tr "\n" " "))

# Push elemets in releted arrays    
    for (( i = $LEFTFILES; i < ${#sortedArray[@]}; i++ )); do
        remove_element ${sortedArray[i]}
    done
    
# Remove elements
    echo "*----------Removed Files----------*"
    for (( i = 0; i < ${#REMOVEDFILES[@]}; i++ )); do
        rm -f ${REMOVEDFILES[i]}
        echo "${REMOVEDFILES[i]}"
    done

    echo "*----------Removed Dirs----------*"
    for (( i = 0; i < ${#REMOVEDIRS[@]}; i++ )); do
        rm -rf ${REMOVEDIRS[i]}
        echo "${REMOVEDIRS[i]}"
    done

    echo "*----------Left files----------*"
    for (( i = 0; i < $LEFTFILES; i++ )); do
        echo ${sortedArray[i]}
    done
}


# Call main()
main $1 
