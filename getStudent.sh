#!/bin/bash
file=$1
function create_student(){
    # create account
    sudo useradd -m -d /home/HAD/${3}/${4}/${1} ${1}
    # add to student group
    sudo usermod -g student $1
    #add to hostel group
    sudo usermod -aG $3 $1

    deptcode=${2:0:4}
    year=${2:4:2}
    month=$(date +%B)

    case $deptcode in 
        "1061") dept="CSE"
        ;;
        "1081") dept="ECE"
        ;;
        "1021") dept="CL"
        ;;
        "1071") dept="EEE"
        ;;
        "1111") dept="ME"
        ;;
        "1121") dept="MME"
        ;;
        "1031") dept="CE"
        ;;
        "1101") dept="ICE"
        ;;
        "1141") dept="PR"
        ;;
    esac
    #userDetails.txt
    sudo touch /home/HAD/$3/$4/$1/userDetails.txt
    sudo chmod 402 /home/HAD/$3/$4/$1/userDetails.txt
    sudo echo "$1 $2 $dept $year $3 $5 $month $6" > /home/HAD/$3/$4/$1/userDetails.txt

    #fees.txt
    sudo touch /home/HAD/$3/$4/$1/fees.txt
    sudo chmod 402 /home/HAD/$3/$4/$1/fees.txt
    sudo echo "0 0 0 0" > /home/HAD/$3/$4/$1/fees.txt

    sudo chmod -R 700 /home/HAD/$3/$4/$1
    sudo chown -R $1: /home/HAD/$3/$4/$1
}

#creating HAD account
sudo useradd -m -d /home/HAD HAD
sudo touch /home/HAD/mess.txt
echo "HAD account created"

#creating accounts for hostel wardens
hostels=("GarnetA" "GarnetB" "Agate" "Opal")

for hostel in ${hostels[@]};
do
    sudo useradd -m -d /home/HAD/${hostel} ${hostel}
    sudo touch /home/HAD/${hostel}/announcements.txt
    sudo touch /home/HAD/${hostel}/feeDefaulters.txt
done
echo "Hostel accounts created"

echo "creating student accounts"

sudo groupadd student
if [ $# -eq 1 ]
then
    #creating student accounts
    flag=0
    while read name rollno hostel room mess messpref; 
    do
        # Ignore first line (headings)
        if [ $flag -eq 0 ];
        then
            flag=1
            continue
        fi

        create_student $name $rollno $hostel $room $mess $messpref    
    done < $file

elif [ $# -eq 6 ]
then
    name=$1
    rollno=$2
    hostel=$3
    room=$4
    mess=$5
    messpref=$6

    create_student $name $rollno $hostel $room $mess $messpref
else
    echo "Error : Pass in filename or individual details, ie-  name, roll number, hostel, room, mess, mess preference"
fi