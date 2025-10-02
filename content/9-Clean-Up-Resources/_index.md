---
title : "Clean Up Resources"
date : "2025-01-27" 
weight : 9
chapter : false
pre : " <b> 9. </b> "
---

### Step 9: Clean Up Resources

After successfully testing the HA/DR & Failover mechanism, you need to delete the AWS resources created to avoid incurring costs.

{{%notice warning%}}
**⚠️ Warning**: Resource deletion is irreversible. Make sure you have backed up/exported everything necessary before proceeding.
{{%/notice%}}

### Why Clean Up is Needed?

- **Cost Optimization**: Avoid unnecessary costs
- **Resource Management**: Keep AWS account clean
- **Security**: Remove unused endpoints and resources
- **Best Practice**: Good habit in cloud resource management

### Content

1. [Delete API Gateway (Secondary – Tokyo)](#1-delete-api-gateway-secondary-tokyo)
2. [Delete DynamoDB Global Tables](#2-delete-dynamodb-global-tables)
3. [Delete Lambda Functions](#3-delete-lambda-functions)
4. [Delete Route 53 Health Checks & DNS Records](#4-delete-route-53-health-checks-dns-records)
5. [Delete ACM Certificates](#5-delete-acm-certificates)
6. [Delete S3 Bucket (Frontend Website)](#6-delete-s3-bucket-frontend-website)
7. [Delete IAM Roles](#7-delete-iam-roles)

#### 1. Delete API Gateway (Secondary – Tokyo)

**Step 1: Delete Custom Domain Mapping (if any)**

- Go to **API Gateway** in **Tokyo (ap-northeast-1)** region
- Select **Custom domain names** → select **api.turtleclouds.id.vn**
- **API mappings** tab → **Delete API mapping**



**Step 2: Delete API Gateway**

- Return to **APIs** → select **HighAvailabilityAPI**
- Choose **Actions** → **Delete**
- Type ```delete``` to confirm


**Step 3: Delete Custom Domain**

- Go to **Custom domain names** → select **api.turtleclouds.id.vn**
- Choose **Actions** → **Delete domain name**
- Type domain name to confirm



**CLI (optional):**
```bash
# Get list of APIs
aws apigateway get-rest-apis --region ap-northeast-1

# Delete API mapping first
aws apigateway delete-base-path-mapping \
  --domain-name api.turtleclouds.id.vn \
  --base-path "" \
  --region ap-northeast-1

# Delete API
aws apigateway delete-rest-api --rest-api-id <API_ID> --region ap-northeast-1

# Delete custom domain
aws apigateway delete-domain-name \
  --domain-name api.turtleclouds.id.vn \
  --region ap-northeast-1
```

{{%notice info%}}
**Note**: API Gateway in Singapore was already deleted in the previous failover test step.
{{%/notice%}}

#### 2. Delete DynamoDB Global Tables

**Step 1: Delete Global Table Replicas**

- Go to **DynamoDB** in **Tokyo (ap-northeast-1)** region
- Select **HighAvailabilityTable**
- **Global Tables** tab → **Delete replica**



**Step 2: Delete Primary Table**

- Switch to **Singapore (ap-southeast-1)** region
- Select **HighAvailabilityTable**
- **Actions** → **Delete table**
- Type ```delete``` to confirm



**CLI (optional):**
```bash
# Delete replica in Tokyo
aws dynamodb delete-table --table-name HighAvailabilityTable --region ap-northeast-1

# Delete primary table in Singapore
aws dynamodb delete-table --table-name HighAvailabilityTable --region ap-southeast-1
```

#### 3. Delete Lambda Functions

**Delete Lambda Functions in Tokyo:**

- Go to **Lambda** in **Tokyo (ap-northeast-1)** region
- Delete functions:
  - **ReadFunction**
  - **WriteFunction**
  - **DeleteFunction**



**Delete Lambda Functions in Singapore:**

- Go to **Lambda** in **Singapore (ap-southeast-1)** region
- Delete similar functions (if any remain)

**CLI (optional):**
```bash
# Tokyo
aws lambda delete-function --function-name ReadFunction --region ap-northeast-1
aws lambda delete-function --function-name WriteFunction --region ap-northeast-1
aws lambda delete-function --function-name DeleteFunction --region ap-northeast-1

# Singapore
aws lambda delete-function --function-name ReadFunction --region ap-southeast-1
aws lambda delete-function --function-name WriteFunction --region ap-southeast-1
aws lambda delete-function --function-name DeleteFunction --region ap-southeast-1
```

#### 4. Delete Route 53 Health Checks & DNS Records

**Step 1: Delete Health Checks**

- Go to **Route 53 Console** → **Health checks**
- Delete health checks:
  - **Primary Singapore**
  - **Secondary Tokyo**



**Step 2: Delete DNS Records**

- Go to **Hosted zones** → **api.turtleclouds.id.vn**
- Delete failover records:
  - Primary failover record
  - Secondary failover record
  - ACM validation CNAME records



**Step 3: Delete Hosted Zone (optional)**

- If no longer needed, you can delete the hosted zone **api.turtleclouds.id.vn**
- **Actions** → **Delete hosted zone**



{{%notice warning%}}
**Warning**: Only delete hosted zone if you're sure you won't use the api.* subdomain anymore.
{{%/notice%}}

#### 5. Delete ACM Certificates

**Delete Certificate in Singapore:**

- Go to **AWS Certificate Manager (ACM)** in **Singapore (ap-southeast-1)** region
- Select certificate **api.turtleclouds.id.vn**
- **Actions** → **Delete**



**Delete Certificate in Tokyo:**

- Go to **ACM** in **Tokyo (ap-northeast-1)** region
- Delete similar certificate

{{%notice info%}}
**Note**: Certificates can only be deleted when they are not being used by any resources.
{{%/notice%}}

#### 6. Delete S3 Bucket (Frontend Website)

**Step 1: Empty Bucket**

- Go to **S3 Console** → bucket **api.turtleclouds.id.vn**
- Select **Empty bucket**
- Type ```permanently delete``` to confirm



**Step 2: Delete Bucket**

- After emptying, select **Delete bucket**
- Type bucket name to confirm



**CLI (optional):**
```bash
# Empty bucket
aws s3 rm s3://api.turtleclouds.id.vn --recursive

# Delete bucket
aws s3 rb s3://api.turtleclouds.id.vn
```

#### 7. Delete IAM Roles

- Go to **IAM Console** → **Roles**
- Delete roles created for Lambda:
  - **HighAvailabilityLambdaRole**
  - Other project-related roles



**CLI (optional):**
```bash
# Detach policies first
aws iam detach-role-policy --role-name HighAvailabilityLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Delete role
aws iam delete-role --role-name HighAvailabilityLambdaRole
```

### Clean Up Checklist

After completion, check:

- ✅ **API Gateway** (both Singapore and Tokyo) deleted
- ✅ **DynamoDB Global Tables** completely deleted
- ✅ **Lambda Functions** in both regions deleted
- ✅ **Route 53 Health Checks** deleted
- ✅ **Route 53 DNS Records** deleted
- ✅ **ACM Certificates** in both regions deleted
- ✅ **S3 Bucket** and contents deleted
- ✅ **IAM Roles** no longer needed deleted

### Conclusion

You have successfully deleted all AWS resources created in this lab. This helps:

- **Avoid unnecessary costs**
- **Keep AWS account clean**
- **Apply best practices** in cloud resource management
- **Complete the cycle** of development and testing

{{%notice success%}}
**Complete!** You have successfully cleaned up all resources and completed the Serverless Failover Architecture lab.
{{%/notice%}}