#!/bin/bash
echo "Would you like to start the installation?"
select yn in "Yes" "No"; do
		case $yn in
				Yes ) 
					echo "Starting installation..."; 
					sleep 3;
					echo "Creating volumes, please wait.";
					sleep 3;
					docker volume create minecraft-data;
					docker volume create hass-data;
					docker volume create drupal-modules;
					docker volume create drupal-profiles;
					docker volume create drupal-themes;
					docker volume create drupal-sites;
					docker volume create pihole;
					docker volume create dnsmasq;
					echo "Creating containers";
					sleep 3;
					echo "Starting Minecraft server";
					docker service create --name minecraft-server --publish 25565:25565 --publish 19132:19132 --mount source=minecraft-data,target=/data -e EULA=TRUE -e TYPE=PAPER itzg/minecraft-server;
				sleep 3;
				echo "Starting Home Assistant";
				docker service create --name hass --privileged -e TZ=America/Chicago --mount source=hass-data,target=/config --network=host ghcr.io/home-assistant/home-assistant stable;
				echo "Creating Drupal server";
				docker service create --name postgres -e POSTGRES_PASSWORD=<password> postgres:10
				sleep 4;
				docker service create --name drupal --publish 8080:80 --mount source=drupal-modules,target=/var/www/html/modules --mount source=drupal-profiles,target=/var/www/html/profiles --mount source=drupal-themes,target=/var/www/html/themes --mount source=drupal-sites,target=/var/www/html/sites drupal:8-apache;
				sleep 3;
				echo "Installing Pihole";
				sleep 3;
				docker service create --name pihole -e TZ=America/Chicago -e WEBPASSWORD=<password> -e SERVERIP=<server ip> --mount source=pihole,target=/etc/pihole --mount source=dnsmasq,target=/etc/dnsmasq.d --publish 80:80 --publish 53:53/tcp --publish 53:53/udp pihole/pihole;
				sleep 3;
				echo "Scaling the services";
				docker service scale minecraft=server=3;
				sleep 3;
				docker service scale hass=3;
				sleep 3;
				docker service scale postgres=3;
				sleep 3;
				docker service scale drupal=3;
				sleep 3;
				docker service scale pihole=3;
				sleep 3;
				echo "Scaling complete";
				sleep 3;
				echo "Installation completed";
				break;;
				No )
					echo "Installation cancelled";
					exit;;
		esac
done
