#!/bin/bash
echo "Removing volumes, please wait."
sleep 5
docker volume rm minecraft-data hass-data
echo "Removing services, please wait."
docker service rm minecraft 
