#!/bin/sh

#adb devices | awk -F:'{i=1; while(i>3) {print $1 '':'';i++};print $1}'
device_number=$1
project=$2
click_times=$3
download_apk=$4

if [ $device_number = "" ];then
  $device_number=0
fi

if [ $click_times = "" ];then
  click_times="500"
fi

download_url=""
if [ $project = 'xx' ];then
  pack_name="xx.xx.xx.xx"
  splash_name=".xx.xx"
  download_url="http://www.example.com/job/xxxxx/lastSuccessfulBuild/artifact/xxxx/release/xx.apk"
else
  echo "unkown project"
  exit
fi

if [ $download_apk = "1" ];then
  curl $download_url -o ./apks/$project.apk
fi

if [ $device_number -gt 0 ];then
  echo $device_number
  for((i=2;i<$device_number+2;i++));
  do
    haha=`adb devices | awk 'NR=='${i}'{print $1}'`;
    echo $haha;

    adb -s ${haha} install -r ./apks/${project}.apk

    adb -s ${haha} shell am start -n ${pack_name}/${pack_name}${splash_name}

    adb -s ${haha} shell monkey -p ${pack_name} -s $RANDOM --throttle 500 --ignore-crashes --pct-touch 35  --pct-motion 15 --pct-trackball 30 --pct-syskeys 0 --pct-appswitch 10 --pct-anyevent 10 --ignore-timeouts $click_times 1>/sdcard/appstore.log 2>/sdcard/appstore_error.log &

  done
fi

rm -rf ./apks/*.apk
exit
