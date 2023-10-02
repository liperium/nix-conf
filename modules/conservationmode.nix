{ stdenv, lib, writeShellScriptBin }:
let
  conservationmode = writeShellScriptBin "conservationmode"''
    #!/bin/sh
    conservationmode_file=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
    if [ "$1" = "status" ]
    then
        cat $conservationmode_file
    elif [ "$1" = "on" ]
    then 
        echo 1 | sudo tee $conservationmode_file
    elif [ "$1" = "off" ]
    then 
        echo 0 | sudo tee $conservationmode_file
    elif [ "$1" = "-h" ] || [ "$1" = "-help" ]
    then
        printf " -h/-help : help \n on : turns conservation_mode on \n off : turns conservation_mode off \n status : returns on/off (1/0)\n"
    fi
  '';
in {
  environment.systemPackages = [ conservationmode ];
}