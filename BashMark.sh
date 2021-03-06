#!/bin/bash
: '
The MIT License (MIT)
Copyright (c) 2015 Aroop 'Finlay' Roelofs
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

clear
_version='1.6'
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"


# Declare all functions
header(){
echo "========== FinlayDaG33k BashMark =========="
echo
}
help_dialog(){
echo "./${me} [options]"
echo
echo
echo "Options:"
echo "        -d | --download    Activates the Downloadspeed test (Requires an active Internet Connection)"
echo "        -F | --full        Activates the full suite of Benchmarks"
echo "        -f | --file        Outputs log to file (Usage -f=output.txt or --file=output.txt)"
echo "        -h | --help        Shows this help dialog"
echo "        -io| --io          Activates the IO (Harddrive) test"
echo "        -nh| --no-host     Disables hostname in results"
echo "        -o | --openssl     Activates the OpenSSL test"
echo "        -pi| --pi          Activates the Pi Test"
echo "        -s | --stress      Activates the Stresstest (Does not benchmark!)"
echo "        -u | --username    Add your nickname/username to the results (Usage -u=FinlayDaG33k or --username=FinlayDaG33k)"
echo "        -U | --update      Updates BashMark with the Github version (overwrites current file even if they are identical!)"
echo "        -v | --version     Display BashMark Version"
}
check_parameters(){
# Check all parameters
for i in "$@"
do
case $i in
    -U|--update)
    update
    exit 0
    ;;
    -h|--help)
    help_dialog
    exit 0
    ;;
    -v|--version)
    echo "BashMark Version: ${_version}"
    exit 0
    ;;
    -s|--stress)
    stress_cpu
    exit 0
    ;;
    -d=*|--download=*)
    download_test_count=${i#*=}
    if [ download_test_count -gt 0 ]; then
    download="true"
    fi
    shift # past argument=value
    ;;
    -d|--download)
    download="true"
    download_test_count=11
    shift # past argument=value
    ;;
    -io|--io)
    io="true"
    shift # past argument=value
    ;;
    -o|--openssl)
    OSSL="true"
    shift # past argument=value
    ;;
    -pi|--pi)
    pi_test="true"
    shift # past argument=value
    ;;
    -F|--full)
    download="true"
    download_test_count=11
    io="true"
    OSSL="true"
    pi_test="true"
    shift # past argument=value
    ;;
    -u=*|--username=*)
    username="${i#*=}"
    shift # past argument=value
    ;;
    -nh|--no-host)
    no-host="true"
    shift # past argument=value
    ;;
    -f=*|--file=*)
    output="${i#*=}"
    file_output="true"
    ;;
    *)
      header
      echo "Invalid argument: ${i}"
      help_dialog
      exit 0
    ;;
esac
done
}
check_dependencies(){
# Check if CURL and OpenSSL are installed
CURL=$(which curl) || eval "echo 'Please install curl'; exit 1"

if [ "${OSSL}" = "true" ]; then
CURL=$(which openssl) || eval "echo 'Please install openssl'; exit 1"
fi
}
downloadfile(){
               wget -O /dev/null $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}'
           }          
txtcomplete(){
              echo " Complete"
}
cooldown(){
    echo "Coolingdown for 10 Seconds"
    sleep 10
}
pi_test(){
echo "Testing Pi (This may take a while)..."
	pi_result=$((time echo "scale=32000000; 4*a(1)"| bc -lq) 2>&1 | grep real |  cut -f2)
	txtcomplete
}
downloadspeed(){
# Test Download speeds
if [ "${download_test_count}" -gt 0 ] ; then
echo -n "Testing Cachefly..."
cachefly=$(downloadfile http://cachefly.cachefly.net/100mb.test)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 1 ] ; then
echo -n "Testing Coloat, Atlanta, GA..."
coloatatl=$(downloadfile http://speed.atl.coloat.com/100mb.test)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 2 ] ; then
echo -n "Testing Softlayer, Dallas, TX..."
sldltx=$(downloadfile http://speedtest.dal05.softlayer.com/downloads/test100.zip)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 3 ] ; then
echo -n "Testing Linode, Tokyo, JP..."
linodejp=$(downloadfile http://speedtest.tokyo.linode.com/100MB-tokyo.bin)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 4 ] ; then
echo -n "Testing i3d.net, Rotterdam, NL..."
i3d=$(downloadfile http://mirror.i3d.net/100mb.bin)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 5 ] ; then
echo -n "Testing Linode, London, UK..."
linodeuk=$(downloadfile http://speedtest.london.linode.com/100MB-london.bin)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 6 ] ; then
echo -n "Testing Leaseweb, Haarlem, NL..."
leaseweb=$(downloadfile http://mirror.leaseweb.com/speedtest/100mb.bin)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 7 ] ; then
echo -n "Testing Softlayer, Singapore..."
slsg=$(downloadfile http://speedtest.sng01.softlayer.com/downloads/test100.zip)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 8 ] ; then
echo -n "Testing Softlayer, Seattle, WA..."
slwa=$(downloadfile http://speedtest.sea01.softlayer.com/downloads/test100.zip)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 9 ] ; then
echo -n "Testing Softlayer, San Jose, CA..."
slsjc=$(downloadfile http://speedtest.sjc01.softlayer.com/downloads/test100.zip)
txtcomplete
cooldown
fi

if [ "${download_test_count}" -gt 10 ] ; then
echo -n "Testing Softlayer, Washington, DC..."
slwdc=$(downloadfile http://speedtest.wdc01.softlayer.com/downloads/test100.zip)
txtcomplete
cooldown
fi

echo
}
OSSL(){
echo -n "Testing OpenSSL (This may take a while)..."
openssl=$(openssl speed ecdsap256 ecdhp256 aes-256-cbc aes-128-cbc rsa md5 sha256 2>/dev/null | tail -n +6)
txtcomplete
cooldown
echo
}
IO(){
echo -n "Running I/O Test on Local Drive..."
io_result_hdd=$( ( dd bs=1M count=512 if=/dev/zero of=test conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )
txtcomplete
cooldown
}
downloadspeed_results(){
echo "==== Download Speeds ===="
echo 
echo "Download speed from CacheFly :                  $cachefly "
echo "Download speed from Coloat, Atlanta GA :        $coloatatl "
echo "Download speed from Linode, Tokyo, JP :         $linodejp "
echo "Download speed from i3d.net, Rotterdam, NL :    $i3d"
echo "Download speed from Linode, London, UK :        $linodeuk "
echo "Download speed from Leaseweb, Haarlem, NL :     $leaseweb "
echo "Download speed from Softlayer, Singapore :      $slsg "
echo "Download speed from Softlayer, Seattle, WA :    $slwa "
echo "Download speed from Softlayer, San Jose, CA :   $slsjc "
echo "Download speed from Softlayer, Washington, DC : $slwdc "
}
system_performance(){
echo "==== Sytem Performance ===="
echo
if [ "${OSSL}" = "true" ]; then
echo "$openssl"
fi

if [ "${io}" = "true" ]; then
echo "I/O speed : $io_result_hdd"
fi

if [ "${pi_test}" = "true" ]; then
echo "Pi Time speed : $pi_result"
fi

echo
}
system_info(){
# Get CPU Info
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram_mb=$( free -m | awk 'NR==2 {print $2}' )
tram_gb=$((tram_mb/1000))
swap=$( free -m | awk 'NR==4 {print $2}' )
if [ -z $swap ] ; then
swap=0
fi
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
}
benchmarks(){
# Do the benchmarks
if [ "${download}" = "true" ]; then
downloadspeed
fi

if [ "${OSSL}" = "true" ]; then
OSSL
fi

if [ "${io}" = "true" ]; then
IO
fi

if [ "${pi_test}" = "true" ]; then
pi_test
fi

if [ "${no-host}" != "true" ] ; then
hostname=$(hostname -f)
fi

if [ -z "${username}" ]; then
username="Anonymous"
fi


}
test_complete(){
# Tests complete
if [ "${io}" = "true" ] || [ "${OSSL}" = "true" ] || [ "${download}" = "true" ] || [ "${pi_test}" = "true" ]; then
echo "Tests Complete!" 
echo "Results Below!"
echo 
fi
}
result_screen(){
echo "==== System Information ===="
echo
echo "Username:                                       ${username}"
if [ "${no-host}" != "true" ] ; then
echo "Hostname:                                       ${hostname}"
fi
echo -n "Date:                                           "
date
echo "BashMark Version:                               ${_version}"
md5_current=$(echo -n ${me} | md5sum)
md5_latest=$(curl -s https://raw.githubusercontent.com/FinlayDaG33k/BashMark/master/BashMark.sh | md5sum)
echo -n "BashMark Sum:                                   ${md5_current}"
if [ "${md5_current}" = "${md5_latest}" ] ; then
echo " (Valid)"
else
echo " (Invalid)"
fi
echo "CPU model :                                    $cname"
echo "Number of cores :                               $cores"
echo "CPU frequency :                                $freq MHz"
echo "Total amount of ram :                           $tram_mb MB ($tram_gb GB)"
echo "Total amount of swap :                          $swap MB"
echo "System uptime :                               $up"
echo

if [ "${download}" = "true" ]; then
downloadspeed_results
fi

if [ "${io}" = "true" ] || [ "${OSSL}" = "true" ] || [ "${pi_test}" = "true" ] ; then
system_performance
fi



echo
echo
echo "Hint: post your score to my forum, it's free!"
echo "https://finlaydag33k.nl/da-foramz/forum/projects/bashmark/scores/"
echo "==== Goodbye! ===="
}
update(){
    echo "A new version is available on the github, Auto-Updating!"
    if ! wget --quiet https://raw.githubusercontent.com/FinlayDaG33k/BashMark/master/BashMark.sh -O ${me} ; then
    echo "Failed: Error while trying to get new version!"
    exit 1
    else
    echo "Update succeeded! "
    read -p "Do you want to start BashMark? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
    bash ${me}
    else
    echo "Exitting"
    exit 0
    fi
    fi
}
stress_cpu(){
    echo -n "Starting the stresstest!"
    stress_amount=0
while : ; do
str="I-Love-Benchmarking"
echo -n ${str}| md5sum | sha1sum | base64 | sha256sum > /dev/null
let stress_amount=stress_amount+1
 read -t 0.005 && break
done

echo "User exited!"
echo "BashMark has done ${stress_amount} Hashing computations"
exit 0
}
write_to_file(){
# Redirect stdout ( > ) into a named pipe ( >() ) running "tee"
exec > >(tee ${output})
exec 2>&1
}


header
update
check_parameters $@
if [ "${file_output}" = "true" ] ; then
write_to_file $@
fi
check_dependencies
benchmarks
test_complete
system_info
result_screen
