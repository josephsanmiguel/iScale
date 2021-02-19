Steps in Containerization:

Login to the Public Ip
  ssh -i Test.pem ec2-user@54.252.233.36

Create a Cluster

ECS Amazon Linux 2 (ECS Optimized)
  cat /etc/ecs/ecs.config

If you want to Check what's running Type:
  docker ps
Optional If you want to check the logs:
  docker logs <container id>

Task Definition - tells you how to run it in JSON Format.

Create a task definition
    my-task definition

Create container
    my-container-httpd

Login to Docker Hub To view:
    https://hub.docker.com/_/httpd

    httpd:2.4

Type host port:
    8080
Container port:80

Click Add

Click Create. 

You will see that there's 1 task definition

Choose the JSON tab to see the JSON format

ECS Services help define how many tasks should run and how they should run.

Click on Cluster.

Choose the Cluster-Demo.

Create a service

Launch Type: 
  Ec2
Task Definition: 
  my-taskdefinition
Cluster: 
  cluster-demo
Service Name: 
  httpd-service
Service Type Replica (It depends on how many is required):
number of tasks:
  1
Minimum healthy percent:
  0
Click on Next.
Click on Next.
Then Create Service.
View Service.

Get public IP.
Then Go to Edit the inbound and add:
  Custom TCP 8080 From Anywhere Allow HTTPD

Type the public ip of the Ec2Container Service Instance
http://54.252.233.36:8080/

It will show you that it works!

Edit the task Definition and Increase the number of tasks. 
But it will not work. 

####################################################################################################################################
Bonus points if you are able to containerize this environment and deploy it to a AWS Container Orchestration Service (ECS/EKS)
####################################################################################################################################

Here's the Workaround:
If you want to Scale your cluster, Go to Cluster Demo and  go to ECS Instance.
Then click:
  Scale EC2 Instance,(Place a number that is required).
This is a good wayt to scale and automate via containeriation.

Please Note: I have remove and Terminate everything as it may AWS might bill me already.
