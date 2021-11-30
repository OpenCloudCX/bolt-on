# bolt-on

Project to bolt on capability to an existing OpenCloudCX installation to deal with a provider race condition within Terraform where `depends_on` paramaters can't be used within `provider` blocks. Without this capability, providers expect the resouce (e.g., Jenkins, Spinnaker) to be present during project initialization.

This project is meant to be executed after all core OpenCloudCX resources are up, running, and addressible. This project will not work correctly if no OpenCloudCX capability base is up and running *or* the parameters are not set correctly.

# Toolsets

Most, if not all, of these toolsets should already be installed from the OpenCloudCX bootstrap execution.

## Required

| Toolset                                      | Links                                                                                                                                                                                               | Notes                                                                                                                                                                                                                                                                                                                                                                          |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Terraform&nbsp;(at least version&nbsp;1.0.8) | [Download](https://releases.hashicorp.com/terraform/1.0.8/)                                                                                                                                         | Terraform is distributed as a single binary. Install Terraform by unzipping it and moving it to a directory included in your system's [PATH](https://superuser.com/questions/284342/what-are-path-and-other-environment-variables-and-how-can-i-set-or-use-them). <br />**This project has been tested with Terraform 1.0.8 -- Will be updated as newer versions are tested.** |
| AWS&nbsp;CLI                                 | [Instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) \|\| [Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) | This link provides information for getting started with version 2 of the AWS Command Line Interface (AWS CLI)                                                                                                                                                                                                                                                                  |
| kubectl                                      | [Instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)                                                                                                                                     | Allows commands to be executed against Kubernetes clusters                                                                                                                                                                                                                                                                                                                     |
| Git                                          | [Instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)                                                                                                                       | Need to run this command to avoid a CRLF issues: git config --global core.autocrlf input                                                                                                                                                                                                                                                                                       |

## Optional

| Toolset                           | Links                                                                      | Notes                                                                                                                |
| --------------------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Windows Subsystem for Linux (WSL) | [Instructions](https://docs.microsoft.com/en-us/windows/wsl/install-win10) | This is a robust linux capability for Windows 10 and Windows 11. Linux instructions are written for Ubuntu 20.04 LTS |

# Setup

Once all toolsets are installed and verified to be operational, configure the cloned bootstrap project.

## AWS S3 State Bucket

If remote state storge is desired, follow the instructions in this section. If not, skip to _Project Variables_. This file is not required for successful environment generation.

NOTE: If OpenCloudCX is already using a state bucket, the bolt-on project can use the same bucket with with a different key.

OpenCloudCX can use Terraform state buckets to store all infrastructure snapshot information (e.g., S3 buckets, VPC, EC2, EKS). State buckets allow for teams to have a centralized souce of truth for the infrastructure. Per AWS S3 requirements, this bucket name needs to be globally unique. This bucket is not created automatically and needs to be in place before the terraform project is initialized.

Follows [these]() instructions to create a unique bucket in the account where OpenCloudCX is going to be installed. A good convention for this project is to create and use `opencloucx-state-bucket-####` and replace `####` with the last 4 digits of the AWS account number.

Once the bucket has been created, copy `state.tf.example` and rename the copy (not the original) to `state.tf`. Update the requested and save.

```bash
  backend "s3" {
    key    = "[terraform-state-filename]"
    bucket = "[bucket name]"
    region = "[region]"
  }
```

## Variables

Create copies of the `variables.example.tfvars` and `secrets.exampless.tfvars` files rename them `variables.auto.tfvars` and `secrets.auto.tfvars` respectively. If another filename needs to be used, Terraform automatically loads a number of variable definitions files if named the following way:

- Files named exactly `terraform.tfvars` or `terraform.tfvars.json`
- Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`

Update the variables within the file for any desired configuration changes

### Sensitive variables

| Variable               | Explanation                                                                                      |
| ---------------------- | ------------------------------------------------------------------------------------------------ |
| eks_token              | Retrieved from the OpenCloudCX bootstrap output                                                  |
| cluster_ca_certificate | Retrieved from the OpenCloudCX bootstrap output. **THIS NEEDS TO BE CONVERTED TO A SINGLE LINE** |
| jenkins_pw             | Retrieved from the OpenCloudCX bootstrap output                                                  |
| github_hook_pw         | User generated password for handshake between github hooks and spinnaker pipeline trigger        |

### Non-Sensitive variables

| Variable       | Explanation                                                                                                                                                                                                                                                                            | Example                                             |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| dns_zone       | To experience the full impact of an OpenCloudCX installation, a valid, publicly accessible DNS zone needs to be supplied within the configuration. The default DNS Zone can be used for initial prototyping with appropriate local hosts file manipulation or kubectl port forwarding. | `spinnaker.internal`                                |
| jenkins_host   | Jenkins hostname **WITHOUT THE PROTOCOL AND DNS SUFFIX**                                                                                                                                                                                                                               | `jenkins`                                           |
| spinnaker_host | Spinnaker hostnamer **WITHOUT THE PROTOCOL AND DNS SUFFIX**                                                                                                                                                                                                                            | `spinnaker-gate`                                    |
| eks_host       | Full hostname of the EKS cluster. This can be retrieved from the output of the OpenCloudCX bootstrap execution                                                                                                                                                                         | `https://<ekshost>.gr7.us-east-1.eks.amazonaws.com` |

## Language Modules

These modules will create the necessary Jenkins and Spinnaker pipelines elements for language primers

<table width="100%">

<tr style="font-size:16pt"><th colspan="3" width="50%">Current</th><th colspan="3" width="50%">Future</th></tr>
<tr><td><b>Name</b></td><td><b>Functionality</b></td><td><b>URL</b></td><td><b>Name</b></td><td><b>Functionality</b></td><td><b>URL</b></td></tr>
<tr>
  <td>module-python-microservice</td>
  <td>Python microservice primer</td>
  <td><a href="https://github.com/OpenCloudCX/module-python-microservice">Github Link</a></td>
  <td>module-springboot-microservice</td>
  <td>Java Spring microservice primer</td>
  <td></td>
</tr>

<tr>
  <td></td>
  <td></td>
  <td></td>
  <td>module-golang-microservice</td>
  <td>golang microservice primer</td>
  <td></td>
</tr>

<tr>
  <td></td>
  <td></td>
  <td></td>
  <td>module-dotnet-core-microservice</td>
  <td>dotnet core microservice primer</td>
  <td></td>
</tr>

</table>

# Environment creation

## Initialize Terraform and Execute

### `terraform init`

The `init` command tells Terraform to initialize the project from the current working directory of terraform configurations. If commands relying on initialization are executed before this step, the command will fail with an error.

From [terraform.io](https://www.terraform.io/docs/cli/init/index.html)

> Initialization performs several tasks to prepare a directory, including accessing state in the configured backend, downloading and installing provider plugins, and downloading modules. Under some conditions (usually when changing from one backend to another), it might ask the user for guidance or confirmation.

### `terraform apply`

From [terraform.io](https://www.terraform.io/docs/cli/commands/apply.html)

> The terraform apply command performs a plan just like terraform plan does, but then actually carries out the planned changes to each resource using the relevant infrastructure provider's API. It asks for confirmation from the user before making any changes, unless it was explicitly told to skip approval.

### Command Execution

Execute these two commands in succession.

```
$ terraform init
$ terraform apply --auto-approve
```

If you receive the following error, confirm the s3 state bucket referenced above is correct

```bash
Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Error refreshing state: AccessDenied: Access Denied
        status code: 403, request id: <string> host id: <string>
```

---

_NOTE: Terraform assumes the current `[default]` profile contains the appropriate credentials for environment initialization. If this is not correct, each Terraform command needs to be prefixed with `AWS_PROFILE=` and the desired AWS profile to use._
On Linux this can be found in your home directory .aws update both credentials and config file
On Windows C:\Users\[username]\.aws update both credentials and config file

```
$ AWS_PROFILE=<profile name> terraform init
$ AWS_PROFILE=<profile name> terraform apply --auto-approve
```

---

Once Terraform instructions have been applied, the following message will be displayed

<span style='font-size: 13pt; color: green'>Apply complete! Resources: ### added, 0 changed, 0 destroyed.</span>

# Environment Destruction

### `terraform destroy`

From [terraform.io](https://www.terraform.io/docs/cli/commands/destroy.html)

> The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

Execute the command.

```
$ terraform destroy --auto-approve
```

If the script terminates with a timout error, re-execute the `destroy` command again. If the script times out again, delete the `spinnaker` namespace

```bash
$ kubectl delete namespace spinnaker

namespace "spinnaker" deleted
```

Once this command completes (it may take a while), re execute the `destroy` command again.
