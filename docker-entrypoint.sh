#!/bin/bash
set -e

#Xvfb $DISPLAY -screen 0 800x600x16 &
Xvfb $DISPLAY -screen 0 1280x1280x16 &

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
