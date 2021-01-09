import random
import requests
import ctypes
import os
from config import wallpaper_subs

sub=random.choice(wallpaper_subs)[0]
print(sub)
headers={'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36'}
data=requests.get(f"https://www.reddit.com/r/{sub}/hot.json?limit=5",headers=headers).json()
img_url=data['data']['children'][random.randint(0,4)]['data']['url']
r=requests.get(img_url)
filepath=f"Images/{r.url.split('/')[-1]}"
open(filepath,'wb').write(r.content)

# print(filepath)
abs_img_path=f"{os.getcwd()}/{filepath}"
ctypes.windll.user32.SystemParametersInfoW(20, 0, abs_img_path , 0)
