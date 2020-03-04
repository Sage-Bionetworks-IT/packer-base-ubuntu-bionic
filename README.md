# Overview
Project to build a base ubuntu image and deploy it to AWS

## Workflow
The workflow to provision AWS AMI is done using pull requests.
Just make changes with PRs and when PR is merged a packer build
will kick off which builds the image and deploys it to AWS.

__Note:__: The image will automatically be named <repo>-<branch> (i.e. packer-myimage-master)

### Requirements
* Install [packer](https://www.packer.io/intro/getting-started/install.html) (Use this [shell script](install_packer.sh))

### Create snapshot AMI
1. Create new folder (i.e. mkdir -p packer/sagebio/MyAmi-LATEST)
2. Go into MyAmi-LATEST directory (i.e. cd packer/sagebio/MyAmi-LATEST)
3. Create a packer configuration file (must be `template.json`).  Set `ImageName` in the `variables`
section to `MyAmi-LATEST`
4. Validate packer file (i.e. packer validate template.json)
5. Create a PR with new files.

__Note__: A snapshot AMI is re-deployed (with a new AMI ID) on every PR merge.  This allows us
to make updates to this `LATEST` AMI.

### Manual AMI Build
If you would like to test building an AMI run:
```
cd src
export IMAGE_NAME=<repo name>
packer build -var AwsProfile=my-aws-account -var AwsRegion=us-east-1 -var IMAGE_NAME=${IMAGE_NAME} template.json
```

Packer will do the following:
* Create a temporary EC2 instance, configure it with shell/ansible/puppet/etc. scripts.
* Create an AMI from the EC2
* Delete the EC2

__Note__: Packer deploys a new AMI to the AWS account specified by the AwsProfile

### Deploy a release
To build and deploy a release image just git tag the repo and a packer build will kick off
which builds the image and deploys it to AWS.

__Note:__: The image will automatically be named <repo>-<tag> (i.e. packer-myimage-v1.0.0)

## Contributions
Contributions are welcome.

Requirements:
* Install [pre-commit](https://pre-commit.com/#install) app
* Clone this repo
* Run `pre-commit install` to install the git hook.

## Testing
As a pre-deployment step we syntatically validate our packer json
files with [pre-commit](https://pre-commit.com).

Please install pre-commit, once installed the file validations will
automatically run on every commit.  Alternatively you can manually
execute the validations by running `pre-commit run --all-files`.

## Deployments
Travis runs packer which temporarily deploys an EC2 to create an AMI.

## Continuous Integration
We have configured Travis to deploy cloudformation template updates.

## Issues
* https://sagebionetworks.jira.com/projects/IT

## Secrets
* We use the [AWS SSM](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html)
to store secrets for this project.  Sceptre retrieves the secrets using
a [sceptre ssm resolver](https://github.com/cloudreach/sceptre/tree/v1/contrib/ssm-resolver)
and passes them to the cloudformation stack on deployment.
