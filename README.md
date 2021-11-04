# Raspberry Pi Cluster
#### Prerequisites:
- Raspberry Pis running Ubuntu Server 64 bit
    - I'm using 2x Raspberry Pi CM4 8GB RAM, a Raspberry Pi 4B with 4GB RAM, and a Raspberry Pi 3B+ with 1GB RAM.
    - I installed Ubuntu Server using the following command on my Mac:
        ``` console
        $ sudo diskutil unmountDisk disk4 && pv Downloads/RasPi\ Stuff/Ubuntu\ 20.04.img | sudo dd bs=1m of=/dev/disk4
        ```
- microk8s
    ```console
    $ sudo snap install microk8s --classic`
    $ sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt`
    $ sudo microk8s.enable dns storage`
    $ reboot now
    ```
    - On the master node:
        ```console
        $ sudo microk8s add-node
        ```
    - On the worker nodes:
        ```console
        $ sudo microk8s join ip-<ip>:25000/<key>
        ```
    - After all nodes are joined, run `$ sudo microk8s kubectl get nodes`
    - Make sure HA (high availability) is working by running `$ sudo microk8s status`. If it is working, it should show 
    ```console
    microk8s is running
    high-availability: yes
    ```
- Tailscale
    ```console
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    $ sudo apt update
    $ sudo apt install tailscale`
    $ sudo tailscale up
    $ tailscale ip -4
    ```
#### Instructions:
- Minecraft Server
	- ``
	- ``
	- ``
	- ``
	- ``
- Home Assistant
	- ``
	- ``
	- ``
	- ``
	- ``
- Monitoring
	- ``
	- ``
	- ``
	- ``
	- ``
- Personal Cloud
	- ``
	- ``
	- ``
	- ``
	- ``
- Code Server
	- ``
	- ``
	- ``
	- ``
	- ``
- Drupal
	- ``
	- ``
    - ``
	- ``
	- ``
- Pastebin
	- ``
	- ``
	- ``
	- ``
	- ``
- Notes
	- ``
    - ``
	- ``
	- ``
	- ``
