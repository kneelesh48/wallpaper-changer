# Install required packages
pip install -r requirements.txt

# Create downloaded_images.txt
touch downloaded_images.txt

# Create desktop shortcut
echo "#\!/bin/zsh" > ~/Desktop/wallpaper-changer.sh
echo "cd $(pwd) && python3 main.py" >> ~/Desktop/wallpaper-changer.sh
chmod +x ~/Desktop/wallpaper-changer.sh

# # Add program to crontab
# # write out current crontab
# crontab -l > mycron
# # echo new cron into cron file
# echo "0 11 * * * cd $(pwd) && python3 main.py >> crontab.log" >> mycron
# # install new cron file
# crontab mycron
# rm mycron

# Schedule running the bash script on the desktop using iCalendar.
# This is a workaround for the fact that crontab does not have access to Finder
# cron does not have access to Finder and there is no way to allow cron access to Finder
