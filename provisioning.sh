sudo systemctl daemon-reload
sudo systemctl restart docker
# Enable Docker on server reboot
sudo systemctl enable docker
# Remove and clean unused packages
sudo apt-get autoremove -y
sudo apt-get autoclean -y
