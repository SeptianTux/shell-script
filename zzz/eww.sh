#!/bin/bash

function fireNow()
{
    xfce4-terminal --initial-title=xfce4-term-float
    sleep 0.2
    i3-msg "move up 355; move left 663; resize grow height 718px or 718ppt; resize grow width 200px or 200ppt"
    sleep 0.2

    xfce4-terminal --initial-title=xfce4-term-float
    sleep 0.2
    i3-msg "move up 355; move right 96; resize grow height 143px or 143ppt"
    sleep 0.2

    xfce4-terminal --initial-title=xfce4-term-float
    sleep 0.2
    i3-msg "move down 100; move right 96; resize grow height 260px or 260ppt"
    sleep 0.2

    xfce4-terminal --initial-title=xfce4-term-float
    sleep 0.2
    i3-msg "move up 355; move right 655; resize grow height 719px or 718ppt; resize grow width 11px or 11ppt"
    sleep 0.2
}

fireNow
