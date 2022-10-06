#!/bin/bash
vpn=~/bin/vpn
ecfile=~/vpn-exitcode
ciscoHostFile=/opt/cisco/anyconnect/profile/ac-win-mac-profile.xml
if [[ -f ${ecfile} ]] && [[ "$(cat ${ecfile})" == 22 ]]; then
  rm -f ${ecfile}
  ${vpn} -rp
fi
if ! ${vpn} -np; then
  echo "Enter Password|shell=$vpn param1='-p'";
  # echo "Run vpn -p in terminal| bash=/bin/echo param1=test"
  exit 0
fi

function customConnect(){
  searchString=$(osascript -e '
set theString to text returned of (display dialog "Enter Name of VPN to connect to" default answer "" buttons {"Connect","Cancel"} default button 1)
')
  if [[ ! -z "${searchString}" ]]; then
      textToSearch=$(echo "$searchString" | perl -MURI::Escape -wlne 'print uri_escape $_')
  fi
}
function getAllVPNFromProfile(){
    grep 'HostName>.*<' $ciscoHostFile | sed -n 's:.*<HostName>\(.*\)</HostName>.*:\1:p' | sort
}
CONNECTED=0
if [[ -z "$1" ]]; then # if nothing was selected then show either no vpn/the current vpn/or status like connecting or disconnecting
  if ps -ef|grep 'vpn -[d]' >/dev/null; then
    echo 'Disconnecting... | refresh=true'
  elif ps -ef|grep 'vpn -[c]' >/dev/null; then
    echo 'Connecting... | refresh=true'
  else
    CONNECTED=1
    vpnName=$($vpn -g)
    if [[ -z "$vpnName" ]]; then
      echo '| image=/9j/4AAQSkZJRgABAQAAkACQAAD/4QCMRXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAACQAAAAAQAAAJAAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAACSgAwAEAAAAAQAAACQAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/CABEIACQAJAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAADAgQBBQAGBwgJCgv/xADDEAABAwMCBAMEBgQHBgQIBnMBAgADEQQSIQUxEyIQBkFRMhRhcSMHgSCRQhWhUjOxJGIwFsFy0UOSNIII4VNAJWMXNfCTc6JQRLKD8SZUNmSUdMJg0oSjGHDiJ0U3ZbNVdaSVw4Xy00Z2gONHVma0CQoZGigpKjg5OkhJSldYWVpnaGlqd3h5eoaHiImKkJaXmJmaoKWmp6ipqrC1tre4ubrAxMXGx8jJytDU1dbX2Nna4OTl5ufo6erz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAECAAMEBQYHCAkKC//EAMMRAAICAQMDAwIDBQIFAgQEhwEAAhEDEBIhBCAxQRMFMCIyURRABjMjYUIVcVI0gVAkkaFDsRYHYjVT8NElYMFE4XLxF4JjNnAmRVSSJ6LSCAkKGBkaKCkqNzg5OkZHSElKVVZXWFlaZGVmZ2hpanN0dXZ3eHl6gIOEhYaHiImKkJOUlZaXmJmaoKOkpaanqKmqsLKztLW2t7i5usDCw8TFxsfIycrQ09TV1tfY2drg4uPk5ebn6Onq8vP09fb3+Pn6/9sAQwAHBwcHBwcICAgICwsKCwsQDg0NDhAYERIREhEYJBYaFhYaFiQgJh8dHyYgOS0nJy05Qjc0N0JPR0dPZF9kg4Ow/9sAQwEHBwcHBwcICAgICwsKCwsQDg0NDhAYERIREhEYJBYaFhYaFiQgJh8dHyYgOS0nJy05Qjc0N0JPR0dPZF9kg4Ow/9oADAMBAAIRAxEAAAHv0t+dzxubHkOnZXOmG6K8jxCpxqrR518lpG3N3TtFTG1bbV//2gAIAQEAAQUC7G6jSvj2lkESVXEymgyxpjkEiXcRmUCJCUSIntxaSyj7l5zFi1hMMf3v/9oACAEDEQE/AcmaGPg8n8g4cpne7z5Ar002R3GVclGEjP8AZKQjEf7wO3//2gAIAQIRAT8BlMR48lju8y02i79X7Y4bNWfA/wB89v8A/9oACAEBAAY/Au2OvepZpoB6PnJAKfNhQ8+yAP2nhTTzawNY1PlpRUFXH0+4mJCSa6l0VxJr9/8A/8QAMxABAAMAAgICAgIDAQEAAAILAREAITFBUWFxgZGhscHw0RDh8SAwQFBgcICQoLDA0OD/2gAIAQEAAT8hs1oxxkhO0QCcP/OW2wHlszSCWPB7btdIDzz+rxX/AKf864NPgisBoR7fNyeELybm+GxcIVU8uf8AsWYPWBkHG19BsRv/AOP/2gAMAwEAAhEDEQAAEG8dDwHBHPP/xAAzEQEBAQADAAECBQUBAQABAQkBABEhMRBBUWEgcfCRgaGx0cHh8TBAUGBwgJCgsMDQ4P/aAAgBAxEBPxBDkw2GQsR1HLpH5PAOUDFfp1FTsJ2G8oX8P//aAAgBAhEBPxBY5J8HccuHL0HX8+APPL5hIbbt/q/D/9oACAEBAAE/EKkzuziBKN8gDWO4K5UhJkfp/wCRrUwXKb9UVVJ8B2m0lMrUIQZyfkVu2Ph5RiPsf+LWBI3YifdK+vk5mQq82fJWLIYPbpnivRXGQYdMMJ3/AIkkVZ7oGYHycJUBLvPVbuXFQMAJ7gP/AMf/2Q=='
    else
      echo "$vpnName | color=green image=iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAAXNSR0IArs4c6QAABChJREFUOE99lG1MW1UYx/+n9IVCoYOuHQGWdUFAQJCtY0i2UpFpQhZDBKZ1C5NFRELcRlzCCCYsk6mBL4Iv0Q++wZwkRicqZmOBLHEMamFaUDpgvI6VQklpS1t6ue2919xCCe6DJznJOSfn+Z3/Oef/PASPNY7jCAAxABWAPQDcADwAKABeADQhhH08jg8Kti2ABECiw+FINg4Pp09NTiopil7z0m6rn/jnNRkayZFnjjxQKpUrW1AOAEsICZ4eAoX7fL5so9H4snl8nMnXFSTujY8TMELGuexdXF1yLbseTMx5Vybs7pzM7AWtVjsTHh5uB+AjhPiDIF4NRVHqGz09pfIohUSnzUtd83qdNteyc/BRb1SYKMJ6NLHQFxetWiRCgbN/cEBhsy7uLysr+UUsFk8D2AaJDQZD4fKKK2d/lkJ2b+7OcbvPub7BMA4qQJYiBMrAAdVBd+a+1DsSoThWIhEt9huMGeFCkl5QoGsCMB1UtLCwIL3aebUx9nCgYnz1npDyE5ZlogNCyP0cEy1bp0TSXP+egMViAUVRXoDbSEp64js6wMoqTp+6K5fLu4OgwaHBone7T19Xpe0OsLSMSpLnRD+lyBUNzP6DeYcbhcJ96OrqQk/Pze3Pyn+2cPqk/sTttLQ0q06n2wR99tWnrR9bz9akKA879Km1y4cStGqZRCr9YuDXsO9HTYi9O4Jr33ague1zTEyMI0IsxietLXirts7wQqF2trq6upnwD934QUPvDXF73oWDbdY8tW41ADpWFCaIGVuwRF74+TdhommQXGm6jKb3W/CnqgwZ8+3g57X1lyaLi56buVhXdyYIamq53K3IVOUWJZcyG5zPKxAQQohALhJA8uPQfcnwT18LGt+pR0PjFfwuewkaazvaPmxBedXbayUvPt/bUH/xzeDVrnV2vrc3IeWVuHiVlGEZ3sG8c8WEQHG2pkqalZVFXj9Tjqqa85BKeM8iBGJiI4X9t27dPBUEmc3m/D+GTB8VFB6T+dbXwwCsA9gAkFB+8oTSaDSA2P8CHnYD89c3TUyPctACspTIHzwez6Yip9OZ1NHRUV9c+mo2y7I0yzA8yM8Ban1Z8ZP/B1Jmx3+5YrOcDzlbOjU1Vdrbd7uksuoNtcezMcMGmFWOcAcyM1I1lkcPdyratAA9Cl5RXI66eckyeykEEtM0nWwymV4zmUze8vIKn1Qq5jP/UHp6xtGxsb/Jjqv9B7TraVWdc2W5NQQSAoiiaTpxbm5O19fX55XJZBEajea4Xq8/NjJiEhJbJeAaB1z3N0ESJ7AbUGTHV9ptlm+2kxYAD4sEEG6323fZ7XaJ2WxOPXeuVuZ2e9jImBhGKo3m/BTF+f0UyzCAx+NAGIRDLpdtM9d21CMBAH6N7/zv8XC+yPn5V9myRXB7KIwf84XuXyxK/NM4zHlWAAAAAElFTkSuQmCC"
    fi
  fi
else
  if [[ "$1" = "disconnect" ]]; then
    $vpn -d &
    echo 'Disconnecting...| refresh=true'
  elif [[ "$1" = "search" ]]; then
    customConnect
    $vpn -c "$textToSearch" "$2" || echo $? > ${ecfile} &
    echo "Connecting ($1)...| refresh=true"
  else
    if ! $vpn -np ; then
      # echo "|bash=$(command -v vpn) param1='-p' terminal=true";
      echo "Run vpn -p in terminal| bash=/bin/echo param1=test"
      exit 0
    fi
    $vpn -c "$1" "$2" || echo $? > ${ecfile} &
    echo "Connecting ($1)...| refresh=true"
  fi
fi

echo "---"
[[ "$CONNECTED" -eq 1 ]] && echo "Disconnect| color=red bash='$0' param1=disconnect terminal=false refresh=true";
echo "Connect | color=green"

for i in $(getAllVPNFromProfile); do
    echo "--$i | bash='$0' param1=\"$i\" terminal=false refresh=true"
done
echo "--Click For Custom | bash='$0' param1=search terminal=false"
