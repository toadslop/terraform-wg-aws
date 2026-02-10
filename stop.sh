#!/bin/bash

#Check if you're still connected to the VPN you created
ip_one="$(terraform output | grep Endpoint | awk {'print $3'} | sed 's/:.*$//')"
ip_two="$(curl --silent icanhazip.com)"

if [ "$ip_one" = "$ip_two" ] ; then 
  echo "ERROR: Disconnect from the VPN before destroying the environment that it runs on!" ; 
  exit 1 ; 
fi

terraform destroy -auto-approve

#Remove lines containing keys from terraform.tfvars
sed -i '/^p1_private_key/d' terraform.tfvars
sed -i '/^p1_public_key/d' terraform.tfvars
sed -i '/^p2_private_key/d' terraform.tfvars
sed -i '/^p2_public_key/d' terraform.tfvars
sed -i '/^wg_ps_key/d' terraform.tfvars

#Add empty keys into terraform.tfvars
echo "p1_private_key   = \"\"" >> terraform.tfvars
echo "p1_public_key    = \"\"" >> terraform.tfvars
echo "p2_private_key   = \"\"" >> terraform.tfvars
echo "p2_public_key    = \"\"" >> terraform.tfvars
echo "wg_ps_key        = \"\"" >> terraform.tfvars