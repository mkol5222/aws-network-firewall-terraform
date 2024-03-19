
// deploys an AWS Auto Scaling group configured for Gateway Load Balancer into existing Centralized Security VPC for Transit Gateway.

// https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/aws/tgw-gwlb


# % export AWS_ACCESS_KEY_ID="anaccesskey"
# % export AWS_SECRET_ACCESS_KEY="asecretkey"
# % export AWS_REGION="eu-west-1"

module "gwlb" {

  source = "github.com/mkol5222/CloudGuardIaaS/terraform/aws/tgw-gwlb"

//PLEASE refer to README.md for accepted values FOR THE VARIABLES BELOW

// --- VPC Network Configuration ---
vpc_id = "vpc-0e1e127a71e05ef1c"
internet_gateway_id ="igw-00ac3ad04390d9240"
availability_zones = ["eu-west-1a","eu-west-1b","eu-west-1c"]
number_of_AZs = 3
gateways_subnets= ["subnet-0a7449574e9c0aecf", "subnet-0ce0ecaf60e6e9576", "subnet-05f8b9734adf94c67"]

transit_gateway_attachment_subnet_1_id="subnet-0b30de6518af2c554"
transit_gateway_attachment_subnet_2_id="subnet-046044550dc52e9b7"
transit_gateway_attachment_subnet_3_id="subnet-02efedaff9b7a1b2c"
transit_gateway_attachment_subnet_4_id="subnet-6789" // n/a

nat_gw_subnet_1_cidr ="10.255.61.0/24"
nat_gw_subnet_2_cidr = "10.255.62.0/24"
nat_gw_subnet_3_cidr = "10.255.63.0/24"
nat_gw_subnet_4_cidr = "10.255.64.0/24"

gwlbe_subnet_1_cidr = "10.255.71.0/24"
gwlbe_subnet_2_cidr = "10.255.72.0/24"
gwlbe_subnet_3_cidr = "10.255.73.0/24"
gwlbe_subnet_4_cidr = "10.255.74.0/24"

  
// --- General Settings ---
key_name = "azureshell"
enable_volume_encryption = true
volume_size = 100
enable_instance_connect = false
disable_instance_termination = false
allow_upload_download = true
management_server = "CP-Management-gwlb-tf"
configuration_template = "gwlb-configuration"
admin_shell = "/bin/bash"
  
// --- Gateway Load Balancer Configuration ---
gateway_load_balancer_name = "gwlb1"
target_group_name = "tg1"
#connection_acceptance_required = "false"
enable_cross_zone_load_balancing = "true"
  
// --- Check Point CloudGuard IaaS Security Gateways Auto Scaling Group Configuration ---
gateway_name = "Check-Point-GW-tf"
gateway_instance_type = "c5.xlarge"
minimum_group_size = 3
maximum_group_size = 6
gateway_version = "R81.20-BYOL"
gateway_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0"
gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
gateway_SICKey = "WelcomeHome1984"
gateways_provision_address_type = "private"
allocate_public_IP = false	  
enable_cloudwatch = false
gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
  
// --- Check Point CloudGuard IaaS Security Management Server Configuration ---
management_deploy = true
management_instance_type = "m5.xlarge"
management_version = "R81.20-BYOL"
management_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0"
management_maintenance_mode_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0" # For R81.10 and below the management_password_hash is used also as maintenance-mode password.
gateways_policy = "Standard"
gateway_management = "Locally managed"
admin_cidr = "0.0.0.0/0"
gateways_addresses = "10.0.0.0/8"
  
// --- Other parameters ---
# VolumeType = "gp3"
  
}