#!/bin/bash
#Script to update motd with relevant information.

#Define output file
motd="/etc/motd"

# Collect information
HOSTNAME=`uname -n`
KERNEL=`uname -r`
CPU=`awk -F '[ :][ :]+' '/^model name/ { print $2; exit; }' /proc/cpuinfo`
ARCH=`uname -m`
PACMAN=`checkupdates | wc -l`
DETECTDISK=`mount -v | fgrep 'on / ' | sed -n 's_^\(/dev/[^ ]*\) .*$_\1_p'`
DISC=`df -h | grep $DETECTDISK | awk '{print $5 }'`
MEMORY1=`free -t -m | grep "Mem" | awk '{print $6" MB";}'`
MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
MEMPERCENT=`free | awk '/Mem/{printf("%.2f% (Used) "), $3/$2*100}'`

#Time of day
HOUR=$(date +"%H")
if [ $HOUR -lt 12  -a $HOUR -ge 0 ]
then   TIME="Morning"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
then   TIME="Afternoon"
else   TIME="Evening"
fi

#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))


#System load
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`

#Color variables
#W="\033[00;37m"
W="\033[0m"
B="\033[01;36m"
R="\033[01;31m"
G="\033[01;32m"
N="\033[0m"

#Clear screen before motd
cat /dev/null > $motd

echo -e "
        $B. $W
       $B/#\ $W                     _     $B _ _
      $B/###\ $W      __ _ _ __ ___| |__  $B| (_)_ __  _   ___  __ 
     $B/#####\ $W    / _' | '__/ __| '_ \ $B| | | '_ \| | | \ \/ /
    $B/##.-.##\ $W  | (_| | | | (__| | | |$B| | | | | | |_| |>  <  
   $B/##(   )##\ $W  \__,_|_|  \___|_| |_|$B|_|_|_| |_|\__._/_/\_\\
  $B/#.--   --.#\ $W
 $B/'           '\ 
" > $motd
echo -e "$G---------------------------------------------------------------" >> $motd
echo -e "$W   Good $TIME$A You're Logged Into $B$A$HOSTNAME$W! " 	    >> $motd
echo -e "$G---------------------------------------------------------------" >> $motd
echo -e "$B    KERNEL $G:$W $KERNEL $ARCH                                 " >> $motd
echo -e "$B       CPU $G:$W $CPU                                          " >> $motd
echo -e "$B    MEMORY $G:$W $MEMORY1 / $MEMORY2 - $MEMPERCENT             " >> $motd
echo -e "$B  USE DISK $G:$W $DISC (Used)                      	          " >> $motd
echo -e "$G---------------------------------------------------------------" >> $motd
echo -e "$B  LOAD AVG $G:$W $LOAD1, $LOAD5, $LOAD15		          " >> $motd
echo -e "$B    UPTIME $G:$W $upDays days $upHours hours $upMins minutes $upSecs seconds " >> $motd
#echo -e "$B PROCESSES $G:$W You are running $PSU of $PSA processes        " >> $motd
echo -e "$B    PACMAN $G:$W $PACMAN packages can be updated               " >> $motd
echo -e "$B     USERS $G:$W `users | wc -w` users logged in 	          " >> $motd
echo -e "$G---------------------------------------------------------------" >> $motd
echo -e "  $W Please do not share your login and use$G sudo$W for$R root$W access " >> $motd
echo -e "$G---------------------------------------------------------------" >> $motd
echo -e "$N" >> $motd
