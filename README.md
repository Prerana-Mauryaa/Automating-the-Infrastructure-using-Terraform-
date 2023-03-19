
# Automating Infrastructure using Terraform




Description:

Nowadays, infrastructure automation is critical. We tend to put the most emphasis on software development processes, but infrastructure deployment strategy is just as important. Infrastructure automation not only aids disaster recovery, but it also facilitates testing and development.

Your organization is adopting the DevOps methodology and in order to automate provisioning of infrastructure there's a need to setup a centralised server for Jenkins.

Terraform is a tool that allows you to provision various infrastructure components. Ansible is a platform for managing configurations and deploying applications. It means you'll use Terraform to build a virtual machine, for example, and then use Ansible to instal the necessary applications on that machine.
Considering the Organizational requirement you are asked to automate the infrastructure using Terraform first and install other required automation tools in it.

Tools required: 
---
Terraform, AWS account with security credentials, Keypair

Expected Deliverables:
---
Launch an EC2 instance using Terraform
Connect to the instance
           Install Jenkins, Java, and Python in the instance

                  Project By :-    Prerana Maurya






 
INTRODUCTION
---
For automating the infrastructure , the required softwares are Web Browser , AWS, IDE , and Terraform. For this project, I am working in an Ubuntu distribution  and using a Chrome web browser. 

Setting up Prerequisites
---


INSTALLATION OF TERRAFORM
---

Terraform is an open-source infrastructure-as-code software tool created by HashiCorp. Users define and provide data centre infrastructure using a declarative configuration language known as HashiCorp Configuration Language, or optionally JSON.

**STEP 1**  :- Update the machine

Update your system with the below command 

    sudo apt update -y
  
 
 **STEP 2** :-  Open terminal and install Terraform package

Ensure that your system is up to date, and you have the gnupg, software-properties-common, and curl packages installed. You will use these packages to verify HashiCorp's GPG signature, and install HashiCorp's Debian package repository. [U can prefer to the HashiCorp's official documentation]

**Use the below command** 

 wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor |         
 sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

 echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

Now  install the Terraform

Use the below command 
   
     sudo apt install -y terraform
  

**STEP 3**  :-  Verify the installation of Terraform 

Use the below command to verify the installation of Terraform.

     terraform --version
     which terraform
 




SETTING UP AWS
---


**STEP 1**  :- Login  to the AWS account using credentials 

Choose Sign in to the Console. If Create a new AWS account isn't visible, first choose Sign in to a different account, and then choose Create a new AWS account.
           

   


**STEP 2** :- Creating a new user for our project 
      Create a new user for  the project so that our credentials would be
      Secure .(After the completion of the project you can delete the user )
        
 Create a key pair by following the below steps :-

1.	Search for “IAM” and click the first result .
2.	Click on the “users” .
3.	Click on “add user” and name user  “terraform”.
4.	Attach the required permissions and download the credentials
( .csv  file) .


 
 




**STEP 3**  :- Creating a key pair for our project 

Create a key pair by following the below steps :-
1.	Click on “Create key pair”.
2.	Enter the name of key “Terraform_Automation”.
3.	Choose “RSA”.
4.	Choose “.pem”.
5.	Click on “Create key pair”.
 


WORKING WITH TERRAFORM
---

**STEP 1 ** :- Paste the private key in .ssh directory

For SSH we will need private key.  Steps to setup the private key for making it in use is as follows :-
1.	Go to  .ssh directory .

            cd .ssh
 
2.	Make a .pem file “Terraform_Automation.pem” using vi editor and paste the private key content.

                  vi  Terraform_Automation.pem
 


3.	The private key file on your local workstation should have permission set to 600 and .ssh directory should have permission set to 700.

        sudo chmod 600 Terraform_Automation.pem  
        sudo chmod 700 .ssh  

 

**STEP  2** :- Create a working directory

Create a directory for our project by using below command
         
            mkdir terraform_project

   


**STEP 3** :- Go to the project directory  

Go to the project directory “terraform_project” by using below command
         
         cd  terraform_project

 


**STEP  4** :- Create a inventory file 

Create a inventory file in project directory that stores the host ip address after terraform apply so that we can use it for ansible configuration.
           
            touch inventory
   


**STEP  5** :- Create a ansible configuration file

Create a ansible configuration file ansible.cfg that stores configuration related to ansible.

            vim ansible.cfg
 

   
**STEP 6**:- Create a ansible playbook “task.yml”  

In the project directory create a file task.yml . This file contains the YAML code for Jenkins setup.

         vi  task.yml

 
In task.yml
---

Ansible Playbook to Install Jenkins on Web Servers
---

 The playbook includes the following tasks:

Update the apt package cache

1. Install Java (OpenJDK 8)
2. Add the Jenkins repository to the system
3. Import the Jenkins GPG key
4. Install Jenkins using the apt package manager


**STEP 7**:- Create a terraform file main.tf 

In the project directory create a file main.tf . This file contains the terraform code to automate the infrastructure.

         vi  main.tf
   

In main.tf  file
---
The Terraform script creates a new security group in AWS with inbound and outbound rules allowing traffic on ports 22, 80, 443, and 8080. It also creates a new EC2 instance using the ami-00874d747dde814fa AMI and the t2.micro instance type. The instance is configured using Ansible playbook to install Python 2, default-jdk, and Jenkins. The IP address of the instance is stored in an inventory file for later Ansible configuration.



  
 



 
RUNNING TERRAFORM CODE 
---

**STEP  1** :- terraform init

Run terraform init command to initialize a existing terraform working directory.

            terraform init

 

**STEP  2**:- terraform validate

Run terraform validate command to check the configuration is valid or not.

            terraform validate

 

**STEP  3**  :- terraform plan

Run terraform plan  command to create an execution plan. 

            terraform plan
 



 
 
 

 
 
 


 



**STEP 4**:- terraform apply

Run terraform apply command to apply the changes specified in the terraform configuration to the infrastructure.

         terraform apply

 





 
VERIFYING THE CONFIGURATION 
---


**STEP 1**:- connect the instance using SSH  

Connect the ec2 instance using SSH connection in the local machine.

      ssh -i "/home/ubuntu/.ssh/Terraform_Automation.pem" ubuntu@ec2-18-210-10-7.compute-1.amazonaws.com



 


 
**STEP 2**:- verifying of packages that are installed 

   1. JAVA

           java  --version                
           which java

 
  

2.	PYTHON

            python2 --version
            which python2

 


3.	  JENKINS

            jenkins  --version
            which jenkins

 



**STEP 2**:- checking the status of jenkins

         sudo systemctl status Jenkins

  

**STEP 2**:- Access Jenkins and continue with the installation 

Find the public IP from AWS EC2 instance

 
Go to chrome and enter the below command
          http://ec2-18-210-10-7.compute-1.amazonaws.com:8080/

 
Go back to the terminal and enter the following command
         
         sudo cat /var/lib/jenkins/secrets/initialAdminPassword

  

Copy the  password and enter it in Jenkins to continue 


Now select “install suggested plugins”

Enter your information in the next screen to continue.

 

Click Save and Finish.
     

You are all set! Congratulations!
---


 

