#screen sharing doesn't work , turn off wayland
#########################
#https://askubuntu.com/questions/1407494/screen-share-not-working-in-ubuntu-22-04-in-all-platforms-zoom-teams-google-m
sudo vim /etc/gdm3/custom.conf
#uncomment WaylandEnable=false
echo $XDG_SESSION_TYPE



