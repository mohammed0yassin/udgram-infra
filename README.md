# Udgram infrastructure
## Pipeline status: [![mohammed0yassin](https://circleci.com/gh/mohammed0yassin/udgram-infra.svg?style=svg)](https://app.circleci.com/pipelines/github/mohammed0yassin/udgram-infra)


![Diagram](./FullStackUdagram-app.png)

## Required Environment Variables
| Environment Variable   | Description                                  |
|         :-:            |     :-:                                      |
| NETWORK_STACK_NAME     | Cloudformation Network Stack Name            |
| SERVERS_STACK_NAME     | Cloudformation Servers Stack Name            |
| DATABASE_STACK_NAME    | Cloudformation Database Stack Name           |

## Required SSH Keys to be created before first run
- Create Two SSH Keys in EC2 Console
    1) ec2acc
    2) backendprivate


## Design

-	High Availability by using Auto Scaling Group spanning across two Availability Zones and using a Load Balancer to forward the traffic to all the backend servers in the target group

-	Securing the backend servers by placing them in private subnets that could be only reached using the Bastion Host which is mainly used for Ansible provisioning.
    
    The Database only accepts traffic from the backend servers. 

    The S3 bucket accepts traffic only from the CDN using OAI

-	Using CDN to ensure fast and reliable content deliver



Features:
-	Zero modifications needed to have the infrastructure up and running. Just add the code into an SCM and setup the pipeline on CricleCi.
-	Database passwords are created using AWS Secret Manager and encrypt by AWS KMS and automatically used in Ansible, in short you may never need to see how the password looks like.
-	Bash script to create or update the stacks. It detects if create or update and run accordingly
-	Bash Script to delete and clean the resources without the need for example to empty the S3 bucket first
-	Any needed info about the resources or the URLs are in the Outputs on CloudFormation
