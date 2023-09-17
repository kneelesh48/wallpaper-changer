import os
import random
import logging
import platform

import requests
from notifypy import Notify

from config import wallpaper_subs

if platform.system() == "Windows":
    import ctypes
elif platform.system() == "Darwin":
    from appscript import app, mactypes

cd = os.path.dirname(os.path.abspath(__file__))

notification = Notify(default_notification_title="Wallpaper Changer")


def logger_config():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter("%(asctime)s:%(name)s:%(levelname)s:%(message)s")

    file_handler = logging.FileHandler(f"logfile.log", encoding="UTF-8")
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    stream_handler = logging.StreamHandler()
    logger.addHandler(stream_handler)
    return logger
logger = logger_config()


def fetch_wallpaper(sub, limit=5):
    url = f"https://www.reddit.com/r/{sub}/top.json"
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"
    }
    params = {
        't': 'day',
        'limit': limit
    }

    data = requests.get(url, headers=headers, params=params, timeout=30).json()

    returned_len = len(data["data"]["children"])
    n = random.randint(0, returned_len - 1)
    for i in range(returned_len):  # <returned_len> retries
        submission = data["data"]["children"][(n + i) % returned_len]
        img_url = submission["data"]["url"]
        logger.info(img_url)
        file_name = img_url.split("/")[-1]

        # downloaded_images = os.listdir('Images')
        with open("downloaded_images.txt", encoding="utf-8") as f:
            downloaded_images = f.read().split("\n")

        if file_name in downloaded_images:
            logger.info("File already downloaded")
            continue
        if "post_hint" not in submission["data"]:
            continue
        if submission["data"]["post_hint"] != "image":  # url not image
            logger.info("File not image")
            continue
        if img_url[-3:] == "gif":  # Image is gif
            logger.info("File is a gif")
            continue

        width = submission["data"]["preview"]["images"][0]["source"]["width"]
        height = submission["data"]["preview"]["images"][0]["source"]["height"]
        if width <= height:  # vertical image
            logger.info("Vertical")
            continue
        if not (width >= 1280 and height >= 720):  # Low resolution
            logger.info("Low resolution image")
            continue

        title = submission["data"]["title"]

        logger.info("Downloading file...")
        img_data = requests.get(img_url, headers=headers, timeout=30).content
        with open(f"Images/{file_name}", "wb") as f:
            f.write(img_data)
        with open("downloaded_images.txt", "a", encoding="utf-8") as f:
            print(file_name, file=f)
        logger.info("File downloaded!")
        return (file_name, title)
    return None


def wallpaper_changer():
    num_retries = 5
    for _ in range(num_retries):  # if no image found, try another subreddit
        sub = random.choice(wallpaper_subs)[0]
        logger.info("Subreddit: %s", sub)
        file_name_title = fetch_wallpaper(sub, limit=5)
        if file_name_title is None:
            continue
        file_name, title = file_name_title

        # Set image as wallpaper
        abs_img_path = f"{cd}/Images/{file_name}"
        if platform.system() == "Windows":
            ctypes.windll.user32.SystemParametersInfoW(20, 0, abs_img_path, 0)
        elif platform.system() == "Darwin":
            app("Finder").desktop_picture.set(mactypes.File(abs_img_path))

        # Send desktop notification
        notification.message = f"{title} from r/{sub} set as wallpaper"
        notification.send()
        logger.info("Wallpaper Changed!\n")
        return


if __name__ == "__main__":
    try:
        wallpaper_changer()
    except requests.ConnectionError:
        logger.error("No internet, can't download wallpaper\n")
        notification.message = "No internet, can't download wallpaper"
        notification.send()
