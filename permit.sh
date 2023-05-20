#!/bin/bash
file=$1

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
        sudo setfacl -R -m "u:HAD:rwx" /home/HAD/${hostel}        
    done
}

function students(){
    sudo chmod -R 700 /home/HAD/$3/$4/$2
    sudo chown -R $2: /home/HAD/$3/$4/$2
    sudo setfacl -R -m "u:HAD:rwx" /home/HAD/$3/$4/$2
    sudo setfacl -R -m "u:$3:rwx" /home/HAD/$3/$4/$2
}

mess
hostels

#home directory of students
if [ $# -eq 1 ]
    then
    flag=0
    while read name rollno hostel room mess messpref; 
    do
        students $name $rollno $hostel $room $mess $messpref
    done < <(tail -n+1 $file)
elif [ $# -eq 6 ]
then
    name=$1
    rollno=$2
    hostel=$3
    room=$4
    mess=$5
    messpref=$6

    students $name $rollno $hostel $room $mess $messpref

    echo "Done"
else
    echo "Error : Pass in filename or individual details, ie-  name, roll number, hostel, room, mess, mess preference"
fi