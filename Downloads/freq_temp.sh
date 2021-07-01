if [ "null$1" == "null-h"  ] ; then
	echo "help: "
	echo "    : freqtemp.sh         -- print only"
	echo "    : freqtemp.sh >file   -- save to file"
	exit
fi

echo -n "send, cpufreq0, cpufreq1,cpufreq2,cpufreq3,cpufreq4,cpufreq5,cpufreq6,cpufreq7,"
echo "cputemp0, cputemp1,cputemp2,cputemp3,cputemp4,cputemp5,cputemp6,cputemp7, TopActivityPacakage"
while true; do 

 	send=`date '+%Y-%m-%d %H:%M:%S'`
	echo -n $send, 
	
    base=/sys/devices/system/cpu	
	file=cpufreq/scaling_cur_freq
	index=0

	for tmp in ${base}/cpu?/${file}; do
        cpufreq[$index]=`cat $tmp`
		((index++))
	done
	
	for tmp in ${cpufreq[@]}; do
		printf "%4d," $((tmp/1000))
    done
    
	sensor_index=(8 9 10 11 12 13 14 15)
	base=/sys/class/thermal/thermal_zone
  	index=0

	for i in ${sensor_index[@]}; do
		cputemp[$index]=`cat $base$i/temp`
		((index++))
	done

	for tmp in ${cputemp[@]}; do
		if [[ $tmp -gt 1000 ]]
		then ((tmp=tmp/100))
		fi
	  echo -n $tmp,
	done
	
    TopActivityPacakage=$(dumpsys activity a | grep mResumedActivity | awk '{print $4}'|cut -d "/" -f 1|head -n 1)
	CurrentAPP=$TopActivityPacakage
	echo $CurrentAPP
	
    sleep 1;     
	
done
