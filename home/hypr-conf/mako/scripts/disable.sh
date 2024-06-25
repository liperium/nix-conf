#!/bin/sh

# Define the file path
file_dir="/home/liperium/.local/share/dbus-1/services/"
file_name="fr.emersion.mako.service"

# Create the file with the specified content
cd $file_dir
rm $file_name
cat >> $file_name << 'END'
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=
SystemdService=
END

echo "File created at $file_dir$file_name"