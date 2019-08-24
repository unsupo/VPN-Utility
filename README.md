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
  - `cisco -c aloha-west`
- -g|--get-connected)
  - Use this method to get the currently connected vpn


`ln -s /usr/sbin/vpn vpn`


## TODO
- use https://github.com/matryer/bitbar to add what vpn you're connected to the the
mac toolbar
- tie this together with my SSH-Utility to swap to a vpn when you need to connect
to a host on a different vpn
