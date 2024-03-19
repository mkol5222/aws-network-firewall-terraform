
resource "aws_subnet" "inspcection_vp_cpman_subnet" {

  map_public_ip_on_launch = true
  vpc_id                  = "vpc-0e1e127a71e05ef1c"
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = "10.255.77.0/24"
  
  tags = {
    Name = "inspection-vpc/cpman-subnet"
  }
}

resource "aws_route_table" "inspection_vpc_cpman_subnet_route_table" {

  vpc_id = aws_vpc.inspection_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inspection_vpc_igw.id
  
  }
#   # back to spokes via TGW
#    route {
#     cidr_block         = var.super_cidr_block
#     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   }
  # route {
  #   cidr_block = var.super_cidr_block
  #   # https://github.com/hashicorp/terraform-provider-aws/issues/16759
  #   vpc_endpoint_id = element([for ss in tolist(aws_networkfirewall_firewall.inspection_vpc_anfw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == aws_subnet.inspection_vpc_firewall_subnet[count.index].id], 0)
  # }
  tags = {
    Name = "inspection-vpc/cpman-subnet-route-table"
  }
}

resource "aws_route_table_association" "inspection_vpc_cpman_subnet_route_table_association" {

  route_table_id = aws_route_table.inspection_vpc_cpman_subnet_route_table.id
  subnet_id      = aws_subnet.inspcection_vp_cpman_subnet.id
}

module "management" {

    source = "github.com/mkol5222/CloudGuardIaaS/terraform/aws/management"
    
  
  // --- VPC Network Configuration ---
  vpc_id = "vpc-0e1e127a71e05ef1c"
  subnet_id = aws_subnet.inspcection_vp_cpman_subnet.id
  
  // --- EC2 Instances Configuration ---
  management_name = "CP-Management-tf"
  management_instance_type = "m5.xlarge"
  key_name = "azureshell"
  allocate_and_associate_eip = true
  volume_size = 100
  volume_encryption = "alias/aws/ebs"
  enable_instance_connect = false
  disable_instance_termination = false
  instance_tags = {
    key1 = "value1"
    key2 = "value2"
  }
  
  // --- IAM Permissions ---
  iam_permissions = "Create with read permissions"
  predefined_role = ""
  sts_roles = []
  
  // --- Check Point Settings ---
  management_version = "R81.20-BYOL"
  admin_shell = "/bin/bash"
  # WelcomeHome1984
  management_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0"
  management_maintenance_mode_password_hash = "$6$ycLB31kh2cbEDSnk$b1ZMkobMX/RUXmDWKDWnr2fPpWaGyMAZHyjg0tFrggUA6ehd8YglKyj3H0hyYCNQrgzXn89TohVj1qW2l3LoI0" # For R81.10 and below the management_password_hash is used also as maintenance-mode password.
  // --- Security Management Server Settings ---
  management_hostname = "mgmt-tf"
  management_installation_type = "Primary management"
  SICKey = ""
  allow_upload_download = "true"
  gateway_management = "Locally managed"
  admin_cidr = "0.0.0.0/0"
  gateway_addresses = "0.0.0.0/0"
  primary_ntp = ""
  secondary_ntp = ""
  management_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
}