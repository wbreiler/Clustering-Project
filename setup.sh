#!/bin/bash
echo "Would you like to start the installation?"
select yn in "Yes" "No"; do
		case $yn in
				Yes ) 
					echo "Starting installation..."; 
					sleep 3;
					echo "Installing dependencies...";
					sudo apt update;
					sudo apt install ca-certificates curl gnupg lsb-release -y -qqq;
					sleep 3;
					echo "Installing Docker...";
					curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
					echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
					sudo apt update;
					sudo apt install docker-ce docker-ce-cli containerd.io -y -qqq;
					sleep 3;
					echo "Adding your user to the Docker group...";
					sudo usermod -aG docker $USER;
					echo "Initalizing Docker swarm";
					sudo docker swarm init;
					break;;
				No ) 
					echo "Exiting";
					exit;;
		esac
done
