---
title : "Create IAM Role for Lambda Functions"
date : "2025-01-27"
weight : 3
chapter : false
pre : " <b> 3. </b> "
---

In AWS, **IAM Role** is like a "permission set" that is predefined. A Role is not permanently attached to a specific user, but is temporarily "borrowed" by AWS services or applications to have permission to perform actions.

**Example:**

**AWS Lambda** needs a Role to have permission to read/write data to **DynamoDB**.

EC2 Instance can be assigned a Role to access S3 without storing Access Key/Secret Key in the machine.

Difference compared to IAM User:

User: attached to an individual or application, has username & password or access key.

Role: has no separate login information, only grants temporary permissions to services or users/applications that assume it.

👉 In this lab, you will create a Role named **LambdaDynamoDBRole** to allow Lambda Functions to:

- Access DynamoDB.
- Write logs to CloudWatch.

### Content

1. [Open IAM Console](#1-open-iam-console)
2. [Create New Role for Lambda](#2-create-new-role-for-lambda)
3. [Assign Permissions to Role](#3-assign-permissions-to-role)
4. [Name and Create Role](#4-name-and-create-role)
5. [Save Role ARN](#5-save-role-arn)

## Create IAM Role for Lambda Functions
#### 1. Open IAM Console

- Sign in to **AWS Management Console**.
- Find and select the **IAM** service.

![IAM](/images/3/1.png?featherlight=false&width=90pc)

#### 2. Create New Role for Lambda

- Choose **Roles** → **Create role**.
- In the **Trusted entity type** section, select **AWS Service**.
- Select the **Lambda** service, then click **Next**.

![IAM](/images/3/2.png?featherlight=false&width=90pc)
![IAM](/images/3/3.png?featherlight=false&width=90pc)
![IAM](/images/3/4.png?featherlight=false&width=90pc)
![IAM](/images/3/5.png?featherlight=false&width=90pc)

#### 3. Assign Permissions to Role

- Find and select 2 policies:
  - ```AmazonDynamoDBFullAccess``` → allows Lambda to interact with DynamoDB.
  - ```AWSLambdaBasicExecutionRole``` → allows Lambda to write logs to CloudWatch.

![IAM](/images/3/6.png?featherlight=false&width=90pc)
![IAM](/images/3/7.png?featherlight=false&width=90pc)

#### Click **Next**

![IAM](/images/3/8.png?featherlight=false&width=90pc)

#### 4. Name and Create Role

- Enter Role name: ```LambdaDynamoDBRole```.
- Click **Create role** to complete.

![IAM](/images/3/9.png?featherlight=false&width=90pc)
![IAM](/images/3/10.png?featherlight=false&width=90pc)

#### You have successfully created the **Role**

![IAM](/images/3/11.png?featherlight=false&width=90pc)

#### 5. Save Role ARN

- After creation, open the Role details.
- Copy the **Role ARN** (will be needed when assigning to Lambda function later).

![IAM](/images/3/12.png?featherlight=false&width=90pc)
