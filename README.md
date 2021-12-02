# Raspberry Pi Cluster (WIP)

#### Prerequisites:

- Raspberry Pis running [Ubuntu Server](https://ubuntu.com/download/raspberry-pi) 64 bit
  - I'm using 2x Raspberry Pi CM4 8GB RAM, a Raspberry Pi 4B with 4GB RAM, and a Raspberry Pi 3B+ with 1GB RAM.
  - I wrote the Ubuntu Server image using the following command on my Mac:
    ```sh
    # Replace disk4 with the device name of your SD card
    sudo diskutil unmountDisk disk4 && pv ~/Downloads/RasPi\ Stuff/Ubuntu\ 20.04.img | sudo dd bs=1m of=/dev/disk4
    ```
  - On Windows, I'd recommend using the [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/raspi-imager) from Raspberry Pi Foundation or [Rufus](http://rufus.ie).
  - On Linux, I'd use this command:   
    ```sh
    # Replace sdx with the device name of your SD card
    sudo dd bs=1m if=/home/user/Downloads/Ubuntu\ Server\ 20.04.img of=/dev/sdx status=progress
    ```
- Unattended Upgrades disabled
   ```sh
   # This sounds counterintuitive, but there are packages that need to be installed
   # and that can't be done with unattended-upgrades running
   sudo systemctl stop unattended-upgrades
   # Disable it
   sudo systemctl disable unattended-upgrades
   ```
- [Docker](https://www.docker.com/)
  - On all nodes:
    ```sh
    # Make sure your APT cache is updated
    sudo apt update
    # Install any updates
    sudo apt upgrade
    # Install necessary prerequisites
    sudo apt-get install ca-certificates curl gnupg lsb-release
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    # Add the Docker repository to APT sources
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Update the APT cache
    sudo apt update
    # Install Docker
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    # Add user to docker group
    sudo usermod -aG docker $USER
    # Reboot
    sudo reboot now
    ```
  - On the master node:
    ```sh
    # Initialize Docker Swarm
    docker swarm init --advertise-addr <IP address>
    ```
  - On the worker node(s):
    ```sh
    # Replace <server> with the IP address of the master node and <token> with the server token
    docker swarm join --token <token> <server>:2377
    ```
- [Tailscale](http://tailscale.com) (Optional, used for management outside of my LAN)
  ```sh
  # Output from the below command should be "OK", if it isn't run it again
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
  # Add repository to APT list
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
  # Update package cache:
  sudo apt update
  # Install Tailscale:
  sudo apt install tailscale
  # Start Tailscale:
  sudo tailscale up
  # Find Tailscale IPv4 address:
  tailscale ip -4
  ```
- [Netdata](https://netdata.cloud) (Optional. The build process might take a while, depending on the computer you're installing it on.)
  ```sh
  # Run install script:
  bash <(curl -Ss https://my-netdata.io/kickstart.sh)
  # Join my Netdata space
  bash <(curl -Ss https://my-netdata.io/kickstart.sh) --claim-token <token> --claim-rooms <room-id> --claim-url https://app.netdata.cloud
  ```
  #### Instructions:
- [Minecraft Server](https://github.com/itzg/docker-minecraft-server)
  ```sh
  # Make Minecraft volume
  docker volume create minecraft-data
  # Run the server
  docker service create --name minecraft-server --publish 25565:25565 --publish 19132:19132 --mount source=minecraft-data,target=/data -e EULA=TRUE -e TYPE=PAPER -e MEMORY=3G itzg/minecraft-server
  # Scale the service
  docker service scale minecraft-server=3
  ```
- [Home Assistant](https://home-assistant.io/)
  - What is [Home Assistant]()?
    - [Home Assistant]() is a free and open-source software for home automation that's designed to be the central control system for smart home devices with focus on local control and privacy. It is commonly hosted on a Raspberry Pi
  - Installation (WIP): 
- [Drupal](https://drupal.org/)
  - What is Drupal?
    - [Drupal]() is a CMS (content management system) written in PHP, similar to Wordpress.
  - Installation (WIP):
    ```sh
    # Download the stack.yml file
    wget https://raw.githubusercontent.com/wbreiler/Clustering-Project/master/stack.yml  
    # Run the server
    docker stack deploy -c stack.yml drupal
    # Scale the services
    docker service scale drupal_drupal=3
    docker serivce scale drupal_postgres=3
    ```
- [Pi-hole](https://pi-hole.net/)
  - What is Pi-hole?
    - [Pi-hole]() is a DNS server that blocks ads and tracking, originally created for use on a Raspberry Pi.
  - Installation:
    ```sh
    # Create the volumes
    docker volume create pihole
    docker volume create dnsmasq
    # Run Pi-hole
    docker service create --name pihole -e TZ=America/Chicago -e WEBPASSWORD=<password> -e SERVERIP=<serverip> --mount source=pihole,target=/etc/pihole --mount source=dnsmasq,target=/etc/dnsmasq.d --publish 80:80 --publish 53:53/tcp --publish 53:53/udp pihole/pihole
    # Scale the service
    docker service scale pihole=3
    ```
- [Heimdall](http://heimdall.site)
  - What is Heimdall?
    - [Heimdall]() is a dashboard to manage all of your applications. It doesn't have to be limited to just applications though, it can link to anything you'd like.
  - Installation:
    ```sh
    # Create the volumes
    docker volume create heimdall-config
    # Run Heimdall
    docker service create --name dashboard -e TZ=America/Chicago --publish 80:80 --publish 443:443 --mount source=heimdall-config.target=/config lscr.io/linuxserver/heimdall
    # Scale the service
    docker service scale dashboard=3
    ```

#### TODO:
- [ ] Make shell script to install all of the above (In progress)
- [ ] Add a "cleanup" script that will remove all of the above (In progress)
- [ ] Clean up formatting (In progress)
- [ ] Take a picture of the cluster and upload it to GitHub (Waiting on another CM4)
- [ ] Order 2x of [these](https://www.aliexpress.com/item/1005003389500589.html)
- [ ] Order PoE HATs from AdaFruit [here](https://www.adafruit.com/product/5058)
- [ ] Order PoE switch [here](https://www.amazon.com/dp/B076HZFY3F/)
- [ ] Order [this](https://www.amazon.com/dp/B07K72STFB)
