# AHTfix

Restore the Apple Hardware Test (AHT) on your (old) Mac.

## The Problem

„Apple Hardware Test (AHT) contains a suite of diagnostics that will test the hardware of your computer. […]
If your Mac was released after June 2013, you will use Apple Diagnostics rather than Apple Hardware Test (AHT).“
See also https://support.apple.com/en-us/HT201257

If you have reinstalled an older Mac from scratch, the diagnostic tools might no longer be available.
If there is content in /System/Library/CoreServices/.diagnostics you are affected. Unless you have the original disks
that came with your Mac, there seems to be no way to restore the AHT.

## The Solution

The application will determine the model of your Mac, query an Apple server, download the appropriate AHT binaries and
restore it on your Mac. And once restored you just need to follow the instructions at https://support.apple.com/en-us/HT201257
in order to perform all hardware diagnostics on your Mac.

Note: Starting with El Capitan (OS X 10.11) there is a new feature called System Integrity Protection (SIP) that prevents the modificaiton of a number of operating sytem directories by default.
In order to use AHTFix on El Capitan and later you have to disable SIP temporarily.
See also http://www.macworld.com/article/2986118/security/how-to-modify-system-integrity-protection-in-el-capitan.html

### System Requirements

* A Mac, released before June 2013
* Mac OS X 10.6 or later
* SIP disabled if you run El Capitan (OS X 10.11) or later
* An internet connection (any bandwidth)

### Usage

```bash
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
```

### Implementation details and credits

On https://github.com/upekkha/AppleHardwareTest you find detailed instructions from Claude Becker how to restore the AHT manually.
I put those instructions (and a few more) to a bash script so that you can restore the AHT in a comfortable way.

I also would like to thank Apple for hosting the AHT binaries on their servers. That really helps users to restore the AHT on Macs that would be otherwise incomplete.