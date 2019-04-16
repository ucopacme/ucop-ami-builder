This is our amazon linux ami build.
===================================

launch codepipeline cfn stack
-----------------------------

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

  aws cloudformation describe-stack --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation describe-stack-outputs --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation describe-stack-events --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME
  aws cloudformation delete-stack --stack-name ucop-ami-builder-$PACKER_PROJECT_NAME





windows2016::

  PACKER_PROJECT_NAME=windows2016
