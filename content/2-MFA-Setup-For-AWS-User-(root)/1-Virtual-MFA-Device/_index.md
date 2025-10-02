---
title : "Enable Global Tables and Add Secondary Region"
date : "2025-01-27" 
weight : 1
chapter : false
pre : " <b> 2.1 </b> "
---

#### Amazon DynamoDB Global Tables

**Amazon DynamoDB Global Tables** is a feature that enables automatic multi-Region data replication. When you enable Global Tables, data written in one Region is automatically replicated to other Regions following a multi-active model (both Regions can read/write).

This helps applications achieve:

- **High Availability**: If one Region experiences an outage, the application can still access data from the remaining Region.
- **Disaster Recovery (DR)**: Ensures data is not interrupted and can be recovered quickly.
- **Global Performance**: Users in different regions can access data from the nearest Region to reduce latency.

In this lab, after creating the DynamoDB table in the primary Region (e.g., us-east-1), you will enable Global Tables to create a replica in the secondary Region (us-west-2). When completed, any changes to the table in one Region will be synchronized in near real-time to the table in the other Region.

### Step 2: Enable Global Tables and Add Secondary Region

#### 1. After completing the first step, next we will click on the newly created **HighAvailabilityTable**

![DynamoDB](/images/2/7.png?featherlight=false&width=90pc)

#### 2. In the newly created table, navigate to the **Global Tables** tab

![DynamoDB](/images/2/8.png?featherlight=false&width=90pc)

#### 3. Choose Create replica → select backup Region (e.g., Tokyo ap-northeast-1)

![DynamoDB](/images/2/9.png?featherlight=false&width=90pc)

#### 4. After creation, we will wait 3-5 minutes for resource initialization. Finally, when you see "Replica" change to Status **Active**, it is successful

![DynamoDB](/images/2/10.png?featherlight=false&width=90pc)
