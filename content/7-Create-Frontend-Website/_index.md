---
title : "Create the Frontend Website"
date : "2025-01-27" 
weight : 7
chapter : false
pre : " <b> 7. </b> "
---

### Step 7: Create the Frontend Website

In this step, you will deploy a static frontend website to communicate with the API. The website uses HTML, Bootstrap for UI, and JavaScript to call APIs through Route 53 DNS name.

### Why Frontend Website is Needed?

- **User Interface**: Provide user-friendly interface to test API
- **Real-world Testing**: Test failover from end-user perspective
- **Complete Solution**: Complete full-stack architecture with frontend + backend
- **Demonstration**: Illustrate integration with API Gateway through custom domain

### Content

1. [Download source code from GitHub](#1-download-source-code-from-github)
2. [Create S3 Bucket](#2-create-s3-bucket)
3. [Edit API configuration](#3-edit-api-configuration)
4. [Upload files to S3](#4-upload-files-to-s3)
5. [Enable Static Website Hosting](#5-enable-static-website-hosting)
6. [Configure Public Access Block](#6-configure-public-access-block)
7. [Configure Public Objects (Object ACLs)](#7-configure-public-objects-object-acls)
8. [Test Website](#8-test-website)

#### 1. Download source code from GitHub

Clone or download repository directly:
👉 **Front-end-Workshop-Failover**: https://github.com/quywork62/Front-end-Workshop-Failover-

**If using git:**
```bash
git clone https://github.com/quywork62/Front-end-Workshop-Failover-.git
```

**Or download ZIP file and extract.**

![GitHub](/images/7/1.png?featherlight=false&width=90pc)

#### 2. Create S3 Bucket

- Access **Amazon S3** → **Create bucket**
- Bucket name: ```api.turtleclouds.id.vn``` (Bucket name must exactly match the domain you will use to host the website)
- **Region**: select **ap-southeast-1 (Singapore)**
- Keep other default options → Choose **Create bucket**

![S3](/images/7/2.1.png?featherlight=false&width=90pc)

![S3](/images/7/3.png?featherlight=false&width=90pc)

![S3](/images/7/4.png?featherlight=false&width=90pc)
![Code](/images/7/5.png?featherlight=false&width=90pc)

#### 3. Edit API configuration

In the source code, find the main JavaScript file (e.g., in `index.html`) and edit:

```javascript
const apiUrl = 'https://api.<YOUR-DOMAIN>'; // Use Route 53 DNS name
---> const apiUrl = 'https://api.turtleclouds.id.vn/prod';  // Use Route 53 DNS name pointing to API Gateway
```

![S3](/images/7/2.png?featherlight=false&width=90pc)

{{%notice info%}}
**Note**: Ensure the API URL points to the domain configured in Route 53, not the regional domain names of API Gateway.
{{%/notice%}}

#### 4. Upload files to S3

- Go to bucket **api.turtleclouds.id.vn** → **Upload**
- Select all code files (HTML, CSS, JS, images) from the project folder
- Click **Upload**

![S3](/images/7/6.png?featherlight=false&width=90pc)
![S3](/images/7/7.png?featherlight=false&width=90pc)
![S3](/images/7/8.png?featherlight=false&width=90pc)

#### 5. Enable Static Website Hosting

- Go to bucket → **Properties** tab
- Scroll down to **Static website hosting** section → Choose **Edit**

![S3](/images/7/9.png?featherlight=false&width=90pc)
![S3](/images/7/10.png?featherlight=false&width=90pc)

**Configuration:**
- **Static website hosting**: **Enable**
- **Hosting type**: **Host a static website**
- **Index document**: ```index.html```
- Click **Save changes**

![S3](/images/7/11.png?featherlight=false&width=90pc)
![S3](/images/7/12.png?featherlight=false&width=90pc)

👉 After enabling, you will see the website endpoint provided by S3:
```
http://api.turtleclouds.id.vn.s3-website-ap-southeast-1.amazonaws.com
```

![S3](/images/7/13.png?featherlight=false&width=90pc)

#### 6. Configure Public Access Block

By default, S3 blocks public access. Need to disable it to allow website access:

- Go to bucket → **Permissions** tab
- **Block public access (bucket settings)** section → Choose **Edit**
- **Uncheck** "Block all public access"
- Choose **Save changes** → Confirm **Confirm**

![S3](/images/7/14.png?featherlight=false&width=90pc)
![S3](/images/7/15.png?featherlight=false&width=90pc)
![S3](/images/7/16.png?featherlight=false&width=90pc)
![S3](/images/7/17.png?featherlight=false&width=90pc)

{{%notice warning%}}
**Warning**: Only disable public access block for buckets containing static websites. Do not apply to buckets containing sensitive data.
{{%/notice%}}

#### 7. Configure Public Objects (Object ACLs)

**a. Enable ACLs in Object Ownership**

- Go to bucket → **Permissions** tab
- **Access controls list(ACLs)** section → **bucket owner enforced**

![S3](/images/7/18.png?featherlight=false&width=90pc)
![S3](/images/7/19.png?featherlight=false&width=90pc)

**Select:**
- **ACLs enabled**
- **Bucket owner preferred**
- Check "I acknowledge..."
- Click **Save changes**

![S3](/images/7/20.png?featherlight=false&width=90pc)
![S3](/images/7/21.png?featherlight=false&width=90pc)

👉 After that you will see status: **Object Ownership = Bucket owner preferred (ACLs enabled)**

**b. Make frontend files public**

- Go to **Objects** tab → Select all website files (HTML, CSS, JS, images)
- Click **Actions** → **Make public using ACL**
- Confirm with **Make public**

![S3](/images/7/22.png?featherlight=false&width=90pc)
![S3](/images/7/23.png?featherlight=false&width=90pc)
![S3](/images/7/24.png?featherlight=false&width=90pc)

👉 Now, static files are public and can be accessed directly via URL.

#### 8. Test Website

**Test Static Website Endpoint:**
```
http://api.turtleclouds.id.vn.s3-website-ap-southeast-1.amazonaws.com
```

**Test Direct S3 URL:**
```
https://s3.ap-southeast-1.amazonaws.com/api.turtleclouds.id.vn/index.html
```

![S3](/images/7/25.png?featherlight=false&width=90pc)

### Results

After completing this step:

- ✅ **S3 Bucket** created and configured
- ✅ **Static Website Hosting** enabled
- ✅ **Frontend Code** uploaded and made public
- ✅ **Website** accessible via S3 endpoint
- ✅ **API Integration** working with Route 53 domain

### Troubleshooting

**If website doesn't load:**
1. Check **Block public access** is disabled
2. Verify **Object ACLs** are set to public
3. Ensure **index.html** exists in bucket root

**If API calls fail:**
1. Check **CORS** configuration on API Gateway
2. Verify **Route 53** records have propagated
3. Test API endpoint directly with curl

### Preparation for Next Step

The frontend website is now ready to test the entire high availability architecture. You can test failover scenarios and monitor health checks from the user interface.