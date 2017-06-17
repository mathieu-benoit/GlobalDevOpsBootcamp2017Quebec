# DevOps Challenge \#3 #

In this challenge, you will create a new Azure Serverless Function, and make this a part of your application. The function should take care of sending a Mail or SMS (look at Twilio) confirmation after you have placed an order. First you will write a simple Azure Function that you will expose publicly. Then you will create an ARM template to create the necessary resources and publish the function from the pipeline. Update your website or service (or both) to use this Azure Function and publish the update with the pipelines.

When you successfully completed the challenge, you can build and release an Azure Function App as part of the total solution.

## Content ##
* [Pre-requisites](#pre-requisites)
* [Getting started](#getting-started)
* [Achievements](#achievements)
* [Bonus Goals](#bonus-goals)
* [Resources](#resources)

## Pre-requisites ##

* Azure Subscription
* Team Project for venue with git repo per challenge team; VSTS account per participant
* Participants need administrator role on the Default Agent Pool (to be able to install a local build agent)
* Participants need administrator rights to add new service end-points in VSTS 
* Azure Database for ASP.NET Music Store (created in Challenge 1)
* [optional for bonus challenge] [Visual Studio 2017 (version 15.3) Preview](https://www.visualstudio.com/vs/preview/)
* [optional for bonus challenge] Visual Studio 2017 - Tools for Azure functions (Extensions & Updates)

## Getting started ##
* Clone the ASP.NET MVC Music Store application from GitHub by cloning [https://github.com/GlobalDevOpsBootcamp/challenge1](https://github.com/GlobalDevOpsBootcamp/challenge1) to your VSTS project as described in challenge1. Or use the current finished solution from either challenge1 or challenge2
* Clone or download the files for challenge 3 from [https://github.com/GlobalDevOpsBootcamp/challenge3](https://github.com/GlobalDevOpsBootcamp/challenge3)

## Achievements ##
|#| Achievement   |
|---|---------------|
|1| Add an Azure function application in the Azure portal |
|2| Configure a VSTS Build and Release process |
|3| Set up your Infrastructure as Code |
|4| Deploy the enhanced Musicstore application |

## Bonus Goals ##
|#| Bonus Goal   |
|---|---------------|
|1| Create a Visual Studio Functions App project |
|2| Incorporate unit tests |
|3| Build & Release Visual Studio Function project with VSTS |

## Achievement #1 - Add an Azure function application in the Azure portal ##

* Create a Twilio Test Account for sending SMS. [Create an account here](https://www.twilio.com/sms)
* Using the Azure portal, create an Azure Function to send an SMS message by using Twilio, or just send an Email
    * The function must be triggered with a HTTP trigger

You can find the code for the Azure function on [Challenge3 on github](https://github.com/GlobalDevOpsBootcamp/challenge3/tree/master/SendSMSAzureFunction)

* Test the function, by sending a POST message with the following body:

```json
{
    "message": "Hello, World!"
}
```

## Achievement #2 - Configure a VSTS Build and Release process ##

Download the function app that you created in achievement 1 and structure them accordingly. ([see here](https://pgroene.wordpress.com/2017/01/27/use-vsts-to-deploy-functions-as-infrastructure-as-code/)) .

Create a VSTS build pipeline that will "build" the Azure Function app (actually just package the file) and copy the build artifacts for release. Then create a release pipeline that uses the WebApp Deploy task to release the function app to Azure.

Recommended reading:
* https://pgroene.wordpress.com/2017/01/27/use-vsts-to-deploy-functions-as-infrastructure-as-code/
* https://www.joshcarlisle.io/blog/2017/5/17/visual-studio-2017-tools-for-azure-functions-and-continuous-integration-with-vsts

### Create a VSTS build pipeline

* In the VSTS portal use your existing pipeline from challenge 1 or 2. If you have not completed those challenges, create a new Build pipeline.
* Verify that the build artefacts from the Azure Function App are included in the build output.

## Achievement #3 - Set up your Infrastructure as Code ##

Create n ARM template to set up the infrastructure of this function. Later, set up the release pipeline that will provision your Function App to Azure including this infrastructure.

### Create a provisioning project ###

* Get the ARM template from [Github Challenge 3](https://github.com/GlobalDevOpsBootcamp/challenge3) 
* Include the downloaded project in the MVC Music Store solution. Tweak the files, parameters and template and try and provision the Function app from Visual Studio.

###  Provision the Function App from a release pipeline ###

* Modify the Release pipeline in VSTS to include the provisioning of the ARM template from the previous step. 
* Test the release by removing and reprovisioning the Function App. Test the app after provisioning and deployment and show that it can still send a SMS text message.

You can now provision and release an Azure Function App from your source code repository to production. Achievement unlocked.

Recommended reading:
* https://pgroene.wordpress.com/2017/01/27/use-vsts-to-deploy-functions-as-infrastructure-as-code/
* https://www.joshcarlisle.io/blog/2017/5/17/visual-studio-2017-tools-for-azure-functions-and-continuous-integration-with-vsts

## Achievement #4 - Deploy the enhanced Musicstore application ##

Enhance the MVC Music store application to be able to send an HTTP trigger to the Function App upon a purchase.
Build and release the entire application and order items from the store. Verify that the complete application functions as intended.

Use the ShoppingCart.cs file from the GitHub repo [https://github.com/GlobalDevOpsBootcamp/challenge3/MVCMusicStoreEnhancee](https://github.com/GlobalDevOpsBootcamp/challenge3/tree/master/MVCMusicStoreEnhance)

### Enhance MVCMusicStore application

* Open the ShoppingCart.cs file and add the following code at the end of the class definition.
```
private const string FunctionURL = "https://musicstorefunctionapp.azurewebsites.net/api/SendSMS?code=6lLuMqGplnMAImGAJhXF9imPOEpUUuUzAOPybFU6K7bAddt8ZTx26g==";

        private async Task SendSMSMessage(string firstName, string lastName, decimal total, DateTime orderDate)
        {
            HttpResponseMessage response = null;
            try
            {
                HttpClient client = new HttpClient();
                string message = $"Hello {firstName} {lastName}, your order was processed on {orderDate}";
                response = await client.PostAsync(FunctionURL, new StringContent(message));
                if (!response.IsSuccessStatusCode) return;
                string content = await response.Content.ReadAsStringAsync();
            }
            catch (HttpRequestException)
            {
                // TODO: Log exception details
            }
        }
```

* Find the CreateOrder method and include a call to the SendSMSMessage right after the invocation of EmptyCart().

```csharp
SendSMSMessage(order.FirstName, order.LastName, order.Total, order.OrderDate);
```
* Run your application locally and check whether a completed order will trigger the Function App.
* Make any required adjustments to your build and release pipelines to deploy the new MVC Music Store application.