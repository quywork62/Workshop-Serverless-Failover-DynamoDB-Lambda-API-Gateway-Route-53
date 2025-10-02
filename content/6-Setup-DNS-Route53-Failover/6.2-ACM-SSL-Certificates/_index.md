---
title : "ACM DNS validation for both regions"
date : "2025-01-27" 
weight : 2
chapter : false
pre : " <b> 6.2 </b> "
---

### ACM DNS validation for both regions

Since you're using Regional APIs in ap-southeast-1 (Singapore – primary) and ap-northeast-1 (Tokyo – secondary), you need 2 certificates, one in each corresponding region.

### Why SSL Certificates are Needed for Both Regions?

- **Regional Requirement**: API Gateway Regional endpoints need certificates in the same Region
- **Custom Domain**: To use custom domain instead of default AWS URLs
- **HTTPS Security**: Ensure all API calls are encrypted
- **Failover Support**: Both Regions need SSL for failover to work

### Content

1. [Create Certificate for Singapore Region](#1-create-certificate-for-singapore-region)
2. [DNS Validation for Singapore](#2-dns-validation-for-singapore)
3. [Create Certificate for Tokyo Region](#3-create-certificate-for-tokyo-region)
4. [DNS Validation for Tokyo](#4-dns-validation-for-tokyo)
5. [Check Certificate Status](#5-check-certificate-status)

#### 1. Create Certificate for Singapore Region

- Ensure you are in **Singapore (ap-southeast-1)** Region
- Access **AWS Certificate Manager (ACM)**
- Choose **Request a certificate**

![ACM](/images/6.2/1.png?featherlight=false&width=90pc)

**Configure Certificate:**
- **Certificate type**: **Request a public certificate**
- Choose **Next**

![ACM](/images/6.2/2.png?featherlight=false&width=90pc)

**Domain names:**
- **Fully qualified domain name**: ```api.turtleclouds.id.vn```
- If you need SAN (Subject Alternative Names): ```www.api.turtleclouds.id.vn```
- **Validation method**: **DNS validation**
- **Key algorithm**: **RSA 2048**
- Choose **Request**

![ACM](/images/6.2/3.png?featherlight=false&width=90pc)
![ACM](/images/6.2/4.png?featherlight=false&width=90pc)
![Route 53](/images/6.2/5.png?featherlight=false&width=90pc)

![Route 53](/images/6.2/6.png?featherlight=false&width=90pc)

#### 2. DNS Validation for Singapore

ACM will display validation information. You will see a CNAME record that needs to be created:

**Example CNAME record:**
- **Name**: ```_4724b28c2f251eaf0f8e5de086a13395.api.turtleclouds.id.vn```
- **Value**: ```_d527ab199f33beee1a7c9dedf48c932a.xlfgrmvvlj.acm-validations.aws```

👉 In **ACM** interface, choose **Create records in Route 53** to create automatically.
![ACM](/images/6.2/7.png?featherlight=false&width=90pc)

- Create DNS record in **Route 53**

When you click the button, ACM will open the DNS record creation interface in Route 53.

**Domain**: ```api.turtleclouds.id.vn```

**Validation status**: **Pending validation**

Choose **Create records** to confirm.
![ACM](/images/6.2/8.png?featherlight=false&width=90pc)

- Verify status

After creation, return to the certificate details screen in ACM.

Status will be **Pending validation**.

After a few minutes, when DNS propagation is complete, ACM will automatically change to **Issued**.
![ACM](/images/6.2/9.png?featherlight=false&width=90pc)
![ACM](/images/6.2/10.png?featherlight=false&width=90pc)

{{%notice info%}}
Note: Since subdomain api.* has been delegated to Route 53, you create the CNAME record directly in Route 53 (zone: api.turtleclouds.id.vn), no need to work with Cloudflare.
{{%/notice%}}

#### 3. Create Certificate for Tokyo Region

- Switch to **Tokyo (ap-northeast-1)** Region
- Access **AWS Certificate Manager (ACM)**
- Repeat the same steps as Singapore

**Configure Certificate:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Validation method**: **DNS validation**
- **Key algorithm**: **RSA 2048**
- Choose **Request**

#### 4. DNS Validation for Tokyo

ACM Tokyo will provide a different CNAME record for validation:

**Example CNAME record for Tokyo:**
- **Name**: ```_8956c39d4e362bfb2c9f7a180b24567e.api.turtleclouds.id.vn```
- **Value**: ```_f638bc210e44ceef2d8d0f57f49c843b.ylfgrmvvlj.acm-validations.aws```

👉 In **ACM** interface, choose **Create records in Route 53** to create automatically.

- Create DNS record in **Route 53**

When you click the button, ACM will open the DNS record creation interface in Route 53.

**Domain**: ```api.turtleclouds.id.vn```

**Validation status**: **Pending validation**

Choose **Create records** to confirm.

- Verify status

After creation, return to the certificate details screen in ACM.

Status will be **Pending validation**.

After a few minutes, when DNS propagation is complete, ACM will automatically change to **Issued**.

![ACM](/images/6.2/11.png?featherlight=false&width=90pc)

{{%notice info%}}
Note: Since subdomain api.* has been delegated to Route 53, you create the CNAME record directly in Route 53 (zone: api.turtleclouds.id.vn), no need to work with Cloudflare.
{{%/notice%}}

#### 5. Check Certificate Status

**Check Singapore Certificate:**
- Return to ACM in **Singapore** Region
- Wait for status to change from **Pending validation** → **Issued** (usually 2-10 minutes)

![ACM](/images/6.2/10.png?featherlight=false&width=90pc)

**Check Tokyo Certificate:**
- Switch to ACM in **Tokyo** Region
- Wait for status to change from **Pending validation** → **Issued**

![ACM](/images/6.2/11.png?featherlight=false&width=90pc)

### Troubleshooting

If certificates are not issued after 15 minutes:

1. **Check CNAME records**: Ensure they are created correctly in Route 53
2. **Check DNS propagation**: Use `nslookup` to verify
3. **Check TTL**: Ensure TTL is not too high (recommended 300s)

```bash
nslookup -type=CNAME _4724b28c2f251eaf0f8e5de086a13395.api.turtleclouds.id.vn
```

### Results

After completing this step:

- ✅ **SSL Certificate** issued for Singapore Region
- ✅ **SSL Certificate** issued for Tokyo Region
- ✅ **DNS Validation** working correctly
- ✅ **CNAME Records** created in Route 53

### Preparation for Next Step

With 2 SSL certificates ready, we can create Custom Domain Names for API Gateway in both Regions in the next step.