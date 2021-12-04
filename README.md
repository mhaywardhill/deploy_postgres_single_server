
## Deploy Postgres Single Server in Azure

### Login to Azure using the CLI

```
az Login
```

Use `az account show` to check the subscription context.

### Set environment variables

The project prefix is used to name all the resources and db_password to set the Postgres Admin Password.

```variables
export TF_VAR_project_name="<project prefix>"

export TF_VAR_db_password="<password>"
```


### Init, Apply, and Plan, to deploy resources using Terraform


Navigate to the environment folder, for example /environments/test, and run the following commands.

```terraform
./terraform.exe init

./terraform.exe plan

./terraform.exe apply
```

### Cleanup Resources

```
./terraform.exe destroy
```

#### Notes

Installed Linux Terraform version: hashicorp/azurerm v2.88.1 