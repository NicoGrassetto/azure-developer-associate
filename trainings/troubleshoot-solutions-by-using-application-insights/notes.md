# Troubleshoot solutions by using Application Insights
## Monitor app performance
### Introduction

Instrumenting and monitoring your apps helps you maximize their availability and performance.

### Explore Application Insights

Application Insights is an extension of Azure Monitor and provides Application Performance Monitoring (APM) features. APM tools are useful to monitor applications from development, through test, and into production in the following ways:

- Proactively understand how an application is performing.
- Reactively review application execution data to determine the cause of an incident.

In addition to collecting metrics and application telemetry data, which describe application activities and health, Application Insights can also be used to collect and store application trace logging data.

The log trace is associated with other telemetry to give a detailed view of the activity. Adding trace logging to existing apps only requires providing a destination for the logs; the logging framework rarely needs to be changed.

#### Application Insights feature overview

Features include, but not limited to:

|Feature|Description|
|---|---|
|Live Metrics|Observe activity from your deployed application in real time with no effect on the host environment.|
|Availability|Also known as _Synthetic Transaction Monitoring_, probe your applications external endpoints to test the overall availability and responsiveness over time.|
|GitHub or Azure DevOps integration|Create GitHub or Azure DevOps work items in context of Application Insights data.|
|Usage|Understand which features are popular with users and how users interact and use your application|
|Smart Detection|Automatic failure and anomaly detection through proactive telemetry analysis.|
|Application Map|A high level top-down view of the application architecture and at-a-glance visual references to component health and responsiveness.|
|Distributed Tracing|Search and visualize an end-to-end flow of a given execution or transaction.|

#### What Application Insights monitors

Application Insights collects Metrics and application Telemetry data, which describe application activities and health, as well as trace logging data.

- **Request rates, response times, and failure rates** - Find out which pages are most popular, at what times of day, and where your users are. See which pages perform best. If your response times and failure rates go high when there are more requests, then perhaps you have a resourcing problem.
- **Dependency rates, response times, and failure rates** - Find out whether external services are slowing you down.
- **Exceptions** - Analyze the aggregated statistics, or pick specific instances and drill into the stack trace and related requests. Both server and browser exceptions are reported.
- **Page views and load performance** - reported by your users' browsers.
- **AJAX calls** from web pages - rates, response times, and failure rates.
- **User and session counts**.
- **Performance counters** from your Windows or Linux server machines, such as CPU, memory, and network usage.
- **Host diagnostics** from Docker or Azure.
- **Diagnostic trace logs** from your app - so that you can correlate trace events with requests.
- **Custom events and metrics** that you write yourself in the client or server code, to track business events such as items sold or games won.

#### Getting started with Application Insights

Application Insights is one of the many services hosted within Microsoft Azure, and telemetry is sent there for analysis and presentation. It's free to sign up, and if you choose the basic pricing plan of Application Insights, there's no charge until your application has grown to have substantial usage.

There are several ways to get started monitoring and analyzing app performance:

- **At run time:** instrument your web app on the server. Ideal for applications already deployed. Avoids any update to the code.
- **At development time:** add Application Insights to your code. Allows you to customize telemetry collection and send more telemetry.
- **Instrument your web pages** for page view, AJAX, and other client-side telemetry.
- **Analyze mobile app usage** by integrating with Visual Studio App Center.
- **Availability tests** - ping your website regularly from our servers.


### Discover log-based metrics

Application Insights log-based metrics let you analyze the health of your monitored apps, create powerful dashboards, and configure alerts. There are two kinds of metrics:

- **Log-based metrics** behind the scene are translated into [Kusto queries](https://learn.microsoft.com/en-us/azure/kusto/query/) from stored events.
- **Standard metrics** are stored as preaggregated time series.

Since _standard metrics_ are preaggregated during collection, they have better performance at query time. Standard metrics are a better choice for dashboarding and in real-time alerting. The _log-based metrics_ have more dimensions, which makes them the superior option for data analysis and ad-hoc diagnostics. Use the [namespace selector](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-getting-started#create-your-first-metric-chart) to switch between log-based and standard metrics in [metrics explorer](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-getting-started).

#### Log-based metrics

Developers can use the SDK to send events manually (by writing code that explicitly invokes the SDK) or they can rely on the automatic collection of events from autoinstrumentation. In either case, the Application Insights backend stores all collected events as logs, and the Application Insights blades in the Azure portal act as an analytical and diagnostic tool for visualizing event-based data from logs.

Using logs to retain a complete set of events can bring great analytical and diagnostic value. For example, you can get an exact count of requests to a particular URL with the number of distinct users who made these calls. Or you can get detailed diagnostic traces, including exceptions and dependency calls for any user session. Having this type of information can significantly improve visibility into the application health and usage, allowing to cut down the time necessary to diagnose issues with an app.

At the same time, collecting a complete set of events may be impractical (or even impossible) for applications that generate a large volume of telemetry. For situations when the volume of events is too high, Application Insights implements several telemetry volume reduction techniques, such as sampling and filtering that reduces the number of collected and stored events. Unfortunately, lowering the number of stored events also lowers the accuracy of the metrics that, behind the scenes, must perform query-time aggregations of the events stored in logs.

#### Preaggregated metrics

The preaggregated metrics aren't stored as individual events with lots of properties. Instead, they're stored as preaggregated time series, and only with key dimensions. This makes the new metrics superior at query time: retrieving data happens faster and requires less compute power. This enables new scenarios such as near real-time alerting on dimensions of metrics, more responsive dashboards, and more.

>**Important**:Both, log-based and pre-aggregated metrics coexist in Application Insights. To differentiate the two, in the Application Insights UX the pre-aggregated metrics are now called "Standard metrics (preview)", while the traditional metrics from the events were renamed to "Log-based metrics".

The newer SDKs ([Application Insights 2.7](https://www.nuget.org/packages/Microsoft.ApplicationInsights/2.7.2) SDK or later for .NET) preaggregate metrics during collection. This applies to [standard metrics sent by default](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftinsightscomponents) so the accuracy isn't affected by sampling or filtering. It also applies to custom metrics sent using [GetMetric](https://learn.microsoft.com/en-us/azure/azure-monitor/app/api-custom-events-metrics#getmetric) resulting in less data ingestion and lower cost.

For the SDKs that don't implement preaggregation the Application Insights backend still populates the new metrics by aggregating the events received by the Application Insights event collection endpoint. While you don't benefit from the reduced volume of data transmitted over the wire, you can still use the preaggregated metrics and experience better performance and support of the near real-time dimensional alerting with SDKs that don't preaggregate metrics during collection.

It's worth mentioning that the collection endpoint preaggregates events before ingestion sampling, which means that [ingestion sampling](https://learn.microsoft.com/en-us/azure/azure-monitor/app/sampling) will never impact the accuracy of preaggregated metrics, regardless of the SDK version you use with your application.

### Instrument an app for monitoring

At a basic level, "instrumenting" is simply enabling an application to capture telemetry. There are two methods to instrument your application:

- Automatic instrumentation (autoinstrumentation)
- Manual instrumentation

**Autoinstrumentation** enables telemetry collection through configuration without touching the application's code. Although it's more convenient, it tends to be less configurable. It's also not available in all languages. See [Autoinstrumentation supported environments and languages](https://learn.microsoft.com/en-us/azure/azure-monitor/app/codeless-overview). When autoinstrumentation is available, it's the easiest way to enable Azure Monitor Application Insights.

**Manual instrumentation** is coding against the Application Insights or OpenTelemetry API. In the context of a user, it typically refers to installing a language-specific SDK in an application. This means that you have to manage the updates to the latest package version by yourself. You can use this option if you need to make custom dependency calls or API calls that are not captured by default with autoinstrumentation. There are two options for manual instrumentation:

- [Application Insights SDKs](https://learn.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core)
- [Azure Monitor OpenTelemetry Distros](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-enable).

#### Enabling via Application Insights SDKs

You only need to install the Application Insights SDK in the following circumstances:

- You require custom events and metrics
- You require control over the flow of telemetry
- Auto-Instrumentation isn't available (typically due to language or platform limitations)

To use the SDK, you install a small instrumentation package in your app and then instrument the web app, any background components, and JavaScript within the web pages. The app and its components don't have to be hosted in Azure. The instrumentation monitors your app and directs the telemetry data to an Application Insights resource by using a unique token.

A list of SDK versions and names is hosted on GitHub. For more information, visit [SDK Version](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/docs/versions_and_names.md).

#### Enable via OpenTelemetry

Microsoft worked with project stakeholders from two previously popular open-source telemetry projects, [OpenCensus](https://opencensus.io/) and [OpenTracing](https://opentracing.io/). Together, we helped to create a single project, OpenTelemetry. OpenTelemetry includes contributions from all major cloud and Application Performance Management (APM) vendors and lives within the [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/). Microsoft is a Platinum Member of the CNCF.

Some legacy terms in Application Insights are confusing because of the industry convergence on OpenTelemetry. The following table highlights these differences. OpenTelemetry terms are replacing Application Insights terms.

|Application Insights|OpenTelemetry|
|---|---|
|Autocollectors|Instrumentation libraries|
|Channel|Exporter|
|Codeless / Agent-based|Autoinstrumentation|
|Traces|Logs|
|Requests|Server Spans|
|Dependencies|Other Span Types (Client, Internal, etc.)|
|Operation ID|Trace ID|
|ID or Operation Parent ID|Span ID|
### Select an availability test

After you deploy your web app or website, you can set up recurring tests to monitor availability and responsiveness. Application Insights sends web requests to your application at regular intervals from points around the world. It can alert you if your application isn't responding or responds too slowly. You can create up to 100 availability tests per Application Insights resource.

Availability tests don't require any changes to the website you're testing and work for any HTTP or HTTPS endpoint that's accessible from the public internet. You can also test the availability of a REST API that your service depends on.

You can create up to 100 availability tests per Application Insights resource, and there are three types of availability tests:

- **Standard test:** This is a type of availability test that checks the availability of a website by sending a single request, similar to the deprecated URL ping test. In addition to validating whether an endpoint is responding and measuring the performance, Standard tests also include TLS/SSL certificate validity, proactive lifetime check, HTTP request verb (for example, `GET`,`HEAD`, and `POST`), custom headers, and custom data associated with your HTTP request.
    
- **Custom TrackAvailability test:** If you decide to create a custom application to run availability tests, you can use the [TrackAvailability()](https://learn.microsoft.com/en-us/dotnet/api/microsoft.applicationinsights.telemetryclient.trackavailability) method to send the results to Application Insights.
    
- [URL ping test (classic)](https://learn.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability): You can create this test through the portal to validate whether an endpoint is responding and measure performance associated with that response. You can also set custom success criteria coupled with more advanced features, like parsing dependent requests and allowing for retries.
    

>**Important**: **URL ping tests:** On September 30, 2026, URL ping tests in Application Insights will be retired. Existing URL ping tests will be removed from your resources. Review the [pricing](https://azure.microsoft.com/pricing/details/monitor) for standard tests and [transition](https://aka.ms/availabilitytestmigration) to using them before September 30, 2026 to ensure you can continue to run single-step availability tests in your Application Insights resources.
 
### Troubleshoot app performance by using Application Map

Application Map helps you spot performance bottlenecks or failure hotspots across all components of your distributed application. Each node on the map represents an application component or its dependencies; and has health key performance indicator and alerts status. You can select through from any component to more detailed diagnostics, such as Application Insights events. If your app uses Azure services, you can also select through to Azure diagnostics, such as SQL Database Advisor recommendations.

Components are independently deployable parts of your distributed/microservices application. Developers and operations teams have code-level visibility or access to telemetry generated by these application components.

- Components are different from "observed" external dependencies such as SQL, Event Hubs, etc. which your team/organization may not have access to (code or telemetry).
- Components run on any number of server/role/container instances.
- Components can be separate Application Insights instrumentation keys (even if subscriptions are different) or different roles reporting to a single Application Insights instrumentation key. The preview map experience shows the components regardless of their configuration.

You can see the full application topology across multiple levels of related application components. Components could be different Application Insights resources, or different roles in a single resource. The app map finds components by following HTTP dependency calls made between servers with the Application Insights SDK installed.

This experience starts with progressive discovery of the components. When you first load the application map, a set of queries is triggered to discover the components related to this component. A button at the top-left corner updates with the number of components in your application as they're discovered.

Selecting **Update map components** refreshes with all components discovered until that point. Depending on the complexity of your application, this may take a minute to load.

If all of the components are roles within a single Application Insights resource, then this discovery step isn't required. The initial load for such an application has all its components.

![Application Map screenshot showing the initial load of an app where all of the components are roles within a single Application Insights resource.](https://learn.microsoft.com/en-gb/training/modules/monitor-app-performance/media/application-map.png)

One of the key objectives with this experience is to be able to visualize complex topologies with hundreds of components. Click on any component to see related insights and go to the performance and failure triage experience for that component.

![Screenshot showing component details in the Application Map.](https://learn.microsoft.com/en-gb/training/modules/monitor-app-performance/media/application-map-component.png)

Application Map uses the cloud role name property to identify the components on the map. You can manually set or override the cloud role name and change what gets displayed on the Application Map.

### Monitor an application with autoinstrumentation

In this exercise, you create an Azure App Service web app with Application Insights enabled, configure autoinstrumentation without modifying code, create and deploy a Flask application, and then view application metrics and error data in Application Insights. Implementing comprehensive application monitoring and observability, without having to make changes to your code, makes deployments and migrations simpler.

Tasks performed in this exercise:

- Create a web app resource with Application Insights enabled
- Configure instrumentation for the web app.
- Create a new Flask app and deploy it to the web app resource.
- View application activity in Application Insights
- Clean up resources

This exercise takes approximately **20** minutes to complete.

#### Create resources in Azure

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
    
2. Select the **+ Create a resource** located in the **Azure Services** heading near the top of the homepage.
    
3. In the **Search the Marketplace** search bar, enter _web app_ and press **enter** to start searching.
    
4. In the Web App tile, select the **Create** drop-down and then select **Web App**.
    
    [![Screenshot of the Web App tile.](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-insights/media/create-web-app-tile.png)](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-insights/media/create-web-app-tile.png)
    

Selecting **Create** will open a template with a few tabs to fill out with information about your deployment. The following steps walk you through what changes to make in the relevant tabs.

1. Fill out the **Basics** tab with the information in the following table:
    
    |Setting|Action|
    |---|---|
    |**Subscription**|Retain the default value.|
    |**Resource group**|Select Create new, enter `rg-WebApp`, and then select OK. You can also select an existing resource group if you prefer.|
    |**Name**|Enter a unique name, for example **YOUR-INITIALS-monitorapp**. Replace **YOUR-INITIALS** with your initials, or some other value. The name needs to be unique, so it may require a few changes.|
    |Slider under **Name** setting|Select the slider to turn it off. This slider only appears in some Azure configurations.|
    |**Publish**|Select the **Code** option.|
    |**Runtime stack**|Select **Python 3.11** in the drop-down menu.|
    |**Operating System**|Select **Linux**.|
    |**Region**|Retain the default selection, or choose a region near you.|
    |**Linux Plan**|Retain the default selection.|
    |**Pricing plan**|Select the drop-down and choose the **Free F1** plan.|

    > **Note**: Python autoinstrumentation for Application Insights requires Linux OS and Python versions 3.9-3.13. Custom containers are not supported. For more information, see [Enable application monitoring in Azure App Service](https://learn.microsoft.com/en-us/azure/azure-monitor/app/codeless-app-service?tabs=python).
    
2. Select, or navigate to, the **Monitor + secure** tab, and enter the information in the following table:
    
    |Setting|Action|
    |---|---|
    |**Enable Application Insights**|Select **Yes**.|
    |**Application Insights**|Select **Create new** and a dialog box will appear. Enter `autoinstrument-insights` in the **Name** field of the dialog box. Then select **OK** to accept the name.|
    |**Workspace**|Enter `Workspace` if the field isn't already filled in and locked.|
    
3. Select **Review + create** and review the details of your deployment. Then select **Create** to create the resources.
    

It will take a few minutes for the deployment to complete. When it's finished, select the **Go to resource** button.

##### Configure instrumentation settings

To enable monitoring without changes to your code, you need to configure the instrumentation for your app at the service level.

1. In the left-navigation menu expand **Monitoring** and select **Application Insights**.
    
2. Locate the **Instrument your application** section and select **Python**.
    
3. Select **Recommended** in the **Collection level** section.
    
4. Select **Apply** and then confirm the changes.
    
5. In the left-navigation menu, select **Overview**.

> **Note**: For Python applications, logging telemetry is collected at the level of the root logger. To learn more about Python's native logging hierarchy, visit the [Python logging documentation](https://docs.python.org/3/library/logging.html).
    

#### Create and deploy a Flask app

In this section of the exercise you create a Flask app in the Cloud Shell and deploy it to the web app you created. All of the steps in this section are performed in the Cloud Shell.

1. Use the **[>_]** button to the right of the search bar at the top of the page to create a new cloud shell in the Azure portal, selecting a _**Bash**_ environment. The cloud shell provides a command line interface in a pane at the bottom of the Azure portal. If you are prompted to select a storage account to persist your files, select **No storage account required**, your subscription, and then select **Apply**.
    
    > **Note**: If you have previously created a cloud shell that uses a _PowerShell_ environment, switch it to _**Bash**_.
    
2. Run the following commands to create a directory for the Flask app and change into the directory.
    
    ```bash
    mkdir flaskapp
    cd flaskapp
    ```
    
3. Create a new Flask application by creating the necessary files. First, create the `app.py` file:
    
    ```bash
    cat > app.py << 'EOF'
    from flask import Flask, render_template
    import random

    app = Flask(__name__)

    @app.route("/")
    def home():
        return render_template("index.html")

    @app.route("/counter")
    def counter():
        return render_template("counter.html")

    @app.route("/weather")
    def weather():
        # Simulated weather data
        forecasts = [
            {"date": "2024-01-01", "temp_c": 15, "summary": "Sunny"},
            {"date": "2024-01-02", "temp_c": 18, "summary": "Cloudy"},
            {"date": "2024-01-03", "temp_c": 12, "summary": "Rainy"},
            {"date": "2024-01-04", "temp_c": 20, "summary": "Warm"},
            {"date": "2024-01-05", "temp_c": 17, "summary": "Mild"},
        ]
        return render_template("weather.html", forecasts=forecasts)

    if __name__ == "__main__":
        app.run()
    EOF
    ```

4. Create the `requirements.txt` file:
    
    ```bash
    cat > requirements.txt << 'EOF'
    Flask==3.0.0
    gunicorn==21.2.0
    EOF
    ```

5. Create the templates directory and HTML files:
    
    ```bash
    mkdir templates
    
    cat > templates/index.html << 'EOF'
    <!DOCTYPE html>
    <html>
    <head><title>Home</title></head>
    <body>
        <h1>Welcome to the Flask App</h1>
        <nav>
            <a href="/">Home</a> | 
            <a href="/counter">Counter</a> | 
            <a href="/weather">Weather</a>
        </nav>
    </body>
    </html>
    EOF
    
    cat > templates/counter.html << 'EOF'
    <!DOCTYPE html>
    <html>
    <head><title>Counter</title></head>
    <body>
        <h1>Counter Page</h1>
        <p>Current count: <span id="count">0</span></p>
        <button onclick="document.getElementById('count').innerText = parseInt(document.getElementById('count').innerText) + 1">Increment</button>
        <nav>
            <a href="/">Home</a> | 
            <a href="/counter">Counter</a> | 
            <a href="/weather">Weather</a>
        </nav>
    </body>
    </html>
    EOF
    
    cat > templates/weather.html << 'EOF'
    <!DOCTYPE html>
    <html>
    <head><title>Weather</title></head>
    <body>
        <h1>Weather Forecast</h1>
        <table border="1">
            <tr><th>Date</th><th>Temp (°C)</th><th>Summary</th></tr>
            {% for forecast in forecasts %}
            <tr>
                <td>{{ forecast.date }}</td>
                <td>{{ forecast.temp_c }}</td>
                <td>{{ forecast.summary }}</td>
            </tr>
            {% endfor %}
        </table>
        <nav>
            <a href="/">Home</a> | 
            <a href="/counter">Counter</a> | 
            <a href="/weather">Weather</a>
        </nav>
    </body>
    </html>
    EOF
    ```

6. Verify the application structure:
    
    ```bash
    ls -la
    ls templates/
    ```
    

##### Deploy the app to App Service

To deploy the app you need to create a _.zip_ file containing your application code for deployment.

1. Run the following commands to create a _.zip_ file of the app. The _.zip_ file will be located in the root directory of the application.
    
    ```bash
    zip -r app.zip . -x "*.pyc" -x "__pycache__/*"
    ```
    
2. Run the following command to deploy the app to App Service. Replace **YOUR-WEB-APP-NAME** and **YOUR-RESOURCE-GROUP** with the values you used when creating the App Service resources earlier in the exercise.
    
    ```bash
    az webapp deploy --name YOUR-WEB-APP-NAME \
        --resource-group YOUR-RESOURCE-GROUP \
        --src-path ./app.zip
    ```

3. Configure the startup command for the Flask app:

    ```bash
    az webapp config set --name YOUR-WEB-APP-NAME \
        --resource-group YOUR-RESOURCE-GROUP \
        --startup-file "gunicorn --bind=0.0.0.0 --timeout 600 app:app"
    ```
    
4. When the deployment is completed, select the link in the **Default domain** field located in the **Essentials** section to open the app in a new tab in your browser.
    

Now it's time to view some basic application metrics in Application Insights. Don't close this tab, you'll use it in the rest of the exercise.

#### View metrics in Application Insights

Return the tab with the Azure Portal and navigate to the Application Insights resource you created earlier. The **Overview** tab displays some basic charts:

- Failed requests
- Server response time
- Server requests
- Availability

In this section you will perform some actions in the web app and then return to this page to view the activity. The activity reporting is delayed, so it may take a few minutes for it to appear in the charts.

Perform the following steps in the web app.

1. Navigate between the **Home**, **Counter**, and **Weather** navigation options in the menu of the web app.
    
2. Refresh the web page several times to generate **Server response time** and **Server requests** data.
    
3. To create some errors, select the **Home** button and then append the URL with **/failures**. This route doesn't exist in the web app and will generate an error. Refresh the page several times to generate error data.
    
4. Return to the tab where Application Insights is running, and wait a minute or two for the information to appear in the charts.
    
5. In the left-navigation expand the **Investigate** section and select **Failures**. It displays the failed request count along with more detailed information about the response codes for the failures.
    

Explore other reporting options to get an idea of what other types of information is available.

#### Clean up resources

Now that you finished the exercise, you should delete the cloud resources you created to avoid unnecessary resource usage.

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
2. Navigate to the resource group you created and view the contents of the resources used in this exercise.
3. On the toolbar, select **Delete resource group**.
4. Enter the resource group name and confirm that you want to delete it.

> **CAUTION:** Deleting a resource group deletes all resources contained within it. If you chose an existing resource group for this exercise, any existing resources outside the scope of this exercise will also be deleted.
