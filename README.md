# AWS CI/CD Pipeline with Jenkins, CodeDeploy, and Auto Scaling

## Problem Statement

Set up a CI/CD pipeline that:

1.  Deploys a simple web application (Node.js) to an EC2 instance on a code push to a GitHub repository.
2.  Ensures the deployed web application is accessible via a web browser.
3.  Scales automatically based on traffic load, ensuring all new instances have the updated code.

**Tools:**

-   Jenkins
-   AWS EC2
-   AWS CodeDeploy
-   GitHub

## Solution Overview

This project sets up a fully automated CI/CD pipeline using Jenkins for continuous integration, AWS CodeDeploy for deployment, and an auto-scaling group (ASG) for dynamic scalability. When code is pushed to the GitHub repository, Jenkins triggers the build, stores the artifacts in an S3 bucket, and deploys them using AWS CodeDeploy. The infrastructure is scalable, using an auto-scaling group, ensuring that new EC2 instances are automatically configured with the latest deployment.

## Steps to Implement

### Step 1: Set Up Jenkins on EC2

1.  **Launch Jenkins EC2 instance:**
    
    -   Create an EC2 instance with a public IP to host Jenkins.
    -   SSH into the instance and install Jenkins.
    -   Ensure inbound rules allow access to port `8080` so Jenkins UI is accessible in the browser.
    
2.  **Configure IAM Role for Jenkins EC2 instance:**
    
    -   Attach an IAM role to the EC2 instance granting **S3 Full Access** to allow Jenkins to store build artifacts in an S3 bucket.
3.  **Set up GitHub repository:**
    
    -   Create a GitHub repository and add your Node.js web application.
    -   Write a `Jenkinsfile` in the repository to define the pipeline steps:
        -   Install dependencies
        -   Build the application
        -   Store artifacts in S3

### Step 2: Create AWS CodeDeploy Agent and Configure Auto Scaling

1.  **Launch EC2 Instance for CodeDeploy:**
    
    -   Launch a separate EC2 instance (this will act as the web server where the application is deployed).
    -   Install the **CodeDeploy agent** on the instance and configure it to connect to AWS CodeDeploy.
    
2.  **Create an AMI (Amazon Machine Image):**
    
    -   After setting up CodeDeploy on the instance, create an AMI of the instance to use in your **Launch Template**.
3.  **Create Launch Template and Auto Scaling Group (ASG):**
    
    -   Create a **Launch Template** using the AMI.
    -   Set up an **Auto Scaling Group** (ASG) to manage the scaling of EC2 instances based on load.
    -   This ensures that each new EC2 instance launched by the ASG automatically has the CodeDeploy agent installed.

### Step 3: Create CodeDeploy Application and Deployment Group

1.  **Create CodeDeploy Application:**
    
    -   In AWS CodeDeploy, create a new **application** for deploying the Node.js web app.
    -   Set up a **Deployment Group** that uses the EC2 instances created by your ASG.
2.  **Configure AWS CodeDeploy:**
    
    -   In the Deployment Group, specify the EC2 instances that should receive the deployment.
    -   Set up the **AppSpec** file in your GitHub repository to define how the application should be deployed on the server.

### Step 4: Jenkins and GitHub Integration for CodeDeploy

1.  **Install AWS CodeDeploy Plugin in Jenkins:**
    
    -   Go to **Jenkins > Manage Jenkins > Plugins** and install the **AWS CodeDeploy plugin**.
    -   Configure Jenkins to trigger AWS CodeDeploy whenever there’s a new build.
2.  **Configure Jenkins Pipeline:**
    
    -   Modify the `Jenkinsfile` to include steps for deploying to AWS CodeDeploy:
        -   Push build artifacts to S3.
        -   Trigger CodeDeploy to deploy the new version from S3 to the EC2 instances.
  
### Challenges Faced

1.  **IAM Role Permissions Issues**:  
    Initially, there were issues with Jenkins not being able to access S3. This was resolved by updating the IAM role for the Jenkins EC2 instance to grant full access to S3.
    
2.  **Auto Scaling Group Configuration**:  
    Ensuring that new EC2 instances launched by the auto-scaling group had the latest CodeDeploy agent was tricky. This was solved by creating an AMI with CodeDeploy pre-installed and using it in the Launch Template.
    
3.  **GitHub Webhook for Jenkins**:  
    Setting up the GitHub webhook to trigger Jenkins builds on a commit push had some challenges due to network configurations. I had to make sure that Jenkins was publicly accessible and that the security groups allowed the necessary inbound traffic.
    

----------

## Conclusion

This project successfully demonstrates how to set up a CI/CD pipeline using Jenkins, AWS EC2, and AWS CodeDeploy to automatically build, deploy, and scale a Node.js web application. The integration of auto-scaling ensures that the application can handle varying levels of traffic, while AWS CodeDeploy ensures that new instances are automatically updated with the latest version of the application.

----------