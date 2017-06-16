# DevOps Challenge \#2 #

In this challenge, you will move the ASP.NET application to a Docker container. 
After you have created and tested the image locally, you will set up an Azure Container Registry and use the build pipeline
to build and publish the image to this registry.
Finally you will publish the container to an already created Azure Container Service cluster using the Kubernetes user interface.

When you succesfully completed the challenge, your webapplication is running in a Docker container on a cluster.

## Content ##
* [Pre-requisites](#pre-requisites)
* [Getting started](#getting-started)
* [Achievements](#achievements)
* [Bonus Goals](#bonus-goals)
* [Resources](#resources)

## Pre-requisites ##
*   Pipeline per team
*   Visual Studio 2017 Enterprise (with the Coded UI test component)
*   Docker for Windows [installed](https://download.docker.com/win/stable/InstallDocker.msi) 
*   Azure Subscription
*   Team Project for venue with git repo per challenge team; VSTS account per participant
*   Participants need administrator role on the Default Agent Pool (to be able to install a local build agent)
*   Participants need administrator rights to add new service end-points in VSTS 
*   Azure Database for ASP.NET Music Store (created in Challenge 1)
*   Docker Integration VSTS extension from the Azure Marketplace
*   Base Docker image downloaded (already pulled for you) for achievements  ```docker pull microsoft/aspnet```

## Getting started ##
* [Verify the Docker installation and explore the application](https://docs.docker.com/docker-for-windows/#check-versions-of-docker-engine-compose-and-machine)
* Clone the started code from [https://github.com/GlobalDevOpsBootcamp/challenge1](https://github.com/GlobalDevOpsBootcamp/challenge1) to your VSTS project as described in challenge1
* Download for challenge 2: [Dockerfile](./Dockerfile) + [associated Provisioning/docker folder](./Provisioning/Docker) and nested files.  

## Achievements ##
|#| Achievement   |
|---|---------------|
|1| Configure a build agent |
|2| Create a Dockerfile and build a local Docker image with the webapplication installed |
|3| Set up an Azure Container Registry |
|4| Create a build definition for your containerized application |
|5| Set up a release pipeline that consumes the container from your Azure Container Registry |

## Bonus Goals ##
|#| Bonus Goal   |
|---|---------------|
|1| Containerize SQL server and connect it to the webapplication container (with docker compose) |
|2| Incorporate unit tests |
|3| Clean-up environment after release |
|4| Make sure pipeline can deploy if the previous release failed |
|5| Setup continuous deployments |
|6| Add an additional environment |
|7| Integrate Coded tests |
|8| Setup and Use Kubernetes to run your container and let your Azure WebApp website use this. |

## Achievement \#1 - Configure a build agent ##

### Download a build agent ###
* Navigate to your VSTS environment
* Login with the provided GDBC account
* Goto VSTS administration functionalities by clicking on the gear icon
* Goto Agent queues and select default queue
* Click on Download Agent and download the agent
* Create folder on local machine C:\VSTSAgent
* Extract the files from the downloaded agent zip to this folder

### Generate a PAT token (required when installing a build agent) ###
* Click on your profile icon in VSTS
* Click on Security
* Choose to add a new PAT token to your list of Personal Access Tokens and select the correct scopes (Agent Pools (read, manage), Build (read and execute), Code (read and write))
* Make sure that you copy the token that has been generated!!!!

### Install a local build agent on your Azure VM ###
* Run C:\VSTSAgent\config.cmd from a command prompt with administrator privileges
* Enter server URL: https://[....].visualstudio.com
* Press enter for PAT a authentication type
* Copy-paste the previously generated PAT token when asked to Enter personal access token and press enter
* Press enter for default agent pool
* Enter GDBC-challenge2 as the agent name and press enter
* Press enter for default work folder
* Choose N to run the agent as a service (agent will run in interactive mode for demo purposes)
* Press enter for the default network service account
* After configuration is complete you have to use the ```run``` command to start the agent

Achievement Unlocked. Your are now a Build Agent Installation Guru!

## Achievement \#2 - Create a Dockerfile and build a local Docker image with the webapplication installed ##
### What do we need to rollout an ASP.NET website to a windows docker container? ###

To run an ASP.NET 4.X website you need the following things:

*   The Operating system with IIS installed
*   ASP.NET 4.X installed
*   Webdeploy installed

### Building the container with IIS, ASP.NET and Webdeploy ###
* Get the file named [Dockerfile](./Dockerfile) (without extension)

### Create publishing profile for web application ###
* In Visual Studio right click the MvcMusicStore project
* Select Publish
* Select Create new profile
* Select IIS, FTP, etc. --> OK
* Select Webdeploy package as Publish method
* Package location c:\temp\MvcMusicStore.zip
* Sitename Default Web Site
* Save the profile
* Select CustomProfile and click Publish

### Create image and run localy ###
* Copy docker file to c:\temp
* Copy fixAcls.ps1 to c:\temp from the MvcMusic store repo folder: Provisioning\Docker
* Copy WebDeploy_2_10_amd64_en-US.msi to c:\temp from the MvcMusic store repo folder: Provisioning\Docker
* Open PowerShell command prompt and execute:

```
    docker build . -t mycontainerizedwebsite
    docker run -p 80:80 -d --name mvcmusicstore mycontainerizedwebsite
    docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' mvcmusicstore

```
* Use the returned IP address to navigate to the website in your browser
* To stop the container
```
    docker stop mvcmusicstore
    docker rm mvcmusicstore
```
Congratulations! You are now a Local Docker Hero!!! Achievement unlocked.

## Achievement \#3 - Set up an Azure Container Registry ##
* Navigate to the Azure Portal of your Azure Subscription
* Navigate to the Container Registries service
* Click on Add to add a Azure Container Registry
* Enter a name for the registry in the following format: <VENUENAME><TEAMNAME>
* Click on Create

* Copy the login server name from the overview page of your Container Registry (eg. <VENUENAME><TEAMNAME>.azurecr.io) for later use

* Navigate to the access keys of your Container Registry and enable admin user
* Copy the user name and password2

You can now perform your most craziest dance to celebrate that you are a Azure Container Registry Creation Master. Achievement unlocked.

## Achievement \#4 - Create a build definition for your containerized application ##
* Navigate to your VSTS environment and select Builds
* Create a new Build
* Select Visual Studio template
* Select the right git repository and branch (the venue repo for your team) in the Get Sources step of your Build process
* Remove the last two tasks from the process (Copy Files and Publish Build Artifacts)

### Change task: Build solution **\*.sln (to publish a WebDeploy package on build)
* Click on the Build solution **\*.sln task
* Change the build to ```/p:DeployOnBuild=true;PublishProfile=CustomProfile /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true /p:PackageLocation="$(build.stagingDirectory)/Provisioning/Docker"```

### Add task: copy Dockerfile to staging directory
* Add a Copy Files task below the Index Sources & Publish Symbols task
* Change Contents to ```Dockerfile```
* Change Target Folder to ```$(build.stagingDirectory)/Provisioning/Docker```

### Add task: copy additional Files to staging directory
* Add another Copy Files task below the first Copy Files task
* Change source folder to ```Provisioning/docker```
* Change contents to ```**```
* Change target folder to ```$(build.stagingDirectory)/Provisioning/Docker```

### Create ImageName variable
* Navigate to the Variables tab
* Add a new variabele with the name ```ImageName```
* Set the value to ```<VENUENAME><TEAMNAME>.azurecr.io/mvcmusicstore:$(Build.BuildId)``` (for example ```hilversumteam0001.azurecr.io/mvc-music-store:$(Build.BuildId)```)

### Add task: Build an image
* Add a Docker task (the one with the whale icon)
* Change action to ```Build an image```
* Change Docker File to ```$(build.stagingDirectory)/Provisioning/Docker/Dockerfile```
* Change Build Context to ```$(build.stagingDirectory)/Provisioning/Docker```
* Change Image Name to ```$(ImageName)```
* Check the Include Latest Tag checkbox

### Add task: Push an image ###
* Add another Docker task (the one with the whale icon again)
* Click the gear icon behind the Docker Registry connection dropdown to add the previously created Azure Container Registry (<VENUE><TEAMNAME>ContainerRegistry) as service end-point
    - Select Docker Registry as Service Endpoint type
    - Enter <VENUENAME><TEAMNAME>ContainerRegistry as connection name
    - Enter the login server name from Achievement 3 in the field Docker Registry value
    - Enter the user name and password from Achievement 3 in the fields Docker ID and Password
    - Enter a value in the email field
* Select the created Registry end-point as Docker Registry Connection in the dropdown
* Change action to ```Push an image```
* Change Image Name to ```$(ImageName)```
* Check the Include Latest Tag checkbox

### Add task: Publish artifact: MvcMusicStore
*even though we are publishing a docker image to our Azure container registry we also need to publish an artifact to VSTS so the release definition can be linked to this artifcat. This is required to access information about this build during the release*
* Add a Publish Artifact task
* Change Path to Publish to: ```$(build.stagingDirectory)```
* Change Artifact name to: ```MvcMusicStore```
* Change Artifact type to: ```Server```

## Achievement \#5 - Set up a release pipeline that consumes the container from your Azure Container Registry
* Navigate to your VSTS environment and select Builds
* Create a new Release definition
* Use the previously created build definition as Sources
* Rename your environment (for example to Test)

### Create ImageName variable
* Navigate to the Variables tab
* Add a new variabele with the name ```ImageName```
* Set the value to ```<VENUENAME><TEAMNAME>.azurecr.io/mvcmusicstore:$(Build.BuildId)``` (for example ```hilversumteam0001.azurecr.io/mvc-music-store:$(Build.BuildId)```)

### Create ContainerName variable
* Navigate to the Variables tab
* Add a new variabele with the name ```ContainerName```
* Set the value to ```mvcmusicstore```

### Add task: Run an image
* Add a Docker task (the one with the whale icon)
* Change Docker Registry Connection to you previously registry endpoint (for example: HilversumTeam0001ContainerRegistry)
* Change action to ```Run an image```
* Change Image Name to ```$(ImageName)```
* Change Container Name to ```$(ContainerName)```
* Change Ports to ```80:80```

### Add task: Manual Intervention
* Add a server phase 
* Add a Manual Intervention task
* Change instructions to:
```
Logon to the agent
docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' mvcmusicstore

Use the returned IP address to navigate to the website in your browser
```

### Add task: Run a Docker command (stop container)
* Add another Agent phase
* Add a Docker task (the one with the whale icon)
* Change the name of the task to: ```Run a Docker command (stop container)```
* Change action to ```Run a Docker command```
* Change command to ```rm $(ContainerName)```

### Add task: Run a Docker command (remove container)
* Change the name of the task to: ```Run a Docker command (stop container)```
* Add a Docker task (the one with the whale icon)
* Change action to ```Run a Docker command```
* Change command to ```stop $(ContainerName)```

### Run both Agent phases on the default queue
* Select each Agent phase (```Run on agent```)
* Change Deployment queue to ```Default```
* Under Additional options check ```Skip artifacts download```
*We don't actually need the artifacts, but we do need the information that is provided by linking the artifacts to the release*

## Bonus Goal \#6 - Deploy the application to Kubernetes##
Setup and Use Kubernetes  to run your container and let your Azure WebApp website use this.

### What do we need to rollout an ASP.NET website to a windows docker container? ###

When you run an ASP.NET 4.X website then you need the following things:

*   The Operating system with IIS installed
*   ASP.NET 4.X installed
*   Webdeploy installed

### Building the container with IIS, ASP.NET and Webdeploy ###

Here are the steps you need to take to create a docker container that has all these required ingredients:

Fist we need a basic operating system image from docker hub. For this we already got the image for you (take long time) that you can check this with the following command:

**docker images**

This should output something similar to the following screenshot:

[![image](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/08/image_thumb.png?resize=676%2C122 "image")](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/08/image.png)

Now we can start adding the first layer and that is installing IIS. For this you can use the **dism** command on windows and pass it in the arguments to install the IIS webserver role to windows server core. You can do this at an interactive prompt or use the docker **build** command. I prefer the later and for this we create a dockerfile that contains the following statements:

**FROM microsoft/windowsservercore   

RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart**

After saving the file under the name dockerfile without any extensions you run a command line to build the image:

**docker build -t windowsserveriis .**

The command tells docker to build an image, give it the tag windowsserveriis and use the current folder (denoted with the dot) as the context to build the image. this means that everything stated in the dockerfile is relative to that context. Note that you are only allowed to use lowercase characters for the tagename.

After running the command you now have a new docker image with the name **windowsserveriis**

If you now run the command:

**docker images**

you will see the new image available

[![image](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/08/image_thumb-1.png?resize=676%2C122 "image")](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/08/image-1.png)

We can take the next step and that is to install ASP.NET 4.5

We can do this in a similar way, by creating a docker file with the following commands:

**FROM windowsserveriis
**RUN  dism /online /enable-feature /featurename:IIS-ASPNET45****

**

and again after saving the file you can run the command line to build the image:

**docker build –t windowsserveriisaspnet .**

Now we have an image that is capable of running an ASP.NET application. The next step is that we need webdepoy to be installed in the container. For this we need to download the installer for webdeploy and then issue an command that will install and wait for the installation to finish. We first download the installer in the same folder as the dockerfile and then we will add it to the image. In the following steps I assume you already downloaded the MSI (WebDeploy_2_10_amd64_en-US.msi) and have it in the same folder as the dockerfile. When installing the msi we will use msiexec and need to start a process that we can wait on to be done. If we would only run msiexec, then this command returns and runs in the background, making the container to exit, leaving us in an undefined state.

When you create the following dockerfile, you install webdeploy:

**FROM windowsserveriisaspnet**

**RUN mkdir c:\install**

**ADD WebDeploy_2_10_amd64_en-US.msi /install/WebDeploy_2_10_amd64_en-US.msi**

**WORKDIR /install**

**RUN powershell start-Process msiexec.exe -ArgumentList '/i c:\install\WebDeploy_2_10_amd64_en-US.msi /qn' -Wait**



Note that we are using powershell start-process with the –wait option, so we wait for the installation to finish, before we commit the new layer.

Now run the docker command again to build the image using the new dockerfile:

**docker build –t windowsserveriisaspnetwebdeploy .**

Now we have an image that is capable to host our website in IIS and use webdeploy to install our website.

### Doing it all in one dockerfile ###

In the previous steps we created a new docker file for each step. But it is probably better to do this in one file, batching all commands together leaving you with the same endstate. We can also optimize the process a bit, since Microsoft already provides an image called microsoft/iis that has the iis feature enabled. This means we can use that image as the base layer and skip the install of IIS.

The simplified docker file looks as follows:

**FROM microsoft/iis  
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart  
RUN mkdir c:\install  
ADD WebDeploy_2_10_amd64_en-US.msi /install/WebDeploy_2_10_amd64_en-US.msi  
WORKDIR /install  
RUN powershell start-Process msiexec.exe -ArgumentList '/i c:\install\WebDeploy_2_10_amd64_en-US.msi /qn' -Wait**

Now again we run the docker build command to get the docker image capable of running our website and use the webdeploy packages that can be produced by a standard ASP.NET build procedure.

**docker build –t windowsserveriisaspnetwebdeploy .**

The final step is to deploy your webdeploy package to the image.

### Getting the webdeploy package ###

Now before we can deploy our website we need to get the webdeploy package.

I assume you have a standard ASP.NET web project in Visual Studio. In this case you can very easily create the deploy package inside Visual Studio (in the next post I show you how to do this using VSTS/TFS builds)

When you right click the Visual Studio project you can select the publish option:

[![image](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb.png?resize=676%2C388 "image")](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image.png)

After selecting publish you will see the following dialog:

[![image](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-1.png?resize=676%2C536 "image")](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-1.png)

In order to just create a package in stead of deploying to a server or Azure, I select Custom

[![image](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-2.png?resize=676%2C534 "image")](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-2.png)

then you give the profile a name, in my case dockerdeploydemo

[![image](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-3.png?resize=676%2C533 "image")](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-3.png)

then we select web deploy package from the dropdown and provide the required information, package location and the name of the website

[![image](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-4.png?resize=676%2C539 "image")](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-4.png)

next you can setup any database connections if you have any, in my case I have no database

[![image](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-5.png?resize=676%2C533 "image")](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-5.png)

next, click publish and you will find the resulting deployment package and accompanying deployment files in the c:\temp folder

[![image](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-6.png?resize=676%2C136 "image")](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-6.png)

Now that we have the webdeploy package and the accompanying deployment artifacts, we can again create a docker file that will then upload the package to the container and install the website in the container. This will then leave you with a complete docker image that runs your website.

### Publish the website in the docker container ### 

The dockerfile to deploy your website looks as follows:

**FROM windowsserveriisaspnetwebdeploy** 

**RUN mkdir c:\webapplication**

**WORKDIR /webapplication**

**ADD dockerdeploydemo.zip  /webapplication/dockerdeploydemo.zip**

**ADD dockerdeploydemo.deploy.cmd /webapplication/dockerdeploydemo.deploy.cmd  
ADD dockerdeploydemo.SetParameters.xml /webapplication/dockerdeploydemo.SetParameters.xml**

**RUN dockerdeploydemo.deploy.cmd, /Y**

We build the container again using the docker build command:

**docker build –t mycontainerizedwebsite .**

This now finally results in our web application in a container that we can then run on any windows server that has windows containers enabled.

### Running the website in the container ###

In order to test if we succeeded we now issue the docker **run** command and then map the container port 80 to a port on our host. This can be done by using the –p option, where you specify a source and destination port. We also need to specify a command that ensures the container keeps running. For this we now use e.g. a command like ping –t which will result in an endless ping loop, that is enough to keep the container running. so to test the container we now run the following command:

**docker run –p 80:80 mycontainerizedwebsite ping localhost -t**

Now we can browse to the website. Be aware that you can only reach the container from the outside, so if you would browse to localhost, which results in the 127.0.0.0 you will not see any results. You need to address your machine on its actual hostname or outside IP address.

### Summary  ###

To summarize what we have done, we first created a docker image capable of running IIS, then we added ASP.NET 4.5, then we added webdeploy and finally we deployed our website to the container using webdeploy and the package generated by Visual Studio.

In the next post I will show you how we can use this image in build and release management using VSTS and then deploy the container to a server so we can run automated tests as a stage in the delivery pipeline.

### Creating the docker image that has the website, from the build ###

When we want to use docker as part of our build, then we need the build agent to run on a host that has the docker capabilities build in. For this we can use either windows 10 anniversary edition, or we can use windows server 2016 Technical preview 5\. In my example I choose windows server 2016 TP5, since it is available from the azure gallery and gives a very simple setup. You choose the Windows server 2016 TP5 with containers as the base server and after you provision this in azure you download the build agent from VSTS and install it on the local server. After the agent is running, we can now create a build that contains several commands to create the container image.

First we need to ensure the build produces the required webdeploy package and accompanying artefacts and we place those in the artifact staging area. This is simply done by adding the following msbuild arguments to the build solution task that is part of a standard Visual Studio build template.

/p:DeployOnBuild=true /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true /p:PackageLocation=$(build.stagingDirectory)

Then after we are done creating the package and copying the files to the artifacts staging location, we then add an additional copy task that copies the docker files I described in my previous post to the artifacts staging directory, so they become part of the output of my build. I put the docker files in my Git repo, so they are part of every build and versioned.

[![image](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image_thumb-7.png?resize=676%2C368 "image")](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/image-7.png)

After copying the docker files, we then add a couple of command line tasks that we will look at in more detail.

In the following screenshot you can see the additional build steps I used to make this work. The first extra command I added is the docker build command to build the image based on the dockerfile I described in my previous post. I just added the dockerfile to the Git repository as you normally do with all the infrastructure scripts you might have. The docker file contains the correct naming of the package that we produce in the build solution task.

[![backe image](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/backe-image_thumb.png?resize=676%2C371 "backe image")](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/backe-image.png)

You see me passing in the arguments like I did in the previous post, to give the image a tag that I can use later in my release pipeline to run the image.

You see I am using a variable $(GitVersion.NugetVersionV2). this variable is available to me because I use the task GitVersion that you can get from the marketplace. GitVersion determines the semantic version of the current build, based on your branch and changes and this is override able by using git commit messages. For more info on this task and how it works you can go [here](http://gitversion.readthedocs.io/en/latest/)

Now after I create the image, I also want to be able to use it on any of my machines, by using the dockerhub as a repository for my images. So the next step is to login to dockerhub

[![login to dockerhub](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/login-to-dockerhub_thumb.png?resize=676%2C368 "login to dockerhub")](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/login-to-dockerhub.png)

After I have logged in to dockerhub, I can now push the newly created image to the repository.

[![push to dockerhunb](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/push-to-dockerhunb_thumb.png?resize=676%2C371 "push to dockerhunb")](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/push-to-dockerhunb.png)

And now we are done with our build. Next is using the image in our release pipeline

### Running a docker image in the release pipeline ###

Now I go to release management and create a new release definition. What I need to do to run the docker container, is I need the release agent to run on the docker capable machine, exactly the same as with the build. Next we can then issue commands on that machine to run the image and it will pull it from dockerhub when not found on the local machine. Here you can see the release pipeline with two environments, test and production.

[![release-dockerrun](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/release-dockerrun_thumb.png?resize=676%2C368 "release-dockerrun")](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/release-dockerrun.png)

As you can see the first step is nothing more then issuing the docker run command and mapping the port 80 of the container to 80 on the machine. We Also use the –detach option, since we don’t want the agent to be blocked on running the container, so this starts the container and releases control back to the release agent. I also pass it in a name, so I can use the same name in a later stage to stop the image and remove it.

Next I run a set of CodedUI tests to validate if my website is running as expected and then I use the following docker command to stop the container:

[![release-stopcontaienr](https://i0.wp.com/fluentbytes.com/wp-content/uploads/2016/09/release-stopcontaienr_thumb.png?resize=676%2C360 "release-stopcontaienr")](https://i2.wp.com/fluentbytes.com/wp-content/uploads/2016/09/release-stopcontaienr.png)

**docker stop $(docker.processname)**

the variable $(docker.processname) is just a variable I defined for this release template and just contains an arbitrary name that I can then use cross multiple steps.

Finally I am running the command to remove the container after use. This ensures I can run the pipeline again with a new image after the next build

[![release-removecontainer](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/release-removecontainer_thumb.png?resize=676%2C343 "release-removecontainer")](https://i1.wp.com/fluentbytes.com/wp-content/uploads/2016/09/release-removecontainer.png)

For this I use the docker command:

**docker rm –f $(docker.processname)**

I used the –f flag,  and I set the task to always run, so I am guaranteed this image is removed and even after a non successful release. this ensures the repeatability of the process which is of course very important.

## Resources ##
No resources specified