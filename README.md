# Raspberry Pi Cluster (WIP)
#### Prerequisites:
- Raspberry Pis running [Ubuntu Server](https://ubuntu.com/download/raspberry-pi) 64 bit
    - I'm using 2x Raspberry Pi CM4 8GB RAM, a Raspberry Pi 4B with 4GB RAM, and a Raspberry Pi 3B+ with 1GB RAM.
    - I wrote the Ubuntu Server image using the following command on my Mac:
        ```sh
        # Replace disk4 with the device name of your SD card
        $ sudo diskutil unmountDisk disk4 && pv ~/Downloads/RasPi\ Stuff/Ubuntu\ 20.04.img | sudo dd bs=1m of=/dev/disk4
        ```
        - On Windows, I'd recommend using the Raspberry Pi Imager from [Raspberry Pi Foundation](https://www.raspberrypi.org/downloads/raspi-imager/) or [Rufus](http://rufus.ie).
        - On Linux, I'd use this command:
            ```sh
            # Replace sdx with the device name of your SD card
            $ sudo dd bs=1m if=/home/user/Downloads/Ubuntu\ Server\ 20.04.img of=/dev/sdx status=progress
            ```
- [k3s](https://k3s.io)
    ```sh
    # Make sure your APT cache is updated
    $ sudo apt update
    # Install any updates
    $ sudo apt upgrade
    # Add "cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1" to /boot/firmware/cmdline.txt. This will enable the cpuset and memory cgroups.
    $ sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt
    # Reboot
    $ sudo reboot now
    # Install k3s
    $ curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
    ```
    - On the master node:
        ```sh
        # Find the server token and save it to a file
        $ sudo cat /var/lib/rancher/k3s/server/token > ~/token.txt
        ```
    - On the worker node(s):
        ```sh
        # Replace <server> with the IP address of the master node and <token> with the server token
        $ curl -sfL https://get.k3s.io | K3S_URL=https://<server>:6443 K3S_TOKEN=<token> sh -
        ```
- [Tailscale](http://tailscale.com) (optional, used for management outside of my LAN)
    ```sh
    # Output from the below command should be "OK"
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
    # Add repository to APT list
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    # Update package cache:
    $ sudo apt update
    # Install Tailscale:
    $ sudo apt install tailscale
    # Start Tailscale:
    $ sudo tailscale up
    # Find Tailscale IP address:
    $ tailscale ip -4
    ```
- [Helm](https://helm.sh) (Necessary to run the Minecraft server and Pi-hole)
    ```sh
    # Download the Helm install script
    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    # Make the script executable
    $ chmod 700 get_helm.sh
    # Run the script
    $ ./get_helm.sh
    ```
- [Netdata](https://netdata.cloud) (Optional. The build process might take a while, depending on the computer you're installing it on.)
    
    ```sh
	# Run install script:
	$ bash <(curl -Ss https://my-netdata.io/kickstart.sh)
	# Join my Netdata space
	$ bash <(curl -Ss https://my-netdata.io/kickstart.sh) --claim-token <token> --claim-rooms <room-id> --claim-url https://app.netdata.cloud
	```
#### Instructions:
- [Minecraft Server]()
	```sh
    # Add the stable helm repo
    $ sudo helm repo add stable https://kubernetes-charts.storage.googleapis.com
    # Create a namespace
    $ sudo kubectl create namespace minecraft
    # Install the Minecraft server, using the values we set in the manifest file
    $ sudo helm install --namespace minecraft --values manifests/minecraft/minecraft.yml minecraft stable/minecraft
    $ sudo kubectl get svc --namespace minecraft -w minecraft-minecraft
    ```
- [Home Assistant](https://home-assistant.io/)
    WIP
- [Monitoring](https://github.com/carlosedp/cluster-monitoring)
    ```sh
    # Update and install build-essential (needed for "make") and the go language
    $ sudo apt-get update && sudo apt-get install -y build-essential golang
    # Download the monitoring repo
    $ git clone https://github.com/carlosedp/cluster-monitoring.git
    # Enter the directory
    $ cd cluster-monitoring
    ```
    - Edit the `vars.jsonnet` file, tweaking the IP addresses to servers in the cluster, and enabling the `k3s` option as well as the `armExporter`
    ```sh
    $ make vendor
    $ make
    $ make deploy
    ```
- [Drupal](https://drupal.org/)
    - What is Drupal?	
	    - [Drupal]() is a CMS (content management system) written in PHP, similar to Wordpress.
    - Installing:
        ```sh
        $ sudo kubectl create namespace drupal
        $ sudo kubectl apply -f manifests/drupal/drupal.yml
        $ sudo kubectl apply -f manifests/drupal/mariadb.yml
        ```
        - Be sure to change the "host" value in the `drupal.yml` file to the IP address of the master node. 
- [Pi-hole](https://pi-hole.net/)
    - What is Pi-hole?
        - [Pi-hole]() is a DNS server that blocks ads and tracking.
    - Installing:   
        ```sh
        # Add the necessary repo to helm
        $ sudo helm repo add mojo2600 https://mojo2600.github.io/pi-hole-kubernetes/
        # Update your helm cache
        $ sudo helm repo update
        # Create pi-hole namespace
        $ sudo kubectl create namespace pihole
        # Install Pi-hole, using the values we set in the manifest file
        $ sudo helm install --namespace pihole --values manifests/pihole/pihole.yml pihole mojo2600/pihole
        ```
#### TODO:
- [ ] Add Home Assistant
- [ ] Make shell script to install all of the above
    - [ ] Make an Ansible playbook to install all of the above
- [ ] Add a "cleanup" script that will remove all of the above
    - [ ] Make an Ansible playbook to remove all of the above
- [ ] Clean up formatting
- [ ] Take a picture of the cluster and upload it to GitHub
- [ ] Order 2x of [these](https://www.aliexpress.com/item/1005003389500589.html)
- [ ] Order PoE HATs from AdaFruit [here](https://www.adafruit.com/product/5058)
- [ ] Order PoE switch [here](https://www.amazon.com/dp/B076HZFY3F/)
- [ ] Order [this](https://www.amazon.com/dp/B07K72STFB)
