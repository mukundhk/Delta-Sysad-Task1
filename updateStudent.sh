#!/bin/bash

function feeDefaulter(){
    name=`cat $1/userDetails.txt | cut -d' ' -f 1`
    echo "$name $2" >> /home/HAD/$3/feeDefaulters.txt
}

user=`whoami`

string=$(awk -F: "/^$user/ {print \$4;}" /etc/group)
readarray -d, -t rollnos <<< $string

currentMonth=$(date +%m)

paidStudents=()

for n in "${!rollnos[@]}"; 
do
    pathToStudent=`find /home/HAD/$user -name ${rollnos[$n]}`

    # last transaction
    lastTransaction=`tail -1 $pathToStudent/fees.txt`
    if [[ $lastTransaction == "Transaction history" ]];
    then
        feeDefaulter $pathToStudent ${rollnos[$n]} $user
        continue
    fi

    read a b c d date <<< $lastTransaction

    # odd semester
    if [[ $currentMonth > "05" ]];
    then
        if [[ ${date:0:2} < "06" ]] || [[ $(date +%y) != ${date:6:2} ]];
        then
            feeDefaulter $pathToStudent ${rollnos[$n]} $user
            continue
        fi
    
    # even semester
    else
        if [[ ${date:0:2} > "05" ]] || [[ $(date +%y) != ${date:6:2} ]];
        then
            feeDefaulter $pathToStudent ${rollnos[$n]} $user
            continue
        fi
    fi
    paidStudents+=(${rollnos[n]})        
done

# first 5 students
for (( i=0; i < 5; i++ ));
do
    firstRollIndex=0
    firstDate=99
    for j in ${!paidStudents[@]};
    do
        pathToStudent=`find /home/HAD/$user/ -name ${paidStudents[$j]}`

        # last transaction
        read a b c d date < <(tail -1 $pathToStudent/fees.txt)
        # finding first student
        if [[ $date < $firstDate ]];
        then
            firstDate=$date
            firstRollIndex=$j
        fi
    done
    echo ${paidStudents[$firstRollIndex]} >> /home/HAD/$user/announcements.txt
    # remove first student
    unset paidStudents[$firstRollIndex]
done