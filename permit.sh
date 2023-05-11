#!/bin/bash
file=$1

function students(){
    sudo chmod -R 700 /home/HAD/$3/$4/$1
    sudo chown -R $1: /home/HAD/$3/$4/$1
    sudo setfacl -m "u:HAD:rwx" /home/HAD/$3/$4/$1
    sudo setfacl -m "u:$3:rwx" /home/HAD/$3/$4/$1
}

function mess(){
    sudo chmod 700 /home/HAD/mess.txt
    sudo chown -R HAD: /home/HAD/mess.txt
    sudo setfacl -m "g:student:rwx" /home/HAD/mess.txt
}

function hostels(){
    hostels=("GarnetA" "GarnetB" "Agate" "Opal")
    for hostel in ${hostels[@]};
    do
        sudo chown -R $hostel:$hostel /home/HAD/${hostel}
        sudo chmod 740 /home/HAD/${hostel}/announcements.txt
        sudo chmod 740 /home/HAD/${hostel}/feeDefaulters.txt
        sudo setfacl -m "u:HAD:rwx" /home/HAD/${hostel}
    done
}

#home directory of students
if [ $# -eq 1 ]
    then
    flag=0
    while read name rollno hostel room mess messpref; 
    do
        # Ignore first line (headings)
        if [ $flag -eq 0 ];
        then
            flag=1
            continue
        fi
        students $name $rollno $hostel $room $mess $messpref
    done < $file
elif [ $# -eq 6 ]
then
    name=$1
    rollno=$2
    hostel=$3
    room=$4
    mess=$5
    messpref=$6

    students $name $rollno $hostel $room $mess $messpref

else
    echo "Error : Pass in filename or individual details, ie-  name, roll number, hostel, room, mess, mess preference"
fi

mess
hostels