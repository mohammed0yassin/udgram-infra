# Udgram infrastructure

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

## Pipeline status: [![mohammed0yassin](https://circleci.com/gh/mohammed0yassin/udgram-infra.svg?style=svg)](https://app.circleci.com/pipelines/github/mohammed0yassin/udgram-infra)