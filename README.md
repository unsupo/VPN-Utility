# VPN-Utility
I was tired of swapping vpns and entering my password many times a day to do this
so i created this script to do it for me.

## Notes:
must first stop cisco anyconnect for this to work

## Help `vpn -h`
CISCO Any Connect Script
- -d|--disconnect)
  - Use this method to disconnect from whatever vpn you are on
- -c|--connect)
  - Use this method along with a parameter to connect to a vpn
  This will disconnect if not connected to specified vpn
  A group is added as a third parameter
  - example:
  - `cisco -c vpn-name`
- -g|--get-connected)
  - Use this method to get the currently connected vpn

`cd VPN-Utility`

for just the utility

`ln -s $(pwd)/vpn /usr/local/bin/vpn`

for the utility and the bitbar plugin

`sh bitbar-installation.sh`

## Completed
- use https://github.com/matryer/bitbar to add what vpn you're connected to the the
mac toolbar
- Also use bitbar to disconnect and connect to various vpns
- set the available vpns to the ones listed in cisco

## TODO
- set available vpns to custom ones in a properties file or global variable...
- tie this together with my SSH-Utility to swap to a vpn when you need to connect
to a host on a different vpn

