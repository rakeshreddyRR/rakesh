#create vpc
resource "aws_vpc" "virtual" {
     tags = {
      Name = "VPC"
    }
    cidr_block = var.cidr_name
  
}
#create public subnet1
resource "aws_subnet" "public_subnet_1" {
    tags = {
      Name = "Subnet 1"
    }
    vpc_id = var.vpc_id
    cidr_block = var.cidr
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1b"
  
}


#create public subnet2
resource "aws_subnet" "public_subnet_2" {
     tags = {
      Name = "Subnet 2"
    }
    vpc_id = var.vpc_id
    cidr_block = var.public
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1c"
  
}

#create internet gateway
resource "aws_internet_gateway" "igm" {
     tags = {
      Name = "IGW"
    }
 vpc_id = var.vpc_id
  
 }
  
# #create route table
resource "aws_route_table" "public_route" {
     vpc_id = var.vpc_id
     tags = {
      Name = "RT"
    }
}
 
 resource "aws_route" "internet_access" {
     route_table_id = var.route_tab 
    destination_cidr_block = var.destination
    gateway_id = var.internet_gateway
 }

#attach subnets to route tables
resource "aws_route_table_association" "association_1" {
 subnet_id = aws_subnet.public_subnet_1.id
 route_table_id = var.route_tab
}

# resource "aws_route_table_association" "association_2" {
#     subnet_id = aws_subnet.public_subnet_2
#     route_table_id = aws_route_table.public_route
  
# }


# #create security group
# resource "aws_security_group" "allow_traffic" {

#     vpc_id = aws_vpc.virtual


#     ingress =  [
#     {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         cidr_block = ["0.0.0.0/0"]
#     },
#      {
#         from_port = 8080
#         to_port = 8080
#         protocol = "tcp"
#         cidr_block = ["0.0.0.0/0"]
#     },
#      {
#         from_port = 443
#         to_port = 443
#         protocol = "tcp"
#         cidr_block = ["0.0.0.0/0"]
#     }
#     ]
    
#     #egress = {
#      #   from_port = 0
#       #  to_port = 0
       
#     # protocol = "-1"
#      #   cidr_block = ["0.0.0.0/0"]
#     #}
# }

# resource "aws_instance" "apache_1" {

#     ami = "ami-08718895af4dfa033"
#     instance_type = var.type
#     subnet_id = aws_subnet.public_subnet_1.id
#     security_groups = aws_security_group.allow_traffic.virtual

#     user_data = <<-EOF
#     #!/bin/bash
#     sudo yum update -y
#     sudo yum install httpd -y
#     sudo service httpd start
#     sudo system enable httpd
#     EOF

# }


# resource "aws_instance" "tomcat_2" {

#   ami = "ami-08718895af4dfa033"
#   instance_type = var.type_2
#   subnet_id = aws_subnet.public_subnet_2.id
#   security_groups = aws_security_group.allow_traffic.virtual


#   user_data = <<-EOF
#   #!/bin/bash
#   sudo yum update -y
#   sudo yum insatll tomcat -y
#   sudo start tomcat
#   sudo systemctl enable tomcat
#   EOF
#   }

#   #create target groups

#   resource "aws_lb_target_group" "apache_tg" {

#     name = "apache-tg"
#     port = 80
#     protocol = "http"
#     vpc_id = aws_vpc.virtual.id
#     target_type = aws_instance.apache_1
    
#   }


#   resource "aws_lb_target_group" "tomcat_tg" {

#     name = "tomcat-tg"
#     port = 8080
#     protocol = "http"
#     vpc_id = aws_vpc.virtual.id
#     target_type = aws_instance.tomcat_2
    
#   }

#   #create load balancer

#   resource "aws_lb" "app_lb" {
#     name = "application_lb"
#     internal = false
#     load_balancer_type = "application"
#     security_groups = [aws_security_group.allow_traffic.id]
#     subnets = [aws_subnet.public_subnet_1, aws_subnet.public_subnet_2]

    
#   }


#   #listner rules apache

# resource "aws_lb_listener" "apache_listener" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"

#     target_group_arn = aws_lb_target_group.apache_tg.arn
#   }
  
# }

# #listner rule for tomcat

# resource "aws_lb_listener" "tomcat_listner" {
#     load_balancer_arn = aws_lb.app_lb
#     port = "8080"
#     protocol = "http"

#     default_action {
#       type = "forward"
#       target_group_arn = aws_lb_target_group.tomcat_tg.arn
#     }
  
# }


# #attaching instances tg:

# resource "aws_lb_target_group_attachment" "apache_attch" {
#     target_group_arn = aws_lb_target_group.apache_tg.arn
#     target_id = aws_instance.apache_1.id
#     port = 80
  
# }


# resource "aws_lb_target_group_attachment" "tomcat_attch" {
#     target_group_arn = aws_lb_target_group.tomcat_tg.arn
#     target_id = aws_instance.tomcat_2.id
#     port = 8080
  
# }