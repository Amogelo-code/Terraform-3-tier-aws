# Terraform AWS 3-Tier Architecture

## Overview

This project implements a modular 3-tier AWS architecture using Terraform.

The purpose of the project was to move beyond provisioning AWS infrastructure from a single Terraform configuration and learn how to design reusable Terraform modules while working with multiple AWS services.

The architecture separates the infrastructure into three main tiers:

- Public Application Load Balancer
- Private Application/Compute Tier
- Private Database Tier

The project also incorporates security, encryption, secrets management, monitoring, high availability, and automated scaling.

## Architecture

The architecture follows this general traffic flow:

Internet
   |
   v
Internet Gateway
   |
   v
Application Load Balancer
   |
   v
Private Application Tier
(EC2 instances managed by ASG)
   |
   v
Private Database Tier
(Amazon RDS)

The Application Load Balancer acts as the public entry point to the application. Application instances are placed in private subnets and receive traffic through the ALB rather than directly from the internet.

The database is isolated in private database subnets and only accepts traffic from the application tier.

## AWS Services

- Amazon VPC
- Internet Gateway
- NAT Gateway
- Application Load Balancer
- EC2
- Auto Scaling Groups
- Amazon RDS
- IAM
- AWS KMS
- AWS Secrets Manager
- Amazon CloudWatch
- AWS Systems Manager Session Manager

## Project Structure

```text
terraform-3-tier/
│
├── main.tf
├── variables.tf
├── local.tf
├── provider.tf
├── output.tf
├── .gitignore
├── .terraform.lock.hcl
├── README.md
│
└── modules/
    ├── alb/
    ├── compute/
    ├── database/
    ├── iam/
    ├── kms/
    ├── monitoring/
    ├── network/
    ├── secrets_manager/
    └── security/