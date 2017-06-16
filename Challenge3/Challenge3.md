# DevOps Challenge \#3 #
In this challenge, you will create a new Azure Serverless Function, and make this a part of your application. The function should take care of sending a Mail or SMS (look at Twilio) confirmation after you have placed an order. First you will write a simple Azure Function that you will expose publicly. Then you will create an ARM template to create the neccessary resources and publish the function from the pipeline. Update your website or service (or both) to use this Azure Function and publish the update with the pipelines.

When you succesfully completed the challenge, you can build and release an Azure Function App as part of the total solution.

## Content ##
* [Pre-requisites](#pre-requisites)
* [Getting started](#getting-started)
* [Achievements](#achievements)
* [Bonus Goals](#bonus-goals)
* [Resources](#resources)

## Pre-requisites ##

*   Azure Subscription
*   Team Project for venue with git repo per challenge team; VSTS account per participant
*   Participants need administrator role on the Default Agent Pool (to be able to install a local build agent)
*   Participants need administratir rights to add new service end-points in VSTS 
*   Azure Database for ASP.NET Music Store (created in Challenge 1)
* [optional for bonus challenge] [Visual Studio 2017 (version 15.3) Preview](https://www.visualstudio.com/vs/preview/)
* [optional for bonus challenge] Visual Studio 2017 - Tools for Azure functions (Extensions & Updates)

## Getting started ##
* Clone the ASP.NET MVC Music Store application from GitHub by cloning [https://github.com/GlobalDevOpsBootcamp/challenge1](https://github.com/GlobalDevOpsBootcamp/challenge1) to your VSTS project as described in challenge1. Or use the current finished solution from either challenge1 or challenge2
* Clone or download the files for challenge 3 from [https://github.com/GlobalDevOpsBootcamp/challenge3](https://github.com/GlobalDevOpsBootcamp/challenge3)

## Achievements ##
|#| Achievement   |
|---|---------------|
|1| Add an Azure function application in the Azure portal and use this in your Web Application |
|2| Configure a VSTS Build process |
|3| Configure a VSTS Release pipeline |
|4| Deploy the application |

## Achievement 1 Add an Azure function application in the Azure portal and use this in your Web Application##

* Create a Twilio Test Account for sending SMS. [Create an account here](https://www.twilio.com/sms) 
* Using the Azure portal, create an Azure Function to send an SMS message by using Twilio, or just send an Email
    * The function must be triggered with a HTTP trigger

You can find the code for the Azure function on [Challenge3 on github](https://github.com/GlobalDevOpsBootcamp/challenge3/SendSMSAzureFunction) 

* Test the function, by sending a POST message with the following body:
```
{
    "message": "Hello, World!"
}
```

## Achievement 1 Add an Azure function application ##

Add an Azure Functions application to the solution of the MVCMusicStore application.
Next, add a function to send SMS messages to the project. The function must be activated by an HTTP trigger.

Make sure you have Visual Studio 2017 (version 15.3 or later) installed and that the extension "Azure Function Tools for Visual Studio 2017" is added.

Learn about Azure Function apps here:
* https://blogs.msdn.microsoft.com/webdev/2017/05/10/azure-function-tools-for-visual-studio-2017

### Implement Function app ###
* Create a Twilio test account
* Manage the NuGet packages for the new project and install the Twilio REST API Helper Library package.
* Add appropriate using statements to the Azure Function C# file
* Use the code fragment below to implement a HTTP triggered function. 

```
log.Info($"Webhook was triggered!");

    string jsonContent = await req.Content.ReadAsStringAsync();
    dynamic data = JsonConvert.DeserializeObject(jsonContent);

    if (data.message == null)
    {
        return req.CreateResponse(HttpStatusCode.BadRequest, new
        {
            error = "Please pass message properties in the input object"
        });
    }

    string accountSid = "<YourSidHere>";
    string authToken = "<YourOAuthTokenHere>";

    TwilioClient.Init(accountSid, authToken);

    // Send a new outgoing SMS by POSTing to the Messages resource
    MessageResource.Create(
        from: new PhoneNumber("+3197001234567"), // TODO: Replace
        to: new PhoneNumber("+31622334455"), // TODO: Replace
        body: $"{data.message}");

    return req.CreateResponse(HttpStatusCode.OK, new
    {
        greeting = $"Message Sent"
    });

```
* Publish the function app to Azure.
* Test the function, by sending a POST message with the following body:
```
{
    "message": "Hello, World!"
}
```

You can now receive a text message at the mobile number you used for signing up at Twilio. Achievement unlocked

## Achievement 2 - Configure a VSTS Build process ##

Create a VSTS build pipeline that will compile the Azure Function app and copy the build artefact for release. Use an ARM template to provision an Function app Website in Azure.

Recommended reading:
* https://www.joshcarlisle.io/blog/2017/5/17/visual-studio-2017-tools-for-azure-functions-and-continuous-integration-with-vsts


### Create a VSTS build pipeline

* In the VSTS portal use your existing pipeline from challenge 1 or 2. If you have not completed those challenges, create a new Build pipeline.
* Verify that the build artefacts from the Azure Function App are included in the build output.

You can now build an Azure Function App from source code. Achievement unlocked

## Achievement 3 - Configure a VSTS Release pipeline ##

Create a new Release pipeline that will provision your Function App to Azure.  

### Create a provisioning project ###

* From the Azure Portal check your deployment of the Function app from Challenge 1. Download the ARM template for that deployment.
* Add an Azure Resource Group project to the MVC Music Store solution. Include the files from the downloaded deployment. Tweak the files, parameters and template and try and provision the Function app from Visual Studio.

###  Provision the Function App from a release pipeline ###

* Create a Release pipeline in VSTS and provision the ARM template from the previous step. Also, release the Function app build artifacts that was created.
* Test the release by removing and reprovisioning the Function App. Test the app after provisioning and deployment and show that it can still send a SMS text message.

You can now provision and release an Azure Function App from your source code repository to production. Achievement unlocked.

## Achievement 4 - Deploy the application ##

Enhance the MVC Music store application to be able to send an HTTP trigger to the Function App upon a purchase.
Build and release the entire application and order items from the store. Verify that the complete application functions as intended.

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
```
SendSMSMessage(order.FirstName, order.LastName, order.Total, order.OrderDate);
```
* Run your application locally and check whether a completed order will trigger the Function App.
* Make any required adjustments to your build and release pipelines to deploy the new MVC Music Store application.

You can now deploy the entire application including a Function App. Achievement unlocked.