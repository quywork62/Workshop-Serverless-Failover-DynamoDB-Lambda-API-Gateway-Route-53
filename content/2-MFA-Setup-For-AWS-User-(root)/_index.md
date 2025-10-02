---
title : "Create DynamoDB Table in Primary Region"
date : "2025-01-27"
weight : 2
chapter : false
pre : " <b> 2. </b> "
---

### Introduction to DynamoDB

Amazon DynamoDB is a fully managed NoSQL database service that provides key-value and document data storage with single-digit millisecond latency at any scale. The major advantages of DynamoDB are auto scaling, no server management required, and built-in security, backup, and caching features.

In this lab, DynamoDB serves as the primary data storage foundation for the application, ensuring data is automatically replicated between multiple Regions through Global Tables, helping the application maintain availability and consistency even when a Region experiences an outage.

#### **Content**

1. [Create DynamoDB Table in Primary Region](#step-1-create-dynamodb-table-in-primary-region)
2. [Enable Global Tables and Add Secondary Region](1-virtual-mfa-device/)

### Step 1: Create DynamoDB Table in Primary Region

#### 1. Sign in to the AWS Management Console

#### 2. Navigate to the [DynamoDB](https://ap-southeast-1.console.aws.amazon.com/dynamodbv2/home?region=ap-southeast-1#service) service

![DynamoDB](/images/2/2.png?featherlight=false&width=90pc)

#### 3. Create a new table in the primary region (e.g., ap-southeast-1)

Table name: ```HighAvailabilityTable```

Partition key: ```ItemId``` (String)

![DynamoDB](/images/2/1.png?featherlight=false&width=90pc)
![DynamoDB](/images/2/3.png?featherlight=false&width=90pc)

#### 4. Select "Default Settings" in the Table Settings section

![DynamoDB](/images/2/4.png?featherlight=false&width=90pc)

#### 5. Finally, choose "Create table"

![DynamoDB](/images/2/5.png?featherlight=false&width=90pc)

#### Wait approximately 2-3 minutes for resource initialization. Check that the Status changes to "Active" for success

![DynamoDB](/images/2/6.png?featherlight=false&width=90pc)
