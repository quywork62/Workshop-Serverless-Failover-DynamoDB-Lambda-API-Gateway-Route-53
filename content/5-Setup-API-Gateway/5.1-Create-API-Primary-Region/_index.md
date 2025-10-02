---
title : "Create API Gateway in Primary Region"
date : "2025-01-27" 
weight : 1
chapter : false
pre : " <b> 5.1 </b> "
---

### Create API Gateway in Primary Region (Singapore)

In this step, we will create API Gateway in the Primary Region (Singapore ap-southeast-1) to provide REST API endpoints for frontend applications.

### Content

1. [Access API Gateway Console](#1-access-api-gateway-console)
2. [Create New REST API](#2-create-new-rest-api)
3. [Configure Basic Information](#3-configure-basic-information)
4. [Create Resource read](#4-create-resource-read)
5. [Create Resource write](#5-create-resource-write)
6. [Create GET Method (for ReadFunction)](#6-create-get-method-for-readfunction)
7. [Create POST Method (for WriteFunction)](#7-create-post-method-for-writefunction)
8. [Enable CORS for Resource](#8-enable-cors-for-resource)
9. [Deploy API](#9-deploy-api)
10. [Save the Invoke URL](#10-save-the-invoke-url)

#### 1. Access API Gateway Console

- Sign in to **AWS Management Console**
- Ensure you are in **Singapore (ap-southeast-1)** Region
- Find and select **API Gateway** service

![API Gateway](/images/5/1.png?featherlight=false&width=90pc)

#### 2. Create New REST API

- Choose **Create API**
- In the **REST API** section, choose **Build** (not Private REST API)

![API Gateway](/images/5/2.png?featherlight=false&width=90pc)
![API Gateway](/images/5/3.png?featherlight=false&width=90pc)

#### 3. Configure Basic Information

- **Choose the protocol**: REST
- **Create new API**: New API
- **API name**: ```HighAvailabilityAPI```
- **Description**: ```Primary Region API for Serverless Failover```
- **Endpoint Type**: **Regional**
- Choose **Create API**

![API Gateway](/images/5/4.png?featherlight=false&width=90pc)

#### 4. Create Resource ```read```

- In the newly created API, choose **Actions** → **Create Resource**
- **Resource Name**: ```read```
- **Resource Path**: ```/read```
- **Enable API Gateway CORS**: ✅ (enable)
- Choose **Create Resource**

![API Gateway](/images/5/5.png?featherlight=false&width=90pc)
![API Gateway](/images/5/6.png?featherlight=false&width=90pc)

#### 5. Create Resource ```write```

- In the API, choose **Actions** → **Create Resource**
- **Resource Name**: ```write```
- **Resource Path**: ```/write```
- **Enable API Gateway CORS**: ✅ (enable)
- Choose **Create Resource**

![API Gateway](/images/5/7.png?featherlight=false&width=90pc)
![API Gateway](/images/5/8.png?featherlight=false&width=90pc)

#### 6. Create GET Method (for ReadFunction)

- Select the ```/read``` resource just created
- Choose **Actions** → **Create Method**
- From dropdown, select **GET** and click ✅

![API Gateway](/images/5/9.png?featherlight=false&width=90pc)

**Configure Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (enable)
- **Lambda Region**: ap-southeast-1
- **Lambda Function**: ```ReadFunction```
- Choose **Save**

![API Gateway](/images/5/10.png?featherlight=false&width=90pc)
![API Gateway](/images/5/11.png?featherlight=false&width=90pc)
![API Gateway](/images/5/12.png?featherlight=false&width=90pc)

#### 7. Create POST Method (for WriteFunction)

- Select the ```/write``` resource
- Choose **Actions** → **Create Method**
- From dropdown, select **POST** and click ✅

![API Gateway](/images/5/13.png?featherlight=false&width=90pc)

**Configure Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (enable)
- **Lambda Region**: ap-southeast-1
- **Lambda Function**: ```WriteFunction```
- Choose **Save**

![API Gateway](/images/5/14.png?featherlight=false&width=90pc)
![API Gateway](/images/5/15.png?featherlight=false&width=90pc)

#### 8. Enable CORS for Resource

- Select the root resource ```/```
- Choose **Actions** → **Enable CORS**

![API Gateway](/images/5/21.png?featherlight=false&width=90pc)

**Configure CORS:**
- **Access-Control-Allow-Origin**: ```*```
- **Access-Control-Allow-Headers**: 
  ```
  Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token
  ```

![API Gateway](/images/5/22.png?featherlight=false&width=90pc)
![API Gateway](/images/5/23.png?featherlight=false&width=90pc)

#### 9. Deploy API

- Choose **Actions** → **Deploy API**
- **Deployment stage**: [New Stage]
- **Stage name**: ```prod```
- **Stage description**: ```Production stage for Primary Region```
- **Deployment description**: ```Initial deployment```
- Choose **Deploy**

![API Gateway](/images/5/16.png?featherlight=false&width=90pc)
![API Gateway](/images/5/17.png?featherlight=false&width=90pc)
![API Gateway](/images/5/18.png?featherlight=false&width=90pc)

#### 10. Save the Invoke URL

After successful deployment, in the **Stages** → **prod** tab, you will see the **Invoke URL**:

```
https://xxxxxxxxxx.execute-api.ap-southeast-1.amazonaws.com/prod
```

![API Gateway](/images/5/19.png?featherlight=false&width=90pc)

**Save this URL** - we will need it to:
- Test API functionality
- Configure Route 53 health checks
- Integrate with frontend application

