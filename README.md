# Azure ML security

Demonstrating Azure Machine Learning workspace security features, primarily network, with private datastores via private endpoints, as well as a workspace private endpoint.

<img src=".assets/aml-architecture.png" />

## 1 - Setup

Copy the template `.auto.tfvars` configuration file:

> 💡 Prefer a private workspace, or check the public workspace [section](#public-aml-workspace) for more information

```sh
cp config/template-step1.tfvars .auto.tfvars
```

Set the `allowed_ip_address` to allow connectivity to Azure.

Optionally, generate an SSH key pair to be used for compute node connection:

```sh
mkdir keys
ssh-keygen -f keys/ssh_key
```

## 2 - Apply

### Step 1 - Create the project

Apply the resources:

```sh
terraform init
terraform apply -auto-approve
```

Once all resources are created run the step 2.

> ℹ️ The managed VNET is created along with the compute in the next step. Private endpoints should active after or available for approval.

The workspace will be created with `AllowOnlyApprovedOutbound`. Configure the outbound access in the [managed VNET][1] using a preferred interface (add the data lake and the SQL database), which will enable secure outbound access via private endpoints.

> 💡 A Container Registry with `Premium` SKU is required.

### Step 2 - Create the AML instance

Once the base resources are ready, create the 

Set the `mlw_instance_create_flag` variable to `true`:

```terraform
mlw_instance_create_flag = true
```

Apply again:

> ℹ️ This step will take 10-15 minutes to complete.

```sh
terraform apply -auto-approve
```

To complete the process via Terraform, a private endpoint must be manually approved when the compute is created. I assume this endpoint is required to enable the instances to communicate with the workspace.

> 💡 The execution will halt until the manual approval is done, so keep watching for when the approval is requested.

<img src=".assets/aml-compute-approval.png" width=700 />

## 3 - Outbound rules

Once all resources are created, the data stores must be registered in the outbound rules section in order to use them securely via private connections.

<img src=".assets/aml-outbound-rules.png" />

It might be required to perform manual private endpoint approvals, such as in this example for the SQL Server:

<img src=".assets/aml-outbound-pe.png" />

## 4 - Datastores

It's time to connect the data sources to the AML workspace. These connections should happen via private endpoints.

**Create a secret** for the pre-create Application Registration in Entra ID that can be used to setup connections to the data lake. Optionally, it can also be used for the SQL Server, but it will require an external authentication setup which is not covered here - SQL authentication should be enough for this demo.

## 5 - VM access

TODO:

## Public AML workspace

TODO:

---

### Clean-up

Delete the resources and avoid unplanned costs:

```sh
terraform destroy -auto-approve
```

[1]: https://learn.microsoft.com/en-us/azure/machine-learning/how-to-managed-network?view=azureml-api-2&tabs=azure-cli
[2]: https://learn.microsoft.com/en-us/azure/machine-learning/how-to-configure-private-link?view=azureml-api-2&tabs=cli#limitations
[3]: https://learn.microsoft.com/en-us/AZURE/machine-learning/how-to-access-data?view=azureml-api-1
[4]: https://k21academy.com/microsoft-azure/dp-100/datastores-and-datasets-in-azure/
