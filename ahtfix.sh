#!/bin/bash
PATH="/sbin:/usr/sbin:/bin:/usr/bin"

# AHTfix
# Restore the Apple Hardware Test (AHT) on your (old) Mac.
#
# Copyright 2019 Johann N. Loefflmann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


###############################################################################
# This function transforms a string to a number.
#
# Even Mac OS X 10.9.5 bundles Bash 3.2.53 and not Bash 4.
# Bash 3.x only supports associative arrays indexed by a number
# and not by a string.
###############################################################################
function hash {
    echo $1 | cksum | tr -d '0' | tr -d ' '
}


###############################################################################
# Determines the board ID of the Mac where this program is running on
#
# output: $ID
###############################################################################
function boardID {
   # get the board id (e.g. Mac-F42D89C8)
   ID=$(/usr/sbin/ioreg -l | grep board-id)
   ID=${ID#*=}
   ID=${ID/<\"/}
   ID=${ID/\">/}
   ID=$(echo "$ID" | tr -d ' ')
}


###############################################################################
# Determines the model ID of the Mac where this program is running on
#
# output: $MODEL
###############################################################################
function model {
    # get the model ID (e.g. MacBook5,1)
    MODEL=$(system_profiler SPHardwareDataType | grep 'Model Identifier' | awk -F: '{ print $2 }')
}


###############################################################################
# prints the board ID of this Mac
#
# input:  n/a
# output: "Board ID is <ID>"
###############################################################################
function printBoardID {
   # echo Board ID is "x-$ID-x"
   echo Board ID is $ID
}


###############################################################################
# setup the hash map between board id and filename
# see also https://github.com/upekkha/AppleHardwareTest
#
# input: n/a
# output: $ARRAY
###############################################################################
function initHashMap {

    # MacBook
    # -------
    ARRAY[$(hash Mac-F4208CA9)]=018-2590-A # MacBook2,1
    ARRAY[$(hash Mac-F4208CAA)]=018-2766-A # MacBook2,1
    ARRAY[$(hash Mac-F22788C8)]=018-3085-A # MacBook3,1
    ARRAY[$(hash Mac-F22788A9)]=022-3862-A # MacBook4,1
    ARRAY[$(hash Mac-F42D89A9)]=022-4216-A # MacBook5,1
    ARRAY[$(hash Mac-F42D89C8)]=022-4037-A # MacBook5,1
    ARRAY[$(hash Mac-F22788AA)]=022-4299-A # MacBook5,2
    ARRAY[$(hash Mac-F22C8AC8)]=022-4453-A # MacBook6,1
    ARRAY[$(hash Mac-F22C89C8)]=022-4705-A # MacBook7,1

    # MacBook Pro
    # -----------
    ARRAY[$(hash 3A106)]=018-2398-A        # MacBookPro1,1 
    ARRAY[$(hash 3A107)]=018-2405-A        # MacBookPro1,1
    ARRAY[$(hash Mac-F42189C8)]=018-2592-A # MacBookPro2,1 
    ARRAY[$(hash Mac-F42187C8)]=018-2591-A # MacBookPro2,2
    ARRAY[$(hash Mac-F42388C8)]=018-2833-A # MacBookPro3,1
    ARRAY[$(hash Mac-F4238BC8)]=018-2770-A # MacBookPro3,1
    ARRAY[$(hash Mac-F42C86C8)]=022-3832-A # MacBookPro4,1
    ARRAY[$(hash Mac-F42C89C8)]=022-3833-A # MacBookPro4,1
    ARRAY[$(hash Mac-F42D86A9)]=022-4266-A # MacBookPro5,1
    ARRAY[$(hash Mac-F42D86C8)]=022-4048-A # MacBookPro5,1
    ARRAY[$(hash Mac-F2268EC8)]=022-4217-A # MacBookPro5,2
    ARRAY[$(hash Mac-F22587C8)]=022-4343-A # MacBookPro5,3
    ARRAY[$(hash Mac-F22587A1)]=022-4344-A # MacBookPro5,4
    ARRAY[$(hash Mac-F2268AC8)]=022-4339-A # MacBookPro5,5
    ARRAY[$(hash Mac-F22589C8)]=022-4596-A # MacBookPro6,1
    ARRAY[$(hash Mac-F22586C8)]=022-4597-A # MacBookPro6,2
    ARRAY[$(hash Mac-F222BEC8)]=022-4653-A # MacBookPro7,1
    ARRAY[$(hash Mac-94245B3640C91C81)]=022-5052-A # MacBookPro8,1
    ARRAY[$(hash Mac-94245A3940C91C80)]=022-5053-A # MacBookPro8,2
    ARRAY[$(hash Mac-942459F5819B171B)]=022-5054-A # MacBookPro8,3
    ARRAY[$(hash Mac-4B7AC7E43945597E)]=022-5879-A # MacBookPro9,1 
    ARRAY[$(hash Mac-6F01561E16C75D06)]=022-5879-A # MacBookPro9,2
    ARRAY[$(hash Mac-C3EC7CD22292981F)]=022-5882-A # MacBookPro10,1

    # MacBook Air
    # -----------
    ARRAY[$(hash Mac-F42C8CC8)]=018-3259-A # MacBookAir1,1
    ARRAY[$(hash Mac-F42D88C8)]=022-4114-A # MacBookAir2,1
    ARRAY[$(hash Mac-942452F5819B1C1B)]=022-4704-A # MacBookAir3,1
    ARRAY[$(hash Mac-942C5DF58193131B)]=022-4267-A # MacBookAir3,2
    ARRAY[$(hash Mac-C08A6BB70A942AC2)]=022-5205-A # MacBookAir4,1
    ARRAY[$(hash Mac-742912EFDBEE19B3)]=022-5205-A # MacBookAir4,2
    ARRAY[$(hash Mac-66F35F19FE2A0D05)]=022-5745-A # MacBookAir5,1
    ARRAY[$(hash Mac-2E6FAB96566FE58C)]=022-5745-A # MacBookAir5,2

    # MacMini
    # -------
    # MacMini v1.1GMc2
    # MacMini1,1 3A102
    ARRAY[$(hash Mac-F4208EAA)]=018-2886-A # MacMini2,1
    ARRAY[$(hash Mac-F22C86C8)]=022-4292-A # MacMini3,1
    ARRAY[$(hash Mac-F2208EC8)]=022-4739-A # MacMini4,1
    ARRAY[$(hash Mac-8ED6AF5B48C039E1)]=022-5207-A # MacMini5,1
    ARRAY[$(hash Mac-4BC72D62AD45599E)]=022-5207-A # MacMini5,2

    # iMac
    # ----
    # iMac v2.5.1GMc1
    # iMac v2.5.2GMc5
    # iMac v2.5.3GMc1
    # iMac4,1 3A103
    ARRAY[$(hash Mac-F4228EC8)]=018-2534-A # iMac5,1 
    ARRAY[$(hash Mac-F42786A9)]=018-2533-A # iMac5,1 
    ARRAY[$(hash Mac-F4218EC8)]=018-2535-A # iMac5,2 
    ARRAY[$(hash Mac-F4218FC8)]=018-2579-A # iMac6,1 
    ARRAY[$(hash Mac-F42386C8)]=018-2845-A # iMac7,1
    ARRAY[$(hash Mac-F226BEC8)]=022-3936-A # iMac8,1
    ARRAY[$(hash Mac-F227BEC8)]=022-3937-A # iMac8,1
    ARRAY[$(hash Mac-F2218EA9)]=022-4297-A # iMac9,1 
    ARRAY[$(hash Mac-F2218EC8)]=022-4293-A # iMac9,1
    ARRAY[$(hash Mac-F2218FC8)]=022-4294-A # iMac9,1
    # only the latest images 
    # ARRAY[$(hash Mac-F2268CC8)]=022-4451-A # iMac10,1
    ARRAY[$(hash Mac-F2268CC8)]=022-4647-A # iMac10,1
    # ARRAY[$(hash Mac-F2268DC8)]=022-4452-A # iMac10,1 
    ARRAY[$(hash Mac-F2268DC8)]=022-4644-A # iMac10,1
    ARRAY[$(hash Mac-F2238AC8)]=022-4703-A # iMac11,2 
    ARRAY[$(hash Mac-F2238BAE)]=022-4776-A # iMac11,3 
    # ARRAY[$(hash Mac-942B5BF58194151B)]=022-5090-A # iMac12,1
    ARRAY[$(hash Mac-942B5BF58194151B)]=022-5344-A # iMac12,1
    ARRAY[$(hash Mac-942B59F58194171B)]=022-5091-A # iMac12,2

    # MacPro
    # ------
    ARRAY[$(hash Mac-F4208DC8)]=018-2769-A # MacPro1,1
    ARRAY[$(hash Mac-F4208DA9)]=018-2667-A # MacPro2,1
    # only the latest images
    # ARRAY[$(hash Mac-F42C88C8)]=018-3273-A # MacPro3,1
    # ARRAY[$(hash Mac-F42C88C8)]=022-3843-A # MacPro3,1
    ARRAY[$(hash Mac-F42C88C8)]=022-4020-A # MacPro3,1
    # only the latest images
    # is the model really important ?
    # ARRAY[$(hash Mac-F221BEC8)]=022-4149-A # MacPro4,1
    ARRAY[$(hash Mac-F221BEC8)]=022-4831-A # MacPro5,1
    
    # Xserve
    # ------
    ARRAY[$(hash Mac-F4208AC8)]=018-3282-A # Xserve1,1
    ARRAY[$(hash Mac-F42289C8)]=018-3282-A # Xserve2,1
}


###############################################################################
# Are there any collisions due to our hash function ?
# exits if a collision is detected
#
# input: $ARRAY
# ouput: n/a
###############################################################################
function checkForCollisions {
    # the size of the hash map
    SIZE=${#ARRAY[@]}
    # the number of additions to the hash map in this script
    LINES=$(cat $0 | grep -e "^    ARRAY\[" | wc -l)
    if [ $SIZE -ne $LINES ]; then
        echo "Fatal Error in script: Collision in hash map detected!"
        exit
    fi
}


###############################################################################
# print out the entire hash map
#
# input:  $ARRAY
# output: "key: <key> value: <value>
###############################################################################
function printEntireHashMap {
    for key in "${!ARRAY[@]}"
    do
        echo "key: " $key "value: " ${ARRAY[$key]}
    done
}


###############################################################################
# download all files that are being referenced by the hash map
###############################################################################
function downloadAllFiles {
    for key in "${!ARRAY[@]}"
    do
        FILENAME=${ARRAY[$key]}.dmg
        echo $FILENAME
        downloadDMGbyFilename
        checkIntegrityOfDMG
    done
}


###############################################################################
# Download the .dmg file if it is not there yet
#
# input:  $FILANAME
# output: n/a
###############################################################################
function downloadDMGbyFilename {
    # download the file
    if ! [ -f "$FILENAME" ]; then
        echo Downloading the file $FILENAME from $URL ...
        URL=https://download.info.apple.com/Apple_Hardware_Test/$FILENAME
        curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.74.9 (KHTML, like Gecko) Version/7.0.2 Safari/537.74.9" -L -O "$URL"
    else
        echo $FILENAME found. Skipping download.
    fi
}


###############################################################################
# Download the image that is identified by ID if not done already.
# Exits with a message if the board ID is not supported.
#
# input:  $ARRAY, $ID
# output: n/a
###############################################################################
function downloadDMGbyID {
    if [[ ${ARRAY[$(hash $ID)]} ]]; then
        FILENAME=${ARRAY[$(hash $ID)]}.dmg
        downloadDMGbyFilename
    else
        echo Board ID $ID is not supported.
        exit
    fi
}


###############################################################################
# Checks the integrity of the .dmg file.
# Exits if the file is corrupt.
#
# input: $FILENAME
# output: n/a
###############################################################################
function checkIntegrityOfDMG {
    echo Checking integrity of $FILENAME ...
    INTEGRITY=$(hdiutil verify $FILENAME 2> /dev/stdout | tail -1)
    INTEGRITY=${INTEGRITY##* }
    if [ $INTEGRITY == "VALID" ]; then
        echo "Ok."
    else
        echo File $FILENAME is corrupt.
        exit
    fi
}


###############################################################################
# Mounts the DMG
#
# input: $FILENAME
# output: $DEVICE, $MOUNTPOINT
###############################################################################
function mountTheDMG {
    # mount the file
    echo Mounting $FILENAME ...
    MOUNT=$(hdiutil attach -nobrowse $FILENAME 2> /dev/stdout | tail -1)
    # if there is no error, the last line tells us both device and mountpoint
    DEVICE=${MOUNT%% *}
    # if there is an error, it is most likely an old image that needs to be
    # converted to a later image version; error message example:
    # hdiutil: attach failed - älteres Bild sollte konvertiert werden
    # in case of an error, the DEVICE value is "hdiutil:" rather than the device
    if [ $DEVICE == "hdiutil:" ]; then
        # we need to convert the image since it is an old image version‚
        hdiutil convert $FILENAME -format UDZO -o $FILENAME.converted.dmg
        # and mount it
        MOUNT=$(hdiutil attach -nobrowse $FILENAME.converted.dmg 2> /dev/stdout | tail -1)
        DEVICE=${MOUNT%% *}
    fi
    MOUNTPOINT=${MOUNT##*	}
    # echo "DEVICE--$DEVICE--"
    # echo "MOUNTPOINT--$MOUNTPOINT--"
}


###############################################################################
# Unmounts the mounted DMG
#
# input:  $DEVICE
# output: n/a
###############################################################################
function unmountTheDMG {
    echo Unmounting $DEVICE ...
    hdiutil detach $DEVICE
}


###############################################################################
# Copy the .diagnostics folder recursively to the system folder
#
# dependencies: mountTheDMG, unmountTheDMG
# input:  n/a
# output: n/a
###############################################################################
function copyDMGContentToSystem {
    DEST=/System/Library/CoreServices
    if ! [ -d $DEST/.diagnostics ]; then

        mountTheDMG

        # copying
        SOURCE=$MOUNTPOINT/System/Library/CoreServices/.diagnostics
        echo Copying from $SOURCE to $DEST ...
        cp -PR $SOURCE $DEST

        unmountTheDMG

    else
        echo Folder $DEST/.diagnostics already exists. Skipping copy.
    fi
}


###############################################################################
# Copy the AHT to the USB device that is mounted on /Volumes/CopyAHTHere
#
# input:  n/a
# output: n/a
#
###############################################################################
function copyAHTtoUSB {
    echo "Insert USB Stick"
    
}


###############################################################################
# Does the initialization
#
# dependencies: see function body
# input: n/a
# output: n/a
###############################################################################
function init {
    initHashMap
    checkForCollisions
}


###############################################################################
# The end routine
#
# input:  n/a
# output: n/a
###############################################################################
function end {
    # Let's do some housekeeping
    # $FILENAME.converted.dmg
    if [ -f $FILENAME.converted.dmg ]; then
        rm $FILENAME.converted.dmg
    fi
    echo Done.
}


###############################################################################
# Prints the syntax of this script
#
# input:  n/a
# output: n/a
###############################################################################
function help {
    cat << EOF
NAME
    AHTFix v1.0.0 -- downloads and installs the Apple Hardware Test (AHT)
    
SYNOPSIS
    ahtfix [option]
    
DESCRIPTION
    By default (without any option) ahtfix installs the AHT to this Mac OS X
    instance.

OPTIONS
    -help       print this help
    
    -info       print the boardID of this Mac, the location of the
                corresponding AHT image, and whether the .dmg is locally
                available

    -fillcache  download all known AHT images from the Apple server

    -burn [ID]  burns the AHT image that belongs to the board ID to an optical
                media in an attached burning device. 

    -tousb [ID] copy the AHT of the board ID to the USB device that is 
                mounted at /Volumes/CopyAHTHere

EOF
}


###############################################################################
# makes sure that the process runs under root permissions
# does not work if it script has been started by the Platypus wrapper
# dependencies: n/a
# input: n/a
# output: n/a
###############################################################################
function rootPermissionsRequired {
    if [ "$(id -u)" != "0" ]; then
        echo "This script has to be run as root. Exit."
        exit 1
    fi
}


###############################################################################
# Installs the AHT to this Mac instance
#
# dependencies: see function body
# input: n/a
# output: n/a
###############################################################################
function installAHTToThisMac {
    # rootPermissionsRequired
    boardID
    printBoardID
    downloadDMGbyID
    checkIntegrityOfDMG
    copyDMGContentToSystem
    end
}


###############################################################################
# Print information
#
# dependencies: boardID 
# input: $ARRAY
# ouput: n/a
###############################################################################
function printInfo {
    boardID
    echo Board ID: $ID
    FILENAME=${ARRAY[$(hash $ID)]}.dmg    
    echo Location: https://download.info.apple.com/Apple_Hardware_Test/$FILENAME
    if [ -f "$FILENAME" ]; then
       echo Local copy available: YES
    else
       echo Local copy available: NO
    fi
}


function burnDMG {
    echo "Please insert a writable optical media (e.g. CD-R, CD-RW, etc.) into your burning device ..." 
    hdiutil burn $FILENAME
}

###############################################################################
# The main function
#
# input: program arguments
# output: n/a
###############################################################################
function main {

    # help
    if [ $# -eq 1 -a "$1" = "-help" ]; then
        help
        exit
    fi

    # any other options than -help require an actual initialization
    init

    # fill the cache
    if [ $# -eq 1 -a "$1" = "-fillcache" ]; then
        downloadAllFiles
        end
        exit
    fi

    # print the IDs
    if [ $# -eq 1 -a "$1" = "-info" ]; then
        printInfo
        exit
    fi

    # burn on CD-ROM
    if [ $# -eq 1 -a "$1" = "-burn" ]; then
        if [ $# -eq 2 ]; then
            ID=$2
        else
            boardID
        fi
        downloadDMGbyID
        checkIntegrityOfDMG
        burnDMG
        end    
        exit
    fi

    if [ $# -eq 1 -a "$1" = "-tousb" ]; then
        if [ $# -eq 2 ]; then
            ID=$2
        else
            boardID
        fi
        downloadDMGbyID
        checkIntegrityOfDMG
        copyAHTtoUSB
        end
        exit
    fi

    

    installAHTToThisMac
}

main "$@"

