---
title : "Test failover mechanism by deleting primary API (Singapore)"
date : "2025-01-27" 
weight : 8
chapter : false
pre : " <b> 8. </b> "
---

In this step, we will completely delete the API in Singapore region (ap-southeast-1) to verify the failover mechanism to the Secondary region (Tokyo).

{{%notice warning%}}
**⚠️ Important Note**: This action cannot be undone if you haven't exported the API. Therefore, export before deleting to be able to restore later.
{{%/notice%}}

### Why Test Failover is Needed?

- **Validate Architecture**: Verify that the failover mechanism works correctly
- **Real-world Simulation**: Simulate real-world scenarios when Primary Region fails
- **Business Continuity**: Ensure service is not interrupted
- **Confidence Building**: Build confidence in the High Availability system

### Content

1. [(Optional) Export API](#1-optional-export-api)
2. [Delete Domain Mapping (if any)](#2-delete-domain-mapping-if-any)
3. [Delete API on Console](#3-delete-api-on-console)
4. [Check Health Check (Route 53)](#4-check-health-check-route-53)
5. [Verify Failover](#5-verify-failover)

#### 1. (Optional) Export API

- Navigate to **API Gateway** → **APIs** → select **HighAvailabilityAPI**
- Go to **Stages** → select **prod**
- Choose **Export** to download Swagger/OpenAPI definition file

![API Gateway](/images/8/1.png?featherlight=false&width=90pc)
![API Gateway](/images/8/2.png?featherlight=false&width=90pc)

👉 Save this file to restore or redeploy the API if needed.

#### 2. Delete Domain Mapping (if any)

Some AWS accounts require removing domain mapping before deleting API.

**Steps:**
- Go to **Custom domain names** → select domain
- Choose **Delete API mapping**

![API Gateway](/images/8/3.png?featherlight=false&width=90pc)
![API Gateway](/images/8/4.png?featherlight=false&width=90pc)
![API Gateway](/images/8/5.png?featherlight=false&width=90pc)

#### 3. Delete API on Console

- Return to **APIs** → select **HighAvailabilityAPI**
- Choose **Actions** → **Delete**
- Type ```delete``` to confirm

![API Gateway](/images/8/6.png?featherlight=false&width=90pc)
![API Gateway](/images/8/7.png?featherlight=false&width=90pc)
![API Gateway](/images/8/8.png?featherlight=false&width=90pc)

**Or via AWS CLI:**

**Get list of APIs in Singapore:**
```bash
aws apigateway get-rest-apis --region ap-southeast-1
```

**Delete API:**
```bash
aws apigateway delete-rest-api \
  --rest-api-id <API_ID> \
  --region ap-southeast-1
```

#### 4. Check Health Check (Route 53)

After Singapore API is deleted, Primary health check will report **Unhealthy** (HTTP 404/403).

Route 53 will automatically failover all traffic to Secondary (Tokyo – ap-northeast-1).

- Access **Route 53** → **Health checks**
- Check status of **Primary Singapore** health check
- Status will change from **Success** → **Failure**

![Route 53](/images/8/9.png?featherlight=false&width=90pc)
![Route 53](/images/8/10.png?featherlight=false&width=90pc)

**Check Frontend Website:**

While waiting for health check to detect failure, you can test the frontend website to see the changes:

- Access frontend website: ```http://api.turtleclouds.id.vn.s3-website-ap-southeast-1.amazonaws.com```
- Try CRUD functions
- Initially may encounter errors when Singapore API was just deleted
- After 2-3 minutes, website will work normally again when traffic is switched to Tokyo

![Website](/images/8/11.png?featherlight=false&width=90pc)
![Website](/images/8/12.png?featherlight=false&width=90pc)
![Website](/images/8/13.png?featherlight=false&width=90pc)

{{%notice info%}}
**Note**: Health check may take 2-3 minutes to detect failure and trigger failover.
{{%/notice%}}

#### 5. Verify Failover

**Method 1: Test directly in Route 53**

- Go to **Route 53 Console** → **Hosted zones** → select domain **api.turtleclouds.id.vn**
- Click **Test record**

![Route 53](/images/8/14.png?featherlight=false&width=90pc)

**Enter:**
- Record name: ```api.turtleclouds.id.vn```
- Record type: **A**
- Click **Test**

![Route 53](/images/8/15.png?featherlight=false&width=90pc)

👉 If failover is successful, record will resolve to IP in Tokyo (ap-northeast-1) instead of Singapore.

**Method 2: Verify actual IP**

**Check DNS/IP from terminal:**
```bash
dig api.turtleclouds.id.vn
```

**Or on Windows PowerShell:**
```powershell
Resolve-DnsName api.turtleclouds.id.vn
```

![Terminal](/images/8/16.png?featherlight=false&width=90pc)

👉 Result will show IP list (e.g., 35.74.x.x, 52.199.x.x, 52.193.x.x) — all belonging to Tokyo region.

**Method 3: Reverse DNS to identify Region**

**On Linux/Mac:**
```bash
host <IP>
```

**On Windows PowerShell:**
```powershell
Resolve-DnsName <IP> -Type PTR
```

![Terminal](/images/8/17.png?featherlight=false&width=90pc)
![Terminal](/images/8/18.png?featherlight=false&width=90pc)

👉 If result shows **ap-northeast-1** (Tokyo) → proves failover successful. 🎉

### Expected Results

✅ **API in Singapore has been deleted**

✅ **Health check changed to Unhealthy**

✅ **Route 53 failover to Tokyo (ap-northeast-1)**

✅ **Accessing domain api.turtleclouds.id.vn will return response from Tokyo API**

### Monitoring and Verification

**CloudWatch Metrics:**
- Route 53 Health Check status changes
- API Gateway request metrics (should show 0 for Singapore, increased for Tokyo)
- Lambda invocation metrics shift to Tokyo region

**Timeline Expectations:**
- **0-2 minutes**: API deletion completed
- **2-5 minutes**: Health check detects failure
- **5-7 minutes**: DNS failover propagation
- **7+ minutes**: All traffic routed to Tokyo

### Troubleshooting

**If failover doesn't work:**

1. **Check Health Check configuration**
2. **Verify Failover records setup correctly**
3. **Check DNS TTL settings**
4. **Ensure Tokyo API and Lambda functions work normally**

**If you want to restore Singapore API:**

1. **Import API from exported file**
2. **Redeploy Lambda functions**
3. **Recreate Custom Domain mapping**
4. **Wait for Health Check to recover**

### Conclusion

You have successfully verified that the **Serverless Failover** mechanism works automatically and effectively. The system has the ability to:

- **Automatically detect failures** through Route 53 Health Checks
- **Switch traffic** to backup Region within 5-7 minutes
- **Maintain service continuity** without manual intervention
- **Ensure data consistency** thanks to DynamoDB Global Tables

{{%notice success%}}
**Congratulations!** You have successfully built a **High Availability Serverless** architecture with fault tolerance and automatic recovery capabilities.
{{%/notice%}}