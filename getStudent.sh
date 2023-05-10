#!/bin/bash

#creating HAD account
sudo useradd -m -d /home/HAD HAD

#creating accounts for hostel wardens
hostels=("GarnetA" "GarnetB" "Agate" "Opal")

for hostel in ${hostels[@]};
do
    sudo useradd -m -d /home/HAD/${hostel} ${hostel}
done

if [ $# -eq 1 ]
then
    #creating student accounts
    flag=0
    while read line; 
    do
        # Ignore first line (headings)
        if [ $flag -eq 0 ];
        then
            flag=1
            continue
        fi
        # splitting line
        IFS=" "
        read -ra details <<< $line
        name=${details[0]}
        hostel=${details[2]}
        room=${details[3]}

        sudo useradd -m -d /home/HAD/${hostel}/${room}/${name} $name
    done < $1
elif [ $# -eq 3 ]
then
    name=$1
    hostel=$2
    room=$3

    sudo useradd -m -d /home/HAD/${hostel}/${room}/${name} $name
else
    echo "Error : Pass in file or individual details, ie-  name, hostel, room"
fi