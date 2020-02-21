#!/bin/ash

if [ ! -f /data/adbkey ] ; then
  echo "Generating ADB key"
  adb keygen /data/adbkey
fi

echo "Starting ADB server"
adb -a server nodaemon
