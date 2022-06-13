# Install required packages
pip install -r requirements.txt

# Create desktop shortcut
echo "#\!/bin/zsh" > ~/Desktop/test.sh
echo "cd $(pwd) && python3 main.py" >> ~/Desktop/test.sh
chmod +x ~/Desktop/test.sh

# Add program to crontab
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 11 * * * cd $(pwd) && python3 main.py >> crontab.log" >> mycron
#install new cron file
crontab mycron
rm mycron
