# **_db-access-code-generator_**

---

## Overview

This is the client side of the overall Code Generator project which users will work with locally.

It will connect to users' databases to retrieve the schema information of tables specified by the user and their relationships according to the foreign key defined, and then request the **_OData_** and **_Graph_** asset generation from the server side of the project which is hosted on CloudHub.

The assets it generates are the **_OData_** and **_Graph_** API definition and implementation code, based on MuleSoft **_OData API Kit_** and **_GraphQL API Kit_** module, to provide the **_OData_** and **_Graph_** interface for the databases (currently supporting Oracle, MySql, and Sql Server), plus the Postaman collection which can be used to test the generated implementation.

To use this tool, download this MuleSoft project and import it into your MuleSoft Studio, add your custom database connection information to its property configuration, add (by copy/paste) the database connector configuration and the corresponding operation, then execute the project in any Mule Runtime (Studio, CloudHub, on-premise) that can communicate with the databases.

The generated code supports the following:

#### _OData_

The current generated **_OData_** code supports **_"MsSql"_**, **_"Oracle"_**, and **_"MySql"_** with the following **_REST_** operation:

- **_GET COLLECTION_** (support **_\$top_**, **_\$skip_**, **_\$orderby_**, **_\$select_**, **_\$count_**, **_\$filter_**, **_\$expand_**, and **_nested \$expand_**)
- **_POST COLLECTION_** (though it is accepting one record at a time, it is catagorized to COLLECTION because it doesn't take the ENTITY ID as the URI Param)
- **_GET ENTITY_** (support **_\$select_** and **_\$expand_**)
- **_PATCH ENTITY_**
- **_PUT ENTITY_**
- **_DELETE ENTITY_**

The database tables primary key, either single primary key or composite keys, must be defined. For tables with no primary key defined, it requires to be either fixed in the database or manually change the generated schemaInfo file before continuing.

This tool currently support the MSSql tables with "auto-generated" primary key column. However, the "auto-generated" primary key in Oracle and MySql are not supported yet.

#### _GraphQL_

Currently this tool only generates code to support **_GraphQL Query_** but not **_GraphQL Mutation_**, and the generated **_GraphQL_** code is built on top of the **_OData_** implementation.

## Usage

### Step 1. Update _db-access-code-generator_ project for your databases

1.  Update **_"dev-properties.yaml"_**

    - **_"filename.baseDir"_**

      - Update this field to match your directory path

    - **_"schemaConnection"_**

      - **"default.newApp"**

        > This set of configuration items will be used to provide the default configuration for the new **_OData application_** and the new **_GraphQL application_** users are creating. Each of the values can be overridden at the specific **"\<schemaConnectionName>"** level.

        - **"default.newApp.odata."**
          > **appPort:** the default listening port the new **_OData application_** will be listening on
          > **apiVersion:** the API version number the new **_OData application_** is providing
          > **defaultPageSize:** the default page size for the new **_OData application_**
        - **"default.newApp.gql"**
          > **appPort:** the default listening port the new **_GraphQL application_** will be listening on
          > **apiVersion:** the API version number the new **_GraphQL application_** is providing
          > **defaultPageSize:** the default page size for the new **_GraphQL application_** > **[maxQueryDepthAllowed](https://docs.mulesoft.com/apikit/latest/apikit-graphql-module-reference#config):** the maximum depth a query can have. The value must be greater than 1.
          > **[maxQueryComplexityAllowed](https://docs.mulesoft.com/apikit/latest/apikit-graphql-module-reference#config):** the maximum number of data fields a query can include. The value must be greater than 1.
          > **httpRequestResponseTimeout:** the HTTP timeout value when querying from the OData layer
          > **[introspectionEnabled](https://docs.mulesoft.com/apikit/latest/apikit-graphql-module-reference#parameters):** enables schema introspection (recommand to set it to "false" for Production environment by default)

      - **"\<schemaConnectionName>"**

        > Add the connection information section with its own unique **"\<schemaConnectionName>"** for your databases following the 3 examples (**_"ex_mssql"_**, **_"ex_mysql"_**, and **_"ex_oracle"_**) found in the default property file.

        > Please note that based on your database type: **_"mssql"_**, **_"mysql"_**, or **_"oracle"_**, the database identifier names are **_"databaseName"_**, **_"database"_**, and **_"serviceName"_**.

      - **"\<schemaConnectionName>._is4SFDC_"**

        > If the generated **_OData_** implementation code is to be used as the **"External Data Source"** in **Salesforce**, the field **_"is4SFDC"_** needs to be set to **_"true"_**.

      - **"\<schemaConnectionName>._dbtype_"**

        > This field is to specify the type of database, and the values currently supported are **_"mssql"_**, **_"mysql"_**, and **_"oracle"_**.

      - **"\<schemaConnectionName>._schemaname_"**

        > In the case of **_"mssql"_**, this field is not used.

      - **"\<schemaConnectionName>._tablenames_"**

        > Use this field to list all the names of the tables you'd like to have the code generator to generate the (**_OData_** and/or **_GraphQL_**) implementation code for you.

        > In the case of **_"mssql"_**, the field **_"schemaname"_** is not needed, but the way to specify the name of the tables need to be **"\<schemaname>.\<tablename>"**, for example, **_"PRODUCTION.BRANDS"_**

      - **"\<schemaConnectionName>._password_"**

        > The password field needs to be **encrypted** using a **_"secureKey"_** of your choice with the default Algorithm (**_"AES"_**) and default Mode (**_"CBC"_**) (which you are free to change). The value of the **_"secureKey"_** will also be needed at the OData/GraphQL projects runtime if you use the generated code without any modification.

      - **"\<schemaConnectionName>._databaseName | database | serviceName_"** (for MsSql | MySql | Oracle)

        > Specify the database name or the database service name according to the database type as following:

        - MsSql: **_databaseName_**
        - MySql: **_database_**
        - Oracle: **_serviceName_**

2.  Update "Schema-Info.xml"

- in **_"Global Elements"_** tab

  > Add a "Database Config" for your database based on the "schemaConnection" you put into the property file earlier.

- in **_"Message Flow"_** tab

  > Create a **"_getSchema_.\<schemaConnectionName>"** sub-flow for your database by copy/paste an arbitrary one of the 3 examples found in the flow configuration file: **_"getSchema.ex_mssql"_**, **_"getSchema.ex_mysql"_**, and **_"getSchema.ex_oracle"_**, and then change the **_"Connector configuration"_** to point to your newly created **_"Database Config"_** for your database.

  > **Note:** The **"\<schemaConnectionName>"** used in **_"getSchema._\<schemaConnectionName>"** as part of the sub-flow name must match the **\<schemaConnectionName>** specified in the **_"schemaConnection"_** section found in **_"dev-properties.yaml"_**.

3.  Provide your own Postman exported "postman_collection.json" file to replace the default "EMPTY.postman_collection.json" (OPTIONAL)

- 1. Create an **_empty Postman collection_** and export it to a JSON file.

- 2. Copy the exported Empty Postman Collection JSON file into the project somewhere under **_"src/main/resources"_** directory.

- 3. Configure the **_filename.input.postmanCollection_** to point to this exported file (relative to **_"src/main/resources"_**) in the **_dev-properties.yaml_**.

### Step 2. Generate the database metadata information

- Issue a GET against the endpoint **"http://localhost:8888/schemaInfo/<schemaConnectionName\>"**

  > It creates the assets based on the database metadata (including the foreign key definition) under the **"\<db-access-code-generator>/_generated_/\<schemaConnectionName>/_schemaInfo_"** directory, which will be used as the base for any further code generation:

  - **"\<schemaConnectionName>\__schema.json_"**

    > This file contains the metadata of tables listed for the **\<schemaConnectionName>** in the **\*"schemaConnection"** section found in the property file.

  - **"\<schemaConnectionName>_\_NavigationReference.json_"**

    > This file describes the relationships among tables. It contains both the foreign key lookup relationship defined for each table, and the reversed foreign key lookup from other partner tables.

  - **"_WARNING/keyColumnCount\_\_\<N>\_\<tableName>_\_noContent.txt\_"**

    > This type of files has empty content and is trying to use its filename to notify the users that there exists tables of which the key column count is not exactly 1. If the key column count is 0, then it must be fixed before start generating the implementation code because currently this code generator program only supports tables with a single key column.

    > This issue can either be fixed in database and then re-invoke the **"_/schemaInfo/_\<schemaConnectionName>"** endpoint, or temporarily modify the generated **"\<schemaConnectionName>_\_schema.json"_** in order to generate the initial implementation and then manually update the generated code to support the tables with 0 or more than 1 key columns.

### Step 3. Generate the _OData_ schema definition, REST API definition, and implementation

- Issue a GET against the **"http://localhost:8888/schemaCodeGen/odata/<schemaConnectionName\>"**  
   It creates the assets needed for your **_OData_** project under the **"\<db-access-code-generator>_/generated/_\<schemaConnectionName>/OData/"** directory:

  - **_"/api/"_** folder

    > Merge this folder to your new **_OData_** project **_"src/main/resources/api"_** folder.

    > This folder contains the **_CSDL_** file required by **_"APIKit for OData"_** and the **_RAML_** files define the **_OData_** REST API.

    > **NOTE_1:** the **_RAML_** definition for the **_"ENTITY"_** entries are not exact because the **_OData_** client syntax for specifying the "id" is using a pair of parentheses instead of following a slash after the object name, and currently don't know right way to describe it. For example, to search the _"PRODUCT"_ of which the ID is _"201"_, instead of querying using **"\<baseURL>**_/PRODUCTS/201_**"**, it is **"\<baseURL>/**_PRODUCTS(201)_**"**.

    > **NOTE_2:** In some cases, the field type in the generated **_CSDL_** file may need to be fixed manually during the test due to the incompatibility between the runtime data with the data type defined in **_CSDL_**. For example, in **_MySQL_**, for fields of type **_"decimal"_**, some can be translated to **_"Edm.Decimal"_**, while some others must be translated to "Edm.Double". This may be fixed by patch or in the future release.

  - **_"/dw4Odata/"_** folder

    > Copy/paste this folder to your **_OData_** project under the **_"src/main/resources"_** directory

  - **"\<schemaConnectionName>_\_OData.xml_"**

    > Copy/paste this file into your **_OData_** project under the **_"src/main/mule"_** folder.

    > This is the main **_OData_** implementation file.

    > After past this file into your new **_OData_** project, it is suggested to open it in the **_"Configuration XML"_** tab and perform a **_"select all"/"copy"/"past"_** the XML content to trigger Studio to generate new **_"doc:it"_** for all elements.

  - **_"global.xml"_**

    > Copy/paste this file into your **_OData_** project under the **_"src/main/mule"_** folder.

    > This file contains the **_"Global Elements"_** needed for your **_OData_** project.

  - **"\<schemaConnectionName>_\_postman.json_"**

    > This file contains the element to be copied into an existing (may be empty) **_Postman_** exported file inside an array element **_"item:[]"_**, and then the file is to be imported back into **_Postman_**.

    > The generated **_Postman_** element is to help the users to test the **_"$expand"_** on all objects.

  - **"\<schemaConnectionName>_\_properties.yaml_"**

    > Copy/paste this file to your **_OData_** project under the **_"src/main/resources"_** directory, or merge the content into your existing property file for your **_OData_** project.

    > This file contains all the required properties required by the generated **_OData_** implementation.

  - **_"odata4_POMDependencies.txt"_**

    > Merge the content of this file into the **_"pom.xml"_** inside your **_OData_** project.

  - **_"odata4_Suggested_Log4J_Loggers.txt"_**

    > Merge the content of this file into the **_"src/main/resources/log4j2.xml"_** inside your **_OData_** project.

    > It contains the **_"loggers"_** defined for the logging **_"Categories"_** for easy logging configuration at runtime.

    > This step is optional.

- Current version generates the codes support the following:
  - Tables with Composite Key
  - **_mssql_** with **_auto-generated_** ID column (but not **_"oracle"_** and **_"mysql"_** with the autogenerated ID column yet)

### Step 4. Generate the _GraphQL_ schema definition and implementation

- Issue a GET against the **"http://localhost:8888/schemaCodeGen/gql/<schemaConnectionName\>"**

  > It creates the assets needed for your **_GraphQL_** project under the **"\<db-access-code-generator>/_generated_/\<schemaConnectionName>/_GraphQL_"** directory:

  - **_"/api/"_** folder

    > Merge this folder to your new **_GraphQL_** project **_"src/main/resources/api"_** folder.

    > This folder contains the **_".graphql"_** file required by **_"APIKit for GraphQL"_**.

  - **_"/dw4gql/"_** folder

    Copy/paste this folder to your **_GraphQL_** project under the **_"src/main/resources"_** directory

  - **"\<schemaConnectionName>_\_GraphQL.xml_"**

    > Copy/paste this file into your **_GraphQL_** project under the **_"src/main/mule"_** folder.

    > This is the main **_GraphQL_** implementation file.

    > After past the file into your new **_GraphQL_** project, it is suggested to open it in the **_"COnfiguration XML"_** tab and perform a "select all"/"copy"/"past" the XML content to trigger Studio to generate new **_"doc:it"_** for all elements.

  - **"\<schemaConnectionName>_\_global.xml_"**

    > Copy/paste this file into your **_GraphQL_** project under the **_"src/main/mule"_** folder.

    > This file contains the **_"Global Elements"_** needed for your **_GraphQL_** project.

  - **"\<schemaConnectionName>_\_gqlPostman.json_"**

    > This file contains the element to be copied into an existing (may be empty) **_Postman_** exported file inside an array element **_"item:[]"_**, and then the file is to be imported back into **_Postman_**.

    > The generated **_Postman_** element is to help the users to test the linked objects on all objects.

  - **"_dev-_\<schemaConnectionName>_-properties.yaml_**

    > Copy/paste this file to your **_GraphQL_** project under the **_"src/main/resources"_** directory, or merge the content into your existing property file for your **_GraphQL_** project.

    > This file contains all the required properties required by the generated **_GraphQL_** implementation.

  - **_"POMDependencies.txt"_**

    > Merge the content of this file into the "pom.xml" for your **_GraphQL_** project.

  - **_"GraphQL_Suggested_Log4J_Loggers.txt"_**

    > Merge the content of this file into the "src/main/resources/log4j2.xml" of your **_GraphQL_** project.

    > It contains the loggers defined for the logging "Categories" for easy logging configuration at runtime.

    > This step is optional.
