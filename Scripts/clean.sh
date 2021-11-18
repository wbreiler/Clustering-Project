#!/bin/bash
echo "Would you like to remove the volumes?"
select yn in "Yes" "No"; do
	case $yn in
		Yes )
			docker volume rm $(docker volume ls -q);
			sleep 3;
			echo "Volumes removed";
			break;;
		No ) 
			echo "Volumes not removed";
			sleep 1;
			break;;
		esac
done

echo "Would you like to remove the containers?"
select yn in "Yes" "No"; do
	case $yn in
		Yes )
			docker service rm $(docker service ls -q);
			sleep 3;
			echo "Containers removed";
			break;;
		No ) 
			echo "Containers not removed";
			sleep 1;
			break;;
		esac
done
