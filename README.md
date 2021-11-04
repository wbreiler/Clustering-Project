# Raspberry Pi Cluster (WIP)
#### Prerequisites:
- Raspberry Pis running [Ubuntu Server](https://ubuntu.com/download/raspberry-pi) 64 bit
    - I'm using 2x Raspberry Pi CM4 8GB RAM, a Raspberry Pi 4B with 4GB RAM, and a Raspberry Pi 3B+ with 1GB RAM.
    - I installed Ubuntu Server using the following command on my Mac:
        ``` console
        $ sudo diskutil unmountDisk disk4 && pv ~/Downloads/RasPi\ Stuff/Ubuntu\ 20.04.img | sudo dd bs=1m of=/dev/disk4
        ```
- [k3s](https://k3s.io)
    ```console
    $ sudo apt update
    $ sudo apt upgrade
    $ sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt`
    $ curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
    $ sudo reboot now
    ```
    - On the master node:
        ```console
        $ sudo cat /var/lib/rancher/k3s/server/token
    - On the worker nodes:
        ```console
        $ curl -sfL https://get.k3s.io | K3S_URL=https://<server>:6443 K3S_TOKEN=<token> sh -
        ```
- [Tailscale](http://tailscale.com) (optional)
    ```console
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
    $ curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    $ sudo apt update
    $ sudo apt install tailscale`
    $ sudo tailscale up
    $ tailscale ip -4
    ```
- [Helm](https://helm.sh) (Necessary to run the Minecraft server)
    ```console
    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh
    ```
#### Instructions:
- [Minecraft Server]()
	```console
    $ sudo helm repo add stable https://kubernetes-charts.storage.googleapis.com
    $ sudo kubectl create namespace minecraft
    $ sudo helm install --version '1.2.2' --namespace minecraft --values manifests/minecraft/minecraft.yml minecraft stable/minecraft
    $ sudo kubectl get svc --namespace minecraft -w minecraft-minecraft
    ```
- [Home Assistant](https://home-assistant.io/)
    WIP
- [Monitoring](https://github.com/carlosedp/cluster-monitoring)
    ```console
    $ sudo apt-get update && apt-get install -y build-essential golang
    $ git clone https://github.com/carlosedp/cluster-monitoring.git
    $ cd cluster-monitoring
    ```
    Edit the `vars.jsonnet` file, tweaking the IP addresses to servers in the cluster, and enabling the `k3s` option as well as the `armExporter`
    ```console
    $ make vendor
    $ make
    $ make deploy
- [Drupal](https://drupal.org/)
    ```console
    $ sudo kubectl create namespace drupal
    $ sudo kubectl apply -f manifests/drupal/drupal.yml
    $ sudo kubectl apply -f manifests/drupal/mariadb.yml
    ```
    - Be sure to change the "host" value in the `drupal.yml` file to the IP address of the master node. 
- [Pi-hole](https://pi-hole.net/)
    ```console
    $ sudo helm repo add mojo2600 https://mojo2600.github.io/pi-hole-kubernetes/
    $ sudo helm repo update
    $ sudo kubectl create namespace pihole
    $ sudo helm install --version '1.7.6' --namespace pihole --values manifests/pihole/pihole.yml pihole mojo2600/pihole
    ```