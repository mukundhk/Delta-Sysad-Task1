#!/bin/bash
if [[ $# eq 1 ]];
then
    TuitionFee_p=$((50*$1/100))
    HostelRent_p=$((20*$1/100))
    ServiceCharge_p=$((10*$1/100))
    MessFee_p=$((20*$1/100))
    newDate=$(date +%D)

    IFS=' '
    cumFees=`sed -n '2p' $HOME/fees.txt`
    read TuitionFee HostelRent ServiceCharge MessFee <<< $cumFees
    newTuitionFee=$((${TuitionFee} + $TuitionFee_p))
    newHostelRent=$((${HostelRent} + $HostelRent_p))
    newServiceCharge=$((${ServiceCharge} + $ServiceCharge_p))
    newMessFee=$((${MessFee} + $MessFee_p))


    echo $(cat $HOME/fees.txt | sed "2s/\<$cumFees\>/$newTuitionFee $newHostelRent $newServiceCharge $newMessFee/") > $HOME/fees.txt
    echo $TuitionFee_p $HostelRent_p $ServiceCharge_p $MessFee_p $newDate >> $HOME/fees.txt
else
    echo "Enter total fee amount as command line argument."
fi