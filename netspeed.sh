#!/bin/ash                                                                                                                              
        
#Récupére les TX + RX de l'interface spécifié, calcule la bande passante / seconde puis la poste vers influxDB
#Fait ces opérations toutes les secondes, 59 fois...et est dans la crontab pour execution toutes les minutes


INTERVAL="1"  # update interval in seconds                                                                                              
                                                                                                                                        
if [ -z "$1" ]; then                                                                                                                    
        echo                                                                                                                            
        echo usage: $0 [network-interface] [server]                                                                                             
        echo                                                                                                                            
        echo e.g. $0 eth0                                                                                                               
        echo                                                                                                                            
        exit                                                                                                                            
fi                                                                                                                                      
                                                                                                                                        
i=0                                                                                                                                     
while [ $i -le 59 ]                                                                                                                     
do                                                                                                                                      
                                                                                                                                        
        [ -f /sys/class/net/$1/statistics/rx_bytes ] && R1=`cat /sys/class/net/$1/statistics/rx_bytes` || R1=0                          
        [ -f /sys/class/net/$1/statistics/tx_bytes ] && T1=`cat /sys/class/net/$1/statistics/tx_bytes` || T1=0                          
        sleep $INTERVAL                                                                                                                 
        [ -f /sys/class/net/$1/statistics/rx_bytes ] && R2=`cat /sys/class/net/$1/statistics/rx_bytes` || R2=0                          
        [ -f /sys/class/net/$1/statistics/tx_bytes ] && T2=`cat /sys/class/net/$1/statistics/tx_bytes` || T2=0                          
        TBPS=`expr $T2 - $T1`                                                                                                           
        RBPS=`expr $R2 - $R1`                                                                                                           
        #echo "c: $T1 $R1 $T2 $R2"                                                                                                       
        if [ $T1 -gt 0 ] && [ $T2 -gt 0 ]  && [ $R1 -gt 0 ] && [ $R2 -gt 0 ]; then                                                      
                curl --silent -i -XPOST 'http://obelix:8086/write?db=traffic' --data-binary "traffic,interface=$1,server=$2 rx=$RBPS,tx=$TBPS" > /dev/null            
        fi                                                                                                                              
        i=$(( $i + 1 ))                                                                                                                 
done