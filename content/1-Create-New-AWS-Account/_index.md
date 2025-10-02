---
title : "Preparation Steps"
date : "2025-01-27"
weight : 1
chapter : false
pre : " <b> 1. </b> "
---

### Preparation for Serverless Failover Architecture

Before starting to build the Serverless Failover architecture, we need to prepare some basic components:

### Prerequisites

1. **AWS Account**: Ensure you have an AWS account with Administrator permissions
2. **Domain Name**: Prepare a domain name for Route 53 configuration (optional)
3. **Basic Knowledge**: Understanding of basic AWS services

### Regions to be used

In this lab, we will use 2 Regions:
- **Primary Region**: Singapore (ap-southeast-1)
- **Secondary Region**: Tokyo (ap-northeast-1)

### Architecture Overview

![Serverless Failover Architecture](/images/1/0001.png?v=2025&featherlight=false&width=60pc)

We will build a serverless application with automatic failover capability including:

1. **DynamoDB Global Tables**: Data storage synchronized between Regions
2. **Lambda Functions**: Backend logic processing
3. **API Gateway**: REST API endpoints
4. **Route 53**: DNS failover and health checks
5. **S3**: Static website hosting

**Content:**

1. [Domain Registration at TENTEN.VN](1.1-find-account-id/)
2. [Hosting on DATAONLINE.VN](1.2-update-account/)
3. [Using Cloudflare for Domain Management](1.3-aws-account-alias/)