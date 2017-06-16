FROM microsoft/aspnet

##install web deploy
RUN mkdir c:\install
ADD WebDeploy_2_10_amd64_en-US.msi /install/WebDeploy_2_10_amd64_en-US.msi

##install webapplication
WORKDIR /install
RUN msiexec.exe /i c:\install\WebDeploy_2_10_amd64_en-US.msi /qn
RUN mkdir c:\MvcMusicstore
WORKDIR /MvcMusicStore
ADD fixAcls.ps1 /MvcMusicStore/fixAcls.ps1
ADD MvcMusicstore.zip /MvcMusicStore/MvcMusicStore.zip
ADD MvcMusicStore.deploy.cmd /MvcMusicStore/MvcMusicStore.deploy.cmd
ADD MvcMusicStore.SetParameters.xml /MvcMusicStore/MvcMusicStore.SetParameters.xml

# Running deploy.cmd once will result in an ACLS error
RUN MvcMusicStore.deploy.cmd /Y

# This script will fix the ACLS error
RUN powershell.exe -executionpolicy bypass .\fixAcls.ps1

#Lastly we will need to run the deploy.cmd again to complete the installation
RUN MvcMusicStore.deploy.cmd /Y

EXPOSE 80