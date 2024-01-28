#!/bin/sh

#echo `curl https://github.com/xanmod/linux |grep releases | awk -F/ 'NR==4 {print $(NF)}' | awk -F\" '{print $1}'` > $HOME/.local/log/kernelcheck.log
echo `curl https://xanmod.org | grep "<td><strong>" | awk -F\> 'NR==2 { print $3 }' | awk -F\< '{ print $1 }'` > $HOME/.local/log/kernelcheck.log
