#!/bin/bash
echo "Would you like to remove the volumes?"
select yn in "Yes" "No"; do
		case $yn in
				Yes )
						docker volume rm $(docker volume ls -q);
						echo "Volumes removed";
						break;;
				No ) exit;;
		esac
done

echo "Would you like to remove the containers?"
select yn in "Yes" "No"; do
		case $yn in
				Yes )
						docker rm $(docker ps -a -q);
						echo "Containers removed";
						break;;
				No ) exit;;
		esac
done
