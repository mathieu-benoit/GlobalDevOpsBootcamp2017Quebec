# Global DevOps Bootcamp - DevOps Challenges #

Great! You've made it to the DevOps Challenges. This is where the real fun starts. Together with your group you are facing 3 challenges, that each can earn you points. You are competing with the other teams to create the most beautiful, complete, well-architected and DevOpsed solution to these challenges. 

Besided the challenges, there are also some Bonus Goals you can do, which will gain you even more points!

Summarized, this is what you are going to do!

* Create a group of 3-5 people
* Read the challenges
* Divide the work amongst your group. It is highly recommended to finish a challenge together, before picking up a new one.
* Create a 5 minute demo presentation, highlighting the solution you created

## Context ##
Your group is a DevOps team within a Music Company called Musicamente. You currently have a website which is (to be quite frank) a bit monolithic. Your DevOps team has just visited a bootcamp and is inspired and responsible for moving the monolithic website to a higher level. 

## Goal of the DevOps Challenges ##
Musicamente wants to be able to deliver new features faster, with zero-downtime in a reliable and continuous manner. They also want to move from their on-premises environment to a native cloud platform. As an extra they want their marketing department to be in control over their functional releases, have telemetry around their platform and application, and scale easily. Of course, in an Agile way where Development and Operations work closely together.

## Content ##
* [Challenge \#1 - Moving to the cloud](#Challenge-#1---Moving-to-the-cloud)
* [Challenge \#2 - Moving to containers](#Challenge-#2---Moving-to-containers)
* [Challenge \#3 - Moving to serverless](#Challenge-#3---Moving-to-serverless)
* [Extra Bonuses](#Extra-Bonuses)

## Challenge \#1 - Moving to the cloud ##
Musicamente currently hosts their application on-premises. They face all kinds of issues with performance, availability and support. Together with the architect the decision has been made to move to the Azure cloud.

In this challenge, you will move the current monolith application towards the cloud. The local SQL Server should be replaced with a SQL Azure Database, and the website should be converted to a PaaS Web App on Azure. The deployment of this website should be done with an automated build and pipeline using Visual Studio Team Services.

### Challenge \#1 - Achievements ### 

| # | Achievement   | Maximum score |
|---|---------------|---------------|
|1| Configure a build agent|50|
|2| Create the server environment|100|
|3| Update the application to use the Azure SQL database | 50 |
|4| Set up a build pipeline that builds the web application in to a MSDeploy package | 50 |
|5| Set up a release pipeline that publishes the application to production | 50 |
|6| Deploy a change in the website with Continuous Deployment | 50 | 

### Challenge \#1 - Bonus Goals ###

| # | Bonus Goal   | Maximum score |
|---|---------------|---------------|
|1| Add an extra stage to the release pipeline that uses a deployment slot|50|
|2| Create a backlog with work and a task board with tasks|50|
|3| Set up some usage counters with Application Insights in the website|100|
|4| Create a feature toggle that "reveals" new functionality|100|
|5| Use configuration to inject the connection string for the application during deployment|50|
|6| Use an ARM template to configure and deploy the website and database in Azure|100|
|7| Use approvers to create a controlled deployment pipeline|50|
|8| Set up automatic scaling for your Azure Web App from the portal, create a load test to prove it works |150 |

## Challenge \#2 - Moving to containers ##
The management of Musicamente has just visited a Gartner conference. They learned about cloud tehcnology and came to the conclusion that running a website on PaaS (Azure WebApp) might result in a vendor lock-in. For the website they want to be able to be cloud-agnostic and switch between different clouds or even back to on-premises. 

After investigation of the team the decision is made to run the Web Application in a Docker container. 

In this challenge, you will move the web site to a Docker container. After you have created and tested the image locally, you will set up an Azure Container Registry and use the build pipeline to build and publish the image to this registry. Finally you will publish the container to an already created Azure Container Service cluster using the Kubernetes user interface.

When you succesfully completed the challenge, your Azure Website runs in a Docker container on a cluster, that uses SQL Azure.

### Challenge \#2 - Achievements ### 

|#| Achievement   | Maximum score |
|---|---------------|:---------------:|
|1| Configure a build agent | 100 |
|2| Create a Dockerfile and build a local Docker image with the webapplication installed | 100 |
|3| Set up an Azure Container Registry | 50 |
|4| Create a build definition for your containerized application | 100 |
|5| Set up a release pipeline that consumes the container from your Azure Container Registry | 150 |

### Challenge \#2 - Bonus Goals ###
| # | Bonus Goal | Maximum Score |
|---|---------------|:---------------:|
| 1 | Containerize SQL server and connect it to the webapplication container (with docker compose) | 50 |
| 2 | Deploy your image from a release pipeline to the Kubernetes cluster  | 50 |
| 3 | Incorporate (a few) unit tests and run them from the build | 50 |
| 4 | Clean-up environment after release | 25 |
| 5 | Make sure pipeline can deploy if the previous release failed | 25 |
| 6 | Setup continuous deployments | 25 |
| 7 | Add an additional environment | 25 |
| 8 | Integrate UI tests (Selenium or CodedUI) | 50 |
| 9 | Setup and Use Kubernetes  to run your container and let your Azure WebApp website use this. | 250 | 

## Challenge \#3 - Moving to serverless ##
Musicamente wants to make the User Experience better by sending SMS verification after checking out the shopping cart. At this moment there is no capacity of hsoting a service like this in-house. Important requirement from the business is that they only want to pay for this feature if it is really used. 

After some investigation, an Azure Function can do the trick to fulfill this requirement

In this challenge, you will create a new Azure Serverless Function, and make this a part of your application. The function should take care of sending a Mail or SMS (look at Twilio) confirmation after you have placed an order. First you will write a simple Azure Function that you will expose publicly. Then you will create an ARM template to create the neccessary resources and publish the function from the pipeline. Update your website or service (or both) to use this Azure Function and publish the update with the pipelines.

### Challenge \#3 - Achievements ### 

|#| Achievement   | Maximum score |
|---|---------------|:---------------:|
| 1 | Create an Azure Function and expose the functionality | 100 |
| 2 | Update your website to use the service and show data in the UI | 50 |
| 3 | Create an ARM template and package to publish your Azure Function + Infra  automatically| 150 |
| 4 | Create a release pipeline for your Azure Function | 100 |
| 5 | Publish all updates automatically | 50 | 

#### Challenge \#3 - Bonus Goals ####
| # | Bonus Goal | Maximum Score |
|-----------|-------| --------------|
| 1 | Add API Management to version your Serverless function | 150 |

## Extra Bonuses ##
A few extra bonuses can be earned if applied to the Challenges.

| Challenge | Bonus | Maximum Score |
|-----------|-------| --------------|
| Any | Create a backlog with work and a task board with tasks | 25 |
| Any | Set up some usage counters with Application Insights in the website | 50 |
| Any | Create a feature toggle that "reveals" new functionality | 50 |