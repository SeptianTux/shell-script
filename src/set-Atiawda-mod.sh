#!/bin/bash

_GTK_THEME_NAME=""
_SHELL_THEME_NAME=""
_ICON_NAME=""
_WALLPAPER_FILE=""
_TERMINAL_PROFILE=""
_GEDIT_SCHEME=""
_FIREFOX_HOME_THEME=""
_POWERLINE_SHELL_THEME=""
_NCMPCPP_THEME=""


function iniT() {
    if [ $EUID -eq 0 ]
    then
        echo "please use normal user...."
        exit 2
    fi
}

###########################################################################################################
function getProfileList() {
    local profile_list="$(dconf read /org/gnome/terminal/legacy/profiles:/list)"
    local profile_list_ret=$(echo $profile_list | sed -e "s/[[,',,]//g" | sed "s/]//")
    
    echo $profile_list_ret;
}

function alienProfileNameToHumanProfileName() {
    local name=$(dconf read /org/gnome/terminal/legacy/profiles:/:$1/visible-name | sed "s/'//g")    
    echo $name
}

function humanProfileNameToAlienProfileName() {
    local profile_list_arr=($(getProfileList))
    local human_profile_name=""
        
    for i in ${profile_list_arr[@]}
    do
        human_profile_name=$(alienProfileNameToHumanProfileName "$i")
        
        if [ "$1" == "$human_profile_name" ]
        then
            break
        fi
    done
    
    echo $i
}

function setTerminalUsingHumanProfileNameArg() {
    local alien_profile_name=$(humanProfileNameToAlienProfileName "$1")
    
    gsettings set org.gnome.Terminal.ProfilesList default "$alien_profile_name"
    
    if [ $? -eq 0 ]
    then
        return 0
    fi
    
    return 69
}
###########################################################################################################

###########################################################################################################
function setFirefoxHomeTheme() {
    if [ "$1" == "light" ]
    then
        sed -i 's/css\/custom-[a-zA-Z]*.css/css\/custom-light.css/g' /home/septian/Projects/FirefoxHome/index.html
    elif  [ "$1" == "dark" ]
    then
        sed -i 's/css\/custom-[a-zA-Z]*.css/css\/custom-dark.css/g' /home/septian/Projects/FirefoxHome/index.html
    else
        sed -i 's/css\/custom-[a-zA-Z]*.css/css\/custom-dark.css/g' /home/septian/Projects/FirefoxHome/index.html
    fi
}
###########################################################################################################


###########################################################################################################
function setPowerlineTheme() {
    local cfg_dir=/usr/local/lib/python2.7/dist-packages/powerline/config_files/colorschemes
    
    if [ -f $cfg_dir/default-$1.json ]
    then
        sudo cp -v $cfg_dir/default-$1.json $cfg_dir/default.json
    fi
}
###########################################################################################################

###########################################################################################################
function ncpcppTheme() {
    if [ ! -f $HOME/.ncmpcpp/config-light ] || [ ! -f $HOME/.ncmpcpp/config-dark ]
    then
        echo "ncmpcpp config file is missing..."
        return
    fi
    
    if [ "$_NCMPCPP_THEME" == "light" ]
    then
        cp -v $HOME/.ncmpcpp/config-light $HOME/.ncmpcpp/config
    elif [ "$_NCMPCPP_THEME" == "dark" ]
    then
        cp -v $HOME/.ncmpcpp/config-dark $HOME/.ncmpcpp/config
    else
        echo "ncmpcppTheme() : _NCMPCPP_THEME is not set."
    fi
}
###########################################################################################################


function helpMe() {
    echo "usage :"
    echo -e "\t$0 [dark] or [light]"
    echo 
    echo "example :"
    echo -e "\t$0 dark"
    echo -e "\t$0 light"
}

function light() {
    _GTK_THEME_NAME="Atiawda"
    _SHELL_THEME_NAME="Atiawda"
#    _ICON_NAME="Papirus"
    _WALLPAPER_FILE="/usr/share/desktop-base/lines-theme/wallpaper/gnome-background.xml"
    _TERMINAL_PROFILE="Gnome"
    _GEDIT_SCHEME="builder"
    _FIREFOX_HOME_THEME="light"
    _POWERLINE_SHELL_THEME="light"
    _NCMPCPP_THEME="light"
}

function dark() {
    _GTK_THEME_NAME="Atiawda-Dark"
    _SHELL_THEME_NAME="Atiawda-Dark"
#    _ICON_NAME="Papirus-Dark"
    _WALLPAPER_FILE="/home/septian/.local/share/backgrounds/2019-11-07-20-53-07-texture.png"
    _TERMINAL_PROFILE="GNOME"
    _GEDIT_SCHEME="builder-dark"
    _FIREFOX_HOME_THEME="dark"
    _POWERLINE_SHELL_THEME="dark"
    _NCMPCPP_THEME="dark"
}

function set() {
    gsettings set org.gnome.desktop.interface gtk-theme $_GTK_THEME_NAME
#    gsettings set org.gnome.desktop.interface icon-theme $_ICON_NAME
    setTerminalUsingHumanProfileNameArg "$_TERMINAL_PROFILE"
    gsettings set org.gnome.gedit.preferences.editor scheme "$_GEDIT_SCHEME"
    setFirefoxHomeTheme "$_FIREFOX_HOME_THEME"
    gsettings set org.gnome.desktop.background picture-uri "file://$_WALLPAPER_FILE"
    ncpcppTheme
    setPowerlineTheme "$_POWERLINE_SHELL_THEME"
}

function fire() {
    iniT

    case $1 in
        'light' )
            light
            ;;
        'dark' )
            dark
            ;;
        'help' | '--help' )
            helpMe
            exit 0
            ;;
        * )
            helpMe
            exit 1
            ;;
    esac

    set
}

fire $1
