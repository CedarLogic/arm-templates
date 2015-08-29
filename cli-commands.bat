####### Classic resources ##########

## Create the classic resources

# Step 1 - create the affinity group
azure account affinity-group create profx-sec-group -l "East US 2" -e profx-sec-group

# Step 2.1: create the VNET
azure network vnet create --vnet profx-fe-vnet -e 10.1.0.0 -I 16 -a profx-sec-group --subnet-start-ip 10.1.1.0 --subnet-cidr 24 --subnet-name profx-fe-worker

# Step 2.2: add the gateway subnet
azure network vnet subnet create --vnet-name profx-fe-vnet -n GatewaySubnet --address-prefix 10.1.2.0/24

# Step 2.3: create the local network.  This is the address space of the "local" (aka the other site)
# network.  Note that the VPN address is just a placeholder - we need to come back and update
# it after creating the other site
azure network  local-network create --name profx-sec-network -a 10.2.0.0/24 --vpn-gateway-address 131.1.1.1

# Step 2.4: Add the local network into the VNET
azure network vnet local-network add --name profx-fe-vnet --local-network-name profx-sec-network

# Step 2.5: create a VPN gateway for this VNET; note this must be 
azure network vpn-gateway create --vnet-name profx-fe-vnet --type DynamicRouting --sku HighPerformance

# Step 2.6: Check the configuration
azure network vnet subnet list profx-fe-vnet

# Step 2.7: get the public address of the VPN gateway (TODO - automate)
# 104.209.190.13

# Step 3: create and deploy the PaaS cloud service (note that the Vnet configuration must be
# present within the service configuration file)
azure service create --serviceName profx-fe --affinitygroup profx-sec-group

# Step 3.2: deploy the cloud service
# TODO - need some command line support here

######################################################
##### ARM Resources (Elasticsearch cluster)
######################################################

# Switch to ARM mode
azure config mode arm

# Step 4.1: create the resource group
azure group create --name profx-sec --location "East US 2"

# Step 4.2: deploy the elastic search cluster to the resource group
azure group create "profx-sec" "East US 2" -f azuredeploy.json -e azuredeploy-parameters.json

# Step 4.3: check on the status of the deployment
azure group show profx-sec
azure group deployment list profx-sec
azure group log show profx-sec

Step 5.1: create the local network (corresponding to the paas network)
# TODO - determine how to do this via CLI

# Created VIP 137.116.83.119



# Clean up all resources associated with profx-sec
azure group delete profx-sec

# Deploy the ARM template


# Switch over to the ARM resources
azure config mode arm

azure group list

azure network vnet list profx-sec



