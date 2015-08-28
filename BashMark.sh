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
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')


echo "========== FinlayDaG33k BashMark =========="
echo

CURL=$(which curl) || eval "echo 'Please install curl'; exit 1"
CURL=$(which openssl) || eval "echo 'Please install openssl'; exit 1"

echo -n "Testing Cachefly..."
cachefly=$( wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Coloat, Atlanta, GA..."
coloatatl=$( wget -O /dev/null http://speed.atl.coloat.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Softlayer, Dallas, TX..."
sldltx=$( wget -O /dev/null http://speedtest.dal05.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Linode, Tokyo, JP..."
linodejp=$( wget -O /dev/null http://speedtest.tokyo.linode.com/100MB-tokyo.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing i3d.net, Rotterdam, NL..."
i3d=$( wget -O /dev/null http://mirror.i3d.net/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Linode, London, UK..."
linodeuk=$( wget -O /dev/null http://speedtest.london.linode.com/100MB-london.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Leaseweb, Haarlem, NL..."
leaseweb=$( wget -O /dev/null http://mirror.leaseweb.com/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Softlayer, Singapore..."
slsg=$( wget -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Softlayer, Seattle, WA..."
slwa=$( wget -O /dev/null http://speedtest.sea01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Softlayer, San Jose, CA..."
slsjc=$( wget -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"

echo -n "Testing Softlayer, Washington, DC..."
slwdc=$( wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo " Complete"


echo "Beginning CPU Tests..."
echo -n "Testing SHA256..."
sha256=$(openssl speed sha256 2>/dev/null | tail -n +6)
echo " Complete"

echo -n "Testing MD5..."
md5=$(openssl speed md5 2>/dev/null | tail -n +6)
echo " Complete"

echo -n "Testing RSA..."
rsa=$(openssl speed rsa 2>/dev/null | tail -n +6)
echo " Complete"

echo -n "Testing AES-128-CBC..."
aes128cbc=$(openssl speed aes-128-cbc 2>/dev/null | tail -n +6)
echo " Complete"

echo -n "Testing AES-256-CBC..."
aes256cbc=$(openssl speed aes-256-cbc 2>/dev/null | tail -n +6)
echo " Complete"

echo -n "Testing ECDSAP256..."
ecdsap256=$(openssl speed ecdsap256 2>/dev/null | tail -n +6)
echo " Complete"

echo -n "Testing ECDHP256..."
ecdhp256=$(openssl speed ecdhp256 2>/dev/null | tail -n +6)
echo " Complete"

echo "Beginning I/O Tests..."
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )

echo "Tests Complete!" 
echo "Results Below!"

echo 
echo "==== System Information ===="
echo

date
echo "CPU model : $cname"
echo "Number of cores : $cores"
echo "CPU frequency : $freq MHz"
echo "Total amount of ram : $tram MB"
echo "Total amount of swap : $swap MB"
echo "System uptime : $up"

echo
echo "==== Sytem Performance ===="
echo

echo "SHA256 Speed: $sha256"
echo "MD5 Speed: $md5"
echo "RSA Speed: $rsa"
echo "AES-128-CBC Speed: $aes256cbc"
echo "AES-256-CBC Speed: $aes256cbc"
echo "ECDSAP256 Speed: $ecdsap256"
echo "ECDHP256 Speed: $ecdhp256"
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
