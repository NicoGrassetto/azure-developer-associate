# Develop solutions that use Azure Cosmos DB
## Explore Azure Cosmos DB
### Introduction

Azure Cosmos DB is a globally distributed database system that allows you to read and write data from the local replicas of your database and it transparently replicates the data to all the regions associated with your Cosmos account.

### Identify key benefits of Azure Cosmos DB

Azure **Cosmos** DB is a fully managed NoSQL database designed to provide low latency, elastic scalability of throughput, well-defined semantics for data consistency, and high availability.

You can configure your databases to be globally distributed and available in any of the Azure regions. To lower the latency, place the data close to where your users are. Choosing the required regions depends on the global reach of your application and where your users are located.

With Azure Cosmos DB, you can add or remove the regions associated with your account at any time. Your application doesn't need to be paused or redeployed to add or remove a region.

#### Key benefits of global distribution

With its novel multi-master replication protocol, every region supports both writes and reads. The multi-master capability also enables:

- Unlimited elastic write and read scalability.
- 99.999% read and write availability all around the world.
- Guaranteed reads and writes served in less than 10 milliseconds at the 99th percentile.

Your application can perform near real-time reads and writes against all the regions you chose for your database. Azure Cosmos DB internally handles the data replication between regions with consistency level guarantees of the level you selected.

Running a database in multiple regions worldwide increases the availability of a database. If one region is unavailable, other regions automatically handle application requests. Azure Cosmos DB offers 99.999% read and write availability for multi-region databases.
### Explore the resource hierarchy

The Azure Cosmos DB account is the fundamental unit of global distribution and high availability. Your Azure Cosmos DB account contains a unique Domain Name System (DNS) name and you can manage an account by using the Azure portal or the Azure CLI, or by using different language-specific SDKs. For globally distributing your data and throughput across multiple Azure regions, you can add and remove Azure regions to your account at any time.

#### Elements in an Azure Cosmos DB account

An Azure Cosmos DB container is the fundamental unit of scalability. You can virtually have an unlimited provisioned throughput (RU/s) and storage on a container. Azure Cosmos DB transparently partitions your container using the logical partition key that you specify in order to elastically scale your provisioned throughput and storage.

Currently, you can create a maximum of 50 Azure Cosmos DB accounts under an Azure subscription (can be increased via support request). After you create an account under your Azure subscription, you can manage the data in your account by creating databases, containers, and items.

The following image shows the hierarchy of different entities in an Azure Cosmos DB account:

![Image showing the hierarchy of Azure Cosmos DB entities: Database accounts are at the top, databases are grouped under accounts, and containers are grouped under databases.](https://learn.microsoft.com/en-us/training/wwl-azure/explore-azure-cosmos-db/media/cosmos-entities.png)

#### Azure Cosmos DB databases

You can create one or multiple Azure Cosmos DB databases under your account. A database is analogous to a namespace. A database is the unit of management for a set of Azure Cosmos DB containers.

#### Azure Cosmos DB containers

An Azure Cosmos DB container is where data is stored. Unlike most relational databases, which scale up with larger sizes of virtual machines, Azure Cosmos DB scales out.

Data is stored on one or more servers called _partitions_. To increase partitions, you increase throughput, or they grow automatically as storage increases. This relationship provides a virtually unlimited amount of throughput and storage for a container.

When you create a container, you need to supply a partition key. The partition key is a property that you select from your items to help Azure Cosmos DB distribute the data efficiently across partitions. Azure Cosmos DB uses the value of this property to route data to the appropriate partition to be written, updated, or deleted. You can also use the partition key in the `WHERE` clause in queries for efficient data retrieval.

The underlying storage mechanism for data in Azure Cosmos DB is called a _physical partition_. Physical partitions can have a throughput amount up to 10,000 Request Units per second, and they can store up to 50 GB of data. Azure Cosmos DB abstracts this partitioning concept with a logical partition, which can store up to 20 GB of data.

When you create a container, you configure throughput in one of the following modes:

- **Dedicated throughput**: The throughput on a container is exclusively reserved for that container. There are two types of dedicated throughput: standard and autoscale.
    
- **Shared throughput**: Throughput is specified at the database level and then shared with up to 25 containers within the database. Sharing of throughput excludes containers that are configured with their own dedicated throughput.
    

#### Azure Cosmos DB items

Depending on which API you use, individual data entities can be represented in various ways:

|Azure Cosmos DB entity|API for NoSQL|API for Cassandra|API for MongoDB|API for Gremlin|API for Table|
|---|---|---|---|---|---|
|Azure Cosmos DB item|Item|Row|Document|Node or edge|Item|
### Explore consistency levels

Azure Cosmos DB approaches data consistency as a spectrum of choices instead of two extremes. Strong consistency and eventual consistency are at the ends of the spectrum, but there are many consistency choices along the spectrum. Developers can use these options to make precise choices and granular tradeoffs with respect to high availability and performance.

Azure Cosmos DB offers five well-defined levels. From strongest to weakest, the levels are:

- Strong
- Bounded staleness
- Session
- Consistent prefix
- Eventual

Each level provides availability and performance tradeoffs. The following image shows the different consistency levels as a spectrum.

![Image showing data consistency as a spectrum.](https://learn.microsoft.com/en-us/training/wwl-azure/explore-azure-cosmos-db/media/five-consistency-levels.png)

The consistency levels are region-agnostic and are guaranteed for all operations, regardless of:

- The region where the reads and writes are served
- The number of regions associated with your Azure Cosmos DB account
- Whether your account is configured with a single or multiple write regions.

Read consistency applies to a single read operation scoped within a partition-key range or a logical partition.

### Choose the right consistency level

Each of the consistency models can be used for specific real-world scenarios. Each provides precise availability and performance tradeoffs backed by comprehensive SLAs. The following simple considerations help you make the right choice in many common scenarios.

#### Configure the default consistency level

You can configure the default consistency level on your Azure Cosmos DB account at any time. The default consistency level configured on your account applies to all Azure Cosmos DB databases and containers under that account. All reads and queries issued against a container or a database use the specified consistency level by default.

Read consistency applies to a single read operation scoped within a logical partition. The read operation can be issued by a remote client or a stored procedure.

#### Guarantees associated with consistency levels

Azure Cosmos DB guarantees that 100 percent of read requests meet the consistency guarantee for the consistency level chosen. The precise definitions of the five consistency levels in Azure Cosmos DB using the TLA+ specification language are provided in the [azure-cosmos-tla](https://github.com/Azure/azure-cosmos-tla) GitHub repo.

##### Strong consistency

Strong consistency offers a linearizability guarantee. Linearizability refers to serving requests concurrently. The reads are guaranteed to return the most recent committed version of an item. A client never sees an uncommitted or partial write. Users are always guaranteed to read the latest committed write.

##### Bounded staleness consistency

In bounded staleness consistency, the lag of data between any two regions is always less than a specified amount. The amount can be _K_ versions (that is, _updates_) of an item or by _T_ time intervals, whichever is reached first. In other words, when you choose bounded staleness, the maximum "staleness" of the data in any region can be configured in two ways:

- The number of versions (_K_) of the item
- The time interval (_T_) reads might lag behind the writes

Bounded Staleness is beneficial primarily to single-region write accounts with two or more regions. If the data lag in a region (determined per physical partition) exceeds the configured staleness value, writes for that partition are throttled until staleness is back within the configured upper bound.

For a single-region account, Bounded Staleness provides the same write consistency guarantees as Session and Eventual Consistency. With Bounded Staleness, data is replicated to a local majority (three replicas in a four replica set) in the single region.

##### Session consistency

In session consistency, within a single client session, reads are guaranteed to honor the read-your-writes, and write-follows-reads guarantees. This guarantee assumes a single “writer" session or sharing the session token for multiple writers.

Like all consistency levels weaker than Strong, writes are replicated to a minimum of three replicas (in a four replica set) in the local region, with asynchronous replication to all other regions.

##### Consistent prefix consistency

In consistent prefix, updates made as single document writes see eventual consistency. Updates made as a batch within a transaction, are returned consistent to the transaction in which they were committed. Write operations within a transaction of multiple documents are always visible together.

Assume two write operations are performed on documents _Doc 1_ and _Doc 2_, within transactions T1 and T2. When client does a read in any replica, the user sees either "_Doc 1_ v1 and _Doc 2_ v1" or "_Doc 1_ v2 and _Doc 2_ v2," but never "_Doc 1_ v1 and _Doc 2_ v2" or "_Doc 1_ v2 and _Doc 2_ v1" for the same read or query operation.

##### Eventual consistency

In eventual consistency, there's no ordering guarantee for reads. In the absence of any further writes, the replicas eventually converge.

Eventual consistency is the weakest form of consistency because a client might read the values that are older than the ones it read before. Eventual consistency is ideal where the application doesn't require any ordering guarantees. Examples include count of Retweets, Likes, or nonthreaded comments
### Explore supported APIs

Azure Cosmos DB offers multiple database APIs, which include NoSQL, MongoDB, PostgreSQL, Cassandra, Gremlin, and Table. By using these APIs, you can model real world data using documents, key-value, graph, and column-family data models. These APIs allow your applications to treat Azure Cosmos DB as if it were various other databases technologies, without the overhead of management, and scaling approaches. Azure Cosmos DB helps you to use the ecosystems, tools, and skills you already have for data modeling and querying with its various APIs.

All the APIs offer automatic scaling of storage and throughput, flexibility, and performance guarantees. There's no one best API, and you can choose any one of the APIs to build your application

#### Considerations when choosing an API

API for NoSQL is native to Azure Cosmos DB.

API for MongoDB, PostgreSQL, Cassandra, Gremlin, and Table implement the wire protocol of open-source database engines. These APIs are best suited if the following conditions are true:

- If you have existing MongoDB, PostgreSQL, Cassandra, or Gremlin applications
- If you don't want to rewrite your entire data access layer
- If you want to use the open-source developer ecosystem, client-drivers, expertise, and resources for your database

#### API for NoSQL

The Azure Cosmos DB API for NoSQL stores data in document format. It offers the best end-to-end experience as we have full control over the interface, service, and the SDK client libraries. Any new feature that is rolled out to Azure Cosmos DB is first available on API for NoSQL accounts. NoSQL accounts provide support for querying items using the Structured Query Language (SQL) syntax.

#### API for MongoDB

The Azure Cosmos DB API for MongoDB stores data in a document structure, via BSON format. It's compatible with MongoDB wire protocol; however, it doesn't use any native MongoDB related code. The API for MongoDB is a great choice if you want to use the broader MongoDB ecosystem and skills, without compromising on using Azure Cosmos DB features.

#### API for PostgreSQL

Azure Cosmos DB for PostgreSQL is a managed service for running PostgreSQL at any scale, with the [Citus open source](https://github.com/citusdata/citus) superpower of distributed tables. It stores data either on a single node, or distributed in a multi-node configuration.

#### API for Apache Cassandra

The Azure Cosmos DB API for Cassandra stores data in column-oriented schema. Apache Cassandra offers a highly distributed, horizontally scaling approach to storing large volumes of data while offering a flexible approach to a column-oriented schema. API for Cassandra in Azure Cosmos DB aligns with this philosophy to approaching distributed NoSQL databases. This API for Cassandra is wire protocol compatible with native Apache Cassandra.

#### API for Apache Gremlin

The Azure Cosmos DB API for Gremlin allows users to make graph queries and stores data as edges and vertices.

Use the API for Gremlin for scenarios:

- Involving dynamic data
- Involving data with complex relations
- Involving data that is too complex to be modeled with relational databases
- If you want to use the existing Gremlin ecosystem and skills

#### API for Table

The Azure Cosmos DB API for Table stores data in key/value format. If you're currently using Azure Table storage, you might see some limitations in latency, scaling, throughput, global distribution, index management, low query performance. API for Table overcomes these limitations and the recommendation is to migrate your app if you want to use the benefits of Azure Cosmos DB. API for Table only supports OLTP scenarios.

### Discover request units

With Azure Cosmos DB, you pay for the throughput you provision and the storage you consume on an hourly basis. Throughput must be provisioned to ensure that sufficient system resources are available for your Azure Cosmos database always.

The cost of all database operations is normalized in Azure Cosmos DB and expressed by _request units_ (or RUs, for short). A request unit represents the system resources such as CPU, IOPS, and memory that are required to perform the database operations supported by Azure Cosmos DB.

The cost to do a point read, which is fetching a single item by its ID and partition key value, for a 1-KB item is 1RU. All other database operations are similarly assigned a cost using RUs. No matter which API you use to interact with your Azure Cosmos container, costs are measured by RUs. Whether the database operation is a write, point read, or query, costs are measured in RUs.

The following image shows the high-level idea of RUs:

![Image showing how database operations consume request units.](https://learn.microsoft.com/en-us/training/wwl-azure/explore-azure-cosmos-db/media/request-units.png)

The type of Azure Cosmos DB account you're using determines the way consumed RUs get charged. There are two modes for account creation:

- **Provisioned throughput mode**: In this mode, you provision the number of RUs for your application on a per-second basis in increments of 100 RUs per second. To scale the provisioned throughput for your application, you can increase or decrease the number of RUs at any time in increments or decrements of 100 RUs. You can make your changes either programmatically or by using the Azure portal. You can provision throughput at container and database granularity level.
    
- **Serverless mode**: In this mode, you don't have to provision any throughput when creating resources in your Azure Cosmos DB account. At the end of your billing period, you get billed for the number of request units consumed by your database operations.
### Create Azure Cosmos DB resources by using the Azure portal

In this exercise you learn how to perform the following actions in the Azure portal:

- Create an Azure Cosmos DB account
- Add a database and a container
- Add data to your database
- Clean up resources

#### Prerequisites

- An Azure account with an active subscription. If you don't already have one, you can sign up for a free trial at [https://azure.com/free](https://azure.com/free).

#### Create an Azure Cosmos DB account

1. Sign-in to the [Azure portal](https://portal.azure.com/).
    
2. From the Azure portal navigation pane, select **+ Create a resource**.
    
3. Search for **Azure Cosmos DB**, then select **Create/Azure Cosmos DB** to get started.
    
4. On the **Which API best suits your workload?** page, select **Create** in the **Azure Cosmos DB for NoSQL** box.
    
5. In the **Create Azure Cosmos DB Account - Azure Cosmos DB for NoSQL** page, enter the basic settings for the new Azure Cosmos DB account.
    
    - **Subscription**: Select the subscription you want to use.
    - **Resource Group**: Select **Create new**, then enter _az204-cosmos-rg_.
    - **Account Name**: Enter a _unique_ name to identify your Azure Cosmos account. The name can only contain lowercase letters, numbers, and the hyphen (-) character. It must be between 3-31 characters in length.
    - **Availability Zones**: Select **Disable**.
    - **Location**: Use the location that is closest to your users to give them the fastest access to the data.
    - **Capacity mode**: Select **Serverless**.
6. Select **Review + create**.
    
7. Review the account settings, and then select **Create**. It takes a few minutes to create the account. Wait for the portal page to display **Your deployment is complete**.
    
8. Select **Go to resource** to go to the Azure Cosmos DB account page.
    

#### Add a database and a container

You can use the Data Explorer in the Azure portal to create a database and container.

1. Select **Data Explorer** from the left navigation on your Azure Cosmos DB account page, and then select **New Container**.
    
    ![You can add a container using the Data Explorer.](https://learn.microsoft.com/en-us/training/wwl-azure/explore-azure-cosmos-db/media/portal-cosmos-new-container.png)
    
2. In the **New container** pane, enter the settings for the new container.
    
    - **Database ID**: Select **Create new**, and enter _ToDoList_.
    - **Container ID**: Enter _Items_
    - **Partition key**: Enter _/category_. The samples in this demo use _/category_ as the partition key.
3. Select **OK**. The Data Explorer displays the new database and the container that you created.
    

#### Add data to your database

Add data to your new database using Data Explorer.

1. In **Data Explorer**, expand the **ToDoList** database, and expand the **Items** container. Next, select **Items**, and then select **New Item**.
    
    ![Create new item in the database.](https://learn.microsoft.com/en-us/training/wwl-azure/explore-azure-cosmos-db/media/portal-cosmos-new-data.png)
    
1. Add the following structure to the item on the right side of the **Items** pane:
    
    ```json
    {
        "id": "1",
        "category": "personal",
        "name": "groceries",
        "description": "Pick up apples and strawberries.",
        "isComplete": false
    }
    ```
    
2. Select **Save**.
    
3. Select **New Item** again, and create and save another item with a unique `id`, and any other properties and values you want. Your items can have any structure, because Azure Cosmos DB doesn't impose any schema on your data.
    

#### Clean up resources

1. Select **Overview** from the left navigation on your Azure Cosmos DB account page.
    
2. Select the **az204-cosmos-rg** resource group link in the Essentials group.
    
3. Select **Delete** resource group and follow the directions to delete the resource group and all of the resources it contains.

## Work with Azure Cosmos DB
### Introduction

This module is an introduction to both client and server-side programming on Azure Cosmos DB.
### Explore Microsoft Python SDK for Azure Cosmos DB

This **unit** focuses on Azure Cosmos DB Python SDK for API for NoSQL. (**azure-cosmos** PyPI package.) If you're familiar with the previous version of the Python SDK, you might be familiar with the terms collection and document.

The [azure-sdk-for-python](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cosmos/azure-cosmos/samples) GitHub repository includes the latest Python sample solutions. You use these solutions to perform CRUD (create, read, update, and delete) and other common operations on Azure Cosmos DB resources.

Because Azure Cosmos DB supports multiple API models, the Python SDK uses the generic terms _container_ and _item_. A _**container**_ can be a collection, graph, or table. An _**item**_ can be a document, edge/vertex, or row, and is the content inside a container.

Following are examples showing some of the key operations you should be familiar with. For more examples, please visit the GitHub link shown earlier. The examples below use the synchronous version of the methods (async versions are also available via `azure.cosmos.aio`).

#### CosmosClient

Creates a new `CosmosClient` with a connection string. `CosmosClient` is thread-safe. The recommendation is to maintain a single instance of `CosmosClient` per lifetime of the application that enables efficient connection management and performance.

```python
from azure.cosmos import CosmosClient

client = CosmosClient(url=endpoint, credential=key)
```

#### Database examples

##### Create a database

The `CosmosClient.create_database` method throws an exception if a database with the same name already exists.

```python
# New instance of DatabaseProxy class referencing the server-side database
database1 = client.create_database(id="adventureworks-1")
```

The `CosmosClient.create_database_if_not_exists` checks if a database exists, and if it doesn't, creates it. Only the database `id` is used to verify if there's an existing database.

```python
# New instance of DatabaseProxy class referencing the server-side database
database2 = client.create_database_if_not_exists(id="adventureworks-2")
```

##### Read a database by ID

Reads a database from the Azure Cosmos DB service.

```python
# Gets a DatabaseProxy reference with the ID property of the database you wish to read.
database = client.get_database_client(database=database_id)
properties = database.read()
```

##### Delete a database

Delete a Database.

```python
client.delete_database(database=database_id)
```

#### Container examples

##### Create a container

The `DatabaseProxy.create_container_if_not_exists` method checks if a container exists, and if it doesn't, it creates it. Only the container `id` is used to verify if there's an existing container.

```python
from azure.cosmos import PartitionKey

# Set throughput to the minimum value of 400 RU/s
container = database.create_container_if_not_exists(
    id=container_id,
    partition_key=PartitionKey(path=partition_key),
    offer_throughput=400
)
```

##### Get a container by ID

```python
container = database.get_container_client(container=container_id)
container_properties = container.read()
```

##### Delete a container

Delete a Container.

```python
database.delete_container(container=container_id)
```

#### Item examples

##### Create an item

Use the `ContainerProxy.create_item` method to create an item. The method requires a dictionary that must contain an `id` property, and a `partitionKey`.

```python
response = container.create_item(body=sales_order)
```

##### Read an item

Use the `ContainerProxy.read_item` method to read an item. The method requires an `id` property, and a `partitionKey`.

```python
item_id = "[id]"
account_number = "[partition-key]"
response = container.read_item(item=item_id, partition_key=account_number)
```

##### Query an item

The `ContainerProxy.query_items` method creates a query for items under a container in an Azure Cosmos database using a SQL statement with parameterized values. It returns an iterable.

```python
query = "SELECT * FROM sales s WHERE s.AccountNumber = @AccountInput"
parameters = [{"name": "@AccountInput", "value": "Account1"}]

result_set = container.query_items(
    query=query,
    parameters=parameters,
    partition_key="Account1",
    max_item_count=1
)

for item in result_set:
    print(item)
```

#### Other resources

- The [azure-sdk-for-python](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cosmos/azure-cosmos/samples) GitHub repository includes the latest Python sample solutions to perform CRUD and other common operations on Azure Cosmos DB resources.
    
- Visit this article [Azure Cosmos DB Python SDK examples for the SQL API](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/samples-python) for direct links to specific examples in the GitHub repository.

### Create resources in Azure Cosmos DB for NoSQL using Python

In this exercise, you create an Azure Cosmos DB account and build a Python console application that uses the Azure Cosmos DB SDK to create a database, container, and sample item. You learn how to configure authentication, perform database operations programmatically, and verify your results in the Azure portal.

Tasks performed in this exercise:

- Create an Azure Cosmos DB account
- Create a console app that creates a database, container, and an item
- Run the console app and verify results

This exercise takes approximately **30** minutes to complete.

#### Create an Azure Cosmos DB account

In this section of the exercise you create a resource group and Azure Cosmos DB account. You also record the endpoint, and access key for the account.

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
    
2. Use the **[>_]** button to the right of the search bar at the top of the page to create a new cloud shell in the Azure portal, selecting a _**Bash**_ environment. The cloud shell provides a command line interface in a pane at the bottom of the Azure portal. If you are prompted to select a storage account to persist your files, select **No storage account required**, your subscription, and then select **Apply**.
    
    > **Note**: If you have previously created a cloud shell that uses a _PowerShell_ environment, switch it to _**Bash**_.
    
3. In the cloud shell toolbar, in the **Settings** menu, select **Go to Classic version** (this is required to use the code editor).
    
4. Create a resource group for the resources needed for this exercise.. If you already have a resource group you want to use, proceed to the next step. Replace **myResourceGroup** with a name you want to use for the resource group. You can replace **eastus** with a region near you if needed.
    
    ```shell
    az group create --location eastus --name myResourceGroup
    ```
    
5. Many of the commands require unique names and use the same parameters. Creating some variables will reduce the changes needed to the commands that create resources. Run the following commands to create the needed variables. Replace **myResourceGroup** with the name you're using for this exercise.
    
    ```shell
    resourceGroup=myResourceGroup
    accountName=cosmosexercise$RANDOM
    ```
    
6. Run the following commands to create the Azure Cosmos DB account, each account name must be unique.
    
    ```shell
    az cosmosdb create --name $accountName \
        --resource-group $resourceGroup
    ```
    
7. Run the following command to retrieve the **documentEndpoint** for the Azure Cosmos DB account. Record the endpoint from the command results, it's needed later in the exercise.
    
    ```shell
    az cosmosdb show --name $accountName \
        --resource-group $resourceGroup \
        --query "documentEndpoint" --output tsv
    ```
    
8. Retrieve the primary key for the account with the following command. Record the primary key from the command results, it's needed later in the exercise.
    
    ```shell
    az cosmosdb keys list --name $accountName \
        --resource-group $resourceGroup \
        --query "primaryMasterKey" --output tsv
    ```
    

#### Create data resources and an item with a Python console application

Now that the needed resources are deployed to Azure the next step is to set up the console application. The following steps are performed in the cloud shell.

> **Tip:** Resize the cloud shell to display more information, and code, by dragging the top border. You can also use the minimize and maximize buttons to switch between the cloud shell and the main portal interface.

1. Create a folder for the project and change in to the folder.
    
    ```shell
    mkdir cosmosdb
    cd cosmosdb
    ```
    
2. Create the Python application file.
    
    ```shell
    touch app.py
    ```
    

##### Configure the console application

1. Run the following command to install the **azure-cosmos** and **python-dotenv** packages.
    
    ```shell
    pip install azure-cosmos python-dotenv
    ```
    
2. Run the following command to create the **.env** file to hold the secrets, and then open it in the code editor.
    
    ```shell
    touch .env
    code .env
    ```
    
3. Add the following code to the **.env** file. Replace **YOUR_DOCUMENT_ENDPOINT** and **YOUR_ACCOUNT_KEY** with the values you recorded earlier.
    
    ```
    DOCUMENT_ENDPOINT="YOUR_DOCUMENT_ENDPOINT"
    ACCOUNT_KEY="YOUR_ACCOUNT_KEY"
    ```
    
4. Press **ctrl+s** to save the file, then **ctrl+q** to exit the editor.
    

Now it's time to replace the template code in the **app.py** file using the editor in the cloud shell.

##### Add the starting code for the project

1. Run the following command in the cloud shell to begin editing the application.
    
    ```shell
    code app.py
    ```
    
2. Replace any existing code with the following code snippet.
    
    The code provides the overall structure of the app. Review the comments in the code to get an understanding of how it works. To complete the application, you add code in specified areas later in the exercise.
    
    ```python
    import os
    import uuid
    from azure.cosmos import CosmosClient, exceptions
    from dotenv import load_dotenv
    
    database_name = "myDatabase"  # Name of the database to create or use
    container_name = "myContainer"  # Name of the container to create or use
    
    # Load environment variables from .env file
    load_dotenv()
    cosmos_db_account_url = os.getenv("DOCUMENT_ENDPOINT")
    account_key = os.getenv("ACCOUNT_KEY")
    
    if not cosmos_db_account_url or not account_key:
        print("Please set the DOCUMENT_ENDPOINT and ACCOUNT_KEY environment variables.")
        exit()
    
    # CREATE THE COSMOS DB CLIENT USING THE ACCOUNT URL AND KEY
    
    
    try:
        # CREATE A DATABASE IF IT DOESN'T ALREADY EXIST
    
    
        # CREATE A CONTAINER WITH A SPECIFIED PARTITION KEY
    
    
        # DEFINE A TYPED ITEM (PRODUCT) TO ADD TO THE CONTAINER
    
    
        # ADD THE ITEM TO THE CONTAINER
    
    
        pass
    except exceptions.CosmosHttpResponseError as ex:
        # Handle Cosmos DB-specific exceptions
        # Log the status code and error message for debugging
        print(f"Cosmos DB Error: {ex.status_code} - {ex.message}")
    except Exception as ex:
        # Handle general exceptions
        # Log the error message for debugging
        print(f"Error: {ex}")
    ```
    

Next, you add code in specified areas of the projects to create the: client, database, container, and add a sample item to the container.

##### Add code to create the client and perform operations

1. Add the following code in the space after the **# CREATE THE COSMOS DB CLIENT USING THE ACCOUNT URL AND KEY** comment. This code defines the client used to connect to your Azure Cosmos DB account.
    
    ```python
    client = CosmosClient(
        url=cosmos_db_account_url,
        credential=account_key
    )
    ```
    
    > Note: It's a best practice to use the **DefaultAzureCredential** from the _Azure Identity_ library. This can require some additional configuration requirements in Azure depending on how your subscription is set up.
    
2. Add the following code in the space after the **# CREATE A DATABASE IF IT DOESN'T ALREADY EXIST** comment.
    
    code
    
    ```python
    database = client.create_database_if_not_exists(id=database_name)
    print(f"Created or retrieved database: {database.id}")
    ```
    
3. Add the following code in the space after the **# CREATE A CONTAINER WITH A SPECIFIED PARTITION KEY** comment.
    
    code
    
    ```python
    container = database.create_container_if_not_exists(
        id=container_name,
        partition_key={"paths": ["/id"], "kind": "Hash"}
    )
    print(f"Created or retrieved container: {container.id}")
    ```
    
4. Add the following code in the space after the **# DEFINE A TYPED ITEM (PRODUCT) TO ADD TO THE CONTAINER** comment. This defines the item that's added to the container.
    
    ```python
    new_item = {
        "id": str(uuid.uuid4()),  # Generate a unique ID for the product
        "name": "Sample Item",
        "description": "This is a sample item in my Azure Cosmos DB exercise."
    }
    ```
    
5. Add the following code in the space after the **# ADD THE ITEM TO THE CONTAINER** comment.
    
    ```python
    created_item = container.create_item(body=new_item)
    
    print(f"Created item with ID: {created_item['id']}")
    print(f"Request charge: {container.client_connection.last_response_headers['x-ms-request-charge']} RUs")
    ```
    
6. Now that the code is complete, save your progress use **ctrl + s** to save the file, and **ctrl + q** to exit the editor.
    
7. Run the following command in the cloud shell to test for any errors in the project. If you do see errors, open the _app.py_ file in the editor and check for missing code or pasting errors.
    
    ```
    python app.py
    ```
    

Now that the project is finished it's time to run the application and verify the results in the Azure portal.

#### Run the application and verify results

1. Run the `python app.py` command in the cloud shell. The output should be something similar to the following example.
    
    ```
    Created or retrieved database: myDatabase
    Created or retrieved container: myContainer
    Created item with ID: c549c3fa-054d-40db-a42b-c05deabbc4a6
    Request charge: 6.29 RUs
    ```
    
2. In the Azure portal, navigate to the Azure Cosmos DB resource you created earlier. Select **Data Explorer** in the left navigation. In **Data Explorer**, select **myDatabase** and then expand **myContainer**. You can view the item you created by selecting **Items**.
    
    [![Screenshot showing the location of Items in the Data Explorer.](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-cosmos-db/media/01/cosmos-data-explorer.png)](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-cosmos-db/media/01/cosmos-data-explorer.png)
    

#### Clean up resources

Now that you finished the exercise, you should delete the cloud resources you created to avoid unnecessary resource usage.

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
2. Navigate to the resource group you created and view the contents of the resources used in this exercise.
3. On the toolbar, select **Delete resource group**.
4. Enter the resource group name and confirm that you want to delete it.

> **CAUTION:** Deleting a resource group deletes all resources contained within it. If you chose an existing resource group for this exercise, any existing resources outside the scope of this exercise will also be deleted.

### Create stored procedures

Azure Cosmos DB provides language-integrated, transactional execution of JavaScript that lets you write **stored procedures**, **triggers**, and **user-defined functions (UDFs)**. To call a stored procedure, trigger, or user-defined function, you need to register it. For more information, see [How to work with stored procedures, triggers, user-defined functions in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/sql/how-to-use-stored-procedures-triggers-udfs).

 >**Note**: This unit focuses on stored procedures, the following unit covers triggers and user-defined functions.

#### Writing stored procedures

Stored procedures can create, update, read, query, and delete items inside an Azure Cosmos container. Stored procedures are registered per collection, and can operate on any document or an attachment present in that collection.

Here's a simple stored procedure that returns a "Hello World" response.

```javascript
var helloWorldStoredProc = {
    id: "helloWorld",
    serverScript: function () {
        var context = getContext();
        var response = context.getResponse();

        response.setBody("Hello, World");
    }
}
```

The context object provides access to all operations that can be performed in Azure Cosmos DB, and access to the request and response objects. In this case, you use the response object to set the body of the response to be sent back to the client.

#### Create an item using stored procedure

When you create an item by using a stored procedure, the item is inserted into the Azure Cosmos DB container and an ID for the newly created item is returned. Creating an item is an asynchronous operation and depends on the JavaScript callback functions. The callback function has two parameters: one for the error object in case the operation fails, and another for a return value, in this case, the created object. Inside the callback, you can either handle the exception or throw an error. If a callback isn't provided and there's an error, the Azure Cosmos DB runtime throws an error.

The stored procedure also includes a parameter to set the description as a boolean value. When the parameter is set to true and the description is missing, the stored procedure throws an exception. Otherwise, the rest of the stored procedure continues to run.

This stored procedure takes as input `documentToCreate`, the body of a document to be created in the current collection. All such operations are asynchronous and depend on JavaScript function callbacks.

```javascript
var createDocumentStoredProc = {
    id: "createMyDocument",
    body: function createMyDocument(documentToCreate) {
        var context = getContext();
        var collection = context.getCollection();
        var accepted = collection.createDocument(collection.getSelfLink(),
              documentToCreate,
              function (err, documentCreated) {
                  if (err) throw new Error('Error' + err.message);
                  context.getResponse().setBody(documentCreated.id)
              });
        if (!accepted) return;
    }
}
```

#### Arrays as input parameters for stored procedures

When defining a stored procedure in the Azure portal, input parameters are always sent as a string to the stored procedure. Even if you pass an array of strings as an input, the array is converted to string and sent to the stored procedure. To work around this, you can define a function within your stored procedure to parse the string as an array. The following code shows how to parse a string input parameter as an array:

```javascript
function sample(arr) {
    if (typeof arr === "string") arr = JSON.parse(arr);

    arr.forEach(function(a) {
        // do something here
        console.log(a);
    });
}
```

#### Bounded execution

All Azure Cosmos DB operations must complete within a limited amount of time. Stored procedures have a limited amount of time to run on the server. All collection functions return a Boolean value that represents whether that operation completes or not

#### Transactions within stored procedures

You can implement transactions on items within a container by using a stored procedure. JavaScript functions can implement a continuation-based model to batch or resume execution. The continuation value can be any value of your choice and your applications can then use this value to resume a transaction from a new starting point. The following diagram depicts how the transaction continuation model can be used to repeat a server-side function until the function finishes its entire processing workload.

![This diagram depicts how the transaction continuation model can be used to repeat a server-side function until the function finishes its entire processing workload.](https://learn.microsoft.com/en-us/training/wwl-azure/work-with-cosmos-db/media/transaction-continuation-model.png)

### Create triggers and user-defined functions

Azure Cosmos DB supports pretriggers and post-triggers. Pretriggers are executed before modifying a database item and post-triggers are executed after modifying a database item. Triggers aren't automatically executed. They must be specified for each database operation where you want them to execute. After you define a trigger, you should register it by using the Azure Cosmos DB SDKs.

For examples of how to register and call a trigger, see [pretriggers](https://learn.microsoft.com/en-us/azure/cosmos-db/sql/how-to-use-stored-procedures-triggers-udfs#pre-triggers) and [post-triggers](https://learn.microsoft.com/en-us/azure/cosmos-db/sql/how-to-use-stored-procedures-triggers-udfs#post-triggers).

#### Pretriggers

The following example shows how a pretrigger is used to validate the properties of an Azure Cosmos item that is being created. It adds a timestamp property to a newly added item if it doesn't contain one.

```javascript
function validateToDoItemTimestamp() {
    var context = getContext();
    var request = context.getRequest();

    // item to be created in the current operation
    var itemToCreate = request.getBody();

    // validate properties
    if (!("timestamp" in itemToCreate)) {
        var ts = new Date();
        itemToCreate["timestamp"] = ts.getTime();
    }

    // update the item that will be created
    request.setBody(itemToCreate);
}
```

Pretriggers can't have any input parameters. The request object in the trigger is used to manipulate the request message associated with the operation. In the previous example, the pretrigger is run when creating an Azure Cosmos item and the request message body contains the item to be created in JSON format.

When triggers are registered, you can specify the operations that it can run with. This trigger should be created with a `TriggerOperation` value of `TriggerOperation.Create`, using the trigger in a replace operation isn't permitted.

For examples of how to register and call a pretrigger, visit the [pretriggers](https://learn.microsoft.com/en-us/azure/cosmos-db/sql/how-to-use-stored-procedures-triggers-udfs#pre-triggers) article.

#### Post-triggers

The following example shows a post-trigger. This trigger queries for the metadata item and updates it with details about the newly created item.

```javascript
function updateMetadata() {
var context = getContext();
var container = context.getCollection();
var response = context.getResponse();

// item that was created
var createdItem = response.getBody();

// query for metadata document
var filterQuery = 'SELECT * FROM root r WHERE r.id = "_metadata"';
var accept = container.queryDocuments(container.getSelfLink(), filterQuery,
    updateMetadataCallback);
if(!accept) throw "Unable to update metadata, abort";

function updateMetadataCallback(err, items, responseOptions) {
    if(err) throw new Error("Error" + err.message);
        if(items.length != 1) throw 'Unable to find metadata document';

        var metadataItem = items[0];

        // update metadata
        metadataItem.createdItems += 1;
        metadataItem.createdNames += " " + createdItem.id;
        var accept = container.replaceDocument(metadataItem._self,
            metadataItem, function(err, itemReplaced) {
                    if(err) throw "Unable to update metadata, abort";
            });
        if(!accept) throw "Unable to update metadata, abort";
        return;
    }
}
```

One thing that is important to note is the transactional execution of triggers in Azure Cosmos DB. The post-trigger runs as part of the same transaction for the underlying item itself. An exception during the post-trigger execution fails the whole transaction. Anything committed is rolled back and an exception returned.

#### User-defined functions

The following sample creates a UDF to calculate income tax for various income brackets. This user-defined function would then be used inside a query. For the purposes of this example assume there's a container called "Incomes" with properties as follows:

```json
{
   "name": "User One",
   "country": "USA",
   "income": 70000
}
```

The following code sample is a function definition to calculate income tax for various income brackets:

```javascript
function tax(income) {

        if(income == undefined)
            throw 'no input';

        if (income < 1000)
            return income * 0.1;
        else if (income < 10000)
            return income * 0.2;
        else
            return income * 0.4;
    }
```

### Explore change feed in Azure Cosmos DB

Change feed in Azure Cosmos DB is a persistent record of changes to a container in the order they occur. Change feed support in Azure Cosmos DB works by listening to an Azure Cosmos DB container for any changes. It then outputs the sorted list of documents that were changed in the order in which they were modified. The persisted changes can be processed asynchronously and incrementally, and the output can be distributed across one or more consumers for parallel processing.

#### Change feed and different operations

Today, you see all inserts and updates in the change feed. You can't filter the change feed for a specific type of operation. Currently change feed doesn't log delete operations. As a workaround, you can add a soft marker on the items that are being deleted. For example, you can add an attribute in the item called "deleted," set its value to "true," and then set a time-to-live (TTL) value on the item. Setting the TTL ensures that the item is automatically deleted.

#### Reading Azure Cosmos DB change feed

You can work with the Azure Cosmos DB change feed using either a push model or a pull model. With a push model, the change feed processor pushes work to a client that has business logic for processing this work. However, the complexity in checking for work and storing state for the last processed work is handled within the change feed processor.

With a pull model, the client has to pull the work from the server. In this case, the client has business logic for processing work and also stores state for the last processed work. The client handles load balancing across multiple clients processing work in parallel, and handling errors.

>**Note**: It's recommended to use the push model because you won't need to worry about polling the change feed for future changes, storing state for the last processed change, and other benefits.

Most scenarios that use the Azure Cosmos DB change feed use one of the push model options. However, there are some scenarios where you might want the extra low level control of the pull model. The extra low-level control includes:

- Reading changes from a particular partition key
- Controlling the pace at which your client receives changes for processing
- Doing a one-time read of the existing data in the change feed (for example, to do a data migration)

#### Reading change feed with a push model

There are two ways you can read from the change feed with a push model: Azure Functions Azure Cosmos DB triggers, and the change feed processor library. Azure Functions uses the change feed processor behind the scenes, so they're both similar ways to read the change feed. Think of Azure Functions as simply a hosting platform for the change feed processor, not an entirely different way of reading the change feed. Azure Functions uses the change feed processor behind the scenes. It automatically parallelizes change processing across your container's partitions.

##### Azure Functions

You can create small reactive Azure Functions that are automatically triggered on each new event in your Azure Cosmos DB container's change feed. With the [Azure Functions trigger for Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-trigger), you can use the Change Feed Processor's scaling and reliable event detection functionality without the need to maintain any worker infrastructure.

![Diagram showing the change feed triggering Azure Functions for processing.](https://learn.microsoft.com/en-us/training/wwl-azure/work-with-cosmos-db/media/functions-change-feed.png)

##### Change feed processor

The change feed processor is part of the Azure Cosmos DB [Python](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cosmos/azure-cosmos) and [Java V4](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/cosmos/azure-cosmos) SDKs. It simplifies the process of reading the change feed and distributes the event processing across multiple consumers effectively.

There are four main components of implementing the change feed processor:

1. **The monitored container**: The monitored container has the data from which the change feed is generated. Any inserts and updates to the monitored container are reflected in the change feed of the container.
    
2. **The lease container**: The lease container acts as a state storage and coordinates processing the change feed across multiple workers. The lease container can be stored in the same account as the monitored container or in a separate account.
    
3. **The compute instance**: A compute instance hosts the change feed processor to listen for changes. Depending on the platform, it might be represented by a VM, a kubernetes pod, an Azure App Service instance, an actual physical machine. It has a unique identifier referenced as the instance name throughout this article.
    
4. **The handler**: The handler is the code that defines what you, the developer, want to do with each batch of changes that the change feed processor reads.
    

When implementing the change feed processor the point of entry is always the monitored container, from a `ContainerProxy` instance you call `query_items_change_feed`:

```python
import asyncio
from azure.cosmos.aio import CosmosClient

async def start_change_feed_processor(
    cosmos_client: CosmosClient,
    configuration: dict
) -> None:
    """
    Start the Change Feed Processor to listen for changes and process them with the handle_changes implementation.
    """
    database_name = configuration["SourceDatabaseName"]
    source_container_name = configuration["SourceContainerName"]

    database = cosmos_client.get_database_client(database_name)
    container = database.get_container_client(source_container_name)

    print("Starting Change Feed Processor...")
    
    # Query the change feed
    async for changes in container.query_items_change_feed():
        await handle_changes(changes)
    
    print("Change Feed Processor started.")
```

Where you query the change feed from a container and process changes with a handler function. Following is an example of a handler:

```python
import asyncio
from typing import List, Any

async def handle_changes(changes: List[Any]) -> None:
    """
    The handler receives batches of changes as they are generated in the change feed and can process them.
    """
    print("Started handling changes...")

    for item in changes:
        print(f"Detected operation for item with id {item['id']}, created at {item.get('creationTime', 'N/A')}.")
        # Simulate some asynchronous operation
        await asyncio.sleep(0.01)

    print("Finished handling changes.")
```

In Python, you can use continuation tokens to track progress and resume reading from where you left off. You can also specify partition keys to read changes from specific partitions.

Calling `query_items_change_feed` gives you an async iterator that you can use to process changes as they arrive.

The normal life cycle of a host instance is:

1. Read the change feed.
2. If there are no changes, sleep for a predefined amount of time and go to #1.
3. If there are changes, send them to the handler.
4. When the handler finishes processing the changes successfully, update the continuation token with the latest processed point in time and go to #1.