#!/bin/bash

groupname=$(echo `groups` | cut -d' ' -f 1)

# STUDENT 
if [ $groupname == "student" ];
then
    newMessPref=""
    echo "Mess allotment preference - Enter the number associated with mess"
    echo "1. Kailash" 
    echo "2. Nilgiri"
    echo "3. Opal"
    echo "Enter your first preference:"
    read pref
    newMessPref+=$pref
    echo "Enter your second preference:"
    read pref
    newMessPref+=$pref
    echo "Enter your third preference:"
    read pref
    newMessPref+=$pref

    read name rollno dept year hostel mess month messpref < $HOME/userDetails.txt
    echo $name $rollno $dept $year $hostel $mess $month $newMessPref > $HOME/userDetails.txt

    echo $rollno >> /home/HAD/mess.txt


# HAD 
else
    readarray -t messCapacity < <(sed -n '2,4p' /home/HAD/mess.txt | cut -d' ' -f 2)

    while read rollno;
    do
        pathToDetails=$(find /home/HAD/ -name ${rollno})/userDetails.txt
        read name roll dept year hostel mess month messp < $pathToDetails
        for i in 0 1 2;
        do            
            pref=${messp:i:1}
            currentCap=${messCapacity[$(($pref-1))]}

            if [ $currentCap > 0 ];
            then
                echo $(cat $pathToDetails | sed "s/\<$mess $month\>/$pref $(date +%B)/") > $pathToDetails
                messCapacity[$(($pref-1))]=$(($currentCap-1))
                break
            fi
        done
    done < <(tail -n+6 /home/HAD/mess.txt)
    sed -i '6,$ d' /home/HAD/mess.txt
fi