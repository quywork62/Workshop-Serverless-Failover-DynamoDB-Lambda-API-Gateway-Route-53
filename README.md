# Serverless Failover: DynamoDB, Lambda, API Gateway & Route 53

A comprehensive workshop guide for building a highly available serverless application on AWS Cloud using DynamoDB Global Tables, Lambda Functions, API Gateway, and Route 53 failover mechanisms.

## Serverless Failover Architecture

### 🏗️ Architecture Overview

This workshop demonstrates how to build a fault-tolerant serverless application using:

- **Amazon DynamoDB Global Tables** for multi-region data replication
- **AWS Lambda Functions** for serverless backend processing
- **Amazon API Gateway** for RESTful API endpoints with custom domains
- **Amazon Route 53** for DNS failover and health monitoring
- **AWS Certificate Manager (ACM)** for SSL/TLS certificates
- **Amazon S3** for static website hosting
- **Multi-Region deployment** across Singapore and Tokyo

![Serverless Failover Architecture](/images/1/0001.png)

## 📚 Workshop Content

### 1. Preparation Steps
- AWS account setup and configuration
- Region selection (Singapore as Primary, Tokyo as Secondary)
- Basic understanding of serverless architecture
- Prerequisites and initial setup

### 2. DynamoDB Global Tables Setup
- Create primary DynamoDB table in Singapore region
- Configure Global Tables for multi-region replication
- Set up automatic data synchronization between regions
- Test data consistency across regions

### 3. IAM Roles Configuration
- Create IAM roles for Lambda functions
- Configure proper permissions for DynamoDB access
- Set up cross-region access policies
- Security best practices implementation

### 4. Lambda Functions Deployment
- Deploy Lambda functions in both regions (Singapore & Tokyo)
- Implement CRUD operations (Create, Read, Update, Delete)
- Configure environment variables and runtime settings
- Test function execution and error handling

### 5. API Gateway Setup
- Create REST APIs in both regions
- Configure API Gateway stages and deployments
- Set up CORS for cross-origin requests
- Implement proper error responses and logging

### 6. DNS Route 53 and Failover Configuration
- Set up DNS delegation for custom domain
- Create ACM SSL certificates for both regions
- Configure API Gateway custom domains
- Implement Route 53 health checks and failover records

### 7. Frontend Website Creation
- Deploy static website on Amazon S3
- Configure S3 bucket for website hosting
- Set up public access and object permissions
- Integrate frontend with API endpoints

### 8. Failover Testing
- Test failover mechanism by deleting primary API
- Verify automatic traffic routing to secondary region
- Monitor health check status changes
- Validate end-to-end failover functionality

## 🚀 Getting Started

### Prerequisites
- AWS Account with appropriate permissions
- Basic understanding of serverless architecture
- Familiarity with AWS services (DynamoDB, Lambda, API Gateway)
- Domain name for custom API endpoints (optional but recommended)

### Deployment Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/quywork62/Workshop-Serverless-Failover-DynamoDB-Lambda-API-Gateway-Route-53.git
   cd Workshop-Serverless-Failover-DynamoDB-Lambda-API-Gateway-Route-53
   ```

2. **Follow the workshop guide**
   - Start with the Preparation section
   - Complete each section in sequential order
   - Verify each step before proceeding to the next

3. **Access the workshop**
   - Open `index.html` in your browser for the full workshop experience
   - Or follow the markdown files in the `content/` directory

## 🛠️ Key Features

- **High Availability**: Multi-region deployment with automatic failover
- **Serverless Architecture**: No server management required
- **Global Data Replication**: DynamoDB Global Tables for data consistency
- **Automatic Failover**: Route 53 health checks with DNS failover
- **SSL/TLS Security**: ACM certificates for HTTPS endpoints
- **Cost Effective**: Pay-per-use serverless model
- **Scalable**: Automatic scaling based on demand

## 📖 Workshop Structure

```
content/
├── 1-create-new-aws-account/           # AWS account preparation
├── 2-MFA-Setup-For-AWS-User-(root)/    # DynamoDB Global Tables setup
├── 3-create-admin-user-and-group/      # IAM roles configuration
├── 4-verify-new-account/               # Lambda functions deployment
├── 5-setup-api-gateway/                # API Gateway configuration
│   ├── 5.1-create-api-primary-region/  # Primary region API
│   └── 5.2-create-api-secondary-region/ # Secondary region API
├── 6-setup-dns-route53-failover/       # DNS and failover setup
│   ├── 6.1-setup-dns-delegation/       # DNS delegation
│   ├── 6.2-acm-ssl-certificates/       # SSL certificates
│   ├── 6.3-api-gateway-custom-domains/ # Custom domains
│   └── 6.4-route53-health-check-failover/ # Health checks & failover
├── 7-create-frontend-website/          # Frontend website deployment
└── 8-test-failover-delete-primary-api/ # Failover testing
```

## 🌐 Languages

This workshop is available in:
- **English** - Complete workshop content
- **Vietnamese (Tiếng Việt)** - Full translation available

## 💰 Cost Considerations

This workshop uses several AWS services that may incur charges:

- **DynamoDB** - Global Tables and read/write capacity
- **Lambda** - Function invocations and execution time
- **API Gateway** - API requests and data transfer
- **Route 53** - Hosted zones and health checks
- **ACM** - SSL certificates (free)
- **S3** - Storage and data transfer

**Important**: Remember to clean up resources after completing the workshop to avoid unnecessary charges. Follow the cleanup guide in section 9.

## 🔧 Technologies Used

- **AWS Services**: DynamoDB, Lambda, API Gateway, Route 53, ACM, S3, IAM
- **Programming**: Python for Lambda functions
- **Frontend**: HTML, CSS, JavaScript, Bootstrap
- **Infrastructure**: Multi-region serverless deployment
- **Documentation**: Hugo static site generator

## 📝 Learning Objectives

By completing this workshop, you will learn:

- How to design and implement a serverless failover architecture
- DynamoDB Global Tables configuration and management
- Lambda function development and deployment across regions
- API Gateway setup with custom domains and SSL certificates
- Route 53 DNS failover and health monitoring
- Serverless security best practices
- Cost optimization strategies for serverless applications
- Disaster recovery and business continuity planning

## 🎯 Use Cases

This architecture pattern is ideal for:

- **Mission-critical APIs** requiring high availability
- **Global applications** with users across multiple regions
- **Disaster recovery** scenarios for serverless workloads
- **Cost-effective** high availability solutions
- **Microservices** architectures with failover requirements

## 🔍 Key Concepts Covered

- **Serverless Computing**: Building applications without managing servers
- **Multi-Region Architecture**: Deploying across multiple AWS regions
- **Fault Tolerance**: Designing systems that continue operating during failures
- **Health Monitoring**: Implementing health checks and automated responses
- **DNS Failover**: Automatic traffic routing during outages
- **Data Replication**: Keeping data synchronized across regions

## 🤝 Contributing

We welcome contributions to improve this workshop! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

For questions or issues:
- Join our [AWS Study Group on Facebook](https://www.facebook.com/groups/awsstudygroup)
- Create an issue in this repository
- Contact: journeyoftheaverageguy@gmail.com

## 👥 Authors

- **Gia Hưng** - [LinkedIn](https://www.linkedin.com/in/jotaguy)
- **Hoàng Quy** - [LinkedIn](https://www.linkedin.com/in/quy-hoang-773a45303)

## 📄 License

This workshop is provided under the MIT License. See LICENSE file for details.

## 🏷️ Tags

`AWS` `Serverless` `DynamoDB` `Lambda` `API-Gateway` `Route53` `Failover` `High-Availability` `Multi-Region` `Workshop` `Tutorial` `Disaster-Recovery`

---

**Last Updated**: October 1, 2025

**Workshop Duration**: 4-6 hours

**Difficulty Level**: Intermediate

**AWS Services**: 7+ services used

**Regions**: 2 regions (Singapore, Tokyo)