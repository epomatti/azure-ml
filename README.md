# Azure ML with private data stores

Azure Machine Learning workspace with private data sources.

## 1 - Setup

Copy the template `.auto.tfvars` configuration file:

```sh
cp config/template.tfvars .auto.tfvars
```

Set the `allowed_ip_address` to allow connectivity to Azure.

Optionally, generate an SSH key pair to be used for compute node connection:

```sh
mkdir keys
ssh-keygen -f keys/ssh_key
```

## 2 - Apply

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```

To complete the 

> 💡 The execution will halt until the manual approval is done

<img src=".assets/aml-compute-approval.png" width=500 />

The workspace will be created with `AllowOnlyApprovedOutbound`. Configure the outbound access in the [managed VNET][1] using a preferred interface (add the data lake and the SQL database), which will enable secure outbound access via private endpoints.

> ℹ️ The managed VNET is created with the compute, and private endpoints should active after or available for approval.
> 💡 A Container Registry with `Premium` SKU is required.


[1]: https://learn.microsoft.com/en-us/azure/machine-learning/how-to-managed-network?view=azureml-api-2&tabs=azure-cli
