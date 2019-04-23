ucop-ami-builder
================

ucop-ami-builder provides a automated process for building custom AWS AMIs for multiple OS platforms using packer.

Currently supported packer projects:

- amazonlinux2
- windowsserver2016
- rhel7


Launching a ucop-ami-builder pipeline
-------------------------------------

Clone this git repo to a local directory.  Create a branch named for your packer project::

  git clone git@github.com:ucopacme/ucop-ami-builder.git
  cd ucop-ami-builder
  git checkout -b amazonlinux2


Specify which packer project you want to build::

  PACKER_PROJECT_NAME=amazonlinux2


Launch the CodePipeline Cloudformation template.  Adjust params/tags as is appropriate::

  aws cloudformation create-stack \
  --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME \
  --template-body file://cloudformation/pipeline.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
   ParameterKey=NotificationEmailAddress,ParameterValue="ait-dev@ucop.edu" \
   ParameterKey=PackerProjectName,ParameterValue=$PACKER_PROJECT_NAME \
  --tags \
   Key=ucop:service,Value=ait \
   Key=ucop:application,Value=ucop-aim-builder \
   Key=ucop:environment,Value=test


Add a git origin to you local repo pointing to the newly generated codecommit
repo.  Get the repo url from cloudformation stack outputs::

  aws cloudformation describe-stacks --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME | grep -A2 GitRepository
  git remote add codecommit https://git-codecommit.us-west-2.amazonaws.com/v1/repos/UcopAmiBuilder-amazonlinux2_repo

Push your local repo into codecommit to trigger the pipeline.  **IMPORTANT: you
must push to the branch named for your packer project**::

  git push codecommit amazonlinux2:amazonlinux2



Update your ucop-ami-builder pipeline stack
+++++++++++++++++++++++++++++++++++++++++++

::

  PACKER_PROJECT_NAME=amazonlinux2
  
  aws cloudformation update-stack \
  --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME \
  --template-body file://cloudformation/pipeline.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
   ParameterKey=NotificationEmailAddress,ParameterValue="ait-dev@ucop.edu" \
   ParameterKey=PackerProjectName,ParameterValue=$PACKER_PROJECT_NAME \
  --tags \
   Key=ucop:service,Value=ait \
   Key=ucop:application,Value=ucop-aim-builder \
   Key=ucop:environment,Value=test
  
Some other helpful cfn commands::

  aws cloudformation validate-template --template-body file://cloudformation/pipeline.yaml
  aws cloudformation describe-stacks --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation describe-stack-events --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation delete-stack --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME





Issues
------

Installing software packages (rpms) from within packer
++++++++++++++++++++++++++++++++++++++++++++++++++++++

if the source package is hosted on a public url, no probem.  But if hosted on
an internal website or s3 bucket, packer cannot access the package.  This is
because packer uses the default VPC, which has not route to our yum server or
s3 endpoints.

workarounds:

- stage software packages within the packer project dir
- specify vpc/subnet id to use for packer builds so temp build instances can access yum server
- specify vpc id for packer for a vcp with vpc endpoint for s3 to our staging bucket


Sharing custom AMIs with other accounts
+++++++++++++++++++++++++++++++++++++++

ucop-ami-builder stages ami image IDs in ssm parameter store.  This lets cfn
templates to retrive image IDs using parameters of ``Type: AWS::SSM::Parameter::Value``.
But cloudformation can not access ssm params in other accounts.

workarounds:

- stage ami image IDs in ssm by hand
- manage iam policies to allow codebuild to post to ssm parameter store in other accounts, and configure target account ssm access in codebuild project



Notes
-----

codebuild env vars
https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html

debugging json syntax::

  cat template.json | json_verify 

validating packer templates::
  > export IMAGE_ID=my_ami
  > ~/bin/packer validate validate-template.json 
  Template validated successfully.

