#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS BELOW ##############################################################
mainbanner () {

touch /var/psautomate/auth.bypass

a7=$(cat /var/psautomate/auth.bypass)
if [[ "$a7" != "good" ]]; then domaincheck7; fi
echo good > /var/psautomate/auth.bypass

if [[ "$a7" != "good" ]]; then domaincheck7; fi
echo good > /var/psautomate/auth.bypass


tld=$(cat /var/psautomate/tld.program)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Press                            📓 Reference: psapress.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 PSA Press is a Mass WordPress Management System managed by PSAutomate!

[1] WordPress: Deploy a New Site
[2] WordPress: View Deployed Sites
[3] WordPress: Backup & Restore
[4] WordPress: Set a Top Level Domain - [$tld]
[5] WordPress: Destroy a Website
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER] ' typed < /dev/tty

case $typed in
    1 )
        deploywp
        mainbanner ;;
    2 )
        viewcontainers
        mainbanner ;;
    3 )

    # Checks to That RClone Works
    file=$()
    if [ ! -d "/mnt/gdrive/psautomate/backup/wordpress" ]; then

      # Makes a Test Directory for Checks
      rclone mkdir --config /opt/appdata/psautomate/rclone.conf gdrive:/psautomate/backup/wordpress
      rclonecheck=$(rclone lsd --config /opt/appdata/psautomate/rclone.conf gdrive:/psautomate/backup/ | grep wordpress)
      sleep 1

        # Conducts a Check Again; if fails; then exits
        if [ "$rclonecheck" == "" ]; then
          echo
          echo "💬  Unable to find - /mnt/gdrive/psautomate/backup/wordpress"
          echo ""
          echo "1. Did You Deploy PSAClone?"
          echo "2. Test by typing ~ ls -la /mnt/gdrive"
          echo ""
          read -p 'Confirm Info | Press [ENTER] ' typed < /dev/tty
          mainbanner; fi
    fi

        bash /opt/psapress/psavault/psavault.sh
        mainbanner ;;
    4 )
        tldportion
        mainbanner ;;
    5 )
        destroycontainers
        mainbanner ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

deploywp () {

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Setting a WordPress ID / SubDomain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Type the name for the subdomain wordpress instance. Instance can later be
turned to operate at the TLD (Top Level Domain). Keep it all lowercase and
with no breaks in space.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Quitting? TYPE > exit
EOF
read -p '↘️  Type Subdomain | Press [ENTER]: ' subdomain < /dev/tty

if [ "$subdomain" == "exit" ]; then mainbanner; fi
if [ "$subdomain" == "" ]; then deploywp; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Deploying WordPress Instance: $subdomain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

echo "$subdomain" > /tmp/wp_id

ansible-playbook /opt/psapress/db.yml
ansible-playbook /opt/psapress/wordpress.yml

wpdomain=$(cat /var/psautomate/server.domain)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Site Deployed! Visit - $subdomain.$wpdomain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

read -p '💬 Done? | Press [ENTER] ' typed < /dev/tty

}

viewcontainers () {

docker ps --format '{{.Names}}' | grep "wp-" > /var/psautomate/tmp.containerlist

file="/var/psautomate/tmp.format.containerlist"
if [ ! -e "$file" ]; then rm -rf /var/psautomate/tmp.format.containerlist; fi
touch /var/psautomate/tmp.format.containerlist
cat /var/psautomate/tmp.format.containerlist | cut -c 2- > /var/psautomate/tmp.format.containerlist

num=0
while read p; do
  p="${p:3}"
  echo -n $p >> /var/psautomate/tmp.format.containerlist
  echo -n " " >> /var/psautomate/tmp.format.containerlist
  num=$[num+1]
  if [ "$num" == 7 ]; then
    num=0
    echo " " >> /var/psautomate/tmp.format.containerlist
  fi
done </var/psautomate/tmp.containerlist

containerlist=$(cat /var/psautomate/tmp.format.containerlist)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Press                            📓 Reference: psapress.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 WP Containers Detected Running

$containerlist

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '💬 Done Viewing? | Press [ENTER] ' typed < /dev/tty
}

destroycontainers () {

docker ps --format '{{.Names}}' | grep "wp-" > /var/psautomate/tmp.containerlist

file="/var/psautomate/tmp.format.containerlist"
if [ ! -e "$file" ]; then rm -rf /var/psautomate/tmp.format.containerlist; fi
touch /var/psautomate/tmp.format.containerlist
cat /var/psautomate/tmp.format.containerlist | cut -c 2- > /var/psautomate/tmp.format.containerlist

num=0
while read p; do

  p="${p:3}"
  echo -n $p >> /var/psautomate/tmp.format.containerlist
  echo -n " " >> /var/psautomate/tmp.format.containerlist
  num=$[num+1]
  if [ "$num" == 7 ]; then
    num=0
    echo " " >> /var/psautomate/tmp.format.containerlist
  fi
done </var/psautomate/tmp.containerlist

containerlist=$(cat /var/psautomate/tmp.format.containerlist)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Press                            📓 Reference: psapress.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 WP Containers Detected Running

$containerlist

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Quitting? TYPE > exit
EOF

read -p '💬 Destory Which Container? | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "exit" ]]; then mainbanner; fi
if [[ "$typed" == "" ]]; then destroycontainers; fi

destroycheck=$(echo $containerlist | grep "$typed")

if [[ "$destroycheck" == "" ]]; then
echo
read -p '💬 WordPress Contanier Does Not Exist! | Press [ENTER] ' typed < /dev/tty
destroycontainers; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Press - Destroying the WordPress Instance - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

docker stop "wp-${typed}/mysql"
docker stop "wp-${typed}"
docker rm "wp-${typed}/mysql"
docker rm "wp-${typed}"
rm -rf "/opt/appdata/wordpress/${typed}"

echo
read -p "💬 WordPress Instance $typed Removed! | Press [ENTER] " abc < /dev/tty
mainbanner
}

tldportion () {

docker ps --format '{{.Names}}' | grep "wp-" > /var/psautomate/tmp.containerlist

file="/var/psautomate/tmp.format.containerlist"
if [ ! -e "$file" ]; then rm -rf /var/psautomate/tmp.format.containerlist; fi
touch /var/psautomate/tmp.format.containerlist
cat /var/psautomate/tmp.format.containerlist | cut -c 2- > /var/psautomate/tmp.format.containerlist

num=0
while read p; do
  p="${p:3}"
  echo -n $p >> /var/psautomate/tmp.format.containerlist
  echo -n " " >> /var/psautomate/tmp.format.containerlist
  num=$[num+1]
  if [ "$num" == 7 ]; then
    num=0
    echo " " >> /var/psautomate/tmp.format.containerlist
  fi
done </var/psautomate/tmp.containerlist

containerlist=$(cat /var/psautomate/tmp.format.containerlist)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Press - Set Top Level Domain     📓 Reference: psapress.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 WP Containers Detected Running

$containerlist

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Press - Set Top Level Domain     📓 Reference: psapress.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 WP Containers Detected Running

$containerlist

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Quitting? TYPE > exit
EOF

read -p '💪 Type WordPress Site for Top Level Domain | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "exit" ]]; then mainbanner; fi

destroycheck=$(echo $containerlist | grep "$typed")

if [[ "$destroycheck" == "" ]]; then
echo
read -p '💬 WordPress Contanier Does Not Exist! | Press [ENTER] ' typed < /dev/tty
tldportion; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: TLD Application Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 1.5

# Sets Old Top Level Domain
cat /var/psautomate/tld.program > /var/psautomate/old.program
echo "$typed" > /var/psautomate/tld.program

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Rebuilding Your Old App & New App Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 1.5

old=$(cat /var/psautomate/old.program)
new=$(cat /var/psautomate/tld.program)

touch /var/psautomate/tld.type
tldtype=$(cat /var/psautomate/tld.type)

if [[ "$old" != "$new" && "$old" != "NOT-SET" ]]; then

  if [[ "$tldtype" == "standard" ]]; then
    ansible-playbook /opt/psautomate/containers/$old.yml
  elif [[ "$tldtype" == "wordpress" ]]; then
    echo "$old" > /tmp/wp_id
    ansible-playbook /opt/psapress/wordpress.yml
    echo "$typed" > /tmp/wp_id
  fi
fi

# Repair this to Recall Port for It
echo "$new" > /tmp/wp_id
#echo "$port" > /tmp/wp_port

ansible-playbook /opt/psapress/wordpress.yml

# Notifies that TLD is WordPress
echo "wordpress" > /var/psautomate/tld.type

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  Top Level Domain Container is Rebuilt!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

read -p 'Press [ENTER] ' typed < /dev/tty

# Goes Back to Main Banner AutoMatically
}

domaincheck7() {
  domaincheck=$(cat /var/psautomate/server.domain)
  touch /var/psautomate/server.domain
  touch /tmp/portainer.check
  rm -r /tmp/portainer.check
  wget -q "https://portainer.${domaincheck}" -O /tmp/portainer.check
  domaincheck=$(cat /tmp/portainer.check)
  if [ "$domaincheck" == "" ]; then
  echo
  echo "💬  Unable to reach your Subdomain for Portainer!"
  echo ""
  echo "1. Forget to enable Traefik?"
  echo "2. Valdiate if Subdomain is Working?"
  echo "3. Validate Portainer is Deployed?"
  echo "4. Did you forget to put * wildcare in your DNS?"
  echo ""
  read -p 'Confirm Info | Press [ENTER] ' typed < /dev/tty
  exit; fi
}

mainbanner
