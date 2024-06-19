# **_db-access-code-generator-client_**

---

## Overview

This is the client side of the overall **_MuleSoft DB Access Code Generator_** project which users will work with locally. This Code Generator project currently supports **_Oracle_**, **_MySql_**, **_Sql Server_**, and **_Postgres_** assets generation.

This client side project will be running in user specified environment and will connect to user's databases in order to retrieve the database information. The information retrieved is the schema information (including the Foreign Key constraints) of the tables specified by the user, which serves as the input for users to request the server side asset generator, which is hosted on **_Anypoint CloudHub_**, to generate the **_OData_** and **_GraphQL_** assets. Once the generated assets are obtained, users use these assets to construct the new **_MuleSoft_** projects to provide the **_OData_** and **_GraphQL_** access interface for the databases.

To use this tool, download this client side project and import it into your **_MuleSoft Studio_**, add your custom database connection information to its property configuration, add (by copy/paste) the database connector configuration and the corresponding operation (**"_getSchema_.\<schemaConnectionName>"** sub-flow), then execute the project in any Mule Runtime (**_Studio_**, **_CloudHub_**, or on-premise) that can communicate with your custom databases and the code generator services hosted in **_Anypoint CloudHub_**.

## _Generated Assets_

The generated assets include the following:

- API definition for **_OData_** in RAML
- **_"CSDL" file_** for **_OData API Kit_**
- **_"graphql" file_** for **_GraphQL API Kit_**
- API implementation (based on MuleSoft **_OData API Kit_** and **_GraphQL API Kit_** modules)
- Postman collection

### _Interface types_

#### _OData_

The current generated **_OData_** code supports **_"MsSql"_**, **_"Oracle"_**, **_"MySql"_**, and **_Postgres_** with the following **_REST_** operation:

- **_GET COLLECTION_** (support **_\$top_**, **_\$skip_**, **_\$orderby_**, **_\$select_**, **_\$count_**, **_\$filter_**, **_\$expand_**, and **_nested \$expand_**)
- **_POST COLLECTION_** (though it is accepting one record at a time, it is catagorized to COLLECTION because it doesn't take the ENTITY ID as the URI Param)
- **_GET ENTITY_** (support **_\$select_** and **_\$expand_**)
- **_PATCH ENTITY_**
- **_PUT ENTITY_**
- **_DELETE ENTITY_**

##### Regarding table keys

The primary key, either single column primary key or composite key, should be defined for tables in the database.

> [**NOTE**]: For tables with no primary key defined, it requires to be either fixed in the database or manually change the generated schemaInfo file to mask the underline key field missing issue before continuing.

> [**LIMITION**]: This tool currently support the MSSql tables with "auto-generated" primary key column. However, the "auto-generated" primary key in Oracle, MySql, and Postgres have not been fully tested yet.

#### _GraphQL_

Currently this tool only generates code to support **_GraphQL Query_** but not **_GraphQL Mutation_**, and the generated **_GraphQL_** code is built on top of the **_OData_** implementation.

## Usage

### Step 0. Create empty assets

1. Clone this project to your local.

2. Use Anypoint Studio to create an empty Mule Project for the new OData application, and delete the generated default "Mule Configuration File" from the **_"<newOdataApp\>/src/main/mule"_** directory

3. Use Anypoint Studio to create an empty Mule Project for the new GraphQL application, and delete the generated default "Mule Configuration File" from the **_"<newGraphQLApp\>/src/main/mule"_** directory

4. [_OPTIONAL_]: Create an empty Postman collection and export it to a json file under **_db-access-code-generator-client/src/main/resources_** directory.

### Step 1. Update _db-access-code-generator-client_ project for your databases and start it up

1. Update **_"dev-properties.yaml"_**

   - **_"filename.baseDir"_**

     Update this field to match your directory path

   - **_"filename.input.postmanCollection"_**

     > [_OPTIONAL_]: If you performed the optional task in "Step 0-4", update this field to point to the exported Postman collection you prepared in Step 0. If leave this to the default, an empty Postman collection exported with some dummy information in the "info" section will be used to generate the Postman collection for you to test the new applications.

   - **_"filename.output.base"_**

     This value is relative to the value specified in **_"filename.baseDir"_**, and it points to the location where the generated assets will be saved to before being populated into the new projects.

     > In this document, the value of this configuration is assumed to be **_"generated"_** for discussion purpose.

   - **_"schemaConnection."_**

     - **"default.newApp."**

       > Except **"default.newApp.Studio."** section, wich is required, other configuration items under both **"default.newApp.odata."** and **"default.newApp.gql."** are the default fallback values for the **"schemaConnection.\<schemaConnectionName>.newApp."** section, and any of the them can become optional if its corresponding value is set in all **"schemaConnection.\<schemaConnectionName>.newApp."** individually.

       - **"default.newApp.Studio."**

         - **workspace:** it points out the new application location for the tool to populate the generated assets to

       - **"default.newApp.odata."**

         - **appPort:** the default listening port the new **_OData application_** will be listening on

         - **apiVersion:** the API version number the new **_OData application_** is providing

         - **defaultPageSize:** the default page size for the new **_OData application_** > **projectName:** the Studio project name of the new OData application project

         - **projectName:** the Studio project name of the new OData application project created in **Step 0**

       - **"default.newApp.gql"**

         - **appPort:** the default listening port the new **_GraphQL application_** will be listening on

         - **apiVersion:** the API version number the new **_GraphQL application_** is providing

         - **defaultPageSize:** the default page size for the new **_GraphQL application_** > **[maxQueryDepthAllowed](https://docs.mulesoft.com/apikit/latest/apikit-graphql-module-reference#config):** the maximum depth a query can have. The value must be greater than 1.

         - **[maxQueryComplexityAllowed](https://docs.mulesoft.com/apikit/latest/apikit-graphql-module-reference#config):** the maximum number of data fields a query can include. The value must be greater than 1.

         - **httpRequestResponseTimeout:** the HTTP timeout value when querying from the OData layer

         - **[introspectionEnabled](https://docs.mulesoft.com/apikit/latest/apikit-graphql-module-reference#parameters):** enables schema introspection (recommand to set it to "false" for Production environment by default)

         - **projectName:** the Studio project name of the new GraphQL application project created in **Step 0**

     - **"\<schemaConnectionName>"**

       Add the connection information section with its own unique **"\<schemaConnectionName>"** for your databases following the 3 examples (**_"ex_mssql"_**, **_"ex_mysql"_**, **_"ex_oracle"_**, and **_"ex_postgres"_**) found in the default property file.

       > Please note that based on your database type: **_"mssql"_**, **_"mysql"_**, **_"oracle"_**, or **_"postgres"_** the database identifier names are **_"databaseName"_**, **_"database"_**, and **_"serviceName"_** -- they match how it is in the out of box Database Connector configuration.

       - **"\<schemaConnectionName>._dbtype_"**
         This field is to specify the type of database, and the values currently supported are **_"mssql"_**, **_"mysql"_**, **_"oracle"_**, and **_"postgres"_**

     - **"\<schemaConnectionName>._schemaname_"**
       In the case of **_"mssql"_**, this field is not used.

     - **"\<schemaConnectionName>._tablenames_"**
       Use this field to list all the names of the tables you'd like to have the code generator to generate the (**_OData_** and/or **_GraphQL_**) implementation code for you.

       > In the case of **_"mssql"_**, the field **_"schemaname"_** is not needed, but the way to specify the name of the tables need to be **"\<schemaname>.\<tablename>"**, for example, **_"PRODUCTION.BRANDS"_**

     - **"\<schemaConnectionName>._password_"**

       The password field needs to be **encrypted** using a **_"secureKey"_** of your choice with the default Algorithm (**_"AES"_**) and default Mode (**_"CBC"_**) (which you are free to change). These values are needed as the launch arguments to start up your Code Generator, and will also be used as the OData/GraphQL projects launch arguments at least initially right after the new apps are created and before you modify it.

     - **"\<schemaConnectionName>._databaseName | database | serviceName_"** (for MsSql | MySql | Oracle | Postgres)

       > Specify the database name or the database service name according to the database type as following:

       - MsSql: **_databaseName_**
       - MySql: **_database_**
       - Oracle: **_serviceName_**

2. Update "global.xml" and "Schema-Info.xml"

- in "global.xml" **_"Global Elements"_** tab

  - Add a "Database Config" for your database based on the "schemaConnection" you put into the property file earlier.

- in "schema-Info.xml" **_"Message Flow"_** tab

  - Create a **"_getSchema_.\<schemaConnectionName>"** sub-flow for your database by copy/paste an arbitrary one of the 3 examples found in the flow configuration file: **_"getSchema.ex_mssql"_**, **_"getSchema.ex_mysql"_**, **_"getSchema.ex_oracle"_**, and **_"getSchema.ex_postgres"_**, and then change the **_"Connector configuration"_** to point to your newly created **_"Database Config"_** for your database.

  > **Note:** The **"\<schemaConnectionName>"** used in **_"getSchema._\<schemaConnectionName>"** as part of the sub-flow name must match the **\<schemaConnectionName>** specified in the **_"schemaConnection"_** section found in **_"dev-properties.yaml"_**.

3. Disable those 3 example **_"Database Config"_** in **_"global.xml"_** (by comment out the corresponding lines in the XML file),

4. Disable those 3 example **"_getSchema_.\<schemaConnectionName>"** sub-flows in **_"Schema-Info.xml"_** (by select and right click each sub-flow then select **_"Toggle Comment"_**).

5. Configure the **Launch Arguments** (ex. add these arguments: -M-Denv=dev -M-DsecureKey=fakePassword1234 -M-Dencrypt.algorithm=AES -M-Dencrypt.mode=CBC)

- NOTE: the same set of **Launch Arguments** will also be needed to run the new projects

6. start up the **_db-access-code-generator-client_**

> #### NOTE before starting Step 2, 3 and 4
>
> [**Suggstion**]: Import the file **_"src/main/resources/use-DB-Access-Code-Generator.postman_collection.json"_** into **Postman** to easily go through steps 2, 3 and 4 with your own **_<schemaConnectionName\>_** value assigned to the **Postman** collection variable **_"schemaName"_**

### Step 2. Generate the database metadata information

> [**Suggestion**]: Perform Step 2 in Postman by importing the **_"src/main/resources/use-DB-Access-Code-Generator.postman_collection.json"_** to **Postman** and assign your own **_<schemaConnectionName\>_** value to its collection variable **_"schemaName"_**

- Issue a GET against the endpoint **"http://localhost:8888/schemaInfo/<schemaConnectionName\>"**

> (operation is available in **_src/main/resources/use-DB-Access-Code-Generator.postman_collection.json_**)

It creates the assets based on the database metadata (including the foreign key definition) under the **"\<db-access-code-generator-client>/_generated_/\<schemaConnectionName>/_schemaInfo_"** directory, which will be used as the base for any further code generation.

Here are the assets generated in this step:

- **"\<schemaConnectionName>\__schema.json_"**

  This file contains the metadata of tables listed for the **\<schemaConnectionName>** in the **\*"schemaConnection"** section found in the property file.

- **"\<schemaConnectionName>_\_NavigationReference.json_"**

  This file describes the relationships among tables. It contains both the foreign key lookup relationship defined for each table, and the reversed foreign key lookup from other partner tables.

- **"_WARNING/keyColumnCount\_\_\<N>\_\<tableName>_\_noContent.txt\_"**

  This type of files has empty content and is trying to use its filename to notify the users that there exists tables of which the key column count is not exactly 1 (indicated by **\_\_\_\<N>\_\_**). If the key column count is 0, then it must be fixed before start generating the implementation code; and if the count is greater than 1, it's just to confirm to the user that a composite key is used for the table.

  > This issue can either be fixed in database and then re-invoke the **"_/schemaInfo/_\<schemaConnectionName>"** endpoint, or temporarily modify the generated **"\<schemaConnectionName>_\_schema.json"_** in order to continue.

### Step 3. Generate the _OData_ schema definition, REST API definition, and implementation

> [**Suggestion**]: Perform Step 3 in Postman by importing the **_"src/main/resources/use-DB-Access-Code-Generator.postman_collection.json"_** to **Postman** and assign your own **_<schemaConnectionName\>_** value to its collection variable **_"schemaName"_**

#### 3-a. Issue a GET against the **"http://localhost:8888/schemaCodeGen/odata/<schemaConnectionName\>"**

> (operation is available in **_src/main/resources/use-DB-Access-Code-Generator.postman_collection.json_**)

It creates the assets needed for your **_OData_** project under the **"\<db-access-code-generator-client>_/generated/_\<schemaConnectionName>/OData/"** directory:

- **_"/api/"_** folder

  This will be placed under **_"src/main/resources"_** in the new **_OData_** project.

  This folder contains the **_CSDL_** file required by **_"APIKit for OData"_** and the **_RAML_** files define the **_OData_** REST API.

- **_"/dw4Odata/"_** folder

  This will be placed under **_"src/main/resources"_** in the new **_OData_** project.

  It contains the dataweave files required by the new **_OData_** project.

- **"\<schemaConnectionName>_\_OData.xml_"**

  This will be placed under **_"src/main/mule"_** in the new **_OData_** project.

  This is the main **_OData_** implementation file.

- **_"global.xml"_**

  This will be placed under **_"src/main/mule"_** in the new **_OData_** project.

  This file contains the **_"Global Elements"_** needed for your **_OData_** project.

- **"dev-properties.yaml\_"**

  This will be placed under **_"src/main/resources"_** in the new **_OData_** project.

  This file contains the configuration properties needed for the new **_OData_** project.

- **"\<schemaConnectionName>\_odata.postman*collection.json*"**

  This will be placed under **_"src/main/resources"_** in the new **_OData_** project.

  Import this file into Postman to test the generated code.

  This file is built out of the empty postman file specified by the configuration value of **_filename.input.postmanCollection_** found in the code generator project **_"dev-properties.yaml"_**.

  The generated **_Postman_** element is to help the users to test the queries on all objects, including ENTITY, ENTITY\*COLLECTION, and all the available \*\*\*"$expand"\_\*\*.

- **_"samplePOM.xml"_**

  The **_\<build\>_** and the **_\<dependencies\>_** elements in this file will be used by the **_copy2newApp_** operation to update the new **_OData_** pojrect **_"pom.xml"_** file.

- **_"sampleLog4J2.xml"_**

  The **_\<AsyncLogger\>_** with the attribute **_name_** starts with **_ODATA_** in this file will be used by the **_copy2newApp_** operation to update the new **_OData_** pojrect **_"log4j2.xml"_** file.

#### 3-b. GET **"http://localhost:8888/copy2newApp/odata/<schemaConnectionName\>"**

> (operation is available in **_src/main/resources/use-DB-Access-Code-Generator.postman_collection.json_**)

It populates the new **_OData_** project with the generated assets, and update its pom.xml and log4j2.xml.

### Step 4. Generate the _GraphQL_ schema definition and implementation

> [**Suggestion**]: Perform Step 4 in Postman by importing the **_"src/main/resources/use-DB-Access-Code-Generator.postman_collection.json"_** to **Postman** and assign your own **_<schemaConnectionName\>_** value to its collection variable **_"schemaName"_**

#### 4-a. GET **"http://localhost:8888/schemaCodeGen/gql/<schemaConnectionName\>"**

> (operation is available in **_src/main/resources/use-DB-Access-Code-Generator.postman_collection.json_**)

It creates the assets needed for your **_GraphQL_** project under the **"\<db-access-code-generator-client>/_generated_/\<schemaConnectionName>/_GraphQL_"** directory:

- **_"/api/"_** folder

  This will be placed under **_"src/main/resources"_** in the new **_GraphQL_** project.

  This folder contains the **_"<schemaConnectionName>.graphql"_** file which is required by the **_"APIKit for GraphQL"_**.

- **_"/dw4gql/"_** folder

  This will be placed under **_"src/main/resources"_** in the new **_GraphQL_** project.

  It contains the dataweave files required by the new **_GraphQL_** project.

- **"\<schemaConnectionName>_\_GraphQL.xml_"**

  This will be placed under **_"src/main/mule"_** in the new **_GraphQL_** project.

  This is the main **_GraphQL_** implementation file.

- **"\<schemaConnectionName>_\_global.xml_"**

  This will be placed under **_"src/main/mule"_** in the new **_GraphQL_** project.

  This file contains the **_"Global Elements"_** needed for your **_GraphQL_** project.

- **"_dev-properties.yaml_**

  This will be placed under **_"src/main/resources"_** in the new **_GraphQL_** project.

  This file contains the configuration properties needed for the new **_GraphQL_** project.

- **_"\<schemaConnectionName>\_gql.postman_collection.json"_**

  This will be placed under **_"src/main/resources"_** in the new **_GraphQL_** project.

  Import this file into Postman to test the generated code.

  This file is built out of the empty postman file specified by the configuration value of **_filename.input.postmanCollection_** found in code generator project **_"dev-properties.yaml"_**.

  The generated **_Postman_** element is to help the users to test the queries on all objects with their linked objects.

- **_"samplePOM.xml"_**

  The **_\<build\>_** and the **_\<dependencies\>_** elements in this file will be used by the **_copy2newApp_** operation to update the new **_GraphQL_** pojrect **_"pom.xml"_** file.

- **_"sampleLog4J2.xml"_**

  The **_\<AsyncLogger\>_** with the attribute **_name_** starts with **_GraphQL_** in this file will be used by the **_copy2newApp_** operation to update the new **_GraphQL_** pojrect **_"log4j2.xml"_** file.

#### 4-b. GET **"http://localhost:8888/copy2newApp/gql/<schemaConnectionName\>"**

> (operation is available in **_src/main/resources/use-DB-Access-Code-Generator.postman_collection.json_**)

It populates the new **_GraphQL_** project with the generated assets, and update its pom.xml and log4j2.xml

### Step 5. Start the new projects, import Postman collections, and test

1. Duplicate the "Launch Configuration" out of the one for "db-access-code-generator-client" (so that the "Launch Arguments" are set correctly).

2. Include the new projects into the launch application list.

3. Launch the applications

4. While runtime is starting up, import the Postman collection files from the "src/main/resources" in each new Project

5. Run tests cases from the Postman collection once the applications start up correctly.
