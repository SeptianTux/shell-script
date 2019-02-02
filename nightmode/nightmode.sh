#!/bin/bash

NIGHT_MODE_CMD="/usr/bin/redshift -O 3800K"
NORMAL_MODE_CMD="/usr/bin/redshift -x"
NOW_H=$(date "+%H")
NOW_M=$(date "+%M")
NIGHT_MODE=1
NORMAL_MODE=0
NIGHT_MODE_STATUS=0
LOCK_FILE=/var/lock/nightmode.lock
NIGHT_MODE_WALLPAPER=/home/septian/Pictures/drawing-dark.png
NORMAL_MODE_WALLPAPER=/home/septian/Pictures/drawing.png
WP_SET=0

function termIfRoot()
{
    if [ $EUID -eq 0 ]
    then
        echo "Please use normal user to run this script."
        exit 66
    fi
}

function isRunning()
{
    local lockfile_val=""

    if [ -f $LOCK_FILE ]
    then
        lockfile_val=$(cat $LOCK_FILE)

        if  [ -d /proc/$lockfile_val ] && [ $(cat /proc/$lockfile_val/cmdline | grep -c $(basename $0)) -gt 0 ]
        then
           return 0
        fi
    fi

    return 1
}

function updateNowVar()
{
    NOW_H=$(date "+%H")
    NOW_M=$(date "+%M")
}

function setNightModeWallpaper()
{
    /usr/bin/feh --bg-scale $NIGHT_MODE_WALLPAPER
}

function setNormalModeWallpaper()
{
    /usr/bin/feh --bg-scale $NORMAL_MODE_WALLPAPER
}

function setWallpaperIfNotSet()
{
    if [ $WP_SET -eq 0 ]
    then
        if [ $1 == "night" ]
        then
            setNightModeWallpaper
            WP_SET=1
        else
            setNormalModeWallpaper
            WP_SET=1
        fi
    fi
}
	
	

function setNightMode()
{
    if [ $NOW_H -ge 18 -a $NOW_H -le 23 ] || [ $NOW_H -ge 0 -a $NOW_H -le 5 ]
    then
        if [ ! $NIGHT_MODE -eq $NIGHT_MODE_STATUS ]
        then
            NIGHT_MODE_STATUS=1
            WP_SET=0
            $NIGHT_MODE_CMD
        fi

        setWallpaperIfNotSet "night"
    else
        if [ ! $NORMAL_MODE -eq $NIGHT_MODE_STATUS ]
        then
            NIGHT_MODE_STATUS=0
            WP_SET=0
            $NORMAL_MODE_CMD
        fi

        setWallpaperIfNotSet "normal"
    fi
}

function nightModeOn()
{
    setNightModeWallpaper
    $NIGHT_MODE_CMD
}

function nightModeOff()
{
    setNormalModeWallpaper
    $NORMAL_MODE_CMD
}

function exitNow()
{
    echo $1
    exit $2
}

function looper()
{
    echo -n $BASHPID > $LOCK_FILE

    sleep 2

    while [ 1 ]
    do
        updateNowVar
        setNightMode
	
        sleep 300
    done
}

function killer()
{
    isRunning

    if [ $? -eq 0 ]
    then
        kill $(cat $LOCK_FILE)
        
        if [ $? -eq 0 ]
        then
            echo "Killed."
        else
            echo "Kill failed. "
        fi
        
        rm $LOCK_FILE
    else
        echo "Do nothing."
    fi
}

function statSelf()
{
    isRunning

    if [ $? -eq 0 ]
    then
        echo "Is running."
    else
        echo "Not running."
    fi
}

function getPid()
{
    isRunning

    if [ $? -eq 0 ]
    then
        cat $LOCK_FILE
        echo
    else
        echo "Not running."
    fi
}

function helpMe()
{
    echo -e "Usage  : $(basename $0) [option]\n"
    echo "Option :"
    echo -e "\t* stat\t: Running status."
    echo -e "\t* kill\t: Kill or terminate."
    echo -e "\t* on\t: Turn on night mode."
    echo -e "\t* off\t: Turn off night mode."
    echo -e "\t* auto\t: Run in auto mode."
    echo -e "\t* pid\t: Get pid of $(basename $0)"
    echo -e "\t* help\t: Help."
}

function fire()
{
    termIfRoot
    isRunning

    if [ $? -eq 0 ]
    then
        echo "$(basename $0) is already running."
        updateNowVar
        setNightMode
        exit 69
    fi

    looper &> /dev/null &
}

case $1 in
    "kill" | "terminate") killer
        ;;
    "stat" | "status") statSelf
        ;;
    "help" | "-h" | "--help" ) helpMe
        ;;
    "on") nightModeOn
        ;;
    "off") nightModeOff
        ;;
    "pid") getPid
        ;;
    "auto") fire
        ;;
    "") echo "run in auto mode"; fire
        ;;
    *) helpMe
        ;;
esac

