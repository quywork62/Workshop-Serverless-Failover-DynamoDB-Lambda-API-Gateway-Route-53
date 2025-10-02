---
title : "Route 53 Health check + Failover record (in zone api.turtleclouds.id.vn)"
date : "2025-01-27" 
weight : 4
chapter : false
pre : " <b> 6.4 </b> "
---

### Route 53 Health check + Failover record

The final step is to create Health Checks to monitor API endpoint status and configure Failover Records to automatically redirect traffic when the Primary Region encounters issues.

### Why Health Check and Failover are Needed?

- **Automatic Monitoring**: Route 53 continuously checks API endpoint status
- **Instant Failover**: Automatically switch to Secondary Region when Primary fails
- **Zero Manual Intervention**: No manual intervention required
- **High Availability**: Ensure 99.9% uptime for API service

### Content

1. [Create Health Check for Primary Region](#1-create-health-check-for-primary-region)
2. [Create Health Check for Secondary Region](#2-create-health-check-for-secondary-region)
3. [Create Failover Record for Primary](#3-create-failover-record-for-primary)
4. [Create Failover Record for Secondary](#4-create-failover-record-for-secondary)
5. [Test Failover Scenario](#5-test-failover-scenario)

#### 1. Create Health Check for Primary Region

- Access **Route 53** → **Health checks**
- Choose **Create health check**

![Route 53](/images/6.4/1.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/2.png?featherlight=false&width=90pc)

**Configure Primary Health Check:**
- **Name**: ```Primary Singapore```
- **What to monitor**: **Endpoint**
- **Specify endpoint by**: **Domain name**
- **Protocol**: **HTTPS**
- **Domain name**: ```dynw0bc977.execute-api.ap-southeast-1.amazonaws.com/prod/read``` (API ID of Singapore)
- **Request interval**: **Fast (10 seconds)**
- **Failure threshold**: **3**

![Route 53](/images/6.4/3.png?featherlight=false&width=90pc)

![Route 53](/images/6.4/4.png?featherlight=false&width=90pc)

**Advanced configuration:**
- **Enable SNI**: **Yes**
- **Enable health checker regions**: **3 regions in Asia Pacific**:

Asia Pacific (Tokyo) ✅

Asia Pacific (Singapore) ✅

Asia Pacific (Sydney) ✅

![Route 53](/images/6.4/5.png?featherlight=false&width=90pc)

![Route 53](/images/6.4/6.png?featherlight=false&width=90pc)

![Route 53](/images/6.4/7.png?featherlight=false&width=90pc)

{{%notice warning%}}
**Important**: DO NOT use Regional domain of custom domain (d-a7cx5xv22d.execute-api...) for Health Check as it may cause 403/401 errors. Use invoke URL with API ID instead.
{{%/notice%}}

#### 2. Create Health Check for Secondary Region

- Choose **Create health check** again

**Configure Secondary Health Check:**
- **Name**: ```Secondary Tokyo```
- **What to monitor**: **Endpoint**
- **Specify endpoint by**: **Domain name**
- **Protocol**: **HTTPS**
- **Domain name**: ```qp3nkjwlde.execute-api.ap-northeast-1.amazonaws.com/prod/read``` (API ID of Tokyo)

**Request interval**: **Fast (10 seconds)**
- **Failure threshold**: **3**

**Advanced configuration:**
- **Enable SNI**: **Yes**
- **Enable health checker regions**: **3 regions in Asia Pacific**:

Asia Pacific (Tokyo) ✅

Asia Pacific (Singapore) ✅

Asia Pacific (Sydney) ✅

![Route 53](/images/6.4/8.png?featherlight=false&width=90pc)

#### 3. Create Failover Record for Primary

- Access **Route 53** → **Hosted zones**
- Select zone **api.turtleclouds.id.vn**
- Choose **Create record**

![Route 53](/images/6.4/9.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/10.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/11.png?featherlight=false&width=90pc)

**Configure Primary Failover Record:**
- **Record name**: leave empty (root of api.turtleclouds.id.vn)
- **Record type**: **A**
- **Alias**: **Yes**
- **Route traffic to**: **Alias to API Gateway API**
- **Choose Region**: **Asia Pacific (Singapore)**
- **Choose API Gateway**: Select Singapore API Gateway from dropdown
- **Routing policy**: **Failover**
- **Failover record type**: **Primary**
- **Health check**: Select ```Primary Singapore```
- **Record ID**: ```primary-ap-southeast-1```

![Route 53](/images/6.4/12.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/13.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/14.png?featherlight=false&width=90pc)

#### 4. Create Failover Record for Secondary

- Choose **Create record** again

**Configure Secondary Failover Record:**
- **Record name**: leave empty (root of api.turtleclouds.id.vn)
- **Record type**: **A**
- **Alias**: **Yes**
- **Route traffic to**: **Alias to API Gateway API**
- **Choose Region**: **Asia Pacific (Tokyo)**
- **Choose API Gateway**: Select Tokyo API Gateway from dropdown
- **Routing policy**: **Failover**
- **Failover record type**: **Secondary**
- **Health check**: Select ```Secondary Tokyo```
- **Record ID**: ```secondary-ap-northeast-1```

![Route 53](/images/6.4/15.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/16.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/17.png?featherlight=false&width=90pc)

{{%notice info%}}
**Note**: If "Alias to API Gateway" menu doesn't appear, you can use **Record type CNAME** pointing directly to the Regional domain of the custom domain API Gateway.
{{%/notice%}}

**Check Health Check Status**
- Access **Route 53** → **Health checks**
- Check status of both health checks
- **Success** status means endpoints are working normally

![Route 53](/images/6.4/8.png?featherlight=false&width=90pc)

### Results

After completing this step:

- ✅ **Health Checks** created for both Regions
- ✅ **Failover Records** configured
- ✅ **DNS Failover** working automatically
- ✅ **Custom Domain** `api.turtleclouds.id.vn` ready
- ✅ **High Availability** ensured