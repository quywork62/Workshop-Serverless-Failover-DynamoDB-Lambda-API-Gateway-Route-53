---
title : "DNS Delegation for api.turtleclouds.id.vn"
date : "2025-01-27" 
weight : 1
chapter : false
pre : " <b> 6.1 </b> "
---

### DNS Delegation for api.turtleclouds.id.vn

To properly implement Step 6 (Route 53 health check + failover), we only need to delegate DNS authority for the `api` subdomain to Route 53, while keeping the root domain `turtleclouds.id.vn` with Cloudflare.

### Why DNS Delegation is Needed?

- **Separate Management**: API subdomain managed by Route 53, main domain stays with Cloudflare
- **Health Check**: Route 53 can perform health checks and failover for API endpoints
- **Flexibility**: No impact on other subdomains (www, mail, etc.)
- **AWS Integration**: Better integration with other AWS services

### Content

1. [Create Route 53 Hosted Zone](#1-create-route-53-hosted-zone)
2. [Save NS Records](#2-save-ns-records)
3. [Configure NS Records on Cloudflare](#3-configure-ns-records-on-cloudflare)
4. [Verify DNS Delegation](#4-verify-dns-delegation)

#### 1. Create Route 53 Hosted Zone

- Access **Route 53** in AWS Console
- Choose **Hosted zones** → **Create hosted zone**

![Route 53](/images/6.1/1.png?featherlight=false&width=90pc)
![Route 53](/images/6.1/2.png?featherlight=false&width=90pc)

**Configure Hosted Zone:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Type**: **Public hosted zone**
- **Comment**: ```Subdomain for API Gateway failover```
- Choose **Create hosted zone**

![Route 53](/images/6.1/3.png?featherlight=false&width=90pc)
![Route 53](/images/6.1/4.png?featherlight=false&width=90pc)
![Route 53](/images/6.1/5.png?featherlight=false&width=90pc)

#### 2. Save NS Records

After creating the hosted zone, Route 53 will provide 4 NS (Name Server) records. Save these NS records:

```
ns-xxxx.awsdns-xx.org
ns-xxxx.awsdns-xx.net
ns-xxxx.awsdns-xx.com
ns-xxxx.awsdns-xx.co.uk
```
![Route 53](/images/6.1/5.png?featherlight=false&width=90pc)

{{%notice info%}}
**Note**: Your NS records will be different from the example above. Make sure to copy the exact NS records that Route 53 provides for your hosted zone.
{{%/notice%}}

#### 3. Configure NS Records on Cloudflare

- Sign in to **Cloudflare Dashboard**
- Select domain **turtleclouds.id.vn**
- Go to **DNS** → **Records**

![Cloudflare](/images/6.1/6.png?featherlight=false&width=90pc)

**Add NS Records:**

Create 4 NS records, one for each Route 53 NS server:

**Record 1:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.org```
- **TTL**: Auto

**Record 2:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.net```
- **TTL**: Auto

**Record 3:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.com```
- **TTL**: Auto

**Record 4:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.co.uk```
- **TTL**: Auto

![Cloudflare](/images/6.1/7.png?featherlight=false&width=90pc)
![Cloudflare](/images/6.1/8.png?featherlight=false&width=90pc)

{{%notice warning%}}
**Important**: Ensure **Proxy status** is **DNS only** (gray cloud), not **Proxied** (orange cloud) for NS records.
{{%/notice%}}

#### 4. Verify DNS Delegation

After configuration, verify that DNS delegation is working:

**Using nslookup:**
```bash
nslookup -type=NS api.turtleclouds.id.vn
```

**Expected result:**
```
Server:  8.8.8.8
Address: 8.8.8.8#53

Non-authoritative answer:
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.org.
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.net.
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.com.
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.co.uk.
```

**Using dig (Linux/Mac):**
```bash
dig NS api.turtleclouds.id.vn
```

![DNS Check](/images/6.1/9.png?featherlight=false&width=90pc)

### Results

After completing this step:

- ✅ **Route 53 Hosted Zone** created for `api.turtleclouds.id.vn`
- ✅ **NS Records** configured on Cloudflare
- ✅ **DNS Delegation** working correctly
- ✅ **Subdomain api** now managed by Route 53

### Preparation for Next Step

From now on, all DNS records for `*.api.turtleclouds.id.vn` will be managed by Route 53, while the rest (`www`, `root`, etc.) remain with Cloudflare as before.

In the next step, we will create SSL certificates for this domain using AWS Certificate Manager.