#!/bin/bash
set -e

#Xvfb $DISPLAY -screen 0 800x600x16 &
Xvfb $DISPLAY &

if [ "$CHROME" = true ] ; then
    echo "Running chromedriver"
    chromedriver &
    sleep 1
fi

if [ "$FIREFOX" = true ] ; then
    echo "Running geckodriver"
    geckodriver &
    sleep 1
fi

if [ "$VNC" = true ] ; then
    echo "Running VNC"
    x11vnc &
fi

exec "$@"
