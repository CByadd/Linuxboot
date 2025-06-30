#!/bin/bash

KIOSK_URL="https://adscape-player.vercel.app"
LOGO_PATH="/etc/splash.png"

echo "🔧 Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "📦 Installing kiosk dependencies..."
sudo apt install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox chromium-browser fbi unclutter -y

echo "🖼️ Setting up splash logo..."
sudo cp splash.png $LOGO_PATH
sudo sed -i '/exit 0/i fbi -T 1 -noverbose -a /etc/splash.png' /etc/rc.local

echo "🧹 Disabling cursor and blanking..."
echo -e 'xset -dpms\nxset s off\nxset s noblank\nunclutter &' > ~/.xinitrc
echo "openbox-session &" >> ~/.xinitrc
echo "chromium-browser --kiosk --noerrdialogs --disable-infobars --incognito $KIOSK_URL" >> ~/.xinitrc
chmod +x ~/.xinitrc

echo "🔁 Auto start X on login..."
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx' >> ~/.bashrc

echo "🧼 Cleaning boot text..."
sudo sed -i 's/console=serial0,115200 //g' /boot/cmdline.txt
sudo sed -i 's/console=tty1 //g' /boot/cmdline.txt
sudo sed -i 's/$/ quiet splash logo.nologo vt.global_cursor_default=0/' /boot/cmdline.txt

echo "✅ Kiosk setup complete. Rebooting..."
sudo reboot
