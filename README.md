# **_db-access-code-generator_**

---

## Overview

#### **_OData_**

This project is to help developers to generate the **_OData_** and Graph implementation code to work with the MuleSoft **_OData_** and **_GraphQL_** module.

The current generated **_OData_** code supports **_"MsSql"_**, **_"Oracle"_**, and **_"MySql"_** with the following **_REST_** operation:

- **_GET COLLECTION_** (support **_$top_**, **_$skip_**, **_$orderby_**, **_$select_**, **_$count_**, **_$filter_**, and **_$expand_**)
- **_GET ENTITY_** (support **_$select_** and **_$expand_**)
- **_POST ENTITY_**
- **_PATCH ENTITY_**
- **_PUT ENTITY_**
- **_DELETE ENTITY_**

Currently the code-generator directly supports tables with a single primary key. For tables with 0 or more than 1 keys to work with this code generator, it requires to be either fixed in the database or manually change the generated schemaInfo file before continuing and also manually update the generated **_OData_** code to support the use case.

For the primary key column which is "auto-generated" in MsSql, the required "POST" and "PUT" code is also generated but commented out by default. The "auto-generated" primary key column for Oracle and MySql hasn't been looked into yet.

#### **_GraphQL_**

Currently this tool only generates Query code for **_GraphQL_**, and the generated **_GraphQL_** code is built on top of the **_OData_** implementation.

## Usage

### Step 1. Update **_db-access-code-generator_** project for your databases

1.  Update **_"dev-properties.yaml"_**

    - **_"filename.baseDir"_**

      - Update this field to match your directory path

    - **_"schemaConnection"_**

      - **"\<schemaConnectionName>"** --

        > Add the connection information section with its own unique **"\<schemaConnectionName>"** for your databases following the 3 examples (_"arms"_, _"bikeStore"_, and _"arms_sql"_) found in the default property file.

        > Please note that based on your database type: **_"mssql"_**, **_"mysql"_**, or **_"oracle"_**, the database identifier names are **_"databasename"_**, **_"database"_**, and **_"servicename"_**.

      - **"\<schemaConnectionName>._is4SFDC_"** --

        > If the generated **_OData_** implementation code is to be used as the **"External Data Source"** in **Salesforce**, the field **_"is4SFDC"_** needs to be set to **_"true"_**.

      - **"\<schemaConnectionName>._dbtype_"** --

        > This field is to specify the type of database, and the values currently supported are **_"mssql"_**, **_"mysql"_**, and **_"oracle"_**.

      - **"\<schemaConnectionName>._schemaname_"** --

        > In the case of **_"mssql"_**, this field is not used.

      - **"\<schemaConnectionName>._tablenames_"** --

        > Use this field to list all the names of the tables you'd like to have the code generator to generate the (**_OData_** and/or **_GraphQL_**) implementation code for you.

        > In the case of **_"mssql"_**, the field **_"schemaname"_** is not needed, but the way to specify the name of the tables need to be **"\<schemaname>.\<tablename>"**, for example, _"PRODUCTION.BRANDS"_

      - **"\<schemaConnectionName>._password_"** --

        > The password field needs to be **encrypted** using a **_"secureKey"_** of your choice with the default Algorithm (**_"AES"_**) and default Mode (**_"CBC"_**) (which you are free to change). The value of the **_"secureKey"_** will also be needed at the OData/GraphQL projects runtime if you use the generated code without any modification.

2.  Update "Schema-Info.xml"

- in **_"Global Elements"_** tab

  > Add a "Database Config" for your database based on the "schemaConnection" you put into the property file earlier.

- in **_"Message Flow"_** tab

  > Create a **"_getSchema_.\<schemaConnectionName>"** sub-flow for your database by copy/paste an arbitrary one of the 3 examples found in the file, ex. **_"getSchema_**._arms"_, **_"getSchema_**._bikeStore"_, and **_"getSchema_**._arms_mysql"_, and then change the **_"Connector configuration"_** to point to your newly created **_"Database Config"_** fir your database.

  > **Note:** The **"\<schemaConnectionName>"** used in **_"getSchema._\<schemaConnectionName>"** as part of the sub-flow name must match the **\<schemaConnectionName>** specified in the **_"schemaConnection"_** section found in **_"dev-properties.yaml"_**.

### Step 2. Generate the database metadata information

- Issue a GET against the endpoint **"_/schemaInfo/_\<schemaConnectionName>"**

  > It creates the assets based on the database metadata (including the foreign key definition) under the **"\<db-access-code-generator>/_generated_/\<schemaConnectionName>/_schemaInfo_"** directory, which will be used as the base for any further code generation:

  - **"\<schemaConnectionName>\__schema.json_"**

    > This file contains the metadata of tables listed for the **\<schemaConnectionName>** in the **\*"schemaConnection"** section found in the property file.

  - **"\<schemaConnectionName>_\_NavigationReference.json_"**

    > This file describes the relationships among tables. It contains both the foreign key lookup relationship defined for each table, and the reversed foreign key lookup from other partner tables.

  - **"_keyColumnCount\_\_\<N>\_\<tableName>_\_noContent.txt\_"**

    > This type of files has empty content and is trying to use its filename to notify the users that there exists tables of which the key column count is not exactly 1 and must be fixed before start generating the implementation code because currently this code generator program only supports tables with a single key column.

    > This issue can either be fixed in database and then re-invoke the **"_/schemaInfo/_\<schemaConnectionName>"** endpoint, or temporarily modify the generated **"\<schemaConnectionName>_\_schema.json"_** in order to generate the initial implementation and then manually update the generated code to support the tables with 0 or more than 1 key columns.

### Step 3. Generate the **_OData_** schema definition, REST API definition, and implementation

- Issue a GET against the **"_/odata/schemaCodeGen/_\<schemaConnectionName>"**  
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

- For tables with auto-generated key column

  > During runtime, if you run into issue with POST and PUT operation with the error complaining about "Cannot insert explicit value for identity column in table X when IDENTITY_INSERT is set to OFF" or "Required parameter 'entityTypeKeys' was assigned with value '#[ vars.entityKey ]' which resolved to null.", chances are the table has a "Auto-Generated-Key" and it requires not to send the new key value in the request, and some manual update to the code in order to obtain the auto-generated-key and use it to retrieve the inserted/updated (update in this context means delete the original and insert a new one) record as retun.

  - For **_"mssql"_**

    > The current generated implementation for **_"mssql"_** contains the code supporting this requirement but commented out by default. Here are the steps to turn it back on:

    > 1.  Open the main implementation file (**"\<schemaConnectionName>_\_OData.xml_"**) and select the "Configuration XML" tab in order to work with the XML source code directly.

    > 2.  Search for the key words "FOR-KEY-", and it should find 16 occurrence associated with 8 different **comment section** marked as **_a1_**, **_a2_**, **_b1_**, **_b2_**, **_c1_**, **_c2_**, **_d1_**, **_d2_** for the table which you need to change the implementation to work with the auto-generated-key column.

    > 3.  Each **comment section** mentioned above (from **_a1 to d2_**) has an associated **code compoment** either **right inside** the section (the code is commented out) or **immediate beneath** it if the **comment section** has no code lines inside. By default, the code associated with **a1**, **b1**, **c1**, and **d1** are turned on (not commented out) while the code associated with **a2**, **b2**, **c2**, and **d2** are commented out, in order to support tables with keys NOT auto-generated, and we need to move the associated **code compoment** into or out of the **comment section** in order to support the tables of which the keys are auto-generated.
    > 4.  To see it more clearly, those 8 different sections are structured as following:

        - in ***POST***
           section ***a1*** and ***b1***: the associated code supports the table of which the key column **IS-NOT-AUTO-GENERATED**.
           section ***a2*** and ***b2***: the associated code supports the table of which the key column **IS-AUTO-GENERATED**.
        - in ***PUT***
           section ***c1*** and ***d1***: the associated code supports the table of which the key column **IS-NOT-AUTO-GENERATED**.
           section ***c2*** and ***d2***: the associated code supports the table of which the key column **IS-AUTO-GENERATED**.

    > **In short** - toggle code associated with **a1/b1/c1/d1** to **_ON_** and the ones associated with **a2/b2/c2/d2** to **COMMENTED** in order to support any table of which the key column **IS-NOT-AUTO-GENERATED**, and flip for the case that the key column **IS-AUTO-GENERATED**.

    **NOTE**: In Studio, suggest to CUT/PASTE the lines of code into and out of the **comment section** instead of moving the lines containing the XML comment string **"<--"** or **"-->"** to avoid unexpected temporary Studio visual issue.

  - For **_"oracle"_** and **_"mysql"_**, it will be supported in the future release.

### Step 4. Generate the **_GraphQL_** schema definition and implementation

- Issue a GET against the "/gql/schemaCodeGen/<schemaConnectionName>"

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
