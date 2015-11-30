#!/bin/ash

INTERVAL="1"  # update interval in seconds

if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        exit
fi

IF=$1
i=0
while [ $i -le 59 ]
do
        R1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        #echo "TX $1: $TKBPS kB/s RX $1: $RKBPS kB/s"
	curl -i -XPOST 'http://obelix:8086/write?db=traffic' --data-binary "traffic,interface=$1 rx=$RBPS,tx=$TBPS"
	i=$(( $i + 1 ))
done
