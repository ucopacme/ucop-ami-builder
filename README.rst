This is our amazon linux ami build.
===================================

launch codepipeline cfn stack
-----------------------------


::

aws cloudformation validate-template \
--template-body file://cloudformation/pipeline.yaml

aws cloudformation create-stack \
--stack-name ucop-ami-builder-amazonlinux2 \
--template-body file://cloudformation/pipeline.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters \
 ParameterKey=NotificationEmailAddress,ParameterValue="ait-dev@ucop.edu" \
 ParameterKey=PackerProjectName,ParameterValue=amazonlinux2 \
--tags \
 Key=ucop:service,Value=ait \
 Key=ucop:application,Value=ucop-aim-builder \
 Key=ucop:environment,Value=test


aws cloudformation update-stack \
--stack-name ucop-ami-builder-amazonlinux2 \
--template-body file://cloudformation/pipeline.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters \
 ParameterKey=NotificationEmailAddress,ParameterValue="ait-dev@ucop.edu" \
 ParameterKey=PackerProjectName,ParameterValue=amazonlinux2 \
--tags \
 Key=ucop:service,Value=ait \
 Key=ucop:application,Value=ucop-aim-builder \
 Key=ucop:environment,Value=test


aws cloudformation delete-stack --stack-name ucop-ami-builder-amazonlinux2
