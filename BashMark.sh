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
echo "========== FinlayDaG33k BashMark =========="
echo
_version='1.2'

# Help Dialog
help_dialog(){
echo "./BashMark.sh [options]"
echo
echo
echo "Options:"
echo "        -d | --download    Activates the Downloadspeed test (Requires an active Internet Connection)"
echo "        -F | --full        Activates the full suite of Benchmarks (Overwrites -d|-io|-o parameters)"
echo "        -h | --help        Shows this help dialog"
echo "        -io| --io          Activates the IO (Harddrive) test"
echo "        -nh| --no-host     Disables hostname in results"
echo "        -o | --openssl     Activates the OpenSSL test"
echo "        -pi| --pi          Activates the Pi Test"
echo "        -u | --username    Add your nickname/username to the results (Usage -u=[username] or --username=[username])"
echo "        -v | --version     Display BashMark Version"
}

# Check all parameters
for i in "$@"
do
case $i in
    -h|--help)
    help_dialog
    exit 0
    ;;
    -v|--version)
    echo "BashMark Version: ${_version}"
    exit 0
    ;;
    -d|--download)
    download="true"
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
    *)
            # unknown option
      echo "Invalid argument: ${i}"
      help_dialog
      exit 0
    ;;
esac
done


# Check if CURL and OpenSSL are installed
CURL=$(which curl) || eval "echo 'Please install curl'; exit 1"

if [ "${OSSL}" = "true" ]; then
CURL=$(which openssl) || eval "echo 'Please install openssl'; exit 1"
fi


# Declare all functions

downloadfile(){
               wget -O /dev/null $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}'
           }          
txtcomplete(){
              echo " Complete"
}

pi_test(){
echo "Testing Pi (This may take a while)..."
	pi_result=$((time echo "scale=5000; 4*a(1)"| bc -lq) 2>&1 | grep real |  cut -f2)
}
txtcomplete

downloadspeed(){
# Test Download speeds

echo -n "Testing Cachefly..."
cachefly=$(downloadfile http://cachefly.cachefly.net/100mb.test)
txtcomplete

echo -n "Testing Coloat, Atlanta, GA..."
coloatatl=$(downloadfile http://speed.atl.coloat.com/100mb.test)
txtcomplete

echo -n "Testing Softlayer, Dallas, TX..."
sldltx=$(downloadfile http://speedtest.dal05.softlayer.com/downloads/test100.zip)
txtcomplete

echo -n "Testing Linode, Tokyo, JP..."
linodejp=$(downloadfile http://speedtest.tokyo.linode.com/100MB-tokyo.bin)
txtcomplete

echo -n "Testing i3d.net, Rotterdam, NL..."
i3d=$(downloadfile http://mirror.i3d.net/100mb.bin)
txtcomplete

echo -n "Testing Linode, London, UK..."
linodeuk=$(downloadfile http://speedtest.london.linode.com/100MB-london.bin)
txtcomplete

echo -n "Testing Leaseweb, Haarlem, NL..."
leaseweb=$(downloadfile http://mirror.leaseweb.com/speedtest/100mb.bin)
txtcomplete

echo -n "Testing Softlayer, Singapore..."
slsg=$(downloadfile http://speedtest.sng01.softlayer.com/downloads/test100.zip)
txtcomplete

echo -n "Testing Softlayer, Seattle, WA..."
slwa=$(downloadfile http://speedtest.sea01.softlayer.com/downloads/test100.zip)
txtcomplete

echo -n "Testing Softlayer, San Jose, CA..."
slsjc=$(downloadfile http://speedtest.sjc01.softlayer.com/downloads/test100.zip)
txtcomplete

echo -n "Testing Softlayer, Washington, DC..."
slwdc=$(downloadfile http://speedtest.wdc01.softlayer.com/downloads/test100.zip)
txtcomplete
echo
}
OSSL(){
echo -n "Testing OpenSSL (This may take a while)..."
openssl=$(openssl speed ecdsap256 ecdhp256 aes-256-cbc aes-128-cbc rsa md5 sha256 2>/dev/null | tail -n +6)
txtcomplete

echo
}
IO(){
echo -n "Running I/O Tests..."
io_result=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )
txtcomplete
}
# Define Results
downloadspeed_results(){
echo "==== Download Speeds ===="
echo 
echo "Download speed from CacheFly: $cachefly "
echo "Download speed from Coloat, Atlanta GA: $coloatatl "
echo "Download speed from Linode, Tokyo, JP: $linodejp "
echo "Download speed from i3d.net, Rotterdam, NL: $i3d"
echo "Download speed from Linode, London, UK: $linodeuk "
echo "Download speed from Leaseweb, Haarlem, NL: $leaseweb "
echo "Download speed from Softlayer, Singapore: $slsg "
echo "Download speed from Softlayer, Seattle, WA: $slwa "
echo "Download speed from Softlayer, San Jose, CA: $slsjc "
echo "Download speed from Softlayer, Washington, DC: $slwdc "
}
system_performance(){
echo "==== Sytem Performance ===="
echo
if [ "${OSSL}" = "true" ]; then
echo "$openssl"
fi

if [ "${io}" = "true" ]; then
echo "I/O speed : $io_result"
fi

if [ "${pi_test}" = "true" ]; then
echo "Pi Time speed : $pi_result"
fi

echo
}

# Get CPU Info
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

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


# Tests complete

if [ "${io}" = "true" ] || [ "${OSSL}" = "true" ] || [ "${download}" = "true" ] || [ "${pi_test}" = "true" ]; then
echo "Tests Complete!" 
echo "Results Below!"
echo 
fi


echo "==== System Information ===="
echo
echo "Username: ${username}"
if [ "${no-host}" != "true" ] ; then
echo "Hostname: ${hostname}"
fi
date
echo "BashMark Version: ${_version}"
echo "CPU model : $cname"
echo "Number of cores : $cores"
echo "CPU frequency : $freq MHz"
echo "Total amount of ram : $tram MB"
echo "Total amount of swap : $swap MB"
echo "System uptime : $up"
echo

if [ "${io}" = "true" ] || [ "${OSSL}" = "true" ] || [ "${pi_test}" = "true" ] ; then
system_performance
fi

if [ "${download}" = "true" ]; then
downloadspeed_results
fi

echo
echo
echo "Hint: post your score to my forum, it's free!"
echo "https://finlaydag33k.nl/da-foramz/forum/projects/bashmark/scores/"
echo "==== Goodbye! ===="
