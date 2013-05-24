#Treeboard

##Description

Treeboard is a custom widget for Duckboard, it gets user info from Treehouse via JSON and then pushes it to Ducksboard. 

It's just a proof-of-concept that was hacked together using bash, you are welcome to use it for whatever you like.

####Live Demo at [treeboard.mooo.com](http://treeboard.mooo.com/)

####Screenshot of the leaderboard
![](http://i.imgur.com/O65idrp.jpg)

---

##Get Ready

- [Sign up for Ducksboard](http://ducksboard.com/)
- Create 3 custom widgets on your Duckboard dashboard:
 - leaderboard
 - text
 - counter
- [Install jq](http://stedolan.github.io/jq/download/)

## Install the Script

- Place the treeboard.sh in your home directory
- `chmod u+x treeboard.sh` 

## Configure the Script

- Edit variables for:
 - Your Ducksboard API key
 - Your Ducksboard widgets you created earlier
 - List of Treehouse usernames

## Set the Cron job

- Set the script to push data to Ducksboard at regular intervals
- `crontab -e`
- To run every 5 minutes
 - `*/5 * * * ~/treeboard.sh>>treeboard.cron`
- Save the file