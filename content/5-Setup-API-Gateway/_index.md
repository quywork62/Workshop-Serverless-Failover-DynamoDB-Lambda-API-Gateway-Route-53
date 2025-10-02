---
title : "Set Up API Gateway (Both Regions)"
date : "2025-01-27" 
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

### Introduction to Amazon API Gateway

**Amazon API Gateway** is a fully managed service that makes it easy for developers to create, publish, maintain, monitor, and secure APIs at any scale. API Gateway acts as a "front door" for applications to access data, business logic, or functionality from backend services such as AWS Lambda, Amazon EC2, or any web service.

**In this lab**, API Gateway plays a crucial role in the Serverless Failover architecture:

- **Provides REST API endpoints**: Creates unified endpoints for frontend applications to call
- **Connects with Lambda Functions**: Integrates with ReadFunction and WriteFunction created earlier
- **CORS Support**: Allows frontend from different domains to access the API
- **Logging and Monitoring**: Tracks performance and debugs issues
- **Throttling**: Controls the number of requests to protect the backend

### Benefits of API Gateway in DR Strategy

- **Multi-Region Deployment**: Deployed in both Primary and Secondary Regions
- **Health Check Integration**: Integrates with Route 53 to check endpoint status
- **Custom Domain**: Uses custom domain instead of default AWS URLs
- **SSL/TLS**: Automatically supports HTTPS through AWS Certificate Manager

### Content

1. [Create API Gateway in Primary Region](5.1-create-api-primary-region/)
2. [Replicate API Gateway to Secondary Region](5.2-create-api-secondary-region/)

