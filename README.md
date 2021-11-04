# Raspberry Pi Cluster
#### Prerequisites:
- Raspberry Pis running [Ubuntu Server]() 64 bit
    - I'm using 2x Raspberry Pi CM4 8GB RAM, a Raspberry Pi 4B with 4GB RAM, and a Raspberry Pi 3B+ with 1GB RAM.
    - I installed Ubuntu Server using the following command on my Mac:
        ``` console
        $ sudo diskutil unmountDisk disk4 && pv Downloads/RasPi\ Stuff/Ubuntu\ 20.04.img | sudo dd bs=1m of=/dev/disk4
        ```
- [k3s](https://k3s.io)
    ```console
    $ sudo apt update
    $ sudo apt upgrade
    $ sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt`
    $ curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
    $ reboot now
    ```
    - On the master node:
        ```console
        $ sudo cat /var/lib/rancher/k3s/server/token
    - On the worker nodes:
        ```console
        $ curl -sfL https://get.k3s.io | K3S_URL=https://<server>:6443 K3S_TOKEN=<token> sh -
        ```
- [Tailscale]() (optional)
    ```console
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    $ sudo apt update
    $ sudo apt install tailscale`
    $ sudo tailscale up
    $ tailscale ip -4
    ```
#### Instructions:
- [Minecraft Server]()
	- ``
	- ``
	- ``
	- ``
	- ``
- [Home Assistant](https://home-assistant.io/)
    - ``
    - ``
    - ``
    - ``
    - ``
	- ``
	- ``
	- ``
	- ``
	- ``
- [Uptime Kuma](https://github.com/louislam/uptime-kuma)
	- ``
	- ``
	- ``
	- ``
	- ``
- [Grafana](https://github.com/carlosedp/cluster-monitoring)
    ```console
    $ sudo su -
    # apt-get update && apt-get install -y build-essential golang
    # git clone https://github.com/carlosedp/cluster-monitoring.git
    # cd cluster-monitoring
    ```
    Edit the `vars.jsonnet` file, tweaking the IP addresses to servers in the cluster, and enabling the `k3s` option as well as the `armExporter`
    ```console
    # make vendor
    # make
    # make deploy
- [Personal Cloud]()
	- ``
	- ``
	- ``
	- ``
	- ``
- [Code Server]()
	- ``
	- ``
	- ``
	- ``
	- ``
- [Drupal](https://drupal.org/)
	- ``
	- ``
    - ``
	- ``
	- ``
- [Pastebin]()
	- ``
	- ``
	- ``
	- ``
	- ``
- [Notes]()
	- ``
    - ``
	- ``
	- ``
	- ``
