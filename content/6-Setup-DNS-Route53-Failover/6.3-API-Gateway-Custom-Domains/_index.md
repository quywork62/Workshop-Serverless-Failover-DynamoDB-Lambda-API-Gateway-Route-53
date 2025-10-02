---
title : "Create Custom domains for API Gateway (one per region)"
date : "2025-01-27" 
weight : 3
chapter : false
pre : " <b> 6.3 </b> "
---

### Create Custom domains for API Gateway (one per region)

After having SSL certificates in both Regions, we will create Custom Domain Names for API Gateway to use custom domain instead of default AWS URLs.

### Why Custom Domain is Needed?

- **Professional URL**: Use `api.turtleclouds.id.vn` instead of long AWS URLs
- **SSL/TLS**: Enable HTTPS with custom certificate
- **Branding**: Consistent with brand and main domain
- **Failover Ready**: Prepare for Route 53 failover configuration

### Content

1. [Create Custom Domain for Singapore Region](#1-create-custom-domain-for-singapore-region)
2. [Configure API Mapping for Singapore](#2-configure-api-mapping-for-singapore)
3. [Save Regional Domain Name Singapore](#3-save-regional-domain-name-singapore)
4. [Create Custom Domain for Tokyo Region](#4-create-custom-domain-for-tokyo-region)
5. [Configure API Mapping for Tokyo](#5-configure-api-mapping-for-tokyo)
6. [Save Regional Domain Name Tokyo](#6-save-regional-domain-name-tokyo)

#### 1. Create Custom Domain for Singapore Region

- Ensure you are in **Singapore (ap-southeast-1)** Region
- Access **API Gateway** → **Custom domain names**
- Choose **Add domain names**

![API Gateway](/images/6.3/1.png?featherlight=false&width=90pc)

**Configure Custom Domain:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Endpoint type**: **Regional**
- **ACM certificate**: Select **Issued** certificate from Singapore Region
- **Security policy**: **TLS 1.2**
- Choose **Add domain name**

![API Gateway](/images/6.3/2.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/3.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/4.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/5.png?featherlight=false&width=90pc)

#### 2. Configure API Mapping for Singapore

After creating custom domain, need to map with API Gateway:

- In the newly created custom domain, select **API mappings** tab
- Choose **Configure API mappings**

![API Gateway](/images/6.3/6.png?featherlight=false&width=90pc)

**Add API Mapping:**
- Choose **Add new mapping**
- **API**: Select ```HighAvailabilityAPI```
- **Stage**: ```prod```
- **Path**: leave empty (root path)
- Choose **Save**

![API Gateway](/images/6.3/7.png?featherlight=false&width=90pc)

![API Gateway](/images/6.3/9.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/10.png?featherlight=false&width=90pc)

#### 3. Save Regional Domain Name Singapore

After creating custom domain, API Gateway will generate a **Regional domain name**. Save this information:

**Example Regional Domain Name:**
```
d-a7cx5xv22d.execute-api.ap-southeast-1.amazonaws.com
```

![API Gateway](/images/6.3/10.1.png?featherlight=false&width=90pc)

{{%notice info%}}
**Important**: This Regional domain name will be used in Route 53 to create ALIAS records for failover.
{{%/notice%}}

#### 4. Create Custom Domain for Tokyo Region

- Switch to **Tokyo (ap-northeast-1)** Region
- Access **API Gateway** → **Custom domain names**
- Choose **Add domain names**

**Configure Custom Domain:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Endpoint type**: **Regional**
- **ACM certificate**: Select **Issued** certificate from Tokyo Region
- **Security policy**: **TLS 1.2**
- Choose **Add domain name**

#### 5. Configure API Mapping for Tokyo

- In Tokyo custom domain, select **API mappings** tab
- Choose **Configure API mappings**

**Add API Mapping:**
- Choose **Add new mapping**
- **API**: Select ```HighAvailabilityAPI```
- **Stage**: ```prod```
- **Path**: leave empty (root path)
- Choose **Save**

![API Gateway](/images/6.3/11.png?featherlight=false&width=90pc)

#### 6. Save Regional Domain Name Tokyo

Save the **Regional domain name** for Tokyo:

**Example Regional Domain Name Tokyo:**
```
d-b8dy6yw33e.execute-api.ap-northeast-1.amazonaws.com
```

![API Gateway](/images/6.3/11.1.png?featherlight=false&width=90pc)

### Results

After completing this step:

- ✅ **Custom Domain** created for Singapore Region
- ✅ **Custom Domain** created for Tokyo Region
- ✅ **API Mappings** configured for both Regions
- ✅ **Regional Domain Names** saved for use in Route 53

### Information to Save

| Region | Custom Domain | Regional Domain Name | Certificate |
|--------|---------------|---------------------|-------------|
| **Singapore** | api.turtleclouds.id.vn | d-pbm3eqaneb.execute-api.ap-southeast-1.amazonaws.com | ACM Singapore |
| **Tokyo** | api.turtleclouds.id.vn | d-15ro7mhib1.execute-api.ap-northeast-1.amazonaws.com | ACM Tokyo |

### Preparation for Next Step

With Custom Domains ready, we can create Route 53 Health Checks and Failover Records in the final step.