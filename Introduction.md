# Global DevOps Bootcamp - DevOps Challenges #

This repository is a customization of the default one provided by the [Global DevOps Bootcamp](http://globaldevopsbootcamp.com/) for the local run in Quebec city, Canada.

Remark: mainly, we took the "extended/step-by-step" version and we removed the concept of teams and scores. The local organizers thought this more efficient this way.

## Context ##
You are part of a DevOps team within a Music Company called Musicamente. You currently have a website which is (to be quite frank) a bit monolithic. Your DevOps team has just visited a bootcamp and is inspired and responsible for moving the monolithic website to a higher level. 

## Goal of the DevOps Challenges ##
Musicamente wants to be able to deliver new features faster, with zero-downtime in a reliable and continuous manner. They also want to move from their on-premises environment to a native cloud platform. As an extra they want their marketing department to be in control over their functional releases, have telemetry around their platform and application, and scale easily. Of course, in an Agile way where Development and Operations work closely together.

## Challenge \#1 - Moving to the cloud ##
Musicamente currently hosts their application on-premises. They face all kinds of issues with performance, availability and support. Together with the architect the decision has been made to move to the Azure cloud.

See details about the [Challenge 1](./Challenge1/Challenge1.md)

## Challenge \#2 - Moving to containers ##
The management of Musicamente has just visited a Gartner conference. They learned about cloud tehcnology and came to the conclusion that running a website on PaaS (Azure WebApp) might result in a vendor lock-in. For the website they want to be able to be cloud-agnostic and switch between different clouds or even back to on-premises. 

After investigation of the team the decision is made to run the Web Application in a Docker container. 

In this challenge, you will move the web site to a Docker container. After you have created and tested the image locally, you will set up an Azure Container Registry and use the build pipeline to build and publish the image to this registry. Finally you will publish the container to an already created Azure Container Service cluster using the Kubernetes user interface.

When you succesfully completed the challenge, your Azure Website runs in a Docker container on a cluster, that uses SQL Azure.

See details about the [Challenge 2](./Challenge2/Challenge2.md)

## Challenge \#3 - Moving to serverless ##
Musicamente wants to make the User Experience better by sending SMS verification after checking out the shopping cart. At this moment there is no capacity of hsoting a service like this in-house. Important requirement from the business is that they only want to pay for this feature if it is really used. 

After some investigation, an Azure Function can do the trick to fulfill this requirement

In this challenge, you will create a new Azure Serverless Function, and make this a part of your application. The function should take care of sending a Mail or SMS (look at Twilio) confirmation after you have placed an order. First you will write a simple Azure Function that you will expose publicly. Then you will create an ARM template to create the neccessary resources and publish the function from the pipeline. Update your website or service (or both) to use this Azure Function and publish the update with the pipelines.

See details about the [Challenge 3](./Challenge3/Challenge3.md)