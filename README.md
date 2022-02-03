
## Deploy Postgres Single Server in Azure using Terraform

I use this project to create a Postgres test environment in Azure using Terraform. I execute the commands from a Linux terminal on Windows (Ubuntu on WSL).
 
The environment variable TF_VAR_project_name and the Terraform variable environment_name (hardcoded in the input.tf file) are used to name the resource group and resources.
 
The server parameters for the Postgres server are configured in the input.tf for the PostgreSQL terraform module using a key-value list function. I plan to revisit the server parameters to add best practices; for now, the log_line_prefix is changed.

### Login to Azure using the CLI

```
az Login
```

Use `az account show` to check the subscription context.

### Set environment variables

The project prefix is used to name all the resources and db_password to set the Postgres Admin Password.

```variables
export TF_VAR_project_name="<project prefix>"

export TF_VAR_my_public_ip=$(curl -s http://whatismyip.akamai.com/)

HISTCONTROL=ignoreboth
 export TF_VAR_db_username="<admin username>"
 export TF_VAR_db_password="<password>"
```


### Init, Apply, and Plan, to deploy resources using Terraform


Navigate to the terraform environment folder, for example, environments/test and run the following commands.

```terraform
./terraform init

./terraform plan

./terraform apply
```

### Update server to allow public network access and whitelist my IP
```
export resource_group=$(./terraform output -raw resource_group)
export server_name=$(./terraform output -raw server_name) 
export my_public_ip=$(curl -s http://whatismyip.akamai.com/)

az postgres server update -g $resource_group -n $server_name --public-network-access Enabled

az postgres server firewall-rule create -g $resource_group -s $server_name -n mymachine --start-ip-address $my_public_ip --end-ip-address $my_public_ip

psql "host=${server_name}.postgres.database.azure.com port=5432 dbname=postgres user=${TF_VAR_db_username}@${server_name} password=$TF_VAR_db_password sslmode=require"
```

## Cleanup Resources

```
./terraform destroy
```

## Prerequisites

Download the Linux Terraform binary and copy to terraform environment folder, for example, environments/test.

The project has been tested with Terraform version: hashicorp/azurerm v2.87.0 

https://www.terraform.io/downloads

Install the Azure CLI

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

Install Git

```
sudo apt install git
```
