# Develop message-based solutions
## Discover Azure message queues
### Introduction

Azure supports two types of queue mechanisms: **Service Bus queues** and **Storage queues**.

Service Bus queues are part of a broader Azure messaging infrastructure that supports queuing, publish/subscribe, and more advanced integration patterns. They're designed to integrate applications or application components that may span multiple communication protocols, data contracts, trust domains, or network environments.

Storage queues are part of the Azure Storage infrastructure. They allow you to store large numbers of messages. You access messages from anywhere in the world via authenticated calls using HTTP or HTTPS. A queue may contain millions of messages, up to the total capacity limit of a storage account. Queues are commonly used to create a backlog of work to process asynchronously.

### Choose a message queue solution

Storage queues and Service Bus queues have a slightly different feature set. You can choose either one or both, depending on the needs of your particular solution.

When determining which queuing technology fits the purpose of a given solution, solution architects and developers should consider these recommendations.

#### Consider using Service Bus queues

As a solution architect/developer, **you should consider using Service Bus queues** when:

- Your solution needs to receive messages without having to poll the queue. With Service Bus, you can achieve it by using a long-polling receive operation using the TCP-based protocols that Service Bus supports.
- Your solution requires the queue to provide a guaranteed first-in-first-out (FIFO) ordered delivery.
- Your solution needs to support automatic duplicate detection.
- You want your application to process messages as parallel long-running streams (messages are associated with a stream using the **session ID** property on the message). In this model, each node in the consuming application competes for streams, as opposed to messages. When a stream is given to a consuming node, the node can examine the state of the application stream state using transactions.
- Your solution requires transactional behavior and atomicity when sending or receiving multiple messages from a queue.
- Your application handles messages that can exceed 64 KB but won't likely approach the 256 KB or 1-MB limit, depending on the chosen service tier (although Service Bus queues can handle messages up to 100 MB).
- You deal with a requirement to provide a role-based access model to the queues, and different rights/permissions for senders and receivers.

#### Consider using Storage queues

As a solution architect/developer, **you should consider using Storage queues** when:

- Your application must store over 80 gigabytes of messages in a queue.
- Your application wants to track progress for processing a message in the queue. It's useful if the worker processing a message crashes. Another worker can then use that information to continue from where the prior worker left off.
- You require server side logs of all of the transactions executed against your queues.

### Explore Azure Service Bus

Azure Service Bus is a fully managed enterprise message broker with message queues and publish-subscribe topics. Service Bus is used to decouple applications and services. Data is transferred between different applications and services using **messages**. A message is a container decorated with metadata, and contains data. The data can be any kind of information, including structured data encoded with the common formats such as the following ones: JSON, XML, Apache Avro, and Plain Text.

Some common messaging scenarios are:

- _Messaging_. Transfer business data, such as sales or purchase orders, journals, or inventory movements.
- _Decouple applications_. Improve reliability and scalability of applications and services. Client and service don't have to be online at the same time.
- _Topics and subscriptions_. Enable 1:_n_ relationships between publishers and subscribers.
- _Message sessions_. Implement workflows that require message ordering or message deferral.

#### Service Bus tiers

Service Bus offers basic, standard, and premium tiers. The _premium_ tier of Service Bus Messaging addresses common customer requests around scale, performance, and availability for mission-critical applications. The premium tier is recommended for production scenarios. Although the feature sets are nearly identical, these two tiers of Service Bus Messaging are designed to serve different use cases. For more information on the available tiers, visit [Service Bus pricing](https://azure.microsoft.com/pricing/details/service-bus/).

Some high-level differences between the premium and standard tiers are highlighted in the following table.

|Premium|Standard|
|---|---|
|High throughput|Variable throughput|
|Predictable performance|Variable latency|
|Fixed pricing|Pay as you go variable pricing|
|Ability to scale workload up and down|N/A|
|Message size up to 100 MB|Message size up to 256 KB|

#### Advanced features

Service Bus includes advanced features that enable you to solve more complex messaging problems. The following table describes several of these features.

|Feature|Description|
|---|---|
|Message sessions|To create a first-in, first-out (FIFO) guarantee in Service Bus, use sessions. Message sessions enable exclusive, ordered handling of unbounded sequences of related messages.|
|Autoforwarding|The autoforwarding feature chains a queue or subscription to another queue or topic that is in the same namespace.|
|Dead-letter queue|Service Bus supports a dead-letter queue (DLQ). A DLQ holds messages that can't be delivered to any receiver. Service Bus lets you remove messages from the DLQ and inspect them.|
|Scheduled delivery|You can submit messages to a queue or topic for delayed processing. You can schedule a job to become available for processing by a system at a certain time.|
|Message deferral|A queue or subscription client can defer retrieval of a message until a later time. The message remains in the queue or subscription, but is set aside.|
|Transactions|A transaction groups two or more operations together into an _execution scope_. Service Bus supports grouping operations against a single messaging entity within the scope of a single transaction. A message entity can be a queue, topic, or subscription.|
|Filtering and actions|Subscribers can define which messages they want to receive from a topic. These messages are specified in the form of one or more named subscription rules.|
|Autodelete on idle|Autodelete on idle enables you to specify an idle interval after which a queue is automatically deleted. The minimum duration is 5 minutes.|
|Duplicate detection|An error could cause the client to have a doubt about the outcome of a send operation. Duplicate detection enables the sender to resend the same message, or for the queue or topic to discard any duplicate copies.|
|Security protocols|Service Bus supports security protocols such as Shared Access Signatures (SAS), Role Based Access Control (RBAC) and Managed identities for Azure resources.|
|Geo-disaster recovery|When Azure regions or datacenters experience downtime, Geo-disaster recovery enables data processing to continue operating in a different region or datacenter.|
|Security|Service Bus supports standard AMQP 1.0 and HTTP/REST protocols.|

#### Compliance with standards and protocols

The primary wire protocol for Service Bus is [Advanced Messaging Queueing Protocol (AMQP) 1.0](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-amqp-overview), an open ISO/IEC standard. It allows customers to write applications that work against Service Bus and on-premises brokers such as ActiveMQ or RabbitMQ. The [AMQP protocol guide](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-amqp-protocol-guide) provides detailed information in case you want to build such an abstraction.

Service Bus Premium is fully compliant with the Java/Jakarta EE [Java Message Service (JMS) 2.0](https://learn.microsoft.com/en-us/azure/service-bus-messaging/how-to-use-java-message-service-20) API.

#### Client libraries

Fully supported Service Bus client libraries are available via the Azure SDK.

- [Azure Service Bus for .NET](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/service-bus)
- [Azure Service Bus libraries for Java](https://learn.microsoft.com/en-us/java/api/overview/azure/servicebus)
- [Azure Service Bus provider for Java JMS 2.0](https://learn.microsoft.com/en-us/azure/service-bus-messaging/how-to-use-java-message-service-20)
- [Azure Service Bus Modules for JavaScript and TypeScript](https://learn.microsoft.com/en-us/javascript/api/overview/azure/service-bus)
- [Azure Service Bus libraries for Python](https://learn.microsoft.com/en-us/python/api/overview/azure/servicebus)

### Discover Service Bus queues, topics, and subscriptions

The messaging entities that form the core of the messaging capabilities in Service Bus are **queues**, **topics and subscriptions**, and rules/actions.

#### Queues

Queues offer **First In, First Out** (FIFO) message delivery to one or more competing consumers. That is, receivers typically receive and process messages in the order in which they were added to the queue. And, only one message consumer receives and processes each message. Because messages are stored durably in the queue, producers (senders) and consumers (receivers) don't have to process messages concurrently.

A related benefit is **load-leveling**, which enables producers and consumers to send and receive messages at different rates. In many applications, the system load varies over time. However, the processing time required for each unit of work is typically constant. Intermediating message producers and consumers with a queue means that the consuming application only has to be able to handle average load instead of peak load.

Using queues to intermediate between message producers and consumers provides an inherent loose coupling between the components. Because producers and consumers aren't aware of each other, a consumer can be upgraded without having any effect on the producer.

You can create queues using the Azure portal, PowerShell, CLI, or Resource Manager templates. Then, send and receive messages using clients written in C#, Java, Python, and JavaScript.

#### Receive modes

You can specify two different modes in which Service Bus receives messages: **Receive and delete** or **Peek lock**.

##### Receive and delete

In this mode, when Service Bus receives the request from the consumer, it marks the message as consumed and returns it to the consumer application. This mode is the simplest model. It works best for scenarios in which the application can tolerate not processing a message if a failure occurs. For example, consider a scenario in which the consumer issues the receive request and then crashes before processing it. As Service Bus marks the message as consumed, the application begins consuming messages upon restart. It misses the message that it consumed before the crash.

##### Peek lock

In this mode, the receive operation becomes two-stage, which makes it possible to support applications that can't tolerate missing messages.

1. Finds the next message to be consumed, **locks** it to prevent other consumers from receiving it, and then, return the message to the application.
    
2. After the application finishes processing the message, it requests the Service Bus service to complete the second stage of the receive process. Then, the service **marks the message as consumed**.
    

If the application is unable to process the message for some reason, it can request the Service Bus service to **abandon** the message. Service Bus **unlocks** the message and makes it available to be received again, either by the same consumer or by another competing consumer. Secondly, there's a **timeout** associated with the lock. If the application fails to process the message before the lock timeout expires, Service Bus unlocks the message and makes it available to be received again.

#### Topics and subscriptions

A queue allows processing of a message by a single consumer. In contrast to queues, topics and subscriptions provide a one-to-many form of communication in a **publish and subscribe** pattern. It's useful for scaling to large numbers of recipients. Each published message is made available to each subscription registered with the topic. Publisher sends a message to a topic and one or more subscribers receive a copy of the message.

The subscriptions can use more filters to restrict the messages that they want to receive. Publishers send messages to a topic in the same way that they send messages to a queue. But, consumers don't receive messages directly from the topic. Instead, consumers receive messages from subscriptions of the topic. A topic subscription resembles a virtual queue that receives copies of the messages that are sent to the topic. Consumers receive messages from a subscription identically to the way they receive messages from a queue.

The message-sending functionality of a queue maps directly to a topic and its message-receiving functionality maps to a subscription. Among other things, this feature means that subscriptions support the same patterns described earlier in this section regarding queues: competing consumer, temporal decoupling, load leveling, and load balancing.

##### Rules and actions

In many scenarios, messages that have specific characteristics must be processed in different ways. To enable this processing, you can configure subscriptions to find messages that have desired properties and then perform certain modifications to those properties. While Service Bus subscriptions see all messages sent to the topic, you can only copy a subset of those messages to the virtual subscription queue. This filtering is accomplished using subscription filters. Such modifications are called **filter actions**. When a subscription is created, you can supply a filter expression that operates on the properties of the message. The properties can be both the system properties (for example, **Label**) and custom application properties (for example, **StoreName**.) The SQL filter expression is optional in this case. Without a SQL filter expression, any filter action defined on a subscription is performed on all the messages for that subscription.


### Explore Service Bus message payloads and serialization

Messages in Azure Service Bus carry a payload and metadata. The metadata consists of key-value pair properties that describe the payload and provide handling instructions for Service Bus and applications. Sometimes, metadata alone is enough for the sender to communicate information to receivers, leaving the payload empty.

The object model of the official Service Bus clients for Python supports serialization and mapping to the wire protocols that Service Bus uses. A Service Bus message consists of a binary payload that Service Bus does not process on the service side, along with two sets of properties:

- **Broker properties**: These are predefined system properties that either control message-level functionality within the broker or map to common metadata standards.
    
- **User properties**: These are key-value pairs defined and set by the application.
    

In Python, the `azure.servicebus` library provides classes such as `ServiceBusMessage`, which allow developers to create and handle messages with payloads and metadata efficiently. Developers can set system-defined broker properties and custom user properties within the message object.

#### Message routing and correlation

A subset of the broker properties, specifically `To`, `ReplyTo`, `ReplyToSessionId`, `MessageId`, `CorrelationId`, and `SessionId`, help applications route messages to particular destinations. The following patterns describe the routing:

- **Simple request/reply:** A publisher sends a message into a queue and expects a reply from the message consumer. The publisher owns a queue to receive the replies. The address of that queue is contained in the `ReplyTo` property of the outbound message. When the consumer responds, it copies the `MessageId` of the handled message into the `CorrelationId` property of the reply message and delivers the message to the destination indicated by the `ReplyTo` property. One message can yield multiple replies, depending on the application context.
    
- **Multicast request/reply:** As a variation of the prior pattern, a publisher sends the message into a topic and multiple subscribers become eligible to consume the message. Each of the subscribers might respond in the fashion described previously. If `ReplyTo` points to a topic, such a set of discovery responses can be distributed to an audience.
    
- **Multiplexing:** This session feature enables multiplexing of streams of related messages through a single queue or subscription such that each session (or group) of related messages, identified by matching `SessionId` values, are routed to a specific receiver while the receiver holds the session under lock. Learn more about the details of sessions [here](https://learn.microsoft.com/en-us/azure/service-bus-messaging/message-sessions).
    
- **Multiplexed request/reply:** This session feature enables multiplexed replies, allowing several publishers to share a reply queue. By setting `ReplyToSessionId`, the publisher can instruct one or more consumers to copy that value into the `SessionId` property of the reply message. The publishing queue or topic doesn't need to be session-aware. When the message is sent the publisher can wait for a session with the given `SessionId` to materialize on the queue by conditionally accepting a session receiver.
    

Routing inside of a Service Bus namespace uses autoforward chaining and topic subscription rules. Routing across namespaces can be performed using Azure LogicApps. The `To` property is reserved for future use. Applications that implement routing should do so based on user properties and not lean on the `To` property; however, doing so now won't cause compatibility issues.

## Payload serialization

When in transit or stored within Azure Service Bus, the payload remains an opaque, binary block. The `content_type` property allows applications to describe the payload, following the suggested MIME content-type format according to IETF RFC2045, such as `application/json;charset=utf-8`.

Unlike Java or .NET Standard variants, Python's Service Bus SDK (`azure.servicebus`) manages message serialization explicitly through byte streams rather than relying on hidden framework-based serialization.

The legacy SBMP protocol serializes objects using Python’s standard binary serializers or an externally supplied serializer. In contrast, the AMQP protocol serializes objects into an AMQP format. A receiver can extract those objects using the appropriate decoding method. With AMQP, objects are serialized into an AMQP graph of `list` and `dict` structures, allowing compatibility with AMQP clients.

While implicit serialization can be convenient, applications should take explicit control over object serialization—transforming object graphs into byte streams before adding them to a message. On the receiver side, they should perform the reverse operation. Although AMQP provides a powerful binary encoding model, it is closely tied to the AMQP messaging ecosystem, making it difficult for HTTP-based clients to decode such payloads.

### Exercise: Send and receive message from a Service Bus queue by using Python

#### Sign in to Azure

1. Launch the [Azure Cloud Shell](https://shell.azure.com/) and select **Bash** and the environment.
    
2. Create variables used in the Azure CLI commands. Replace `<myLocation>` with a region near you.
    
    
    ```bash
    myLocation=<myLocation>
    myNameSpaceName=az204svcbus$RANDOM
    ```
    

#### Create Azure resources

1. Create a resource group to hold the Azure resources you're creating.
    
    ```bash
    az group create --name az204-svcbus-rg --location $myLocation
    ```
    
2. Create a Service Bus messaging namespace. The following command creates a namespace using the variable you created earlier. The operation takes a few minutes to complete.
    
    ```bash
    az servicebus namespace create \
        --resource-group az204-svcbus-rg \
        --name $myNameSpaceName \
        --location $myLocation
    ```
    
3. Create a Service Bus queue
    
    ```bash
    az servicebus queue create --resource-group az204-svcbus-rg \
        --namespace-name $myNameSpaceName \
        --name az204-queue
    ```
    
##### Retrieve the connection string for the Service Bus Namespace

1. Open the Azure portal and navigate to the **az204-svcbus-rg** resource group.
    
2. Select the **az204svcbus** resource you created.
    
3. Select **Shared access policies** in the **Settings** section, then select the **RootManageSharedAccessKey** policy.
    
4. Copy the **Primary Connection String** from the dialog box that opens up and save it to a file, or leave the portal open and copy the key when needed.

#### Create console app to send messages to the queue
1. Open a local terminal and create, and change in to, a directory named _az204svcbus_ and then run the command to launch Visual Studio Code.
    
    ```bash
    code .
    ```
    
2. Open the terminal in Visual Studio Code by selecting **Terminal > New Terminal** in the menu bar and run the following commands to create the console app and add the **azure.servicebus** package.
    
    ```bash
    pip install azure-servicebus
    ```
    
3. In _app.py_, add the following `import` statements at the top of the file.
    
    ```python
    from azure.servicebus import ServiceBusClient, ServiceBusMessage
    ```
    
4. Add the following variables to the code and set the `connection_string` variable to the connection string that you obtained earlier.
    
    ```python
	    # connection string to your Service Bus namespace
		connection_str = "<CONNECTION STRING>"
		# name of your Service Bus queue
		queue_name = "az204-queue"
    ```
    
5. Add the following code below the variables you just added. See code comments for details.
    
    ```python
    def send_messages():
        # Create the ServiceBusClient which will be used to create a sender
        with ServiceBusClient.from_connection_string(connection_str) as client:
            sender = client.get_queue_sender(queue_name=queue_name)
            with sender:
                try:
                    # Create a batch to hold messages
                    message_batch = sender.create_message_batch()
                    for i in range(1, 4):
                        try:
                            # Attempt to add a message to the batch
                            message_batch.add_message(ServiceBusMessage(f"Message {i}"))
                        except ValueError as e:
                            raise Exception(f"Message {i} could not be added: {e}")
                    # Send the batch of messages to the queue
                    sender.send_messages(message_batch)
                    print("A batch of three messages has been published to the queue.")
                except Exception as e:
                    print("An error occurred while sending messages:", e)

    if __name__ == "__main__":
        send_messages()
        input("Press Enter to exit the sending script...")
    ```
    
6. Save and run the file using the `python app.py` command and wait for the following confirmation message.
    
    ```bash
    A batch of three messages has been published to the queue.
    ```
#### Review results
1. Sign in to the Azure portal and navigate to your Service Bus namespace.
    
2. Select **Queues** from the **Entities** section of the navigation pane, then select the **az204-queue** from the list.
    
3. Select the **Service Bus Explorer** in the Service Bus Queue navigation pane.
    
4. Select **Peek from start** and the three messages that were sent appear.
    
    ![Decorative.](https://learn.microsoft.com/en-gb/training/wwl-azure/discover-azure-message-queue/media/peek-messages.png)
#### Update project to receive messages to the queue
In this section, you update the app to receive messages from the queue.

1. Add the following code at the end of the existing code. See code comments for details.
    
    ```python
    def receive_messages():
        with ServiceBusClient.from_connection_string(connection_str) as client:
            # Create a receiver for the queue. The max_wait_time defines how long the receiver waits for messages.
            receiver = client.get_queue_receiver(queue_name=queue_name, max_wait_time=10)
            with receiver:
                # Retrieve messages (up to the maximum count available)
                messages = receiver.receive_messages(max_message_count=10)
                if messages:
                    for msg in messages:
                        print("Received:", msg)
                        # Complete the message so it's removed from the queue
                        receiver.complete_message(msg)
                else:
                    print("No messages were received within the wait period.")

    if __name__ == "__main__":
        # First, send messages
        send_messages()
        input("Press Enter to receive messages...")
        
        # Then, receive messages from the queue
        receive_messages()
        input("Press Enter to exit the application...")
    ```
    
2. Use the `python app.py` command to run the application. It sends three more messages to the queue and then retrieve all six messages. Press any key to stop the receiver and the application.
    
    ```bash
    Wait for a minute and then press any key to end the processing
    Received: Message 1
    Received: Message 2
    Received: Message 3
    Received: Message 1
    Received: Message 2
    Received: Message 3
    
    Stopping the receiver...
    Stopped receiving messages
    ```
    
    >**Note**: Since the application sent two batches of messages before retrieving them, you should see two batches of three messages represented in the output.
    
3. Return to the portal and select **Peek from start** again. Notice that no messages appear in the queue since we've retrieved them all.
#### Clean up resources

When the resources are no longer needed, you can use the `az group delete` command in the Azure Cloud Shell to remove the resource group.

```bash
az group delete --name az204-svcbus-rg --no-wait
```

### Explore Azure Queue Storage

Azure Queue Storage is a service for storing large numbers of messages. You access messages from anywhere in the world via authenticated calls using HTTP or HTTPS. A queue message can be up to 64 KB in size. A queue may contain millions of messages, up to the total capacity limit of a storage account. Queues are commonly used to create a backlog of work to process asynchronously.

The Queue service contains the following components:

![Image showing components of the queue service](https://learn.microsoft.com/en-gb/training/wwl-azure/discover-azure-message-queue/media/queue-storage-service-components.png)

- **URL format:** Queues are addressable using the URL format `https://<storage account>.queue.core.windows.net/<queue>`. For example, the following URL addresses a queue in the diagram above `https://myaccount.queue.core.windows.net/images-to-download`
    
- **Storage account:** All access to Azure Storage is done through a storage account.
    
- **Queue:** A queue contains a set of messages. All messages must be in a queue. The queue name must be all lowercase.
    
- **Message:** A message, in any format, of up to 64 KB. Before version 2017-07-29, the maximum time-to-live allowed is seven days. For version 2017-07-29 or later, the maximum time-to-live can be any positive number, or -1 indicating that the message doesn't expire. If this parameter is omitted, the default time-to-live is seven days.

### Create and manage Azure Queue Storage and messages by using Python

In this unit we're covering how to create queues and manage messages in Azure Queue Storage by showing code snippets from a Python project.

The code examples rely on the following Python packages:

- [azure-storage-queue](https://pypi.org/project/azure-storage-queue/): This package enables working with Azure Queue Storage for storing messages that are accessed by a client.
    
- [azure-core](https://pypi.org/project/azure-core/): Provides shared primitives, abstractions, and helpers for modern Azure SDK client libraries.
    

#### Create the Queue service client

The `QueueClient` class enables you to retrieve queues stored in Queue storage. Here's one way to create the service client:

```python
from azure.storage.queue import QueueClient

# Create the QueueClient instance from the connection string and queue name.
queue_client = QueueClient.from_connection_string(connection_string, queue_name)
```

#### Create a queue

This example shows how to create a queue if it doesn't already exist:

```python
import os
from azure.storage.queue import QueueClient

# Get the connection string from environment variables (or another config source)
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Instantiate a QueueClient which will be used to create and manipulate the queue
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Create the queue (if it doesn't already exist)
queue_client.create_queue()
```

#### Insert a message into a queue

To insert a message into an existing queue, call the `send_message` method. A message can be either a string (in UTF-8 format) or a byte array. The following code creates a queue (if it doesn't exist) and inserts a message:

```python
import os
from azure.storage.queue import QueueClient

# Get the connection string from environment variables
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Instantiate a QueueClient which will be used to create and manipulate the queue
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Create the queue if it doesn't already exist
queue_client.create_queue()

# Send a message to the queue
queue_client.send_message(message)
```

#### Peek at the next message

You can peek at the messages in the queue without removing them by calling the `peek_messages` method. If you don't pass a value for the `max_messages` parameter, the default is to peek at one message.

```python
import os
from azure.storage.queue import QueueClient

# Get the connection string from environment variables
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Instantiate a QueueClient which will be used to manipulate the queue
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Peek at the next message
peeked_messages = queue_client.peek_messages()
```

#### Change the contents of a queued message

You can change the contents of a message in-place in the queue. If the message represents a work task, you could use this feature to update the status of the work task. The following code updates the queue message with new contents and sets the visibility timeout to extend another 60 seconds. This saves the state of work associated with the message and gives the client another minute to continue working on the message.

```python
import os
from azure.storage.queue import QueueClient

# Get the connection string from environment variables
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Instantiate a QueueClient which will be used to manipulate the queue
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Retrieve messages from the queue (this returns a generator, so we convert it to a list)
messages = list(queue_client.receive_messages())

if messages:
    # Update the message contents with "Updated contents" and extend the visibility timeout to 60 seconds
    queue_client.update_message(
        messages[0].id, 
        messages[0].pop_receipt, 
        "Updated contents", 
        visibility_timeout=60
    )
```

#### Dequeue the next message

Dequeue a message from a queue in two steps. When you call `receive_messages`, you get the next message in the queue. A message returned from `receive_messages` becomes invisible to any other code reading messages from this queue. By default, this message stays invisible for 30 seconds. To finish removing the message from the queue, you must also call `delete_message`. This two-step process ensures that if your code fails to process a message due to hardware or software failure, another instance of your code can get the same message and try again. Your code calls `delete_message` right after the message has been processed.

```python
import os
from azure.storage.queue import QueueClient

# Get the connection string from environment variables
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Instantiate a QueueClient which will be used to manipulate the queue
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Retrieve the next message (as a list)
messages = list(queue_client.receive_messages())

if messages:
    # Process (i.e., print) the message within the visibility timeout period
    print(f"Dequeued message: '{messages[0].content}'")
    
    # Delete the message from the queue
    queue_client.delete_message(messages[0].id, messages[0].pop_receipt)
```

#### Get the queue length

You can get an estimate of the number of messages in a queue. The `get_queue_properties` method returns queue properties including the message count. The `approximate_message_count` attribute contains the approximate number of messages in the queue. This number isn't lower than the actual number of messages in the queue but could be higher.

```python
import os
from azure.storage.queue import QueueClient

# Instantiate a QueueClient which will be used to manipulate the queue
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Retrieve the queue properties
properties = queue_client.get_queue_properties()

# Retrieve the cached approximate message count
cached_messages_count = properties.approximate_message_count

# Display the number of messages in the queue
print(f"Number of messages in queue: {cached_messages_count}")
```

#### Delete a queue

To delete a queue and all the messages contained in it, call the `delete_queue` method on the queue client object.

```python
import os
from azure.storage.queue import QueueClient

# Get the connection string from environment variables
connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")

# Instantiate a QueueClient which will be used to manipulate the queue
queue_client = QueueClient.from_connection_string(connection_string, queue_name)

# Delete the queue
queue_client.delete_queue()
```

### Send and receive messages from Azure Queue storage

#### Create Azure Queue storage resources
#### Create a Python console app to send and receive messages

Now that the needed resources are deployed to Azure the next step is to set up the console application. The following steps are performed in the cloud shell.

1. Run the following commands to create a directory to contain the project and change into the project directory.
    
    
    ```
    mkdir queuestor
    cd queuestor
    ```
    
2. Run the following commands to add the **Azure.Storage.Queues** and **Azure.Identity** packages to the project.
    
    ```
    pip install azure-storage-queue
    pip install azure-identity
    ```
    

### Add the starter code for the project

1. Run the following command in the cloud shell to begin editing the application.
    
    ```bash
    code script.py
    ```
    
2. Replace any existing contents with the following code. Be sure to review the comments in the code, and replace with the storage account name you recorded earlier.
    
    ```python
    import os
    import uuid
    from azure.identity import DefaultAzureCredential
    from azure.storage.queue import QueueClient

    # Create a unique name for the queue
    # TODO: Replace the <YOUR-STORAGE-ACCT-NAME> placeholder 
    queue_name = "myqueue-" + str(uuid.uuid4())
    storage_account_name = "<YOUR-STORAGE-ACCT-NAME>"

    # ADD CODE TO CREATE A QUEUE CLIENT AND CREATE A QUEUE



    # ADD CODE TO SEND AND LIST MESSAGES



    # ADD CODE TO UPDATE A MESSAGE AND LIST MESSAGES



    # ADD CODE TO DELETE MESSAGES AND THE QUEUE

    ```
    
3. Press **ctrl+s** to save your changes.
    

### Add code to create a queue client and create a queue

Now it's time to add code to create the queue storage client and create a queue.

1. Locate the **# ADD CODE TO CREATE A QUEUE CLIENT AND CREATE A QUEUE** comment and add the following code directly after the comment. Be sure to review the code and comments.
    
    ```python
    # Create a DefaultAzureCredential instance
    credential = DefaultAzureCredential()

    # Instantiate a QueueClient to create and interact with the queue
    account_url = f"https://{storage_account_name}.queue.core.windows.net"
    queue_client = QueueClient(account_url, queue_name=queue_name, credential=credential)

    print(f"Creating queue: {queue_name}")

    # Create the queue
    queue_client.create_queue()

    print("Queue created, press Enter to add messages to the queue...")
    input()
    ```
    
2. Press **ctrl+s** to save the file, then continue with the exercise.
    

### Add code to send and list messages in a queue

1. Locate the **# ADD CODE TO SEND AND LIST MESSAGES** comment and add the following code directly after the comment. Be sure to review the code and comments.
    
    ```python
    # Send several messages to the queue with the send_message method.
    queue_client.send_message("Message 1")
    queue_client.send_message("Message 2")

    # Send a message and save the result for later use
    saved_message = queue_client.send_message("Message 3")

    print("Messages added to the queue. Press Enter to peek at the messages...")
    input()

    # Peeking messages lets you view the messages without removing them from the queue.
    peeked_messages = queue_client.peek_messages(max_messages=10)
    for message in peeked_messages:
        print(f"Message: {message.content}")

    print("\nPress Enter to update a message in the queue...")
    input()
    ```
    
2. Press **ctrl+s** to save the file, then continue with the exercise.
    

### Add code to update a message and list the results

1. Locate the **# ADD CODE TO UPDATE A MESSAGE AND LIST MESSAGES** comment and add the following code directly after the comment. Be sure to review the code and comments.
    
    ```python
    # Update a message with the update_message method and the saved message
    queue_client.update_message(
        saved_message.id,
        saved_message.pop_receipt,
        "Message 3 has been updated"
    )

    print("Message three updated. Press Enter to peek at the messages again...")
    input()

    # Peek messages from the queue to compare updated content
    peeked_messages = queue_client.peek_messages(max_messages=10)
    for message in peeked_messages:
        print(f"Message: {message.content}")

    print("\nPress Enter to delete messages from the queue...")
    input()
    ```
    
2. Press **ctrl+s** to save the file, then continue with the exercise.
    

### Add code to delete messages and the queue

1. Locate the **# ADD CODE TO DELETE MESSAGES AND THE QUEUE** comment and add the following code directly after the comment. Be sure to review the code and comments.
    
    ```python
    # Receive and delete messages from the queue
    messages = queue_client.receive_messages(max_messages=10)
    for message in messages:
        # "Process" the message
        print(f"Deleting message: {message.content}")

        # Let the service know we're finished with the message and it can be safely deleted.
        queue_client.delete_message(message.id, message.pop_receipt)

    print("Messages deleted from the queue.")
    print("\nPress Enter key to delete the queue...")
    input()

    # Delete the queue with the delete_queue method.
    print(f"Deleting queue: {queue_name}")
    queue_client.delete_queue()

    print("Done")
    ```
    
2. Press **ctrl+s** to save the file, then **ctrl+q** to exit the editor.
#### Sign into Azure and run the app

1. In the cloud shell command-line pane, enter the following command to sign into Azure.
    
    
    ```bash
    az login
    ```
    
    **You must sign into Azure - even though the cloud shell session is already authenticated.**
    
    > **Note**: In most scenarios, just using _az login_ will be sufficient. However, if you have subscriptions in multiple tenants, you may need to specify the tenant by using the _--tenant_ parameter. See [Sign into Azure interactively using Azure CLI](https://learn.microsoft.com/cli/azure/authenticate-azure-cli-interactively) for details.
    
2. Run the following command to start the console app. The app will pause many times during execution waiting for you to press any key to continue. This gives you an opportunity to view the messages in the Azure portal.
    
    
    ```bash
    python script.py
    ```
    
3. In the Azure portal, navigate to the Azure Storage account you created.
    
4. Expand **> Data storage** in the left navigation and select **Queues**.
    
5. Select the queue the application creates and you can view the sent messages and monitor what the application is doing.
#### Clean up resources
Now that you finished the exercise, you should delete the cloud resources you created to avoid unnecessary resource usage.

1. Navigate to the resource group you created and view the contents of the resources used in this exercise.
2. On the toolbar, select **Delete resource group**.
3. Enter the resource group name and confirm that you want to delete it.

> **CAUTION:** Deleting a resource group deletes all resources contained within it. If you chose an existing resource group for this exercise, any existing resources outside the scope of this