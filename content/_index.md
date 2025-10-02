---
title : "Serverless Failover: DynamoDB, Lambda, API Gateway & Route 53"
date : "2025-01-27" 
weight : 1 
chapter : false
---

# Serverless Failover: DynamoDB, Lambda, API Gateway & Route 53

## Overview

In production environments, one of the biggest risks is downtime when an AWS Region experiences an outage. For applications that require **High Availability (HA)** and **Disaster Recovery (DR)** capabilities, implementing multi-Region infrastructure is a critical strategy.

In this lab, you will build a multi-Region serverless application with the ability to:

- **Fault-Tolerant**: The application continues to operate normally when a component fails.
- **Disaster Recovery (DR)**: If the Primary Region goes down, the system automatically switches to the Secondary Region without service interruption for end users.

The main goal is to combine multiple AWS serverless services to form a comprehensive, secure, and automatic failover architecture.

## Architecture Overview

![Serverless Failover Architecture](/images/1/0001.png?v=2025&featherlight=false&width=60pc)

## Key Architecture Components

### 1. Amazon DynamoDB Global Tables

**Role**: Primary data storage system for the application following a multi-region, multi-active model.

**How it works**: All data written in one Region is automatically synchronized to other Regions within seconds (e.g., Singapore ↔ Tokyo).

**DR Benefits**: When the Primary Region fails, the Secondary Region still has the latest data to serve users, avoiding data loss (zero data loss) and maintaining continuity.

### 2. AWS Lambda (Python Functions)

**Role**: Provides serverless backend processing layer without infrastructure management.

**How it works**: Lambda functions are deployed in parallel across both Regions, responsible for reading and writing data from DynamoDB. When users call the API, Lambda executes logic and returns results immediately.

**DR Benefits**: Since Lambda is serverless, AWS automatically ensures availability across both Regions. When Route 53 redirects requests, Lambda in the remaining Region continues processing without manual configuration changes.

### 3. Amazon API Gateway

**Role**: Acts as RESTful API gateway, connecting clients and Lambda.

**How it works**: API Gateway is deployed in both Primary and Secondary Regions, providing unified endpoints (stage /prod). It also supports logging and throttling for request control.

**DR Benefits**: Users don't need to know which Region the API is running in. When failover occurs, Route 53 automatically switches DNS to the Secondary Region's API Gateway, providing seamless experience.

### 4. Amazon Route 53

**Role**: Manages DNS and performs failover based on health checks.

**How it works**: You configure DNS records for your domain (e.g., api.example.com) pointing to API Gateway in the Primary Region, and failover records pointing to the Secondary. Route 53 continuously monitors the primary endpoint and redirects to the remaining Region if it detects failures.

**DR Benefits**: Redirection is completely automatic, ensuring zero downtime and minimizing service interruption risks for users.

### 5. AWS Certificate Manager (ACM)

**Role**: Issues and manages SSL/TLS certificates for custom domains.

**How it works**: ACM issues free certificates, which are then attached to API Gateway Custom Domain to enable HTTPS.

**DR Benefits**: Ensures all client requests to the API are always secured via HTTPS, complying with security standards and building user trust.

### 6. Amazon S3 (Frontend Website Hosting)

**Role**: Stores and serves static websites (HTML, CSS, JS).

**How it works**: Frontend website is hosted on an S3 bucket, can be combined with CloudFront for acceleration. This website calls APIs through the domain configured with Route 53.

**DR Benefits**: Since the frontend is served from a static and stable source, when backend failover occurs, the website continues to function normally. Users continue using without changing any URLs.

## Main Content

1. [Preparation Steps](1-create-new-aws-account/)
2. [Create DynamoDB Table in Primary Region](2-MFA-Setup-For-AWS-User-(root)/)
3. [Create IAM Role for Lambda Functions](3-create-admin-user-and-group/)
4. [Create Lambda Functions in Both Regions](4-verify-new-account/)
5. [Set Up API Gateway (Both Regions)](5-setup-api-gateway/)
6. [Set Up DNS Route 53 and Configure Failover for API Gateway](6-setup-dns-route53-failover/)
7. [Create the Frontend Website](7-create-frontend-website/)
8. [Test the failover mechanism by deleting the API in the primary (Singapore)](8-test-failover-delete-primary-api/)
9. [Clean Up Resources](9-clean-up-resources/)