---
title : "Using Cloudflare for Domain Management"
date : "2025-01-27"
weight : 3
chapter : false
pre : " <b> 1.3 </b> "
---

After pointing the domain turtleclouds.id.vn to the hosting IP address on DataOnline, the next step is to use Cloudflare to manage and optimize the domain. Cloudflare acts as an intermediary layer between users and the server, helping to increase access speed through a global CDN system, while enhancing security with firewall and DDoS attack protection. First, you need to create a free account at dash.cloudflare.com and add the domain turtleclouds.id.vn to the system. Cloudflare will automatically scan and import existing DNS records, while providing you with two new Nameservers.

### Content

1. [Log in to Cloudflare and enter domain](#step-1-log-in-to-cloudflare-and-enter-the-registered-domain-here-for-example-turtlecloudsidvn)
2. [Configure DNS Records](#step-2-go-to-the-control-panel-select-dns-then-select-records-next-choose-add-records-to-add-2-records)
3. [Update Nameserver at tenten.vn](#step-3-update-nameserver-at-tentenvn)
4. [Final verification](#step-4-final-verification-step)

#### Step 1: Log in to Cloudflare and enter the registered domain, here for example turtleclouds.id.vn

![Create Account](/images/1.3/1.png?featherlight=false&width=90pc)

#### Step 2: Go to the control panel, select **DNS** then select **Records**. Next, choose **Add records** to add 2 records

![Create Account](/images/1.3/2.png?featherlight=false&width=90pc)

![Create Account](/images/1.3/3.png?featherlight=false&width=90pc)

#### Step 3: Update Nameserver at tenten.vn

- Next, you log in to the domain management page at **tenten.vn**, find the **Nameserver Management** section and change the default **Nameservers** to the two addresses that **Cloudflare** just provided. Save the changes and wait for the system to update.

![Create Account](/images/1.3/4.png?featherlight=false&width=90pc)

- Go to **Actions** then select **NS Settings**

![Create Account](/images/1.3/5.png?featherlight=false&width=90pc)

#### Replace the 2 NS records of tenten.vn with the 2 NS records of **Cloudflare** and click **Update**

![Create Account](/images/1.3/6.png?featherlight=false&width=90pc)

![Create Account](/images/1.3/7.png?featherlight=false&width=90pc)

#### Step 4: Final verification step

- After configuring **Nameserver** at **tenten.vn** and completing **DNS** setup on **Cloudflare**, open **Command Prompt** or **PowerShell** on your computer and use the command:

```
ping turtleclouds.id.vn
```

#### Result

![Create Account](/images/1.3/9.png?featherlight=false&width=90pc)
