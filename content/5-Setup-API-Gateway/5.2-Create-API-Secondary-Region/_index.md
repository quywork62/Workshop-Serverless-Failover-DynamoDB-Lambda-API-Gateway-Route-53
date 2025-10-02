---
title : "Replicate API Gateway to Secondary Region"
date : "2025-01-27" 
weight : 2
chapter : false
pre : " <b> 5.2 </b> "
---

### Replicate API Gateway to Secondary Region (Tokyo)

In this step, we will create a similar API Gateway in the Secondary Region (Tokyo ap-northeast-1) to ensure high availability and failover capability.

### Why Replicate API Gateway?

- **High Availability**: If Primary Region fails, Secondary Region can still serve requests
- **Disaster Recovery**: Ensures zero downtime when failover occurs
- **Performance**: Users in Asia region can access from a closer Region
- **Load Distribution**: Distributes load between Regions

### Content

1. [Switch to Secondary Region](#1-switch-to-secondary-region)
2. [Create Similar API Gateway as Step 5.1](#2-create-similar-api-gateway-as-step-51)
3. [Access API Gateway Console](#3-access-api-gateway-console)
4. [Create New REST API](#4-create-new-rest-api)
5. [Configure Basic Information](#5-configure-basic-information)
6. [Create Resource read](#6-create-resource-read)
7. [Create Resource write](#7-create-resource-write)
8. [Create GET Method (for ReadFunction)](#8-create-get-method-for-readfunction)
9. [Create POST Method (for WriteFunction)](#9-create-post-method-for-writefunction)
10. [Enable CORS for Resource](#10-enable-cors-for-resource)
11. [Deploy API](#11-deploy-api)
12. [Save the Invoke URL](#12-save-the-invoke-url)

#### 1. Switch to Secondary Region

- In AWS Console, switch Region from **Singapore** to **Tokyo (ap-northeast-1)**
- Access **API Gateway** service

![API Gateway](/images/5/25.png?featherlight=false&width=90pc)

#### 2. Create Similar API Gateway as Step 5.1

#### 3. Access API Gateway Console

- Sign in to **AWS Management Console**
- Ensure you are in **Tokyo (ap-northeast-1)** Region
- Find and select **API Gateway** service

#### 4. Create New REST API

- Choose **Create API**
- In the **REST API** section, choose **Build** (not Private REST API)

#### 5. Configure Basic Information

- **Choose the protocol**: REST
- **Create new API**: New API
- **API name**: ```HighAvailabilityAPI```
- **Description**: ```Secondary Region API for Serverless Failover```
- **Endpoint Type**: **Regional**
- Choose **Create API**

#### 6. Create Resource ```read```

- In the newly created API, choose **Actions** → **Create Resource**
- **Resource Name**: ```read```
- **Resource Path**: ```/read```
- **Enable API Gateway CORS**: ✅ (enable)
- Choose **Create Resource**

#### 7. Create Resource ```write```

- In the API, choose **Actions** → **Create Resource**
- **Resource Name**: ```write```
- **Resource Path**: ```/write```
- **Enable API Gateway CORS**: ✅ (enable)
- Choose **Create Resource**

#### 8. Create GET Method (for ReadFunction)

- Select the ```/read``` resource just created
- Choose **Actions** → **Create Method**
- From dropdown, select **GET** and click ✅

**Configure Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (enable)
- **Lambda Region**: Tokyo (ap-northeast-1)
- **Lambda Function**: ```ReadFunction```
- Choose **Save**

#### 9. Create POST Method (for WriteFunction)

- Select the ```/write``` resource
- Choose **Actions** → **Create Method**
- From dropdown, select **POST** and click ✅

**Configure Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (enable)
- **Lambda Region**: Tokyo (ap-northeast-1)
- **Lambda Function**: ```WriteFunction```
- Choose **Save**

#### 10. Enable CORS for Resource

- Select the root resource ```/```
- Choose **Actions** → **Enable CORS**

**Configure CORS:**
- **Access-Control-Allow-Origin**: ```*```
- **Access-Control-Allow-Headers**: 
  ```
  Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token
  ```

#### 11. Deploy API

- Choose **Actions** → **Deploy API**
- **Deployment stage**: [New Stage]
- **Stage name**: ```prod```
- **Stage description**: ```Production stage for Secondary Region```
- **Deployment description**: ```Initial deployment```
- Choose **Deploy**

![API Gateway](/images/5/20.png?featherlight=false&width=90pc)

#### 12. Save the Invoke URL

After successful deployment, in the **Stages** → **prod** tab, you will see the **Invoke URL**:

```
https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/prod
```

![API Gateway](/images/5/24.png?featherlight=false&width=90pc)

**Save this URL** - we will need it to:
- Test API functionality
- Configure Route 53 health checks
- Integrate with frontend application