---
title : "Set Up DNS Route 53 and Configure Failover for API Gateway"
date : "2025-01-27" 
weight : 6
chapter : false
pre : " <b> 6. </b> "
---

### Set Up DNS Route 53 and Configure Failover for API Gateway

In this step, we will configure automatic DNS failover using Amazon Route 53 to ensure high availability for API Gateway. When the Primary Region encounters issues, Route 53 will automatically redirect traffic to the Secondary Region.



### Why DNS Failover is Needed?

- **Automatic Failover**: Automatically redirect traffic when Primary Region fails
- **Health Monitoring**: Continuously monitor API endpoint status
- **Zero Manual Intervention**: No manual intervention required during failover
- **Custom Domain**: Use custom domain instead of default AWS URLs
- **SSL/TLS Security**: Ensure HTTPS for all requests

### DNS Failover Architecture

1. **Route 53 Hosted Zone**: Manages DNS for subdomain `api.turtleclouds.id.vn`
2. **ACM Certificates**: SSL certificates for both Regions
3. **Custom Domains**: API Gateway custom domains with SSL
4. **Health Checks**: Monitor API endpoint status
5. **Failover Records**: Primary/Secondary routing policy

### Content

1. [Set up DNS delegation for api.turtleclouds.id.vn](6.1-setup-dns-delegation/)
2. [Create ACM DNS validation for both regions](6.2-acm-ssl-certificates/)
3. [Create Custom domains for API Gateway (one per region)](6.3-api-gateway-custom-domains/)
4. [Route 53 Health checks + Failover records](6.4-route53-health-check-failover/)

### Important Notes

{{%notice warning%}}
**Prerequisites:**
- Domain `turtleclouds.id.vn` managed by Cloudflare
- API Gateway created in both Regions (Singapore and Tokyo)
- Lambda Functions working properly
- DynamoDB Global Tables configured
{{%/notice%}}

### Implementation Process

1. **Step 6.1**: Create Route 53 Hosted Zone for subdomain `api.turtleclouds.id.vn`
2. **Step 6.2**: Request SSL certificates from ACM for both Regions
3. **Step 6.3**: Create Custom Domain Names for API Gateway
4. **Step 6.4**: Configure Health Checks and Failover Records

### Expected Results

After completion, you will have:

- ✅ **Custom Domain**: `api.turtleclouds.id.vn` pointing to API Gateway
- ✅ **SSL/TLS**: HTTPS enabled for all requests
- ✅ **Health Monitoring**: Route 53 continuously checks API status
- ✅ **Automatic Failover**: Automatically switch to Secondary Region when needed
- ✅ **Zero Downtime**: Users experience no service interruption