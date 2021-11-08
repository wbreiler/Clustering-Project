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
- [Tailscale](http://tailscale.com) (Optional, used for management outside of my LAN)
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
- This repository cloned to your master node
     ```sh
     # Clone the repo
     $ git clone --depth=1 https://github.com/wbreiler/Clustering-Project
     # Enter the directory
     $ cd Clustering-Project
     ```
#### Instructions:
- [Minecraft Server]() (Be sure to change the values in [`minecraft.yml`](https://github.com/wbreiler/Clustering-Project/blob/master/manifests/minecraft/minecraft.yml) to fit your server's resources.)
	```sh
    # To give the node where Minecraft is running access to the whole CPU and RAM you'll need to "taint" it so it only tolerates the Minecraft Server
    $ sudo kubectl taint nodes <node-name> app=minecraft:NoSchedule
    # And to make sure that the minecraft installation will select the node it tolerates you'll also need to label the node.
    $ sudo kubectl label nodes <node-name> role=minecraft
    # Add the minecraft Helm repo
    $ sudo helm repo add itzg https://itzg.github.io/minecraft-server-charts/
    # Update the Helm repo cache
    $ sudo helm repo update
    # Create the minecraft namespace
    $ sudo kubectl create namespace minecraft
    # Install the minecraft server
    $ sudo helm install --namespace minecraft minecraft -f manifests/minecraft/minecraft.yml itzg/minecraft --kubeconfig /etc/rancher/k3s/k3s.yaml
    # Make sure the minecraft server is running
    $ sudo kubectl get pods --namespace minecraft
    # Find the minecraft server IP address
    $ sudo kubectl get pods --namespace minecraft -o wide | grep minecraft | awk '{print $6}'
    ```
- [Home Assistant](https://home-assistant.io/)
    ```sh
    
    ```
- [Monitoring](https://github.com/carlosedp/cluster-monitoring)
    ```sh
    # Update and install build-essential (needed for "make") and the go language
    $ sudo apt-get update && sudo apt-get install -y build-essential golang
    # Clone the monitoring repo
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
- [ ] Add Home Assistant (In progress)
- [ ] Make shell script to install all of the above
    - [ ] Make an Ansible playbook to install all of the above (Need help)
- [ ] Add a "cleanup" script that will remove all of the above
    - [ ] Make an Ansible playbook to remove all of the above (Need help)
- [ ] Clean up formatting (In progress)
- [ ] Take a picture of the cluster and upload it to GitHub (Waiting on the the Pi 3B+, another CM4, and the Raspberry Pi 4)
- [ ] Order 2x of [these](https://www.aliexpress.com/item/1005003389500589.html)
- [ ] Order PoE HATs from AdaFruit [here](https://www.adafruit.com/product/5058)
- [ ] Order PoE switch [here](https://www.amazon.com/dp/B076HZFY3F/)
- [ ] Order [this](https://www.amazon.com/dp/B07K72STFB)
