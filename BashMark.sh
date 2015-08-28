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
_version='1.1'

clear


echo "========== FinlayDaG33k BashMark =========="
echo

CURL=$(which curl) || eval "echo 'Please install curl'; exit 1"
CURL=$(which openssl) || eval "echo 'Please install openssl'; exit 1"

# Declare all functions
downloadfile(){
               wget -O /dev/null $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}'
           }
           
txtcomplete(){
              echo " Complete"
}

# Get CPU Info
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

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
echo -n "Starting CPU Tests (This may take a while)..."
openssl=$(openssl speed ecdsap256 ecdhp256 aes-256-cbc aes-128-cbc rsa md5 sha256 2>/dev/null | tail -n +6)
txtcomplete

echo

echo -n "Running I/O Tests..."
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )
txtcomplete

echo "Tests Complete!" 
echo "Results Below!"

echo 
echo "==== System Information ===="
echo

date
echo "BashMark Version: ${_version}"
echo "CPU model : $cname"
echo "Number of cores : $cores"
echo "CPU frequency : $freq MHz"
echo "Total amount of ram : $tram MB"
echo "Total amount of swap : $swap MB"
echo "System uptime : $up"

echo
echo "==== Sytem Performance ===="
echo

echo "$openssl"

echo "I/O speed : $io"

echo
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

echo "==== Goodbye! ===="
