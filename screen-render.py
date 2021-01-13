import socket
import time
import os, sys
from PIL import Image

# if socket.gethostname() == "rpiv2":
import gfxcili.ili9486
    # width, height, SPI, SPEED, CS, RST, RS
lcd = gfxcili.ili9486.ili9486(480, 320, 0, 3200000, 8, 25, 24)
lcd.rotation = 270
lcd.init()



while True:
    old_image = None
    
    try:
        img = Image.open("/usr/screenshots/UmbrUI.png")
    except:
        # If there is no screenshot wait 5 for the app to start
        time.sleep(5)
        continue
    
    # If the image has not changed do not update the screen
    if old_image == img:
        continue

    # Resize to correctly fit the screen
    basewidth = 480
    wpercent = (basewidth/float(img.size[0]))
    hsize = int((float(img.size[1])*float(wpercent)))
    img = img.resize((basewidth,hsize), Image.ANTIALIAS)
    lcd.draw_image(0,0, img)
    
    time.sleep(5)

