touch downloaded_images.txt
mkdir Images

# Install required packages
pip install -r requirements.txt
pip install appscript

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

# Schedule running the bash script using iCalendar
# This is a workaround because crontab does not have permission to access Finder on MacOS
