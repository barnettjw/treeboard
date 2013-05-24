#!/bin/bash
#edit these variables
ducksboard_api="4Y5AoALWKKsH03KUg587VeyRMAIBLBpi0NMsMkCMlNecNQDuz3"
ducksboard_widget_leaderboard="166564"
ducksboard_widget_total="166294"
ducksboard_widget_text="166531"
treehouse_users=('jim' 'nickpettit' 'bendog24' 'pasanpr' 'chalkers' 'guil' 'amit' 'jasonseifer' 'mathelme' 'dangorgone' 'randyhoyt' 'zgordon' )

###################
echo > temp
echo > sorted

let total=0
#loop through users getting info via curl calls against json
count=${#treehouse_users[@]}
for (( i=0; i < count; i++)); do
	curl -s http://teamtreehouse.com/${treehouse_users[${i}]}.json > json
	  name=$(cat json | jq '.name')
	points=$(cat json | jq '.points.total')
	badges=$(cat json | jq '.badges | length')
	#echo "$name,$points,$badges" #view data as it's written for the impatient debugger
	echo "$name,$points,$badges" >> temp #write to a file so it can be easily sorted
	let total+=$badges
done 

# sort by points then format output as json
# adding a comma between elements except for the last
sort -t"," -nr -k2 temp | head -n -1 >sorted
count=$(wc -l < sorted)
let a=1
while IFS=',' read name2 points2 badges2
do
     data+="{\"name\": $name2, \"values\": [$points2, $badges2]}"
	if [ $a -lt $count ]; then
		data+=",";
	fi
	let a++
done < sorted

data="{\"value\": {\"board\": [$data]}}"
total="{\"value\": $total}"
#echo $data | python -mjson.tool #debug check for properly formatted json
curl -s https://push.ducksboard.com/values/$ducksboard_widget_leaderboard -u $ducksboard_api:x -d"$data"
curl -s https://push.ducksboard.com/values/$ducksboard_widget_total -u $ducksboard_api:x -d"$total"

#get top user from sorted, remove quotes around named that were added by jq, use awk to parse csv
leader=$(head -1 sorted | sed s/\"//g | awk -F ',' '{print "Current Leader is " $1 " with " $2 " points & " $3 " badges";}') 
text="{\"timestamp\": $(date +%s),\"value\": {\"content\": \"$leader\"}}"
curl -s https://push.ducksboard.com/values/$ducksboard_widget_text -u $ducksboard_api:x -d"$text"
date +"%D %R %Z" #add date to cronjob log
echo