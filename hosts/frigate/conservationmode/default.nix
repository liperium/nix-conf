{ config
, pkgs
, lib
, ...
}:
let
  conservationmode = pkgs.writeShellScriptBin "conservationmode" ''
    #!/bin/sh
    conservationmode_file=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
    if [ "$1" = "status" ]
    then
        cat $conservationmode_file
    elif [ "$1" = "on" ]
    then 
        if [[ $EUID -ne 0 ]]; then
            echo "This script must be run as root. Re-executing with sudo..."
            sudo "$0" "$@"   # This will re-run the script as root
            exit $?          # Exit with the status returned by the sudo command
        fi
        echo 1 | sudo tee $conservationmode_file
    elif [ "$1" = "off" ]
    then 
        if [[ $EUID -ne 0 ]]; then
            echo "This script must be run as root. Re-executing with sudo..."
            sudo "$0" "$@"   # This will re-run the script as root
            exit $?          # Exit with the status returned by the sudo command
        fi
        echo 0 | sudo tee $conservationmode_file
    elif [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        printf " -h/-help : help \n on : turns conservation_mode on \n off : turns conservation_mode off \n status : returns on/off (1/0)\n"
    fi
  '';
in
{
  environment.systemPackages = [ conservationmode ];

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/conservationmode";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };
}
