This is our amazon linux ami build.
===================================

Create a new ami builder pipeline
---------------------------------

clone this git repo to a local directory.  Create a branch named for your packer project::

  git clone git@github.com:ucopacme/ucop-ami-builder.git
  cd ucop-ami-builder
  git checkout -b amazonlinux2


specify which packer project you want to build::

  PACKER_PROJECT_NAME=amazonlinux2

launch the CodePipeline Cloudformation template.  adjust params/tags as is appropriate::

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


add a git origin to you local repo pointing to the newly generated codecommit repo.  get the repo url from cloudformation stack outputs::

  aws cloudformation describe-stacks --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME | grep -A2 GitRepository
  git remote add codecommit https://git-codecommit.us-west-2.amazonaws.com/v1/repos/UcopAmiBuilder-windows2016_repo

push your local repo into codecommit to trigger the pipeline.  **IMPORTANT: you must push to the branch named for your packer project**::

  git push codecommit amazonlinux2:amazonlinux2





cfn stack examples
------------------

::

  PACKER_PROJECT_NAME=amazonlinux2

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
  
  aws cloudformation validate-template --template-body file://cloudformation/pipeline.yaml

  aws cloudformation describe-stacks --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation describe-stack-outputs --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation describe-stack-events --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation delete-stack --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME





windows2016::

  PACKER_PROJECT_NAME=windows2016


Notes
-----

codebuild env vars
https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html

debugging json syntax::

  cat template.json | json_verify 
