#!/bin/bash

echo "Updating ansible inventory file"

EC2IP=$(cat terra.log | grep instance_public_ip | tail -n 1 | awk -F'"' '{print $2}')
echo $EC2IP

sed -i -e "s/EC2IP/${EC2IP}/g" dev.inv

cat dev.inv