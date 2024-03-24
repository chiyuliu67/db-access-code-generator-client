var usage = [
"Assets generated for your GraphQL project can be found under the '<db-access-code-generator>/generated/<schemaConnectionName>/GraphQL' directory: "
, "    - '/api/' folder"
, "        Merge this folder to your new GraphQL project 'src/main/resources/api' folder."
, "        This folder contains the '.graphql' file required by 'APIKit for GraphQL'."
, "    - '/dw4gql/' folder"
, "        Copy/paste this folder to your GraphQL project under the 'src/main/resources' directory"
, "    - '<schemaConnectionName>_GraphQL.xml'"
, "        Copy/paste this file into your GraphQL project under the 'src/main/mule' folder."
, "        This is the main GraphQL implementation file."
, "        After past the file into your new GraphQL project, it is suggested to open it in the 'COnfiguration XML' tab and perform a 'select all'/'copy'/'past' the XML content to trigger Studio to generate new 'doc:it' for all elements."
, "    - '<schemaConnectionName>_global.xml'"
, "        Copy/paste this file into your GraphQL project under the 'src/main/mule' folder."
, "        This file contains the 'Global Elements' needed for your GraphQL project."
, "    - '<schemaConnectionName>_gqlPostman.json'"
, "        This file contains the element to be copied into an existing (may be empty) Postman exported file inside an array element 'item:[]', and then the file is to be imported back into Postman."
, "        The generated Postman element is to help the users to test the linked objects on all objects."
, "        Set the variable {{OData_URL_<schemaConnectionName>}}: http://localhost:<newOdataAppPort>/odata/<schemaConnectionName>"
, "        Set the variable {{GQL_URL_<schemaConnectionName>}}: http://localhost:<newGQLAppPort>/odata/<schemaConnectionName>"
, "    - 'dev-<schemaConnectionName>-properties.yaml"
, "        Copy/paste this file to your GraphQL project under the 'src/main/resources' directory, or merge the content into your existing property file for your GraphQL project."
, "        This file contains all the required properties required by the generated GraphQL implementation."
, "    - 'POMDependencies.txt'"
, "        Merge the content of this file into the 'pom.xml' for your GraphQL project."
, "    - 'GraphQL_Suggested_Log4J_Loggers.txt'"
, "        Merge the content of this file into the 'src/main/resources/log4j2.xml' of your GraphQL project."
, "        It contains the loggers defined for the logging 'Categories' for easy logging configuration at runtime."
, "        This step is optional."
]